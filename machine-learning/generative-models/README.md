# Machine learning · Generative models

How do you teach a machine to *make* data — images, audio, 3D scenes — that looks
like the real thing? The papers below trace the four families that answer that
question and how they converged on today's practice. Read them as a path: start
with the two foundational frameworks (VAE and GAN), watch the GAN line learn to
train and scale, cross over to the explicit-likelihood models (autoregressive nets
and normalizing flows), then follow the score-based and diffusion thread that now
dominates — ending with the text-to-image systems that put all of it under natural-
language control.

> **How to read this list.** The four families answer the same question with
> different trade-offs: VAEs give a smooth latent space but blurry samples; GANs give
> sharp samples but no likelihood and unstable training; autoregressive/flow models
> give exact likelihood at a sampling cost; diffusion trades many small denoising
> steps for both stability and fidelity. Track *what each buys and what it costs* as
> you read, and the field's arc — GANs, then diffusion — will make sense.

## Reading order

### Latent-variable and adversarial foundations
*The two ideas everything else builds on: a learned latent space you can decode (VAE), and a learned critic that scores realism (GAN).*
1. **Auto-Encoding Variational Bayes (VAE)** — Kingma, Welling · ICLR 2014 · 14pp · [arXiv](https://arxiv.org/abs/1312.6114) · [PDF](https://arxiv.org/pdf/1312.6114). The VAE and the reparameterization trick; the template for deep latent-variable generative modeling.
   - **From Autoencoder to Beta-VAE** — [Lilian Weng](https://lilianweng.github.io/posts/2018-08-12-vae/). A careful, derivation-first walk through the ELBO and the reparameterization trick.
2. **Neural Discrete Representation Learning (VQ-VAE)** — van den Oord, Vinyals, Kavukcuoglu · NeurIPS 2017 · 11pp · [arXiv](https://arxiv.org/abs/1711.00937) · [PDF](https://arxiv.org/pdf/1711.00937). Discrete latents via vector quantization; the basis for later token-based image and audio generators.
3. **Generative Adversarial Nets (GAN)** — Goodfellow et al. · NeurIPS 2014 · 9pp · [arXiv](https://arxiv.org/abs/1406.2661) · [PDF](https://arxiv.org/pdf/1406.2661). Generation as an adversarial game between a generator and a discriminator; a decade of high-fidelity synthesis followed.
   - **Generative Adversarial Networks (NIPS 2016 tutorial)** — [Ian Goodfellow, VIDEO](https://www.youtube.com/watch?v=HGYYEUSm-0Q). The author's own tour of the idea, the failure modes, and the open problems.
   - **From GAN to WGAN** — [Lilian Weng](https://lilianweng.github.io/posts/2017-08-20-gan/). Why the original objective is hard to train, leading directly into the Wasserstein fix below.
4. **Conditional Generative Adversarial Nets (cGAN)** — Mirza, Osindero · arXiv 2014 · 7pp · [arXiv](https://arxiv.org/abs/1411.1784) · [PDF](https://arxiv.org/pdf/1411.1784). Condition the generator and discriminator on a label — the small change that makes controllable generation possible.
5. **Unsupervised Representation Learning with Deep Convolutional GANs (DCGAN)** — Radford, Metz, Chintala · ICLR 2016 · 16pp · [arXiv](https://arxiv.org/abs/1511.06434) · [PDF](https://arxiv.org/pdf/1511.06434). The conv-net architecture and training recipe that made image GANs stable — the template everyone copied.

### Making GANs train and scale
*GANs were notoriously unstable and low-resolution; this line made them reliable, high-fidelity, and controllable.*
6. **Improved Techniques for Training GANs** — Salimans et al. · NeurIPS 2016 · 10pp · [arXiv](https://arxiv.org/abs/1606.03498) · [PDF](https://arxiv.org/pdf/1606.03498). Feature matching, minibatch discrimination, and the Inception Score — the practical toolkit that tamed GAN training.
7. **Wasserstein GAN (WGAN)** — Arjovsky, Chintala, Bottou · ICML 2017 · 32pp · [arXiv](https://arxiv.org/abs/1701.07875) · [PDF](https://arxiv.org/pdf/1701.07875). Reframes training around the Wasserstein distance, giving a loss that correlates with sample quality and rarely collapses.
8. **Progressive Growing of GANs** — Karras, Aila, Laine, Lehtinen · ICLR 2018 · 26pp · [arXiv](https://arxiv.org/abs/1710.10196) · [PDF](https://arxiv.org/pdf/1710.10196). Grow generator and discriminator layer by layer to reach megapixel resolution — the first convincingly photorealistic GAN faces.
9. **A Style-Based Generator Architecture (StyleGAN)** — Karras, Laine, Aila · CVPR 2019 · 12pp · [arXiv](https://arxiv.org/abs/1812.04948) · [PDF](https://arxiv.org/pdf/1812.04948). A generator that injects style per layer, giving disentangled, controllable high-resolution synthesis.
10. **Large Scale GAN Training for High Fidelity Natural Image Synthesis (BigGAN)** — Brock, Donahue, Simonyan · ICLR 2019 · 35pp · [arXiv](https://arxiv.org/abs/1809.11096) · [PDF](https://arxiv.org/pdf/1809.11096). Scale, big batches, and the truncation trick push class-conditional ImageNet generation to then-unmatched fidelity.

### Exact likelihood: autoregressive models and normalizing flows
*Unlike GANs, these assign explicit probabilities — you can measure likelihood and, for flows, sample and invert exactly. Read them for the other half of the design space.*
11. **Pixel Recurrent Neural Networks (PixelRNN/CNN)** — van den Oord, Kalchbrenner, Kavukcuoglu · ICML 2016 · 11pp · [arXiv](https://arxiv.org/abs/1601.06759) · [PDF](https://arxiv.org/pdf/1601.06759). Model an image one pixel at a time as a product of conditionals — tractable exact likelihood, slow sampling.
12. **Conditional Image Generation with PixelCNN Decoders** — van den Oord et al. · NeurIPS 2016 · 13pp · [arXiv](https://arxiv.org/abs/1606.05328) · [PDF](https://arxiv.org/pdf/1606.05328). Gated PixelCNN with conditioning, the workhorse autoregressive decoder used well beyond images.
13. **WaveNet: A Generative Model for Raw Audio** — van den Oord et al. · arXiv 2016 · 15pp · [arXiv](https://arxiv.org/abs/1609.03499) · [PDF](https://arxiv.org/pdf/1609.03499). Dilated-causal-convolution autoregression over raw waveforms — the same recipe applied to audio, with a step-change in speech quality.
14. **Variational Inference with Normalizing Flows** — Rezende, Mohamed · ICML 2015 · 10pp · [arXiv](https://arxiv.org/abs/1505.05770) · [PDF](https://arxiv.org/pdf/1505.05770). Compose invertible maps to turn a simple density into a flexible one — the founding paper for normalizing flows.
15. **NICE: Non-linear Independent Components Estimation** — Dinh, Krueger, Bengio · ICLR 2015 · 13pp · [arXiv](https://arxiv.org/abs/1410.8516) · [PDF](https://arxiv.org/pdf/1410.8516). The first additive coupling layer with a trivial Jacobian — the trick that makes deep flows practical.
16. **Density Estimation using Real NVP** — Dinh, Sohl-Dickstein, Bengio · ICLR 2017 · 32pp · [arXiv](https://arxiv.org/abs/1605.08803) · [PDF](https://arxiv.org/pdf/1605.08803). Affine coupling layers give exact-likelihood, exact-inverse flow models that scale to natural images.
17. **Glow: Generative Flow with Invertible 1x1 Convolutions** — Kingma, Dhariwal · NeurIPS 2018 · 15pp · [arXiv](https://arxiv.org/abs/1807.03039) · [PDF](https://arxiv.org/pdf/1807.03039). Learnable 1x1 convolutions generalize the coupling permutation, yielding sharp flow-based samples and clean latent interpolation.

### Score-based and diffusion models
*The now-dominant paradigm: corrupt data with noise, then learn to reverse it. Read Song–Ermon and DDPM together — they arrived at the same model from different directions — then follow the sampling, guidance, and speed refinements.*
18. **Generative Modeling by Estimating Gradients of the Data Distribution** — Song, Ermon · NeurIPS 2019 · 23pp · [arXiv](https://arxiv.org/abs/1907.05600) · [PDF](https://arxiv.org/pdf/1907.05600). Score matching across noise scales plus Langevin sampling — the score-based root of modern diffusion.
   - **Generative Modeling by Estimating Gradients of the Data Distribution** — [Yang Song](https://yang-song.net/blog/2021/score/). The author's blog: the single clearest bridge from scores to SDEs.
19. **Denoising Diffusion Probabilistic Models (DDPM)** — Ho, Jain, Abbeel · NeurIPS 2020 · 25pp · [arXiv](https://arxiv.org/abs/2006.11239) · [PDF](https://arxiv.org/pdf/2006.11239). The simplified training objective that made diffusion work and set off the image-generation wave.
   - **What are Diffusion Models?** — [Lilian Weng](https://lilianweng.github.io/posts/2021-07-11-diffusion-models/). The canonical survey-style explainer; read alongside DDPM.
   - **The Annotated Diffusion Model** — [Hugging Face](https://huggingface.co/blog/annotated-diffusion). DDPM reimplemented line by line in PyTorch.
   - **What are Diffusion Models?** — [Ari Seff, VIDEO](https://www.youtube.com/watch?v=fbLgFrlTnGU). A tight, visual intuition build in about 20 minutes.
20. **Denoising Diffusion Implicit Models (DDIM)** — Song, Meng, Ermon · ICLR 2021 · 22pp · [arXiv](https://arxiv.org/abs/2010.02502) · [PDF](https://arxiv.org/pdf/2010.02502). A non-Markovian, deterministic sampler that cuts diffusion from hundreds of steps to tens.
21. **Improved Denoising Diffusion Probabilistic Models** — Nichol, Dhariwal · ICML 2021 · 17pp · [arXiv](https://arxiv.org/abs/2102.09672) · [PDF](https://arxiv.org/pdf/2102.09672). Learned variances and a cosine schedule that improve log-likelihood and sample quality.
22. **Score-Based Generative Modeling through Stochastic Differential Equations** — Song et al. · ICLR 2021 · 36pp · [arXiv](https://arxiv.org/abs/2011.13456) · [PDF](https://arxiv.org/pdf/2011.13456). Unifies score-based models and DDPMs as discretizations of one SDE — the theoretical backbone of the field.
23. **Diffusion Models Beat GANs on Image Synthesis** — Dhariwal, Nichol · NeurIPS 2021 · 44pp · [arXiv](https://arxiv.org/abs/2105.05233) · [PDF](https://arxiv.org/pdf/2105.05233). Architecture improvements plus classifier guidance let diffusion overtake GANs on ImageNet — the turning point.
24. **Classifier-Free Diffusion Guidance** — Ho, Salimans · NeurIPS 2021 Workshop · 14pp · [arXiv](https://arxiv.org/abs/2207.12598) · [PDF](https://arxiv.org/pdf/2207.12598). Trade a separate classifier for jointly training conditional and unconditional models — the guidance trick every text-to-image system now uses.
25. **Consistency Models** — Song, Dhariwal, Chen, Sutskever · ICML 2023 · 42pp · [arXiv](https://arxiv.org/abs/2303.01469) · [PDF](https://arxiv.org/pdf/2303.01469). Learn a map straight to the data manifold for one- or few-step generation, attacking diffusion's core sampling cost.

### Text-to-image generation at scale
*Put generation under natural-language control and scale to internet-sized data — where diffusion, guidance, and large text encoders combine into the systems most people have used.*
26. **Zero-Shot Text-to-Image Generation (DALL·E)** — Ramesh et al. · ICML 2021 · 20pp · [arXiv](https://arxiv.org/abs/2102.12092) · [PDF](https://arxiv.org/pdf/2102.12092). A discrete VAE plus an autoregressive transformer over text-and-image tokens — the first broadly striking text-to-image model.
27. **GLIDE: Text-to-Image Generation and Editing with Guided Diffusion** — Nichol et al. · ICML 2022 · 20pp · [arXiv](https://arxiv.org/abs/2112.10741) · [PDF](https://arxiv.org/pdf/2112.10741). Moves text-to-image onto diffusion with classifier-free guidance, and adds inpainting-style editing.
28. **High-Resolution Image Synthesis with Latent Diffusion Models (Stable Diffusion)** — Rombach et al. · CVPR 2022 · 45pp · [arXiv](https://arxiv.org/abs/2112.10752) · [PDF](https://arxiv.org/pdf/2112.10752). Run diffusion in a compressed latent space, cutting cost enough to make open, high-resolution text-to-image practical.
29. **Hierarchical Text-Conditional Image Generation with CLIP Latents (DALL·E 2 / unCLIP)** — Ramesh et al. · arXiv 2022 · 27pp · [arXiv](https://arxiv.org/abs/2204.06125) · [PDF](https://arxiv.org/pdf/2204.06125). A prior that maps text to a CLIP image embedding, then a diffusion decoder — quality plus controllable variation.
30. **Photorealistic Text-to-Image Diffusion Models with Deep Language Understanding (Imagen)** — Saharia et al. · NeurIPS 2022 · 46pp · [arXiv](https://arxiv.org/abs/2205.11487) · [PDF](https://arxiv.org/pdf/2205.11487). Shows a large frozen text encoder plus cascaded diffusion is enough for state-of-the-art fidelity and text alignment.

### Neural scene representation
*Generative modeling reaches 3D: represent a whole scene as a continuous function you can render from any viewpoint.*
31. **NeRF: Representing Scenes as Neural Radiance Fields for View Synthesis** — Mildenhall et al. · ECCV 2020 · 25pp · [arXiv](https://arxiv.org/abs/2003.08934) · [PDF](https://arxiv.org/pdf/2003.08934). Fit an MLP mapping position and direction to color and density, then volume-render novel views — it reshaped 3D vision and graphics.

<!--html-->
<div class="why">
<b>Four families, one goal.</b> <em>VAEs</em> give a smooth, decodable latent space at
the cost of blurry samples; <em>GANs</em> give sharp samples but no likelihood and
brittle training; <em>autoregressive and flow</em> models give exact likelihood at a
sampling cost; <em>diffusion</em> trades many small denoising steps for both stability
and fidelity, and — with classifier-free guidance and latent-space compression — became
the engine behind modern text-to-image systems.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Deep Learning** — Goodfellow, Bengio, Courville · 2016 · 800pp · [page](https://www.deeplearningbook.org/). Chapter 20 (deep generative models) gives the pre-diffusion foundations — VAEs, GANs, and autoregressive models — with the math worked out.
- **FREE** **Probabilistic Machine Learning: Advanced Topics** — Kevin Murphy · 2023 · 1352pp · [PDF](https://github.com/probml/pml2-book/releases/latest/download/book2.pdf). A modern, unified treatment covering VAEs, normalizing flows, GANs, and diffusion in one notation.
- **FREE** **Understanding Deep Learning** — Simon Prince · 2023 · 541pp · [PDF](https://github.com/udlbook/udlbook/releases/download/v5.0.3/UnderstandingDeepLearning_02_09_26_C.pdf). Clean, figure-driven chapters on GANs, VAEs, normalizing flows, and diffusion — the gentlest first read of the shelf.

## Key terms

- **latent variable** — an unobserved code a model decodes into data; the smooth space VAEs and flows learn.
- **ELBO** — evidence lower bound; the tractable objective VAEs maximize in place of the intractable log-likelihood.
- **reparameterization trick** — sampling a latent as a deterministic function of noise so gradients can flow through it.
- **adversarial training** — training a generator against a discriminator that learns to tell real from generated.
- **mode collapse** — a GAN failure where the generator produces only a few distinct outputs.
- **Wasserstein distance** — an earth-mover metric between distributions; the loss WGAN optimizes for stable training.
- **normalizing flow** — an invertible map from a simple density to a complex one, giving exact likelihood via the change-of-variables formula.
- **autoregressive model** — factorizes data as a product of conditionals and generates one element at a time.
- **score function** — the gradient of log-density; score-based models learn it and follow it toward high-density regions.
- **Langevin dynamics** — noisy gradient ascent on the score that draws samples from a distribution.
- **diffusion / denoising** — gradually add Gaussian noise to data, then train a model to reverse the process step by step.
- **classifier-free guidance** — steer a conditional diffusion sample by extrapolating between its conditional and unconditional predictions.
- **latent diffusion** — run the diffusion process in a compressed autoencoder latent instead of pixel space, cutting compute.
