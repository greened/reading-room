# Transformers — foundational reading list

A pedagogical path through the papers that define the Transformer, with intuition companions (video / web / textbook chapters) slotted in where they help. Read Stage 1 first for the idea and the core architecture, then fill in the details it references (Stage 2), the refinements (Stage 3), and the three model families (Stage 4).

> **Why "Transformer"?** The papers never spell it out. It's from *sequence transduction*: the model *transforms* an input sequence into an output sequence, and, layer by layer, *transforms every token's representation* by mixing in context from the others via attention — instead of *recurring* (RNNs) or *convolving* (CNNs). Paper 2 (§3) and the 3Blue1Brown video show exactly that "transform the representation" picture.

## Reading order

### Watch / read first — intuition before the papers
*Ground the notation visually before opening a paper; these turn the equations into geometry.*

- **3Blue1Brown — "But what is a GPT?" and "Attention, visually explained"** — [video](https://www.youtube.com/watch?v=wjZofJX0v4M) · [video](https://www.youtube.com/watch?v=eMlx5fFNoYc). Embeddings as directions, dot-product as alignment, softmax as soft selection.
- **Jay Alammar — "The Illustrated Transformer"** — [web](https://jalammar.github.io/illustrated-transformer/). The canonical diagram-driven walkthrough of Q/K/V and multi-head attention.

### Stage 1 — the idea, then the architecture
*Motivation before mechanism; then the core paper, read alongside its equation-by-equation companions.*

1. **Neural Machine Translation by Jointly Learning to Align and Translate** — Bahdanau, Cho, Bengio · ICLR 2015 · 15pp · [arXiv](https://arxiv.org/abs/1409.0473) · [PDF](https://arxiv.org/pdf/1409.0473). Attention in its original RNN setting — see *why* attention exists before it becomes the whole model.

2. **Attention Is All You Need** — Vaswani et al. · NeurIPS 2017 · 15pp · [arXiv](https://arxiv.org/abs/1706.03762) · [PDF](https://arxiv.org/pdf/1706.03762). The core paper: full encoder–decoder transformer, multi-head self-attention, positional encoding, tied embeddings. Read most carefully — and alongside these:
   - **The Annotated Transformer** (Harvard NLP) — [web](https://nlp.seas.harvard.edu/annotated-transformer/). Each equation next to the PyTorch that computes it.
   - **Dive into Deep Learning — Attention & Transformers chapter** — [web](https://d2l.ai/chapter_attention-mechanisms-and-transformers/index.html). Equations + runnable code + exercises.
   - **Peter Bloem — "Transformers from scratch"** — [web](https://peterbloem.nl/blog/transformers). The plain-language *why*: why a dot product, why divide by √dₖ.

### Stage 2 — details the core paper only references
*Short papers filling in two things paper 2 uses but doesn't derive: tied embeddings, and where tokens come from.*

3. **Using the Output Embedding to Tie Word Embeddings** — Press, Wolf · EACL 2017 · 7pp · [arXiv](https://arxiv.org/abs/1608.05859) · [PDF](https://arxiv.org/pdf/1608.05859). Why the input embedding and the pre-softmax de-embedding can be the same matrix.

4. **Neural Machine Translation of Rare Words with Subword Units (BPE)** — Sennrich, Haddow, Birch · ACL 2016 · 11pp · [arXiv](https://arxiv.org/abs/1508.07909) · [PDF](https://arxiv.org/pdf/1508.07909). Byte-pair encoding — how the token vocabulary is built.
   - **Karpathy — "Let's build the GPT Tokenizer"** — [video](https://www.youtube.com/watch?v=zduSFxRajkE). Tokenization built in code, start to finish.

5. **Google's Neural Machine Translation System (WordPiece)** — Wu et al. · 2016 · 23pp · [arXiv](https://arxiv.org/abs/1609.08144) · [PDF](https://arxiv.org/pdf/1609.08144). Source of WordPiece (BERT's tokenizer) and a large seq2seq system from just before the transformer.

6. **SentencePiece** — Kudo, Richardson · EMNLP 2018 · 6pp · [arXiv](https://arxiv.org/abs/1808.06226) · [PDF](https://arxiv.org/pdf/1808.06226). Language-agnostic tokenization on raw text — the tooling most modern vocabularies are trained with.

### Stage 3 — architecture refinements
*Only meaningful once you know the base block: where it normalizes, and how far it can attend.*

7. **On Layer Normalization in the Transformer Architecture (Pre-LN)** — Xiong et al. · ICML 2020 · 17pp · [arXiv](https://arxiv.org/abs/2002.04745) · [PDF](https://arxiv.org/pdf/2002.04745). Post-LN vs Pre-LN: why moving the layer norm inside the residual branch lets deep transformers train without warmup.

8. **Transformer-XL** — Dai et al. · ACL 2019 · 20pp · [arXiv](https://arxiv.org/abs/1901.02860) · [PDF](https://arxiv.org/pdf/1901.02860). Segment-level recurrence + relative positions to attend beyond a fixed window — the first serious answer to fixed context length.

### Stage 4 — the three model families
*Each is one specialization of the core architecture — encoder-only, decoder-only, vision — and reads fast once Stages 1–3 are in hand.*

9. **BERT: Pre-training of Deep Bidirectional Transformers** — Devlin et al. · NAACL 2019 · 16pp · [arXiv](https://arxiv.org/abs/1810.04805) · [PDF](https://arxiv.org/pdf/1810.04805). *Encoder-only.* Bidirectional masked-LM pretraining of the encoder stack.
   - **Jay Alammar — "The Illustrated BERT"** — [web](https://jalammar.github.io/illustrated-bert/). The diagram-driven walkthrough.

10. **Improving Language Understanding by Generative Pre-Training (GPT-1)** — Radford et al. · 2018 · 12pp · [PDF](https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf). *Decoder-only.* Generative pretraining of a masked-self-attention decoder stack — the start of the GPT line.

11. **Language Models are Unsupervised Multitask Learners (GPT-2)** — Radford et al. · 2019 · 24pp · [PDF](https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf). Scaling the decoder-only model; zero-shot task transfer from a bigger LM.
    - **Jay Alammar — "The Illustrated GPT-2"** — [web](https://jalammar.github.io/illustrated-gpt2/). The diagram-driven walkthrough.

12. **Language Models are Few-Shot Learners (GPT-3)** — Brown et al. · NeurIPS 2020 · 75pp · [arXiv](https://arxiv.org/abs/2005.14165) · [PDF](https://arxiv.org/pdf/2005.14165). Scaling further; in-context / few-shot learning emerges without gradient updates. (Longest in the set — skim the appendices.)
    - **Karpathy — "Let's build GPT: from scratch, in code"** — [video](https://www.youtube.com/watch?v=kCc8FmEb1nY). The capstone: build a decoder-only model yourself.

13. **An Image is Worth 16×16 Words (ViT)** — Dosovitskiy et al. · ICLR 2021 · 22pp · [arXiv](https://arxiv.org/abs/2010.11929) · [PDF](https://arxiv.org/pdf/2010.11929). *Vision.* Feed image patches to a plain transformer encoder — the architecture isn't language-specific.

## Reference shelf — books & deep-dives

- **FREE** **Understanding Deep Learning** — Prince · MIT Press 2023 · 541pp · [PDF](https://github.com/udlbook/udlbook/releases/download/v5.0.3/UnderstandingDeepLearning_02_09_26_C.pdf). Best figures; strong attention/transformer chapters.
- **FREE** **Mathematics for Machine Learning** — Deisenroth, Faisal, Ong · 2020 · 417pp · [PDF](https://mml-book.github.io/book/mml-book.pdf). The linear algebra / calculus / probability behind the notation.
- **FREE** **The Little Book of Deep Learning** — Fleuret · 2023 · 189pp · [PDF](https://fleuret.org/public/lbdl.pdf). Compact; covers attention/transformers.
- **FREE** **Speech and Language Processing (3rd ed. draft)** — Jurafsky, Martin · 2024 · 626pp · [page](https://web.stanford.edu/~jurafsky/slp3/). Readable NLP text; gentle transformer/LLM chapters.
- **FREE** **Dive into Deep Learning** — Zhang, Lipton, Li, Smola · Cambridge 2023 · [page](https://d2l.ai/). Free online and in print; ch. 11 is the attention/transformers companion.
- **FREE** **Deep Learning** — Goodfellow, Bengio, Courville · 2016 · [page](https://www.deeplearningbook.org/). The math foundations.
- **BUY** **Build a Large Language Model (From Scratch)** — Raschka · Manning 2024 · [page](https://www.manning.com/books/build-a-large-language-model-from-scratch). Hands-on, build-it-yourself.
- **BUY** **Hands-On Large Language Models** — Alammar, Grootendorst · O'Reilly 2024 · [page](https://www.oreilly.com/library/view/hands-on-large-language/9781098150952/). Visual and practical.

<!--html-->
<h2>Key equations, in plain English</h2>
<p class="grouphdr">The handful of equations at the heart of paper 01 (&sect;3.2&ndash;&sect;3.5) &mdash; each with what it means and what it does. This is the notation the rest of the guide keeps pointing at.</p>

<div class="notekey" style="background:#f4f1ea;border-color:#e2dccb;">
<b>The forward pass, end to end.</b>
text &rarr; <b>tokenize</b> (BPE / WordPiece / SentencePiece &mdash; papers 11&ndash;13) &rarr; token ids &rarr; <b>embed</b> (E &times; &radic;d<sub>model</sub> &mdash; paper 10) &rarr; <b>+ positional encoding</b> &rarr; <b>N &times; blocks</b> [ multi-head self-attention &rarr; add&amp;norm &rarr; FFN &rarr; add&amp;norm ] (paper 01 &sect;3) &rarr; <b>de-embed</b> (E<sup>T</sup> &mdash; paper 10) &rarr; <b>softmax</b> &rarr; next-token probabilities.
<div style="color:#6a6a6a;font-size:9pt;margin-top:4px;">Encoder-only (BERT): those blocks with attention <em>unmasked</em>. Decoder-only (GPT): attention <em>masked</em> so each token sees only earlier ones. Original (paper 01): both &mdash; the decoder block adds a second, cross-attention sub-layer that reads the encoder&rsquo;s output.</div>
</div>

<div class="notekey">
<b>Notation key.</b> &nbsp; <b>x</b> &mdash; a token&rsquo;s vector (its current representation), width d<sub>model</sub>. &nbsp;
<b>Q, K, V</b> &mdash; Queries, Keys, Values: three learned linear views of the tokens (Q = &ldquo;what I&rsquo;m looking for,&rdquo; K = &ldquo;what I offer,&rdquo; V = &ldquo;what I&rsquo;d hand over&rdquo;). &nbsp;
<b>d<sub>k</sub></b> &mdash; width of each key/query, per head. &nbsp; <b>h</b> &mdash; number of heads. &nbsp;
<b>W<sub>&lowast;</sub></b> &mdash; learned weight matrices. &nbsp; <b>softmax</b> &mdash; turns a row of scores into positive weights that sum to 1.
</div>

<div class="eqsec">
<ol>
<li>
  <span class="eq">Attention(Q, K, V) = softmax( Q&thinsp;K<sup>T</sup> / &radic;d<sub>k</sub> )&thinsp;V</span>
  <div class="eqm"><b>Math:</b> dot each query with every key &rarr; a grid of scores; scale by &radic;d<sub>k</sub>; softmax each row into weights; take the weighted sum of the value vectors.</div>
  <div class="eqm"><b>Effect:</b> every token pulls in a blend of the other tokens&rsquo; values, weighted by relevance &mdash; &ldquo;reading from&rdquo; the sequence by content. Dividing by &radic;d<sub>k</sub> just keeps the scores from growing large and flattening softmax&rsquo;s gradients as d<sub>k</sub> grows.</div>
</li>
<li>
  <span class="eq">MultiHead(&hellip;) = Concat(head<sub>1</sub>,&hellip;,head<sub>h</sub>)&thinsp;W<sup>O</sup>, &nbsp; head<sub>i</sub> = Attention(Q&thinsp;W<sub>i</sub><sup>Q</sup>, K&thinsp;W<sub>i</sub><sup>K</sup>, V&thinsp;W<sub>i</sub><sup>V</sup>)</span>
  <div class="eqm"><b>Math:</b> run h attentions in parallel on different learned projections of Q/K/V; concatenate the results; project back with W<sup>O</sup>.</div>
  <div class="eqm"><b>Effect:</b> each head can specialize (one tracks syntax, another long-range coreference, another position), so the model attends to several kinds of relationship at once.</div>
</li>
<li>
  <span class="eq">PE(pos, 2i) = sin( pos / 10000<sup>2i/d<sub>model</sub></sup> ), &nbsp; PE(pos, 2i+1) = cos( pos / 10000<sup>2i/d<sub>model</sub></sup> )</span>
  <div class="eqm"><b>Math:</b> add a fixed vector of sinusoids at geometrically-spaced frequencies to each token embedding, keyed to the token&rsquo;s position.</div>
  <div class="eqm"><b>Effect:</b> attention alone is order-blind (it treats the input as a set); this injects &ldquo;where in the sequence&rdquo; so word order carries meaning.</div>
</li>
<li>
  <span class="eq">y = LayerNorm( x + Sublayer(x) ); &nbsp; FFN(x) = max(0, x&thinsp;W<sub>1</sub> + b<sub>1</sub>)&thinsp;W<sub>2</sub> + b<sub>2</sub></span>
  <div class="eqm"><b>Math:</b> every sub-layer (attention or FFN) adds its output back onto its input (a residual) then normalizes; the FFN is a small per-token 2-layer MLP with a ReLU in the middle.</div>
  <div class="eqm"><b>Effect:</b> residuals let gradients flow through a very deep stack; LayerNorm keeps activations well-scaled; the FFN gives each token independent &ldquo;compute&rdquo; between the attention mixes. (Paper 09 is precisely about <em>where</em> to place that LayerNorm.)</div>
</li>
<li>
  <span class="eq">in:&nbsp; e<sub>t</sub> = &radic;d<sub>model</sub> &middot; E[token<sub>t</sub>] + PE(t) &nbsp;&nbsp;&mdash;&mdash;&nbsp;&nbsp; out:&nbsp; logits = h&thinsp;E<sup>T</sup> &rarr; softmax</span>
  <div class="eqm"><b>Math:</b> the input embedding picks row token<sub>t</sub> from a learned matrix E (scaled by &radic;d<sub>model</sub>) and adds the positional vector. At the output, the final hidden state h is multiplied by E<sup>T</sup> to score every vocabulary entry, and softmax turns those scores into next-token probabilities.</div>
  <div class="eqm"><b>Effect:</b> tokens become vectors on the way in and vectors become vocabulary scores on the way out &mdash; and the <em>same</em> matrix E does both (weight tying, paper 10), so &ldquo;embedding&rdquo; and &ldquo;de-embedding&rdquo; are one learned object.</div>
</li>
</ol>
</div>

<h2>Key terms</h2>
<p class="grouphdr">The vocabulary these papers assume.</p>
<div class="notekey">
<b>token</b> &mdash; the atomic unit of input (a subword piece), mapped to an integer id. &nbsp;
<b>embedding</b> &mdash; the learned vector a token id maps to. &nbsp;
<b>positional encoding</b> &mdash; a per-position vector added to embeddings so order matters. &nbsp;
<b>attention</b> &mdash; a weighted read where each token pulls in others' information by relevance. &nbsp;
<b>Q / K / V</b> &mdash; query, key, value: three learned projections used to compute attention. &nbsp;
<b>head</b> &mdash; one independent attention computation; <b>multi-head</b> runs several in parallel. &nbsp;
<b>softmax</b> &mdash; turns scores into positive weights that sum to 1. &nbsp;
<b>logits</b> &mdash; the pre-softmax output scores (here, one per vocabulary entry). &nbsp;
<b>residual connection</b> &mdash; adding a sub-layer's input to its output so gradients flow. &nbsp;
<b>layer normalization</b> &mdash; rescaling activations to keep them well-behaved. &nbsp;
<b>FFN</b> &mdash; the per-token feed-forward (2-layer MLP) sub-layer. &nbsp;
<b>causal / masked attention</b> &mdash; attention restricted so a token sees only earlier tokens (decoder-only / generation). &nbsp;
<b>encoder / decoder</b> &mdash; the two block stacks; encoders see the whole input, decoders generate left-to-right. &nbsp;
<b>pretraining / fine-tuning</b> &mdash; train once on a broad objective, then adapt to a task. &nbsp;
<b>context length</b> &mdash; how many tokens the model can attend over at once. &nbsp;
<b>parameter</b> &mdash; a learned weight; model size is counted in these.
</div>
<!--/html-->
