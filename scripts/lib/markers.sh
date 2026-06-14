#!/usr/bin/env bash
# markers.sh - LF-safe, idempotent in-place replacement of content between
# generator marker comments.
#
# A "marker region" is delimited by a matched pair of HTML comments carrying
# the SAME id:
#
#     <!-- BEGIN GENERATED: <id> -->
#     ...generated content (any number of lines)...
#     <!-- END GENERATED: <id> -->
#
# markers_replace replaces ONLY the lines strictly between the two marker
# comments, leaving the marker lines themselves and everything outside the
# region byte-for-byte untouched. This makes a re-run with identical generated
# content a true no-op (idempotency), which the round-trip test depends on.
#
# Design notes / guarantees:
#   - Pure bash + standard awk. No sed -i, no in-place editors that mangle EOL.
#   - Output is always LF-only (the repo is .gitattributes eol=lf). The marker
#     lines are re-emitted verbatim from the source file, and the injected
#     content is normalized to LF (any stray CR is stripped) so a CRLF-tainted
#     payload can never leak into an LF file.
#   - A trailing newline is always emitted for the injected content block, so
#     the END marker sits on its own line exactly as it did before.
#   - Errors (missing id, unbalanced/duplicate markers, nested markers) are
#     reported to stderr and return non-zero WITHOUT modifying the target.
#
# This file is meant to be SOURCED:
#     source "$(dirname "$0")/lib/markers.sh"
#
# Requirements: bash, awk, mktemp.

# --- guard against double-sourcing -----------------------------------------
if [[ -n "${__MARKERS_SH_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
__MARKERS_SH_LOADED=1

# markers_begin <id> - print the canonical BEGIN marker line for <id>.
markers_begin() { printf '<!-- BEGIN GENERATED: %s -->' "$1"; }
# markers_end <id> - print the canonical END marker line for <id>.
markers_end()   { printf '<!-- END GENERATED: %s -->'   "$1"; }

# markers_has <file> <id>
#   Return 0 if <file> contains a single, well-formed BEGIN/END pair for <id>.
#   Return non-zero (and print nothing) otherwise. Useful as a precondition.
markers_has() {
  local file="$1" id="$2"
  [[ -f "$file" ]] || return 1
  awk -v id="$id" '
    index($0, "<!-- BEGIN GENERATED: " id " -->") { b++ }
    index($0, "<!-- END GENERATED: "   id " -->") { e++ }
    END { exit !(b == 1 && e == 1) }
  ' "$file"
}

# markers_validate <file> <id>
#   Strict structural validation of the region for <id> in <file>. Prints a
#   precise diagnostic to stderr and returns non-zero on any problem:
#     - file missing
#     - BEGIN missing / appears more than once
#     - END   missing / appears more than once
#     - END appears before BEGIN
#   Returns 0 (silent) when exactly one well-ordered pair exists.
markers_validate() {
  local file="$1" id="$2"
  if [[ ! -f "$file" ]]; then
    printf 'markers.sh: ERROR: file not found: %s\n' "$file" >&2
    return 1
  fi
  awk -v id="$id" -v file="$file" '
    index($0, "<!-- BEGIN GENERATED: " id " -->") { b++; if (b==1) bline=NR }
    index($0, "<!-- END GENERATED: "   id " -->") { e++; if (e==1) eline=NR }
    END {
      if (b == 0) { printf("markers.sh: ERROR: missing BEGIN marker for id \x27%s\x27 in %s\n", id, file) > "/dev/stderr"; exit 2 }
      if (b > 1)  { printf("markers.sh: ERROR: duplicate BEGIN marker for id \x27%s\x27 in %s (%d found)\n", id, file, b) > "/dev/stderr"; exit 2 }
      if (e == 0) { printf("markers.sh: ERROR: missing END marker for id \x27%s\x27 in %s\n", id, file) > "/dev/stderr"; exit 2 }
      if (e > 1)  { printf("markers.sh: ERROR: duplicate END marker for id \x27%s\x27 in %s (%d found)\n", id, file, e) > "/dev/stderr"; exit 2 }
      if (eline < bline) { printf("markers.sh: ERROR: END marker precedes BEGIN marker for id \x27%s\x27 in %s\n", id, file) > "/dev/stderr"; exit 2 }
    }
  ' "$file"
}

# markers_extract <file> <id>
#   Print (to stdout) the current content strictly between the BEGIN/END
#   markers for <id>, LF-normalized, exactly as it lives in the file (used by
#   --check to compare against freshly rendered content). Returns non-zero if
#   the region is not well-formed.
markers_extract() {
  local file="$1" id="$2"
  markers_validate "$file" "$id" || return $?
  awk -v id="$id" '
    index($0, "<!-- END GENERATED: " id " -->")   { inside=0 }
    inside { print }
    index($0, "<!-- BEGIN GENERATED: " id " -->") { inside=1 }
  ' "$file" | tr -d '\r'
}

# markers_replace <file> <id> <content>
#   Replace the lines strictly between the BEGIN/END markers for <id> in <file>
#   with <content> (passed as a single string; embedded LFs are honored). The
#   marker lines and all surrounding bytes are preserved verbatim. The write is
#   atomic (temp file + mv) and LF-only. Returns non-zero (leaving <file>
#   untouched) if the region is malformed.
#
#   Idempotency: if <content> already equals the current region content, the
#   resulting file is byte-identical to the input.
markers_replace() {
  local file="$1" id="$2" content="$3"

  markers_validate "$file" "$id" || return $?

  local tmp
  tmp="$(mktemp "${TMPDIR:-/tmp}/markers.XXXXXX")" || {
    printf 'markers.sh: ERROR: failed to create temp file\n' >&2
    return 1
  }

  # Normalize the payload to LF-only and guarantee exactly one trailing LF so
  # the END marker lands on its own line. printf '%s\n' adds the final LF; we
  # strip any CRs the caller may have introduced.
  local clean
  clean="$(printf '%s' "$content" | tr -d '\r')"

  # awk streams the file: copy everything up to and including BEGIN, then on the
  # BEGIN line flush the new payload, suppress old region lines until END, then
  # resume verbatim from END onward. The payload is fed via a separate file to
  # avoid any quoting/escaping hazards inside awk.
  local payload
  payload="$(mktemp "${TMPDIR:-/tmp}/markers.payload.XXXXXX")" || {
    rm -f "$tmp"
    printf 'markers.sh: ERROR: failed to create payload temp file\n' >&2
    return 1
  }
  # Only emit a payload line-block if there is content; an empty region stays
  # empty (no spurious blank line injected).
  if [[ -n "$clean" ]]; then
    printf '%s\n' "$clean" > "$payload"
  else
    : > "$payload"
  fi

  awk -v id="$id" -v payload="$payload" '
    BEGIN { inside = 0 }
    {
      if (index($0, "<!-- BEGIN GENERATED: " id " -->")) {
        print $0
        # stream the payload file verbatim
        while ((getline line < payload) > 0) print line
        close(payload)
        inside = 1
        next
      }
      if (index($0, "<!-- END GENERATED: " id " -->")) {
        inside = 0
        print $0
        next
      }
      if (!inside) print $0
    }
  ' "$file" > "$tmp" || {
    rm -f "$tmp" "$payload"
    printf 'markers.sh: ERROR: awk replacement failed for id %s in %s\n' "$id" "$file" >&2
    return 1
  }

  rm -f "$payload"

  # Final guarantee: strip any CR that could have crept in, then move into place.
  tr -d '\r' < "$tmp" > "$tmp.lf" && mv -f "$tmp.lf" "$file"
  local rc=$?
  rm -f "$tmp"
  return $rc
}
