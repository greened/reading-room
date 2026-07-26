#!/usr/bin/env bash
# Render an HTML reading guide to PDF using headless Chrome/Chromium.
#
# Detects the OS (macOS / Linux / WSL) and picks a browser + temp dir
# accordingly. Any <link rel="stylesheet" href="....css"> is INLINED before
# rendering, so guides can share lib/guide.css without file:// subresource loads.
#
# Usage: bin/render.sh <input.html> [output.pdf]
set -euo pipefail

in="${1:?usage: render.sh <input.html> [output.pdf]}"
out="${2:-${in%.html}.pdf}"

# --- browser candidates by OS ------------------------------------------------
os="$(uname -s)"
case "$os" in
  Darwin)
    candidates=(
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      "/Applications/Chromium.app/Contents/MacOS/Chromium"
      "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
      google-chrome chromium chrome
    ) ;;
  Linux)
    candidates=( google-chrome google-chrome-stable chromium chromium-browser chrome )
    # Under WSL, fall back to a Windows-side Chrome if no Linux browser is present.
    if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
      candidates+=(
        "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
        "/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
      )
    fi ;;
  *)  # other Unixes (BSD, etc.)
    candidates=( google-chrome chromium chromium-browser chrome ) ;;
esac

find_chrome() {
  local c
  for c in "${candidates[@]}"; do
    if [[ "$c" == */* ]]; then
      [[ -x "$c" ]] && { printf '%s' "$c"; return 0; }
    else
      command -v "$c" >/dev/null 2>&1 && { command -v "$c"; return 0; }
    fi
  done
  return 1
}

chrome="$(find_chrome)" || {
  echo "render.sh: no Chrome/Chromium found for $os (install one, or Print-to-PDF by hand)." >&2
  exit 1
}
command -v python3 >/dev/null 2>&1 || {
  echo "render.sh: python3 is required (used to inline the stylesheet)." >&2
  exit 1
}

# --- inline the stylesheet into a portable temp file -------------------------
# (GNU and BSD `mktemp -t` differ; make a temp dir and name the file ourselves.)
tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/guide.XXXXXX")"
trap 'rm -rf "$tmpdir"' EXIT
tmp="$tmpdir/guide.html"
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

# --- render (new headless mode, with a fallback for older Chrome) ------------
render() { "$chrome" --headless="$1" --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$out" "file://$tmp" >/dev/null 2>&1; }
render new || render old || { echo "render.sh: Chrome failed to render $in" >&2; exit 1; }
echo "wrote $out"
