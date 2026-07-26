# Machine learning · Deep-learning foundations

The ideas that make a deep neural network *work*: what it can represent, how it is
trained, the tricks that let gradients reach many layers, and the theory of why such
over-parameterized models generalize at all. The path below runs from
representational power (what a net *can* compute) → the learning algorithm
(backprop) → making depth trainable (initialization, optimizers, activations,
normalization, skip connections) → and finally the modern theory of generalization
(rethinking generalization, double descent, lottery tickets, the neural tangent
kernel, flat minima, and grokking). Read it in order and each section removes an
obstacle the previous one exposed.

> **How to read this list.** Start with the two 1989 universal-approximation results
> so you know a network *can* fit any function — then everything after is about making
> that fit *learnable at depth*. Backprop is the engine; initialization, optimizers,
> activations, and normalization are what keep the engine from stalling as nets get
> deep; the last section explains why the result still generalizes.

## Reading order

### Orientation & representational power
*Begin with what a neural net can represent, plus one modern overview, before touching how to train it.*
1. **Deep Learning** — LeCun, Bengio, Hinton · Nature 2015 · 9pp · [DOI](https://doi.org/10.1038/nature14539) · [PDF](https://www.cs.toronto.edu/~hinton/absps/NatureDeepReview.pdf). A compact survey of the whole field by three of its architects; the map for everything that follows.
2. **Approximation by Superpositions of a Sigmoidal Function** — Cybenko · Math. of Control, Signals and Systems 1989 · 12pp · [DOI](https://doi.org/10.1007/BF02551274) · [PDF](https://hal.science/hal-03753170v1/file/Cybenko1989.pdf). The first proof that a single hidden layer of sigmoidal units is a universal approximator.
3. **Multilayer Feedforward Networks are Universal Approximators** — Hornik, Stinchcombe, White · Neural Networks 1989 · 8pp · [DOI](https://doi.org/10.1016/0893-6080%2889%2990020-8) · [PDF](https://cognitivemedium.com/magic_paper/assets/Hornik.pdf). The independent, more general statement: it is the multilayer architecture, not any particular squashing function, that gives universality.
   - **Companion** — [A visual proof that neural nets can compute any function](http://neuralnetworksanddeeplearning.com/chap4.html). Michael Nielsen's picture-driven walkthrough of exactly what these two theorems claim.

### Learning by gradient descent
*The algorithm that makes fitting possible — and its first real success on images.*
4. **Learning representations by back-propagating errors** — Rumelhart, Hinton, Williams · Nature 1986 · 4pp · [DOI](https://doi.org/10.1038/323533a0) · [PDF](https://www.cs.toronto.edu/~hinton/absps/naturebp.pdf). Established backpropagation as the practical way to train multi-layer nets.
   - **Companion** — [What is backpropagation really doing?](https://www.youtube.com/watch?v=Ilg3gGewQ5U). 3Blue1Brown's visual account of the chain rule flowing backward through a net.
   - **Companion** — [How the backpropagation algorithm works](http://neuralnetworksanddeeplearning.com/chap2.html). Nielsen's from-scratch derivation of the four backprop equations.
5. **Gradient-Based Learning Applied to Document Recognition** — LeCun, Bottou, Bengio, Haffner · Proc. IEEE 1998 · 46pp · [DOI](https://doi.org/10.1109/5.726791) · [PDF](http://yann.lecun.com/exdb/publis/pdf/lecun-98.pdf). LeNet-5 and end-to-end gradient-trained CNNs — backprop applied to a real, structured architecture.

### Making deep nets trainable: initialization & optimization
*Deep nets stalled for years until careful initialization, momentum, and adaptive optimizers tamed the gradients.*
6. **On the Importance of Initialization and Momentum in Deep Learning** — Sutskever, Martens, Dahl, Hinton · ICML 2013 · 9pp · [page](https://proceedings.mlr.press/v28/sutskever13.html) · [PDF](https://proceedings.mlr.press/v28/sutskever13.pdf). Careful init plus Nesterov momentum lets plain SGD train deep nets — the empirical case that *how* you start and step matters.
7. **Understanding the difficulty of training deep feedforward neural networks** — Glorot, Bengio · AISTATS 2010 · 8pp · [page](https://proceedings.mlr.press/v9/glorot10a.html) · [PDF](https://proceedings.mlr.press/v9/glorot10a/glorot10a.pdf). Xavier/Glorot initialization: scale the weights so variance is preserved across layers.
8. **Delving Deep into Rectifiers (PReLU / He init)** — He, Zhang, Ren, Sun · ICCV 2015 · 11pp · [arXiv](https://arxiv.org/abs/1502.01852) · [PDF](https://arxiv.org/pdf/1502.01852). PReLU plus the He initialization that fixes Xavier's variance for rectifier nets — the standard init for ReLU networks.
9. **Adaptive Subgradient Methods for Online Learning and Stochastic Optimization (AdaGrad)** — Duchi, Hazan, Singer · JMLR 2011 · 39pp · [page](https://jmlr.org/papers/v12/duchi11a.html) · [PDF](https://jmlr.org/papers/volume12/duchi11a/duchi11a.pdf). Per-parameter learning rates that shrink with accumulated gradient — the ancestor of every adaptive optimizer, Adam included.
10. **Adam: A Method for Stochastic Optimization** — Kingma, Ba · ICLR 2015 · 15pp · [arXiv](https://arxiv.org/abs/1412.6980) · [PDF](https://arxiv.org/pdf/1412.6980). The default adaptive-gradient optimizer; per-parameter learning rates from running moment estimates.
   - **Companion** — [An overview of gradient descent optimization algorithms](https://arxiv.org/pdf/1609.04747). Sebastian Ruder · 14pp. Puts SGD, momentum, Adagrad, RMSProp, and Adam on one page.
11. **On the Convergence of Adam and Beyond (AMSGrad)** — Reddi, Kale, Kumar · ICLR 2018 · 23pp · [arXiv](https://arxiv.org/abs/1904.09237) · [PDF](https://arxiv.org/pdf/1904.09237). Shows Adam can fail to converge on simple problems and proposes the AMSGrad fix — the paper that made "does your optimizer actually converge?" a first-class question.
12. **Decoupled Weight Decay Regularization (AdamW)** — Loshchilov, Hutter · ICLR 2019 · 19pp · [arXiv](https://arxiv.org/abs/1711.05101) · [PDF](https://arxiv.org/pdf/1711.05101). Separates weight decay from the L2 gradient term so it behaves correctly under adaptive optimizers — now the default recipe for training Transformers.
13. **SGDR: Stochastic Gradient Descent with Warm Restarts** — Loshchilov, Hutter · ICLR 2017 · 16pp · [arXiv](https://arxiv.org/abs/1608.03983) · [PDF](https://arxiv.org/pdf/1608.03983). Cosine-annealed learning rates with periodic warm restarts — the schedule behind most modern training runs.

### Activations, normalization & regularization
*The per-layer tricks that keep gradients flowing and curb overfitting once nets get deep.*
14. **Deep Sparse Rectifier Neural Networks (ReLU)** — Glorot, Bordes, Bengio · AISTATS 2011 · 9pp · [page](https://proceedings.mlr.press/v15/glorot11a.html) · [PDF](https://proceedings.mlr.press/v15/glorot11a/glorot11a.pdf). The case for the rectified linear unit: sparse activations and non-vanishing gradients that made deep supervised training practical.
15. **Gaussian Error Linear Units (GELUs)** — Hendrycks, Gimpel · 2016 · 10pp · [arXiv](https://arxiv.org/abs/1606.08415) · [PDF](https://arxiv.org/pdf/1606.08415). The smooth activation that is now the default nonlinearity in Transformers.
16. **Dropout: A Simple Way to Prevent Neural Networks from Overfitting** — Srivastava, Hinton, Krizhevsky, Sutskever, Salakhutdinov · JMLR 2014 · 30pp · [page](https://jmlr.org/papers/v15/srivastava14a.html) · [PDF](https://jmlr.org/papers/volume15/srivastava14a/srivastava14a.pdf). Randomly dropping units as an ensemble-like regularizer — the workhorse against overfitting.
17. **Batch Normalization** — Ioffe, Szegedy · ICML 2015 · 11pp · [arXiv](https://arxiv.org/abs/1502.03167) · [PDF](https://arxiv.org/pdf/1502.03167). Normalizing activations per mini-batch to train deep nets faster and far more stably.
   - **Companion** — [How Does Batch Normalization Help Optimization?](https://arxiv.org/pdf/1805.11604). Santurkar, Tsipras, Ilyas, Madry · 26pp. Argues the win is a smoother loss landscape, not the "internal covariate shift" the original paper proposed.
18. **Layer Normalization** — Ba, Kiros, Hinton · 2016 · 14pp · [arXiv](https://arxiv.org/abs/1607.06450) · [PDF](https://arxiv.org/pdf/1607.06450). Batch-size-independent normalization; the form that carries over into RNNs and Transformers.
19. **Group Normalization** — Wu, He · ECCV 2018 · 10pp · [arXiv](https://arxiv.org/abs/1803.08494) · [PDF](https://arxiv.org/pdf/1803.08494). Normalizes over channel groups instead of the batch, so accuracy no longer collapses at the small batch sizes where BatchNorm breaks down.
20. **When Does Label Smoothing Help?** — Müller, Kornblith, Hinton · NeurIPS 2019 · 13pp · [arXiv](https://arxiv.org/abs/1906.02629) · [PDF](https://arxiv.org/pdf/1906.02629). A careful study of softening one-hot targets: why it regularizes and calibrates a classifier, and when it quietly hurts distillation.

### Depth at scale
*Unsupervised pretraining and skip connections — the two routes that first unlocked very deep networks.*
21. **Reducing the Dimensionality of Data with Neural Networks** — Hinton, Salakhutdinov · Science 2006 · 4pp · [DOI](https://doi.org/10.1126/science.1127647) · [PDF](https://www.cs.toronto.edu/~hinton/absps/science.pdf). Greedy layer-wise pretraining that reignited deep learning and showed depth could be trained at all.
22. **Deep Residual Learning for Image Recognition (ResNet)** — He, Zhang, Ren, Sun · CVPR 2016 · 12pp · [arXiv](https://arxiv.org/abs/1512.03385) · [PDF](https://arxiv.org/pdf/1512.03385). Residual/skip connections that scale cleanly past 100 layers — and became a fixture inside Transformers.
23. **Residual Networks Behave Like Ensembles of Relatively Shallow Networks** — Veit, Wilber, Belongie · NeurIPS 2016 · 9pp · [arXiv](https://arxiv.org/abs/1605.06431) · [PDF](https://arxiv.org/pdf/1605.06431). Reinterprets a ResNet as an implicit ensemble of many short paths — an explanation for why skip connections train so easily and degrade gracefully.

### Why do they generalize?
*Over-parameterized nets fit random labels yet still generalize; this section is the modern theory of why.*
24. **Understanding deep learning requires rethinking generalization** — Zhang, Bengio, Hardt, Recht, Vinyals · ICLR 2017 · 15pp · [arXiv](https://arxiv.org/abs/1611.03530) · [PDF](https://arxiv.org/pdf/1611.03530). The provocation: big nets memorize pure noise, so classical capacity bounds cannot explain their success.
25. **Reconciling modern machine-learning practice and the bias–variance trade-off** — Belkin, Hsu, Ma, Mandal · PNAS 2019 · 23pp · [DOI](https://doi.org/10.1073/pnas.1903070116) · [PDF](https://arxiv.org/pdf/1812.11118). Names the *double-descent* curve: test error falls, rises at the interpolation threshold, then falls again as models grow.
26. **Deep Double Descent** — Nakkiran, Kaplan, Bansal, Yang, Barak, Sutskever · ICLR 2020 · 24pp · [arXiv](https://arxiv.org/abs/1912.02292) · [PDF](https://arxiv.org/pdf/1912.02292). Shows double descent empirically across model size, data size, and training time in real deep nets.
27. **The Lottery Ticket Hypothesis** — Frankle, Carbin · ICLR 2019 · 42pp · [arXiv](https://arxiv.org/abs/1803.03635) · [PDF](https://arxiv.org/pdf/1803.03635). Dense nets contain small subnetworks that, trained from the same initialization, match the full model — reframing over-parameterization as a search for good sparse "tickets".
28. **Neural Tangent Kernel: Convergence and Generalization in Neural Networks** — Jacot, Gabriel, Hongler · NeurIPS 2018 · 19pp · [arXiv](https://arxiv.org/abs/1806.07572) · [PDF](https://arxiv.org/pdf/1806.07572). In the infinite-width limit training behaves like a fixed kernel method — the theoretical lens that turns "why does it generalize?" into analyzable math.
29. **Sharpness-Aware Minimization for Efficiently Improving Generalization (SAM)** — Foret, Kleiner, Mobahi, Neyshabur · ICLR 2021 · 20pp · [arXiv](https://arxiv.org/abs/2010.01412) · [PDF](https://arxiv.org/pdf/2010.01412). Optimizes for parameters sitting in flat loss regions, turning the flat-minima intuition for generalization into a concrete, widely used algorithm.
30. **Grokking: Generalization Beyond Overfitting on Small Algorithmic Datasets** — Power, Burda, Edwards, Babuschkin, Misra · ICLR 2022 workshop · 10pp · [arXiv](https://arxiv.org/abs/2201.02177) · [PDF](https://arxiv.org/pdf/2201.02177). Networks that first memorize and only much later — long after zero training loss — suddenly generalize; a sharp puzzle for any theory of *when* generalization happens.

## Reference shelf — books

- **FREE** **Deep Learning** — Goodfellow, Bengio, Courville · 2016 · 800pp · [page](https://www.deeplearningbook.org/). The canonical text; Part II (ch. 6 feedforward nets, 7 regularization, 8 optimization) is the textbook version of this entire list.
- **FREE** **Neural Networks and Deep Learning** — Michael Nielsen · 2015 · [page](http://neuralnetworksanddeeplearning.com/). The gentlest visual derivation of backprop and universal approximation — the two companions above are its chapters 2 and 4.
- **FREE** **Understanding Deep Learning** — Simon Prince · 2023 · 544pp · [page](https://udlbook.github.io/udlbook/). A modern, richly illustrated graduate text covering initialization, normalization, and generalization in depth.
- **FREE** **Dive into Deep Learning** — Zhang, Lipton, Li, Smola · 2023 · [page](https://d2l.ai/). Equations, runnable code, and exercises for every foundation on this list.

## Key terms

- **backpropagation** — reverse-mode differentiation of the loss through the network to get every weight's gradient in one backward pass.
- **universal approximation** — the result that a sufficiently wide one-hidden-layer net can approximate any continuous function arbitrarily well.
- **vanishing / exploding gradients** — gradients shrinking or blowing up as they propagate through many layers, the core obstacle to training depth.
- **initialization (Xavier / He)** — choosing initial weight scales so activation and gradient variance are preserved across layers.
- **activation function** — the per-unit nonlinearity (sigmoid, ReLU, GELU) that lets a network represent non-linear maps.
- **adaptive gradient (AdaGrad / Adam)** — per-parameter learning rates derived from a running summary of past gradients.
- **weight decay** — shrinking weights toward zero each step; equivalent to L2 only for non-adaptive optimizers, which is why AdamW decouples it.
- **learning-rate schedule / warm restart** — varying the step size over training, e.g. cosine annealing with periodic restarts (SGDR).
- **normalization (batch / layer / group)** — rescaling activations during training to stabilize and speed up optimization.
- **dropout** — randomly zeroing units at training time as an ensemble-like regularizer.
- **label smoothing** — replacing one-hot targets with slightly softened ones to regularize and calibrate a classifier.
- **residual / skip connection** — adding a layer's input to its output so gradients have a short path, enabling very deep nets.
- **over-parameterization** — having far more parameters than training examples, the regime modern deep nets operate in.
- **double descent** — test error that descends, peaks at the interpolation threshold, then descends again as capacity grows.
- **lottery ticket** — a sparse subnetwork whose original initialization lets it train to full-model accuracy on its own.
- **flat minimum / sharpness** — a loss basin whose neighborhood also has low loss; flatter minima are associated with better generalization (SAM).
- **grokking** — delayed generalization, where test accuracy jumps long after the training loss has already reached zero.
- **neural tangent kernel (NTK)** — the fixed kernel that describes an infinitely wide net's training dynamics under gradient descent.
