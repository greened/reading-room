# Machine learning · Sequence models

How neural networks learn from ordered data — text, speech, time series — before the
Transformer took over. The path runs in six moves: first see *why* plain recurrent
networks are hard to train, then the gated cells (LSTM, GRU) that fixed it, then the
vector *representations* those models consume, then the encoder-decoder-plus-attention
recipe that turned recurrence into translation, then the losses that let sequences be
generated and labeled end to end, and finally the state-space models that are now
challenging recurrence on its own ground.

> **How to read this list.** Start with the foundations to feel the vanishing-gradient
> problem in your hands — every later design is a response to it. Read LSTM and GRU as
> two answers to the same question, then let the representation papers (word2vec → GloVe
> → ELMo) show what a "token" became. Attention enters here in its *original recurrent
> setting* (Bahdanau, Luong); the Transformer that dropped recurrence entirely lives in
> the sibling `../transformers/` topic — read this first, then go there.

## Reading order

### Foundations — recurrence and why it is hard
*Start here: the recurrent idea, its training algorithm, and the gradient problem that everything after is trying to solve.*

*Watch/read first for intuition:* Andrej Karpathy — [The Unreasonable Effectiveness of Recurrent Neural Networks](https://karpathy.github.io/2015/05/21/rnn-effectiveness/); Stanford CS224N (Manning) — [Lecture 6, Simple and LSTM RNNs](https://www.youtube.com/watch?v=0LixFSa7yts).

1. **Finding Structure in Time** — Jeffrey Elman · Cognitive Science 1990 · 33pp · [DOI](https://doi.org/10.1207/s15516709cog1402_1) · [PDF](https://gwern.net/doc/ai/nn/rnn/1990-elman.pdf). The simple recurrent network: feed a network its own previous hidden state and it discovers structure — word boundaries, grammatical categories — from sequence alone. The origin of the recurrent hidden state.

2. **Backpropagation Through Time: What It Does and How to Do It** — Paul Werbos · Proceedings of the IEEE 1990 · 11pp · [DOI](https://doi.org/10.1109/5.58337) · [PDF](http://www.werbos.com/Neural/BTT.pdf). Unroll a recurrent net across time and it becomes a deep feed-forward net you can train by ordinary backprop. The algorithm every RNN is still trained with.

3. **Learning Long-Term Dependencies with Gradient Descent Is Difficult** — Bengio, Simard, Frasconi · IEEE Transactions on Neural Networks 1994 · 10pp · [DOI](https://doi.org/10.1109/72.279181). The bad news, proved: gradients through many time steps vanish or explode, so plain RNNs cannot learn long-range dependencies. The problem statement for the next thirty years.

4. **On the Difficulty of Training Recurrent Neural Networks** — Pascanu, Mikolov, Bengio · ICML 2013 · 12pp · [arXiv](https://arxiv.org/abs/1211.5063) · [PDF](https://arxiv.org/pdf/1211.5063). Revisits Bengio's result with a geometric picture and two practical fixes still used everywhere: gradient clipping for explosion, and a regularizer for vanishing.

### Gated recurrence — cells that remember
*The direct answer to the vanishing gradient: a cell state with multiplicative gates that let information flow across many steps unchanged.*

5. **Long Short-Term Memory** — Hochreiter, Schmidhuber · Neural Computation 1997 · 46pp · [DOI](https://doi.org/10.1162/neco.1997.9.8.1735) · [PDF](https://deeplearning.cs.cmu.edu/F23/document/readings/LSTM.pdf). The gated recurrent cell whose constant error carousel carries gradients across long gaps. It dominated sequence modeling for two decades.
   - **Companion** — [Understanding LSTM Networks](https://colah.github.io/posts/2015-08-Understanding-LSTMs/), Christopher Olah. The canonical walkthrough of the cell diagram — read it beside the paper.

6. **Learning to Forget: Continual Prediction with LSTM** — Gers, Schmidhuber, Cummins · Neural Computation 2000 · 21pp · [DOI](https://doi.org/10.1162/089976600300015015). Adds the forget gate that lets a cell reset itself — the piece missing from the 1997 design and the form of LSTM everyone actually uses.

7. **Learning Phrase Representations using RNN Encoder-Decoder (GRU)** — Cho, van Merriënboer, Bahdanau, Bengio et al. · EMNLP 2014 · 15pp · [arXiv](https://arxiv.org/abs/1406.1078) · [PDF](https://arxiv.org/pdf/1406.1078). Introduces the GRU — a gated cell with fewer parameters than LSTM — and the encoder-decoder framing this list returns to in the transduction section.

8. **LSTM: A Search Space Odyssey** — Greff, Srivastava, Koutník, Steunebrink, Schmidhuber · IEEE TNNLS 2017 · 12pp · [arXiv](https://arxiv.org/abs/1503.04069) · [PDF](https://arxiv.org/pdf/1503.04069). A large ablation over LSTM variants: which gates matter, which do not. The empirical settle-up on the gated cell.

### Representations — the vectors sequence models consume
*Before transduction, the input token itself became a learned vector. This is what changed underneath every model above.*

9. **Efficient Estimation of Word Representations in Vector Space (word2vec)** — Mikolov, Chen, Corrado, Dean · ICLR Workshop 2013 · 12pp · [arXiv](https://arxiv.org/abs/1301.3781) · [PDF](https://arxiv.org/pdf/1301.3781). Cheap, semantically meaningful word embeddings from a shallow predictive model — the vectors where "king − man + woman ≈ queen".
   - **Companion** — [The Illustrated Word2vec](https://jalammar.github.io/illustrated-word2vec/), Jay Alammar. Skip-gram and negative sampling drawn out step by step.

10. **GloVe: Global Vectors for Word Representation** — Pennington, Socher, Manning · EMNLP 2014 · 12pp · [page](https://aclanthology.org/D14-1162/) · [PDF](https://aclanthology.org/D14-1162.pdf). Derives embeddings from global co-occurrence counts rather than local windows — the other standard embedding baseline, and a cleaner objective to reason about.

11. **Deep Contextualized Word Representations (ELMo)** — Peters, Neumann, Iyyer, Gardner, Clark, Lee, Zettlemoyer · NAACL 2018 · 15pp · [arXiv](https://arxiv.org/abs/1802.05365) · [PDF](https://arxiv.org/pdf/1802.05365). Embeddings that depend on the whole sentence, produced by a pretrained bidirectional LSTM. The pivot from static vectors to pretrained contextual representations that BERT and GPT would run with.

### Sequence transduction — encoder-decoder and attention
*Turning one sequence into another. Attention is born here, as a fix to a recurrent bottleneck, before it becomes the whole model next door.*

12. **Sequence to Sequence Learning with Neural Networks** — Sutskever, Vinyals, Le · NeurIPS 2014 · 9pp · [arXiv](https://arxiv.org/abs/1409.3215) · [PDF](https://arxiv.org/pdf/1409.3215). Encode the source into one fixed vector, decode the target from it. Clean, general, and end-to-end — the framework attention was invented to repair.

13. **Neural Machine Translation by Jointly Learning to Align and Translate (Bahdanau attention)** — Bahdanau, Cho, Bengio · ICLR 2015 · 15pp · [arXiv](https://arxiv.org/abs/1409.0473) · [PDF](https://arxiv.org/pdf/1409.0473). Lets the decoder look back at all encoder states through a learned soft alignment, removing the single-vector bottleneck. The direct ancestor of the Transformer's attention.
    - **Companion** — [Attention and Augmented Recurrent Neural Networks](https://distill.pub/2016/augmented-rnns/), Distill; [Attention? Attention!](https://lilianweng.github.io/posts/2018-06-24-attention/), Lilian Weng. Two visual explainers of what "attention over encoder states" actually computes.

14. **Effective Approaches to Attention-based Neural Machine Translation** — Luong, Pham, Manning · EMNLP 2015 · 11pp · [arXiv](https://arxiv.org/abs/1508.04025) · [PDF](https://arxiv.org/pdf/1508.04025). Global vs. local attention and the dot-product scoring function — the concrete attention variant that fed straight into later architectures.

15. **Pointer Networks** — Vinyals, Fortunato, Jaitly · NeurIPS 2015 · 9pp · [arXiv](https://arxiv.org/abs/1506.03134) · [PDF](https://arxiv.org/pdf/1506.03134). Uses attention not to blend inputs but to *point* at input positions, so the output vocabulary is the input itself. The seed of copy mechanisms and pointer-generator models.

### Generation and labeling
*Losses and decoders that let a sequence model produce or annotate a sequence directly, without pre-aligned targets.*

16. **Connectionist Temporal Classification (CTC)** — Graves, Fernández, Gomez, Schmidhuber · ICML 2006 · 8pp · [DOI](https://doi.org/10.1145/1143844.1143891) · [PDF](https://www.cs.toronto.edu/~graves/icml_2006.pdf). A loss that sums over all alignments between input frames and output labels, enabling end-to-end speech and handwriting recognition without a pre-segmented training set.

17. **Generating Sequences With Recurrent Neural Networks** — Alex Graves · arXiv 2013 · 43pp · [arXiv](https://arxiv.org/abs/1308.0850) · [PDF](https://arxiv.org/pdf/1308.0850). Shows LSTMs generating long-range coherent text and handwriting one step at a time, and introduces the attention-based handwriting synthesis that presages soft alignment.

18. **WaveNet: A Generative Model for Raw Audio** — van den Oord, Dieleman, Zen et al. · arXiv 2016 · 15pp · [arXiv](https://arxiv.org/abs/1609.03499) · [PDF](https://arxiv.org/pdf/1609.03499). Autoregressive generation of raw waveforms with dilated causal convolutions — the convolutional alternative to recurrence for long sequences, and a bridge to modern audio models.

### Beyond recurrence — state-space models
*The current challenger: sequence models that keep recurrence's linear-time inference but train like a convolution, closing the gap the Transformer opened on long context.*

19. **Efficiently Modeling Long Sequences with Structured State Spaces (S4)** — Gu, Goel, Ré · ICLR 2022 · 32pp · [arXiv](https://arxiv.org/abs/2111.00396) · [PDF](https://arxiv.org/pdf/2111.00396). A linear state-space layer, parameterized for stability, that handles tens-of-thousands-step dependencies — reframing the recurrence-vs-convolution choice as two views of one operator.
    - **Companion** — [The Annotated S4](https://srush.github.io/annotated-s4/), Sasha Rush & Sidd Karamcheti. The S4 layer built up in runnable JAX, equation by equation.

20. **Mamba: Linear-Time Sequence Modeling with Selective State Spaces** — Gu, Dao · COLM 2024 · 36pp · [arXiv](https://arxiv.org/abs/2312.00752) · [PDF](https://arxiv.org/pdf/2312.00752). Makes the state-space parameters input-dependent (selective), recovering the content-based reasoning attention gives while keeping linear-time inference. The paper that put SSMs back in contention with the Transformer.

<!--html-->
<div class="why">
<b>Three ways to mix context across a sequence.</b> <em>Recurrence</em> (RNN, LSTM, GRU)
carries a hidden state forward step by step — linear-time, but hard to parallelize and
prone to forgetting. <em>Attention</em> (Bahdanau onward, and the whole
<code>../transformers/</code> topic) lets every position look at every other directly —
parallel and long-range, but quadratic in sequence length. <em>State-space models</em>
(S4, Mamba) aim for the best of both: a recurrence you can also evaluate as a convolution,
linear-time yet able to reach far back. This list walks the first line and hands off to
the second next door; the third is where the frontier now sits.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Speech and Language Processing (3rd ed. draft)** — Jurafsky & Martin · 2024 · ~600pp · [PDF](https://web.stanford.edu/~jurafsky/slp3/). The standard NLP text; the RNN, LSTM, and sequence-labeling chapters cover most of this list from the ground up.
- **FREE** **Dive into Deep Learning** — Zhang, Lipton, Li, Smola · 2023 · ~1000pp · [page](https://d2l.ai/chapter_recurrent-neural-networks/index.html). The recurrent-network chapters pair every equation with runnable code and exercises.
- **FREE** **Deep Learning** — Goodfellow, Bengio, Courville · 2016 · ~800pp · [page](https://www.deeplearningbook.org/contents/rnn.html). Chapter 10, *Sequence Modeling: Recurrent and Recursive Nets*, is the textbook treatment of BPTT, LSTM, and the gradient problem.
- **BUY** **Neural Network Methods for Natural Language Processing** — Yoav Goldberg · 2017 · 309pp · [page](https://link.springer.com/book/10.1007/978-3-031-02165-7). Embeddings and recurrent architectures for NLP, written just as this era matured.

## Key terms

- **recurrent network (RNN)** — a network that feeds its own hidden state back in at each time step, giving it a memory of the sequence so far.
- **BPTT** — backpropagation through time; training an RNN by unrolling it across steps into a deep feed-forward net.
- **vanishing / exploding gradient** — the decay or blow-up of gradients over many time steps that keeps plain RNNs from learning long-range dependencies.
- **gate** — a learned multiplicative valve (input, forget, output) that controls what an LSTM/GRU cell keeps, discards, or emits.
- **cell state** — the LSTM's long-term memory channel, along which gradients can flow nearly unchanged.
- **embedding** — a learned dense vector standing in for a discrete token; the input representation for the models here.
- **encoder-decoder** — an architecture that reads a source sequence into a representation, then generates a target sequence from it.
- **attention / alignment** — a learned weighting that lets a decoder position draw on a weighted mix of encoder positions instead of a single summary vector.
- **teacher forcing** — feeding the true previous token (not the model's own prediction) as input during training.
- **beam search** — decoding that keeps the k best partial sequences at each step rather than committing greedily.
- **autoregressive** — generating a sequence one element at a time, each conditioned on those already produced.
- **CTC** — connectionist temporal classification; a loss that marginalizes over all input-to-label alignments so no pre-segmentation is needed.
- **dilated causal convolution** — a convolution that skips inputs at a fixed stride and never looks ahead, giving a large receptive field over past samples (WaveNet).
- **state-space model (SSM)** — a sequence layer defined by a linear recurrence that can also be run as a convolution; selective SSMs make its parameters depend on the input (S4, Mamba).
</content>
</invoke>
