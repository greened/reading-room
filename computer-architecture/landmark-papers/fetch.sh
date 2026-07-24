#!/usr/bin/env bash
# Download the openly-available PDFs for the computer-architecture landmark survey.
# Paywalled entries without a free copy are skipped (see README for DOI links).
set -uo pipefail
cd "$(dirname "$0")"
OUT=pdfs; mkdir -p "$OUT"
UA='Mozilla/5.0'
dl() { local url="$1" f="$OUT/$2"
  if curl -fsSL -A "$UA" -o "$f" "$url" && [ "$(head -c4 "$f")" = "%PDF" ]; then
    echo "ok   $2"; else echo "FAIL $2 <- $url"; rm -f "$f"; fi; }
dl https://www3.cs.stonybrook.edu/~rezaul/Spring-2012/CSE613/reading/Amdahl-1967.pdf Amdahl1967.pdf
dl https://people.engr.tamu.edu/djimenez/taco/utsa-www/cs5513-fall07/reader/smith-cache-memories.pdf Smith1982_Cache-Memories.pdf
dl https://www.cs.sfu.ca/~alaa/courses/cmpt450/fall2022/papers/tullsen-isca-1995.pdf Tullsen1995_SMT.pdf
dl http://arsenalfc.stanford.edu/kunle/publications/hydra_ASPLOS_VII.pdf Olukotun1996_Single-Chip-MP.pdf
dl https://www.cs.cmu.edu/afs/cs/academic/class/15869-f11/www/readings/lindholm08_tesla.pdf Lindholm2008_NVIDIA-Tesla.pdf
dl https://cs.brown.edu/courses/csci2950-u/s18/papers/barroso09warehouse.pdf Barroso2009_Datacenter.pdf
dl https://www.cs.toronto.edu/~pekhimenko/courses/csc2224-f18/docs/Dark%20Silicon.pdf Esmaeilzadeh2011_Dark-Silicon.pdf
dl https://arxiv.org/pdf/1704.04760 Jouppi2017_TPU.pdf
dl https://www.cs.sfu.ca/~ashriram/Courses/CS7ARCH/papers/Kocher-security-2019.pdf Kocher2019_Spectre.pdf
echo "done -> $OUT/  (Tomasulo, Lamport, Roofline are DOI-only; see README)"
