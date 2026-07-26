# Machine learning · Training, scaling & practice

How do you take a model that works on one GPU and train it a thousand times larger?
This list follows that scaling story in the order the field discovered it: first make
one model learn reliably (optimizers, normalization, schedules), then push the batch
across more devices, then fit models that no longer fit in memory, then split them
across machines, then buy parameters without buying compute (mixture-of-experts) and
attention without buying memory (FlashAttention). Only then do the *scaling laws* tell
you how to spend a compute budget — and the last two stages, cheap adaptation and
alignment, turn one expensive pre-trained model into something usable.

> **How to read this list.** Read Sections 1–3 for the mechanics every large run rests
> on — the optimizer, the batch, the memory budget. Sections 4–6 are the three axes of
> "bigger than one device": parallelism, sparsity, and cheaper attention. Section 7 is
> the payoff — the empirical laws that say what to scale. If you only want to *use* big
> models rather than train them, jump to Sections 8–9 (distillation, PEFT, RLHF).

## Reading order

### 1 · How one model learns: optimizers, momentum, normalization
*Everything downstream is doing this same update at massive scale, so start with the update rule itself.*

- **Companion — An overview of gradient descent optimization algorithms** — Sebastian Ruder · 14pp · [PDF](https://arxiv.org/pdf/1609.04747). The one-sitting map of SGD → momentum → Adam; read before the papers below.
- **Companion — Why Momentum Really Works** — Gabriel Goh · [Distill](https://distill.pub/2017/momentum/). Interactive intuition for what momentum buys you.

1. **On the Importance of Initialization and Momentum in Deep Learning** — Sutskever, Martens, Dahl, Hinton · ICML 2013 · 9pp · [PMLR](https://proceedings.mlr.press/v28/sutskever13.html) · [PDF](https://proceedings.mlr.press/v28/sutskever13.pdf). Well-tuned momentum is what makes deep nets trainable by first-order methods at all.

2. **Adam: A Method for Stochastic Optimization** — Kingma, Ba · ICLR 2015 · 15pp · [arXiv](https://arxiv.org/abs/1412.6980) · [PDF](https://arxiv.org/pdf/1412.6980). Per-parameter adaptive step sizes; still the default optimizer for most training.

3. **Decoupled Weight Decay Regularization (AdamW)** — Loshchilov, Hutter · ICLR 2019 · 19pp · [arXiv](https://arxiv.org/abs/1711.05101) · [PDF](https://arxiv.org/pdf/1711.05101). Decoupled weight decay; the default Transformer optimizer.

4. **Batch Normalization** — Ioffe, Szegedy · ICML 2015 · 11pp · [arXiv](https://arxiv.org/abs/1502.03167) · [PDF](https://arxiv.org/pdf/1502.03167). Normalizing layer inputs to stabilize and dramatically speed up training.

5. **SGDR: Stochastic Gradient Descent with Warm Restarts** — Loshchilov, Hutter · ICLR 2017 · 16pp · [arXiv](https://arxiv.org/abs/1608.03983) · [PDF](https://arxiv.org/pdf/1608.03983). Cosine-annealing learning-rate schedules with warm restarts.

### 2 · Scaling the batch: warmup and large-batch optimizers
*The first lever for speed is a bigger batch across more devices — but naive large batches lose accuracy.*

6. **Accurate, Large Minibatch SGD: Training ImageNet in 1 Hour** — Goyal et al. · 2017 · 12pp · [arXiv](https://arxiv.org/abs/1706.02677) · [PDF](https://arxiv.org/pdf/1706.02677). The linear scaling rule plus learning-rate warmup — the recipe that made large-batch training work.

7. **Large Batch Training of Convolutional Networks (LARS)** — You, Gitman, Ginsburg · 2017 · 8pp · [arXiv](https://arxiv.org/abs/1708.03888) · [PDF](https://arxiv.org/pdf/1708.03888). Layer-wise adaptive rates that unlock batch sizes in the tens of thousands.

8. **Large Batch Optimization for Deep Learning: Training BERT in 76 Minutes (LAMB)** — You et al. · ICLR 2020 · 37pp · [arXiv](https://arxiv.org/abs/1904.00962) · [PDF](https://arxiv.org/pdf/1904.00962). LARS carried over to Transformers, the enabler of fast BERT pre-training.

9. **An Empirical Model of Large-Batch Training** — McCandlish, Kaplan, Amodei et al. · 2018 · 35pp · [arXiv](https://arxiv.org/abs/1812.06162) · [PDF](https://arxiv.org/pdf/1812.06162). The gradient noise scale: a principled answer to how large a batch is actually worth it.

### 3 · Fitting bigger models in memory
*Bigger models than fit in memory: trade compute for memory, shrink the numbers, shard the optimizer state.*

10. **Training Deep Nets with Sublinear Memory Cost** — Chen, Xu, Zhang, Guestrin · 2016 · 12pp · [arXiv](https://arxiv.org/abs/1604.06174) · [PDF](https://arxiv.org/pdf/1604.06174). Gradient (activation) checkpointing: recompute activations instead of storing them.

11. **Mixed Precision Training** — Micikevicius et al. · ICLR 2018 · 12pp · [arXiv](https://arxiv.org/abs/1710.03740) · [PDF](https://arxiv.org/pdf/1710.03740). FP16 training with loss scaling and FP32 master weights; half the memory, most of the speed.

12. **ZeRO: Memory Optimizations Toward Training Trillion Parameter Models** — Rajbhandari et al. · SC 2020 · 24pp · [arXiv](https://arxiv.org/abs/1910.02054) · [PDF](https://arxiv.org/pdf/1910.02054). Shard optimizer state, gradients, and parameters across data-parallel ranks — the memory backbone of DeepSpeed.

### 4 · Parallelism across devices
*When one device isn't enough, split the model, not just the data — by layer, by pipeline stage, by tensor.*

- **Companion — How to Train Really Large Models on Many GPUs?** — Lilian Weng · [blog](https://lilianweng.github.io/posts/2021-09-25-train-large/). One post that ties data / pipeline / tensor / expert parallelism together; read before or alongside this section.
- **Companion — Model Parallelism** — Hugging Face docs · [guide](https://huggingface.co/docs/transformers/perf_train_gpu_many). Practical mapping of these ideas onto real training code.

13. **GPipe: Efficient Training of Giant Neural Networks Using Pipeline Parallelism** — Huang et al. · NeurIPS 2019 · 11pp · [arXiv](https://arxiv.org/abs/1811.06965) · [PDF](https://arxiv.org/pdf/1811.06965). Micro-batched pipeline parallelism that splits a model across stages with little idle time.

14. **Megatron-LM: Training Multi-Billion Parameter Language Models Using Model Parallelism** — Shoeybi et al. · 2019 · 15pp · [arXiv](https://arxiv.org/abs/1909.08053) · [PDF](https://arxiv.org/pdf/1909.08053). Tensor (intra-layer) parallelism for Transformers, splitting each matmul across GPUs.

15. **Efficient Large-Scale Language Model Training on GPU Clusters Using Megatron-LM** — Narayanan et al. · SC 2021 · 13pp · [arXiv](https://arxiv.org/abs/2104.04473) · [PDF](https://arxiv.org/pdf/2104.04473). Composing tensor + pipeline + data parallelism (3D / PTD-P) to scale to thousands of GPUs.

### 5 · Conditional computation: mixture of experts
*Grow the parameter count without growing per-token compute by routing each token to just a few experts.*

16. **Outrageously Large Neural Networks: The Sparsely-Gated Mixture-of-Experts Layer** — Shazeer et al. · ICLR 2017 · 19pp · [arXiv](https://arxiv.org/abs/1701.06538) · [PDF](https://arxiv.org/pdf/1701.06538). The gated MoE layer that revived conditional computation at scale.

17. **GShard: Scaling Giant Models with Conditional Computation and Automatic Sharding** — Lepikhin et al. · 2020 · 35pp · [arXiv](https://arxiv.org/abs/2006.16668) · [PDF](https://arxiv.org/pdf/2006.16668). MoE plus an annotation-based sharding compiler; a 600B-parameter translation model.

18. **Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity** — Fedus, Zoph, Shazeer · JMLR 2022 · 40pp · [arXiv](https://arxiv.org/abs/2101.03961) · [PDF](https://arxiv.org/pdf/2101.03961). Top-1 routing that simplifies and stabilizes MoE training to trillion-parameter scale.

### 6 · Making attention itself cheaper
*Quadratic attention is the other scaling wall; make it IO-aware and exact rather than approximate.*

19. **FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness** — Dao, Fu, Ermon, Rudra, Ré · NeurIPS 2022 · 34pp · [arXiv](https://arxiv.org/abs/2205.14135) · [PDF](https://arxiv.org/pdf/2205.14135). Tiling and recomputation make attention memory-linear and much faster — exactly, not approximately.

20. **FlashAttention-2: Faster Attention with Better Parallelism and Work Partitioning** — Tri Dao · 2023 · 14pp · [arXiv](https://arxiv.org/abs/2307.08691) · [PDF](https://arxiv.org/pdf/2307.08691). Rebalances the work partitioning for a further ~2× on modern GPUs.

### 7 · Scaling laws: how to spend the compute
*With the machinery to train at scale in hand, the question becomes how to allocate parameters, data, and compute.*

21. **Scaling Laws for Neural Language Models** — Kaplan et al. · 2020 · 30pp · [arXiv](https://arxiv.org/abs/2001.08361) · [PDF](https://arxiv.org/pdf/2001.08361). Loss follows smooth power laws in model size, data, and compute.

22. **Language Models are Few-Shot Learners (GPT-3)** — Brown et al. · NeurIPS 2020 · 75pp · [arXiv](https://arxiv.org/abs/2005.14165) · [PDF](https://arxiv.org/pdf/2005.14165). The scaling bet cashed out at 175B parameters; in-context learning emerges from scale alone.

23. **Training Compute-Optimal Large Language Models (Chinchilla)** — Hoffmann et al. · NeurIPS 2022 · 36pp · [arXiv](https://arxiv.org/abs/2203.15556) · [PDF](https://arxiv.org/pdf/2203.15556). Corrected the compute-optimal recipe: scale data and parameters together, not just parameters.

24. **Emergent Abilities of Large Language Models** — Wei et al. · TMLR 2022 · 30pp · [arXiv](https://arxiv.org/abs/2206.07682) · [PDF](https://arxiv.org/pdf/2206.07682). Some capabilities appear abruptly past a scale threshold — the flip side of smooth loss curves.

### 8 · Adapting big models cheaply
*Training from scratch is only half the story; distillation and parameter-efficient tuning make one big model reusable without retraining it.*

25. **Distilling the Knowledge in a Neural Network** — Hinton, Vinyals, Dean · 2015 · 9pp · [arXiv](https://arxiv.org/abs/1503.02531) · [PDF](https://arxiv.org/pdf/1503.02531). Compress a large model (or ensemble) into a small deployable one by training on its soft targets.

26. **Parameter-Efficient Transfer Learning for NLP (Adapters)** — Houlsby et al. · ICML 2019 · 13pp · [arXiv](https://arxiv.org/abs/1902.00751) · [PDF](https://arxiv.org/pdf/1902.00751). Freeze the backbone, train tiny inserted adapter layers — the first practical PEFT method.

27. **The Power of Scale for Parameter-Efficient Prompt Tuning** — Lester, Al-Rfou, Constant · EMNLP 2021 · 15pp · [arXiv](https://arxiv.org/abs/2104.08691) · [PDF](https://arxiv.org/pdf/2104.08691). Learn a handful of soft-prompt vectors; at scale it matches full fine-tuning.

28. **LoRA: Low-Rank Adaptation of Large Language Models** — Hu et al. · ICLR 2022 · 26pp · [arXiv](https://arxiv.org/abs/2106.09685) · [PDF](https://arxiv.org/pdf/2106.09685). Low-rank adapters that slashed fine-tuning cost and became the default PEFT method.

29. **QLoRA: Efficient Finetuning of Quantized LLMs** — Dettmers, Pagnoni, Holtzman, Zettlemoyer · NeurIPS 2023 · 26pp · [arXiv](https://arxiv.org/abs/2305.14314) · [PDF](https://arxiv.org/pdf/2305.14314). 4-bit quantization plus LoRA fits fine-tuning of a 65B model on one GPU.

### 9 · Aligning models to human intent
*The final training stage: turn a capable next-token predictor into a model that does what people ask.*

30. **Deep Reinforcement Learning from Human Preferences** — Christiano et al. · NeurIPS 2017 · 17pp · [arXiv](https://arxiv.org/abs/1706.03741) · [PDF](https://arxiv.org/pdf/1706.03741). Foundational RLHF: learn a reward model from human preference comparisons.

31. **Training Language Models to Follow Instructions with Human Feedback (InstructGPT)** — Ouyang et al. · NeurIPS 2022 · 68pp · [arXiv](https://arxiv.org/abs/2203.02155) · [PDF](https://arxiv.org/pdf/2203.02155). RLHF instruction tuning; the recipe behind ChatGPT-style assistants.

32. **Direct Preference Optimization: Your Language Model Is Secretly a Reward Model (DPO)** — Rafailov et al. · NeurIPS 2023 · 27pp · [arXiv](https://arxiv.org/abs/2305.18290) · [PDF](https://arxiv.org/pdf/2305.18290). Aligns directly from preferences with a simple classification loss — RLHF without the RL.

## Reference shelf — books

- **FREE** **Deep Learning** — Goodfellow, Bengio, Courville · 2016 · 800pp · [page](https://www.deeplearningbook.org/). Chapter 8 (optimization for training deep models) is the textbook treatment behind SGD, momentum, Adam, and batch norm.
- **FREE** **Dive into Deep Learning** — Zhang, Lipton, Li, Smola · 2023 · 1000pp · [page](https://d2l.ai/chapter_optimization/index.html). The optimization and computational-performance chapters cover these algorithms with runnable code and exercises.

## Key terms

- **linear scaling rule** — scale the learning rate in proportion to the batch size when using large batches.
- **warmup** — ramp the learning rate up from near zero over the first steps to stabilize early large-batch training.
- **gradient noise scale** — a measure of how much a larger batch still reduces gradient variance; predicts the useful batch size.
- **activation checkpointing** — discard intermediate activations in the forward pass and recompute them in the backward pass to save memory.
- **mixed precision / loss scaling** — train in FP16/BF16 while scaling the loss so small gradients survive the reduced range.
- **data parallelism** — replicate the model on each device and split the batch; average the gradients.
- **tensor (model) parallelism** — split the weights of a single layer across devices.
- **pipeline parallelism** — assign consecutive layers to different devices and stream micro-batches through them.
- **ZeRO sharding** — partition optimizer state, gradients, and parameters across data-parallel ranks instead of replicating them.
- **mixture of experts (MoE)** — a layer of many sub-networks with a gate that routes each token to only a few, adding parameters without adding per-token compute.
- **compute-optimal** — the parameter/data split that minimizes loss for a fixed compute budget (the Chinchilla result).
- **PEFT** — parameter-efficient fine-tuning: adapt a frozen model by training a small number of extra parameters (adapters, prompts, LoRA).
- **RLHF** — reinforcement learning from human feedback: fine-tune a model against a reward model learned from human preferences.
