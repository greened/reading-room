#!/usr/bin/env bash
# Download the openly-available PDFs for the programming-languages landmark survey.
set -uo pipefail
cd "$(dirname "$0")"
OUT=pdfs; mkdir -p "$OUT"; UA='Mozilla/5.0'
dl(){ local u="$1" f="$OUT/$2"; if curl -fsSL -A "$UA" -o "$f" "$u" && [ "$(head -c4 "$f")" = "%PDF" ]; then echo "ok   $2"; else echo "FAIL $2"; rm -f "$f"; fi; }
dl https://www.cs.cmu.edu/~crary/819-f09/Landin66.pdf Landin1966_Next-700.pdf
dl https://www.cis.upenn.edu/~stevez/cis670/pdfs/Reynolds74.pdf Reynolds1974_Type-Structure.pdf
dl https://www.di.ens.fr/~cousot/publications.www/CousotCousot-POPL-77-ACM-p238--252-1977.pdf CousotCousot1977_Abstract-Interpretation.pdf
dl https://research.cs.queensu.ca/home/cordy/cisc860/Biblio/hurd/misc/milner78.pdf Milner1978_Type-Polymorphism.pdf
dl https://plv.mpi-sws.org/plerg/papers/comprehending-monads.pdf Wadler1990_Comprehending-Monads.pdf
dl http://rsim.cs.uiuc.edu/Pubs/popl05.pdf Manson2005_Java-Memory-Model.pdf
dl https://scheme2006.cs.uchicago.edu/13-siek.pdf SiekTaha2006_Gradual-Typing.pdf
dl https://plsyssec.github.io/cse227-spring25/papers/sel4.pdf Klein2009_seL4.pdf
dl https://www.cl.cam.ac.uk/~pes20/cpp/popl085ap-sewell.pdf Batty2011_Cpp-Concurrency.pdf
dl https://plv.mpi-sws.org/rustbelt/popl18/paper.pdf Jung2018_RustBelt.pdf
echo "done -> $OUT/  (Hoare, separation logic are DOI-only; see README)"
