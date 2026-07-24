#!/usr/bin/env bash
# Download the transformer reading-list sources into ./pdfs/ (git-ignored).
# Papers + free books via curl; the d2l chapter is carved from the full book
# with ghostscript (fallback: poppler pdfseparate + pdfunite).
set -uo pipefail
cd "$(dirname "$0")"
OUT=pdfs; mkdir -p "$OUT"
UA='Mozilla/5.0'
sz() { stat -c%s "$1" 2>/dev/null || stat -f%z "$1" 2>/dev/null; }

dl() { # dl <url> <outfile>
  local url="$1" f="$OUT/$2"
  if curl -fsSL -A "$UA" -o "$f" "$url" && [ "$(head -c4 "$f")" = "%PDF" ]; then
    echo "ok   $2 ($(sz "$f") bytes)"
  else
    echo "FAIL $2  <- $url"; rm -f "$f"; return 1
  fi
}

echo "== papers =="
dl https://arxiv.org/pdf/1409.0473  02_Bahdanau-Attention_1409.0473.pdf
dl https://arxiv.org/pdf/1706.03762 01_Attention-Is-All-You-Need_1706.03762.pdf
dl https://arxiv.org/pdf/1608.05859 10_Weight-Tying_Press-Wolf_1608.05859.pdf
dl https://arxiv.org/pdf/1508.07909 11_BPE_Subword-Units_1508.07909.pdf
dl https://arxiv.org/pdf/1609.08144 13_WordPiece_GNMT_1609.08144.pdf
dl https://arxiv.org/pdf/1808.06226 12_SentencePiece_1808.06226.pdf
dl https://arxiv.org/pdf/2002.04745 09_Pre-LN_On-Layer-Normalization_2002.04745.pdf
dl https://arxiv.org/pdf/1901.02860 08_Transformer-XL_1901.02860.pdf
dl https://arxiv.org/pdf/1810.04805 03_BERT_1810.04805.pdf
dl https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf 04_GPT-1_Improving-Language-Understanding.pdf
dl https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf 05_GPT-2_LMs-Unsupervised-Multitask-Learners.pdf
dl https://arxiv.org/pdf/2005.14165 06_GPT-3_Few-Shot-Learners_2005.14165.pdf
dl https://arxiv.org/pdf/2010.11929 07_ViT_16x16-Words_2010.11929.pdf

echo "== free books =="
dl https://github.com/udlbook/udlbook/releases/download/v5.0.3/UnderstandingDeepLearning_02_09_26_C.pdf Book_UnderstandingDeepLearning_Prince.pdf
dl https://mml-book.github.io/book/mml-book.pdf Book_MathForML_Deisenroth.pdf
dl https://fleuret.org/public/lbdl.pdf Book_LittleBookDeepLearning_Fleuret.pdf
dl https://web.stanford.edu/~jurafsky/slp3/ed3book.pdf Book_SpeechAndLanguageProcessing_JurafskyMartin_ed3.pdf

echo "== d2l chapter (carved from the full book) =="
# NOTE: the page range is edition-specific. These are for the current d2l-en.pdf
# ("Attention Mechanisms and Transformers", chapter 11). Adjust if the book moves.
CHAP="$OUT/Companion_d2l_Attention-and-Transformers-chapter.pdf"
if dl https://d2l.ai/d2l-en.pdf d2l-en.pdf; then
  if command -v gs >/dev/null 2>&1; then
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dQUIET -dFirstPage=449 -dLastPage=507 \
       -o "$CHAP" "$OUT/d2l-en.pdf" && echo "ok   $(basename "$CHAP")"
  elif command -v pdfseparate >/dev/null 2>&1 && command -v pdfunite >/dev/null 2>&1; then
    t=$(mktemp -d); pdfseparate -f 449 -l 507 "$OUT/d2l-en.pdf" "$t/p-%d.pdf"
    pdfunite $(ls "$t"/p-*.pdf | sort -t- -k2 -n) "$CHAP" && echo "ok   $(basename "$CHAP")"
    rm -rf "$t"
  else
    echo "SKIP d2l chapter: need ghostscript or poppler (pdfseparate+pdfunite)"
  fi
fi

echo "== Annotated Transformer (rendered from the web, if Chrome is present) =="
AT="$OUT/Companion_Annotated-Transformer_HarvardNLP.pdf"
CHROME=""
for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
         google-chrome google-chrome-stable chromium chromium-browser chrome; do
  if [[ "$c" == */* ]]; then [[ -x "$c" ]] && { CHROME="$c"; break; }; \
  else command -v "$c" >/dev/null 2>&1 && { CHROME="$(command -v "$c")"; break; }; fi
done
if [ -n "$CHROME" ]; then
  "$CHROME" --headless --disable-gpu --no-pdf-header-footer --virtual-time-budget=15000 \
    --print-to-pdf="$AT" https://nlp.seas.harvard.edu/annotated-transformer/ >/dev/null 2>&1 \
    && echo "ok   $(basename "$AT")" || echo "SKIP Annotated Transformer (Chrome render failed)"
else
  echo "SKIP Annotated Transformer: no Chrome/Chromium."
  echo "     Open https://nlp.seas.harvard.edu/annotated-transformer/ and Print-to-PDF."
fi

echo "done -> $OUT/"
