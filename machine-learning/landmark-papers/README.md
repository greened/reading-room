# Machine learning · Landmark papers (a survey)

Twelve papers that a machine-learning practitioner should have read at least once —
the slice across this whole area, one or two standouts per subtopic, each pointing
back to the directory that treats it in depth. Read them as a path, not by date:
first the learning algorithm and the two architectures that proved depth and
perception could be trained (backprop, AlexNet, ResNet), then the recurrent cell and
the learned embedding that gave sequence models memory and a notion of a token, then
the attention architecture that displaced both recurrence and convolution, the two
generative paradigms that learned to *make* data rather than label it (GANs,
diffusion), the reward-driven line that reached superhuman play (DQN, AlphaGo), and
finally the empirical scaling laws — and the reasoning-and-acting loop that turns a
trained model into an agent. For depth on any theme, follow the arrow to its subtopic.

> **How these lists are organized.** The reading room is a set of in-depth subtopic
> directories, and this file is the survey that sits above them. Each numbered entry
> here is a single landmark chosen to stand in for a whole theme, and the arrow at the
> end of its note (→ `subtopic/`) points to the directory that treats that theme in
> full — its predecessors, its refinements, and the systems that grew out of it. Read
> this page top to bottom for the shape of the field and one paper per corner of it;
> follow an arrow whenever you want the surrounding literature rather than the single
> founding result. The `## Going deeper` list at the very bottom is the directory of
> all eight subtopics the arrows point into.

> **How to read this survey.** Each entry is a landmark, not the last word — the
> subtopic directory it points to lists the surrounding work: the predecessors, the
> refinements, and the systems that grew out of it. Read top to bottom; the order
> builds the machinery a modern model rests on (gradients, depth, tokens, attention)
> before spending it on generation, decision-making, scale, and agents. The
> transformer and its model families (BERT, GPT, ViT) have their own in-depth list in
> `transformers/`; this survey names only the founding paper and hands off.

## Reading order

### Foundations — how a deep net learns
*Start here: the algorithm that trains every network below, then the two architectures that first proved perception and real depth could be learned by gradient descent.*
1. **Learning representations by back-propagating errors** — Rumelhart, Hinton, Williams · Nature 1986 · 4pp · [DOI](https://doi.org/10.1038/323533a0) · [PDF](https://www.cs.toronto.edu/~hinton/absps/naturebp.pdf). The practical algorithm for training multi-layer nets — the engine under everything below. → deep-learning-foundations/
2. **ImageNet Classification with Deep Convolutional Neural Networks (AlexNet)** — Krizhevsky, Sutskever, Hinton · NeurIPS 2012 · 9pp · [page](https://papers.nips.cc/paper_files/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html) · [PDF](https://proceedings.neurips.cc/paper_files/paper/2012/file/c399862d3b9d6b76c8436e924a68c45b-Paper.pdf). The GPU-trained ImageNet win that started the modern deep-learning boom. → computer-vision/
3. **Deep Residual Learning for Image Recognition (ResNet)** — He, Zhang, Ren, Sun · CVPR 2016 · 12pp · [DOI](https://doi.org/10.1109/CVPR.2016.90) · [PDF](https://arxiv.org/pdf/1512.03385). Residual/skip connections that made depth past 100 layers trainable, now a fixture inside Transformers too. → deep-learning-foundations/

### Sequences and representations
*Language and time series need memory and a notion of a "token"; these are the gated recurrent cell that dominated sequence modeling for two decades and the learned embedding every later model consumes.*
4. **Long Short-Term Memory** — Hochreiter, Schmidhuber · Neural Computation 1997 · 46pp · [DOI](https://doi.org/10.1162/neco.1997.9.8.1735) · [PDF](https://deeplearning.cs.cmu.edu/F23/document/readings/LSTM.pdf). The gated cell whose constant error carousel carries gradients across long gaps, answering the vanishing-gradient problem. → sequence-models/
5. **Efficient Estimation of Word Representations in Vector Space (word2vec)** — Mikolov, Chen, Corrado, Dean · ICLR Workshop 2013 · 12pp · [arXiv](https://arxiv.org/abs/1301.3781) · [PDF](https://arxiv.org/pdf/1301.3781). Cheap, semantically meaningful word embeddings — the "king − man + woman ≈ queen" vectors the field standardized on. → sequence-models/

### Attention takes over
*Recurrence and convolution both gave way to one architecture that mixes context by attention alone — now the substrate under almost everything, with its own family treated in depth next door.*
6. **Attention Is All You Need** — Vaswani et al. · NeurIPS 2017 · 15pp · [arXiv](https://arxiv.org/abs/1706.03762) · [PDF](https://arxiv.org/pdf/1706.03762). The Transformer: pure self-attention, parallel and long-range, that became the backbone of BERT, GPT, and ViT. → transformers/

### Learning to generate
*A parallel track — not classifying data but producing it. Read the adversarial game and the diffusion process together: the two families the field converged through, ending on the one that now dominates.*
7. **Generative Adversarial Nets (GAN)** — Goodfellow et al. · NeurIPS 2014 · 9pp · [arXiv](https://arxiv.org/abs/1406.2661) · [PDF](https://arxiv.org/pdf/1406.2661). Generation framed as a game between a generator and a discriminator — the start of a decade of high-fidelity synthesis. → generative-models/
8. **Denoising Diffusion Probabilistic Models (DDPM)** — Ho, Jain, Abbeel · NeurIPS 2020 · 25pp · [arXiv](https://arxiv.org/abs/2006.11239) · [PDF](https://arxiv.org/pdf/2006.11239). Corrupt data with noise and learn to reverse it step by step — the objective that set off the image-generation wave. → generative-models/

### Learning from reward
*Where the signal is a reward, not a label. Deep value learning first cracked pixels; learned search then reached superhuman play.*
9. **Human-level Control through Deep Reinforcement Learning (DQN)** — Mnih et al. · Nature 2015 · 13pp · [DOI](https://doi.org/10.1038/nature14236) · [PDF](https://web.stanford.edu/class/psych209/Readings/MnihEtAlHassibis15NatureControlDeepRL.pdf). Learned to play Atari from raw pixels with experience replay and a target network — the founding deep-RL result. → reinforcement-learning/
10. **Mastering the Game of Go with Deep Neural Networks and Tree Search (AlphaGo)** — Silver et al. · Nature 2016 · 20pp · [DOI](https://doi.org/10.1038/nature16961) · [PDF](https://storage.googleapis.com/deepmind-media/alphago/AlphaGoNaturePaper.pdf). Deep policy and value networks guiding tree search beat a top human at Go — the lineage behind AlphaZero and MuZero. → reinforcement-learning/

### Scale, and what to do with it
*With the architectures in hand, the questions become how to spend a compute budget — and how to turn a trained model into something that acts.*
11. **Scaling Laws for Neural Language Models** — Kaplan et al. · 2020 · 30pp · [arXiv](https://arxiv.org/abs/2001.08361) · [PDF](https://arxiv.org/pdf/2001.08361). Loss follows smooth power laws in model size, data, and compute — turning model-building into budget allocation. → training-and-scaling/
12. **ReAct: Synergizing Reasoning and Acting in Language Models** — Yao et al. · ICLR 2023 · 33pp · [arXiv](https://arxiv.org/abs/2210.03629) · [PDF](https://arxiv.org/pdf/2210.03629). Interleave reasoning traces with tool calls and observations — the thought→act→observe loop that turns a model into an agent. → agentic-ai/

## Reference shelf — books

- **FREE** **Understanding Deep Learning** — Simon J.D. Prince · 2023 · 541pp · [PDF](https://github.com/udlbook/udlbook/releases/download/v5.0.3/UnderstandingDeepLearning_02_09_26_C.pdf). The best free single entry point to most of this list.
- **FREE** **Deep Learning** — Goodfellow, Bengio, Courville · 2016 · 800pp · [page](https://www.deeplearningbook.org/). The foundational graduate DL reference.
- **FREE** **Dive into Deep Learning** — Zhang, Lipton, Li, Smola · 2023 · 1151pp · [PDF](https://d2l.ai/d2l-en.pdf). A runnable, code-first book with notebooks for nearly every architecture here.
- **FREE** **Mathematics for Machine Learning** — Deisenroth, Faisal, Ong · 2020 · 417pp · [PDF](https://mml-book.github.io/book/mml-book.pdf). The linear-algebra, calculus, and probability prerequisites, from scratch.
- **FREE** **Probabilistic Machine Learning: An Introduction** — Kevin P. Murphy · 2022 · 860pp · [PDF](https://github.com/probml/pml-book/releases/latest/download/book1.pdf). A comprehensive modern probabilistic treatment in one notation.
- **FREE** **Pattern Recognition and Machine Learning** — Christopher M. Bishop · 2006 · 738pp · [page](https://www.microsoft.com/en-us/research/publication/pattern-recognition-machine-learning/). The classic Bayesian pattern-recognition text, free from the author.
- **FREE** **Reinforcement Learning: An Introduction (2nd ed.)** — Sutton, Barto · 2018 · 548pp · [PDF](http://incompleteideas.net/book/RLbook2020.pdf). The definitive RL text behind the reward-driven entries above.

## Going deeper

- **deep-learning-foundations/** — The machinery that makes gradient descent work at depth: weight initialization, optimizers, normalization, residual learning, regularization, and the generalization theory that asks why over-parameterized nets generalize at all. The standouts are Adam, Batch Normalization, and Dropout, alongside the backprop and ResNet papers this survey already names.
- **computer-vision/** — Perception architectures and the tasks built on them: convolutional backbones (AlexNet, VGG, ResNet), object detection (R-CNN through YOLO), semantic segmentation (U-Net, Mask R-CNN), Vision Transformers, and the vision foundation models that connect images to language. The standouts are ResNet, U-Net, and CLIP and SAM as foundation models.
- **sequence-models/** — Everything that models ordered data before and beside the Transformer: recurrent nets and their gated cells (LSTM, GRU), word and sub-word embeddings, encoder-decoder attention for translation, and the recent state-space models that revisit linear-time sequence modeling. The standouts are LSTM, word2vec, and Bahdanau's attention for alignment, with S4 and Mamba as the modern line.
- **generative-models/** — Models that learn to produce data rather than label it: variational autoencoders, generative adversarial nets, autoregressive models, normalizing flows, and the diffusion and text-to-image systems that now dominate. The standouts are the VAE, the original GAN, and DDPM as the diffusion foundation.
- **reinforcement-learning/** — Learning from a reward signal rather than labels: tabular methods (Q-learning, temporal-difference learning), policy-gradient and actor-critic methods (REINFORCE, A3C, PPO), deep value learning, self-play and learned search, and the RLHF pipeline that aligns modern language models. The standouts are DQN, PPO, and AlphaGo.
- **training-and-scaling/** — How to spend a compute budget once the architecture is fixed: optimizers and learning-rate schedules, data and model parallelism, mixture-of-experts routing, the empirical scaling laws, and parameter-efficient fine-tuning and alignment. The standouts are the Kaplan scaling-laws paper, Chinchilla's compute-optimal correction, and LoRA for cheap adaptation.
- **transformers/** — The Transformer as a reading path through its model families: the original encoder-decoder, bidirectional encoders, the autoregressive decoder line, and Vision Transformers that carry the architecture into images. The standouts are Attention Is All You Need, BERT, and GPT-3.
- **agentic-ai/** — The line that turns a trained language model into an agent: chain-of-thought and related reasoning prompts, tool use and function calling, retrieval augmentation, reflection and long-term memory, and multi-agent coordination. The standouts are Chain-of-Thought prompting, ReAct, and retrieval-augmented generation.

## Key terms

- **gradient descent** — the optimization loop that repeatedly nudges parameters down the loss gradient; stochastic gradient descent (SGD) estimates that gradient on small mini-batches.
- **backpropagation** — the reverse-mode chain rule that computes the loss gradient efficiently through every layer of a network, the engine behind gradient descent.
- **convolution** — a weight-sharing operation that slides a small learned filter over an image or signal, the core building block of a CNN.
- **attention** — a mechanism that lets each position read a learned weighted mix of all others; *self-attention* over a single sequence is the Transformer's core.
- **embedding** — a learned dense vector that represents a token, image, or item in a space where geometric distance reflects similarity.
- **generative model** — a model of the data distribution itself, able to *sample* new examples rather than only label the ones it is given.
- **diffusion** — a generative process that gradually corrupts data with noise and learns to reverse it step by step to synthesize new samples.
- **GAN** — a generator and a discriminator trained against each other as a minimax game, the generator learning to produce data the discriminator cannot tell from real.
- **policy gradient** — a reinforcement-learning method that improves a policy directly by ascending the gradient of expected reward.
- **scaling law** — an empirical power-law relating a model's loss to its parameter count, training-data size, and compute budget.
- **fine-tuning** — adapting a pretrained model to a specific task or preference; parameter-efficient fine-tuning (PEFT), such as LoRA, does this by training a small set of added parameters.
- **RLHF** — reinforcement learning from human feedback, the alignment step that tunes a model toward human-preferred outputs.
- **RAG** — retrieval-augmented generation: fetch relevant documents at inference time and condition the model on them instead of relying on parameters alone.
- **agent** — a model wrapped in a loop that reasons, calls external tools, observes the results, and acts toward a goal.
- **token** — the discrete unit (a word piece, character, or image patch) that a model consumes and predicts.
