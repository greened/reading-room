#!/usr/bin/env bash
# Download the openly-available PDFs for the compilers landmark survey into ./pdfs/.
# Paywalled entries without a free copy are skipped (see README for DOI links).
set -uo pipefail
cd "$(dirname "$0")"
OUT=pdfs; mkdir -p "$OUT"
UA='Mozilla/5.0'
dl() { local url="$1" f="$OUT/$2"
  if curl -fsSL -A "$UA" -o "$f" "$url" && [ "$(head -c4 "$f")" = "%PDF" ]; then
    echo "ok   $2"; else echo "FAIL $2 <- $url"; rm -f "$f"; fi; }
dl https://haoxintu.github.io/files/1-A%20Unified%20Approach%20to%20Global%20Program%20Optimization.pdf Kildall1973_Global-Optimization.pdf
dl https://www.cs.utexas.edu/~pingali/CS380C/2010/papers/ssaCytron.pdf Cytron1991_SSA.pdf
dl https://www.di.ens.fr/~cousot/publications.www/CousotCousot-POPL-77-ACM-p238--252-1977.pdf CousotCousot1977_Abstract-Interpretation.pdf
dl https://web.eecs.umich.edu/~mahlke/courses/583f12/reading/chaitin82.pdf Chaitin1982_Graph-Coloring-RA.pdf
dl http://rsim.cs.uiuc.edu/arch/qual_papers/compilers/knoop92.pdf Knoop1992_Lazy-Code-Motion.pdf
dl https://llvm.org/pubs/2004-01-30-CGO-LLVM.pdf LattnerAdve2004_LLVM.pdf
dl https://www.ece.lsu.edu/jxr/Publications-pdf/pldi08.pdf Bondhugula2008_Pluto.pdf
dl https://xavierleroy.org/publi/compcert-CACM.pdf Leroy2009_CompCert.pdf
dl https://people.csail.mit.edu/jrk/halide-pldi13.pdf RaganKelley2013_Halide.pdf
dl https://theory.stanford.edu/~aiken/publications/papers/asplos13.pdf Schkufza2013_STOKE.pdf
dl https://users.cs.utah.edu/~regehr/papers/pldi15.pdf Lopes2015_Alive.pdf
dl https://arxiv.org/pdf/2002.11054 Lattner2021_MLIR.pdf
echo "done -> $OUT/"
