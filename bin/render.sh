#!/usr/bin/env bash
# Render an HTML reading guide to PDF using headless Chrome/Chromium.
# Works on macOS (Google Chrome) and Linux (google-chrome / chromium).
#
# Any <link rel="stylesheet" href="....css"> is INLINED before rendering, so
# guides can share lib/guide.css without relying on file:// subresource loads.
#
# Usage: lib/render.sh <input.html> [output.pdf]
set -euo pipefail

in="${1:?usage: render.sh <input.html> [output.pdf]}"
out="${2:-${in%.html}.pdf}"

find_chrome() {
  local c
  for c in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    google-chrome google-chrome-stable chromium chromium-browser chrome; do
    if [[ "$c" == */* ]]; then
      [[ -x "$c" ]] && { printf '%s' "$c"; return 0; }
    else
      command -v "$c" >/dev/null 2>&1 && { command -v "$c"; return 0; }
    fi
  done
  return 1
}

chrome="$(find_chrome)" || {
  echo "render.sh: no Chrome/Chromium found (install one, or Print-to-PDF by hand)." >&2
  exit 1
}
command -v python3 >/dev/null 2>&1 || {
  echo "render.sh: python3 is required (used to inline the stylesheet)." >&2
  exit 1
}

tmp="$(mktemp -t guide).html"
trap 'rm -f "$tmp"' EXIT
python3 - "$in" "$tmp" <<'PY'
import os, re, sys
inp, out = sys.argv[1], sys.argv[2]
base = os.path.dirname(os.path.abspath(inp))
html = open(inp, encoding="utf-8").read()
def inline(m):
    p = os.path.normpath(os.path.join(base, m.group(1)))
    with open(p, encoding="utf-8") as f:
        return "<style>\n" + f.read() + "\n</style>"
html = re.sub(r'<link\s+rel="stylesheet"\s+href="([^"]+\.css)"\s*/?>', inline, html)
open(out, "w", encoding="utf-8").write(html)
PY

"$chrome" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$out" "file://$tmp" >/dev/null 2>&1
echo "wrote $out"
