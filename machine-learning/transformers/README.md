# Transformers — foundational reading list

A pedagogical path through the papers that define the Transformer, with intuition
companions (video / web / textbook chapters) slotted in where they help. The
printable version is `reading-guide.html` → `reading-guide.pdf` (`make` it).

Run `./fetch.sh` to download every paper + free book into `./pdfs/` and carve the
d2l chapter. Nothing here redistributes third-party PDFs.

**Why "Transformer"?** The papers never spell it out. It's from *sequence
transduction*: the model *transforms* an input sequence into an output sequence,
and, layer by layer, *transforms every token's representation* by mixing in
context from the others via attention — instead of *recurring* (RNNs) or
*convolving* (CNNs).

**The forward pass, end to end:** text → tokenize (BPE/WordPiece/SentencePiece) →
embed (`E × √d_model`) → + positional encoding → N × [ multi-head self-attention →
add&norm → FFN → add&norm ] → de-embed (`Eᵀ`) → softmax → next-token probabilities.
Encoder-only (BERT) leaves attention unmasked; decoder-only (GPT) masks it so each
token sees only earlier ones; the original (Vaswani) has both, with a cross-attention
sub-layer in the decoder.

## Reading order

Files fetch as `01`–`13` by topic; the order below is pedagogical.

### Stage 1 — the idea, then the architecture
*Watch first for intuition:* 3Blue1Brown — [But what is a GPT?](https://www.youtube.com/watch?v=wjZofJX0v4M) and [Attention, visually explained](https://www.youtube.com/watch?v=eMlx5fFNoYc); Jay Alammar — [The Illustrated Transformer](https://jalammar.github.io/illustrated-transformer/).

1. **Neural MT by Jointly Learning to Align and Translate** — Bahdanau, Cho, Bengio · 15pp · [arXiv 1409.0473](https://arxiv.org/abs/1409.0473). Attention in its original RNN setting.
2. **Attention Is All You Need** — Vaswani et al. · 15pp · [arXiv 1706.03762](https://arxiv.org/abs/1706.03762). The core paper. Read alongside:
   - **The Annotated Transformer** — [nlp.seas.harvard.edu](https://nlp.seas.harvard.edu/annotated-transformer/) (each equation next to its PyTorch).
   - **Dive into Deep Learning, ch. Attention & Transformers** — [d2l.ai](https://d2l.ai/chapter_attention-mechanisms-and-transformers/index.html) (equations + code + exercises).
   - Peter Bloem — [Transformers from scratch](https://peterbloem.nl/blog/transformers) (the *why*: dot products, √d_k).

### Stage 2 — details the core paper only references
3. **Using the Output Embedding to Tie Word Embeddings** — Press & Wolf · 7pp · [arXiv 1608.05859](https://arxiv.org/abs/1608.05859).
4. **Neural MT of Rare Words with Subword Units (BPE)** — Sennrich et al. · 11pp · [arXiv 1508.07909](https://arxiv.org/abs/1508.07909). *Companion:* Karpathy — [Let's build the GPT Tokenizer](https://www.youtube.com/watch?v=zduSFxRajkE).
5. **Google's NMT System (WordPiece)** — Wu et al. · 23pp · [arXiv 1609.08144](https://arxiv.org/abs/1609.08144).
6. **SentencePiece** — Kudo & Richardson · 6pp · [arXiv 1808.06226](https://arxiv.org/abs/1808.06226).

### Stage 3 — architecture refinements
7. **On Layer Normalization in the Transformer (Pre-LN)** — Xiong et al. · 17pp · [arXiv 2002.04745](https://arxiv.org/abs/2002.04745).
8. **Transformer-XL** — Dai et al. · 20pp · [arXiv 1901.02860](https://arxiv.org/abs/1901.02860).

### Stage 4 — the three model families
9. **BERT** — Devlin et al. · 16pp · [arXiv 1810.04805](https://arxiv.org/abs/1810.04805) *(encoder-only)*. Companion: [Illustrated BERT](https://jalammar.github.io/illustrated-bert/).
10. **Improving Language Understanding by Generative Pre-Training (GPT-1)** — Radford et al. · 12pp · [OpenAI](https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf) *(decoder-only)*.
11. **Language Models are Unsupervised Multitask Learners (GPT-2)** — Radford et al. · 24pp · [OpenAI](https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf). Companion: [Illustrated GPT-2](https://jalammar.github.io/illustrated-gpt2/).
12. **Language Models are Few-Shot Learners (GPT-3)** — Brown et al. · 75pp · [arXiv 2005.14165](https://arxiv.org/abs/2005.14165). Capstone: Karpathy — [Let's build GPT from scratch](https://www.youtube.com/watch?v=kCc8FmEb1nY) ([series](https://karpathy.ai/zero-to-hero.html)).
13. **An Image is Worth 16×16 Words (ViT)** — Dosovitskiy et al. · 22pp · [arXiv 2010.11929](https://arxiv.org/abs/2010.11929) *(vision)*.

## Reference shelf — books & deep-dives

Free (fetched by `fetch.sh`): **Understanding Deep Learning** — Prince ([udlbook](https://udlbook.github.io/udlbook/)) · **Mathematics for Machine Learning** — Deisenroth, Faisal & Ong ([mml-book](https://mml-book.github.io)) · **The Little Book of Deep Learning** — Fleuret ([PDF](https://fleuret.org/public/lbdl.pdf)) · **Speech & Language Processing (3rd ed. draft)** — Jurafsky & Martin ([Stanford](https://web.stanford.edu/~jurafsky/slp3/)).

Free online: **Dive into Deep Learning** ([d2l.ai](https://d2l.ai), also in print, Cambridge UP 2023 — the d2l companion is its ch. 11) · **Deep Learning** — Goodfellow, Bengio, Courville ([deeplearningbook.org](https://www.deeplearningbook.org)) · Lilian Weng — [Attention? Attention!](https://lilianweng.github.io/posts/2018-06-24-attention/).

Worth buying: **Build a Large Language Model (From Scratch)** — Raschka (Manning 2024) · **Hands-On Large Language Models** — Alammar & Grootendorst (O'Reilly 2024) · **Natural Language Processing with Transformers** — Tunstall, von Werra, Wolf (O'Reilly 2022).
