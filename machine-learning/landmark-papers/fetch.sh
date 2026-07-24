#!/usr/bin/env bash
# Download the openly-available PDFs for the machine-learning landmark survey.
set -uo pipefail
cd "$(dirname "$0")"
OUT=pdfs; mkdir -p "$OUT"; UA='Mozilla/5.0'
dl(){ local u="$1" f="$OUT/$2"; if curl -fsSL -A "$UA" -o "$f" "$u" && [ "$(head -c4 "$f")" = "%PDF" ]; then echo "ok   $2"; else echo "FAIL $2"; rm -f "$f"; fi; }
dl https://www.cs.toronto.edu/~hinton/absps/science.pdf HintonSalakhutdinov2006.pdf
dl https://www.image-net.org/static_files/files/supervision.pdf Krizhevsky2012_AlexNet.pdf
dl https://arxiv.org/pdf/1301.3781 Mikolov2013_word2vec.pdf
dl https://arxiv.org/pdf/1312.6114 KingmaWelling2013_VAE.pdf
dl https://arxiv.org/pdf/1406.2661 Goodfellow2014_GAN.pdf
dl https://arxiv.org/pdf/1409.3215 Sutskever2014_seq2seq.pdf
dl https://web.stanford.edu/class/psych209/Readings/MnihEtAlHassibis15NatureControlDeepRL.pdf Mnih2015_DQN.pdf
dl https://arxiv.org/pdf/1512.03385 He2016_ResNet.pdf
dl https://arxiv.org/pdf/2006.11239 Ho2020_DDPM.pdf
dl https://arxiv.org/pdf/2001.08361 Kaplan2020_Scaling-Laws.pdf
echo "done -> $OUT/  (backprop, LSTM, AlphaGo are DOI-only; see README)"
