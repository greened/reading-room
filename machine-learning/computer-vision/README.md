# Machine learning · Computer vision

How machines learned to see. The path runs in five stages: first the **backbones**
that learn general visual features from ImageNet, then **detectors** that localize
objects, then **dense prediction** that labels every pixel, then the **transformer**
architectures that displaced the convolutional recipe, and finally the **foundation
models** that fold vision, language, and generation into one promptable interface.
Read each stage in order — every later stage reuses the machinery of the earlier ones.

> **How to read this list.** Start with the backbones: AlexNet through ResNet is the
> story of how depth was made trainable, and almost everything downstream plugs one of
> these networks in as a feature extractor. Detection and segmentation then show two
> ways to *use* those features — boxes and per-pixel masks. Only after that do the
> Transformer papers make sense as a replacement for convolution, and CLIP/SAM/diffusion
> as what you build once the backbone is a general-purpose visual encoder.

## Reading order

### Backbones — learning visual features
*Start here: these classification networks are the feature extractors every detector and segmenter reuses.*
1. **ImageNet Classification with Deep Convolutional Neural Networks (AlexNet)** — Krizhevsky, Sutskever, Hinton · NeurIPS 2012 · 9pp · [page](https://papers.nips.cc/paper_files/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html) · [PDF](https://proceedings.neurips.cc/paper_files/paper/2012/file/c399862d3b9d6b76c8436e924a68c45b-Paper.pdf). The ImageNet win that started the modern deep-learning boom; the paper every later backbone answers.
   - **Companion** — ImageNet Large Scale Visual Recognition Challenge — Russakovsky et al. · IJCV 2015 · 43pp · [PDF](https://arxiv.org/pdf/1409.0575). The benchmark and dataset all of these backbones competed on.
2. **Very Deep Convolutional Networks for Large-Scale Image Recognition (VGG)** — Simonyan, Zisserman · ICLR 2015 · 14pp · [arXiv](https://arxiv.org/abs/1409.1556) · [PDF](https://arxiv.org/pdf/1409.1556). Depth built from stacked 3×3 filters; a simple, durable transfer-learning backbone.
3. **Going Deeper with Convolutions (GoogLeNet/Inception)** — Szegedy et al. · CVPR 2015 · 12pp · [DOI](https://doi.org/10.1109/CVPR.2015.7298594) · [PDF](https://arxiv.org/pdf/1409.4842). The multi-branch Inception module: more depth at controlled compute.
4. **Batch Normalization** — Ioffe, Szegedy · ICML 2015 · 11pp · [arXiv](https://arxiv.org/abs/1502.03167) · [PDF](https://arxiv.org/pdf/1502.03167). Normalizing layer activations to train deep nets faster and far more stably — the enabling trick for what follows.
5. **Deep Residual Learning for Image Recognition (ResNet)** — He, Zhang, Ren, Sun · CVPR 2016 · 12pp · [DOI](https://doi.org/10.1109/CVPR.2016.90) · [PDF](https://arxiv.org/pdf/1512.03385). Skip connections make 100+ layer networks trainable; still the default backbone a decade later.
   - **Companion** — Identity Mappings in Deep Residual Networks — He et al. · ECCV 2016 · 15pp · [PDF](https://arxiv.org/pdf/1603.05027). The follow-up that explains *why* the residual path works and refines it (pre-activation).
6. **Densely Connected Convolutional Networks (DenseNet)** — Huang, Liu, Van der Maaten, Weinberger · CVPR 2017 · 9pp · [DOI](https://doi.org/10.1109/CVPR.2017.243) · [PDF](https://arxiv.org/pdf/1608.06993). Connects every layer to every later one, so features are reused and gradients flow freely — ResNet's accuracy with far fewer parameters.
7. **Squeeze-and-Excitation Networks (SENet)** — Hu, Shen, Sun · CVPR 2018 · 13pp · [DOI](https://doi.org/10.1109/CVPR.2018.00745) · [PDF](https://arxiv.org/pdf/1709.01507). A lightweight block that recalibrates feature-map channels by learned importance; the ImageNet 2017 winner and the first taste of attention inside a CNN.
8. **EfficientNet: Rethinking Model Scaling** — Tan, Le · ICML 2019 · 11pp · [arXiv](https://arxiv.org/abs/1905.11946) · [PDF](https://arxiv.org/pdf/1905.11946). Compound scaling of depth, width, and resolution for accuracy at far lower FLOPs.
   - **Lecture** — [Stanford CS231n · CNN Architectures](https://www.youtube.com/watch?v=bSftLenVU-4). A one-hour tour of AlexNet → ResNet if you want the arc narrated.
9. **A ConvNet for the 2020s (ConvNeXt)** — Liu, Mao, Wu, Feichtenhofer, Darrell, Xie · CVPR 2022 · 15pp · [DOI](https://doi.org/10.1109/CVPR52688.2022.01167) · [PDF](https://arxiv.org/pdf/2201.03545). Modernizes a plain ResNet with the design and training choices behind Vision Transformers and matches them — evidence that much of ViT's gain was recipe, not attention. Read it as the bridge into the Transformer section.

### Object detection — from regions to real time
*With a backbone in hand, the next problem is localization. This section traces detection from slow region proposals to single-shot real-time nets.*
10. **Rich Feature Hierarchies for Object Detection (R-CNN)** — Girshick, Donahue, Darrell, Malik · CVPR 2014 · 21pp · [DOI](https://doi.org/10.1109/CVPR.2014.81) · [PDF](https://arxiv.org/pdf/1311.2524). The first paper to put a CNN backbone under object detection; slow, but it set the template.
11. **Fast R-CNN** — Girshick · ICCV 2015 · 9pp · [DOI](https://doi.org/10.1109/ICCV.2015.169) · [PDF](https://arxiv.org/pdf/1504.08083). Shares convolution across proposals and adds RoI pooling — orders of magnitude faster than R-CNN.
12. **Faster R-CNN: Real-Time Detection with Region Proposal Networks** — Ren, He, Girshick, Sun · NeurIPS 2015 · 14pp · [arXiv](https://arxiv.org/abs/1506.01497) · [PDF](https://arxiv.org/pdf/1506.01497). Learns the proposals too (the RPN), giving one end-to-end network; the reference two-stage detector.
13. **You Only Look Once (YOLO)** — Redmon, Divvala, Girshick, Farhadi · CVPR 2016 · 10pp · [DOI](https://doi.org/10.1109/CVPR.2016.91) · [PDF](https://arxiv.org/pdf/1506.02640). Detection recast as a single regression pass — the real-time, one-stage paradigm.
14. **SSD: Single Shot MultiBox Detector** — Liu et al. · ECCV 2016 · 17pp · [DOI](https://doi.org/10.1007/978-3-319-46448-0_2) · [PDF](https://arxiv.org/pdf/1512.02325). One-stage detection across multiple feature-map scales; the other half of the real-time detection story.
15. **Feature Pyramid Networks for Object Detection (FPN)** — Lin, Dollár, Girshick, He, Hariharan, Belongie · CVPR 2017 · 10pp · [DOI](https://doi.org/10.1109/CVPR.2017.106) · [PDF](https://arxiv.org/pdf/1612.03144). A top-down pyramid that gives detectors multi-scale features cheaply; now a standard neck.
16. **Focal Loss for Dense Object Detection (RetinaNet)** — Lin, Goyal, Girshick, He, Dollár · ICCV 2017 · 10pp · [DOI](https://doi.org/10.1109/ICCV.2017.324) · [PDF](https://arxiv.org/pdf/1708.02002). Fixes the class-imbalance that held one-stage detectors back, closing the accuracy gap with two-stage.
17. **Deformable Convolutional Networks** — Dai, Qi, Xiong, Li, Zhang, Hu, Wei · ICCV 2017 · 12pp · [DOI](https://doi.org/10.1109/ICCV.2017.89) · [PDF](https://arxiv.org/pdf/1703.06211). Lets convolution sample from learned, input-dependent offsets so the receptive field bends to object shape — a drop-in boost for detection and segmentation.
18. **FCOS: Fully Convolutional One-Stage Object Detection** — Tian, Shen, Chen, He · ICCV 2019 · 13pp · [DOI](https://doi.org/10.1109/ICCV.2019.00972) · [PDF](https://arxiv.org/pdf/1904.01355). Drops anchors entirely and predicts boxes per pixel, matching anchor-based detectors with a far simpler design — the anchor-free turn.

### Dense prediction — semantic & instance segmentation
*Detection stops at boxes. These papers label every pixel, and the last one fuses detection with segmentation.*
19. **Fully Convolutional Networks for Semantic Segmentation (FCN)** — Long, Shelhamer, Darrell · CVPR 2015 · 10pp · [DOI](https://doi.org/10.1109/CVPR.2015.7298965) · [PDF](https://arxiv.org/pdf/1411.4038). Dropped the dense layers so a classification net produces per-pixel labels end-to-end.
20. **U-Net: Convolutional Networks for Biomedical Image Segmentation** — Ronneberger, Fischer, Brox · MICCAI 2015 · 8pp · [DOI](https://doi.org/10.1007/978-3-319-24574-4_28) · [PDF](https://arxiv.org/pdf/1505.04597). Encoder–decoder with skip connections; still the default segmentation (and diffusion) backbone.
21. **DeepLab: Atrous Convolution & Fully Connected CRFs** — Chen, Papandreou, Kokkinos, Murphy, Yuille · TPAMI 2018 · 14pp · [DOI](https://doi.org/10.1109/TPAMI.2017.2699184) · [PDF](https://arxiv.org/pdf/1606.00915). Uses dilated (atrous) convolution to widen the receptive field without losing resolution, then sharpens boundaries with a CRF — the reference semantic-segmentation recipe.
22. **Pyramid Scene Parsing Network (PSPNet)** — Zhao, Shi, Qi, Wang, Jia · CVPR 2017 · 11pp · [DOI](https://doi.org/10.1109/CVPR.2017.660) · [PDF](https://arxiv.org/pdf/1612.01105). Pools context at multiple spatial scales so a segmenter reasons about the whole scene, not just local patches.
23. **Mask R-CNN** — He, Gkioxari, Dollár, Girshick · ICCV 2017 · 12pp · [DOI](https://doi.org/10.1109/ICCV.2017.322) · [PDF](https://arxiv.org/pdf/1703.06870). Faster R-CNN plus a mask branch: the instance-segmentation standard, and the point where detection and segmentation converge.

### Transformers take over vision
*Once the backbone toolkit is clear, the Transformer arrives — first as a detector head, then as the backbone itself, then as something you can pretrain without labels.*
24. **End-to-End Object Detection with Transformers (DETR)** — Carion, Massa, Synnaeve, Usunier, Kirillov, Zagoruyko · ECCV 2020 · 26pp · [DOI](https://doi.org/10.1007/978-3-030-58452-8_13) · [PDF](https://arxiv.org/pdf/2005.12872). Detection as set prediction with a Transformer — no anchors, no NMS; the bridge from convolution to attention.
   - **Video** — [DETR explained (Yannic Kilcher)](https://www.youtube.com/watch?v=Cgxsv1riJhI). A walk through the bipartite-matching loss that makes the set-prediction idea click.
25. **An Image Is Worth 16×16 Words (ViT)** — Dosovitskiy et al. · ICLR 2021 · 22pp · [arXiv](https://arxiv.org/abs/2010.11929) · [PDF](https://arxiv.org/pdf/2010.11929). A pure Transformer on image patches matches CNNs at scale — the backbone shift.
   - **Video** — [ViT explained (Yannic Kilcher)](https://www.youtube.com/watch?v=TrdevFK_am4). Why patches-as-tokens works, and where it needs the data to.
26. **Swin Transformer: Hierarchical Vision Transformer using Shifted Windows** — Liu et al. · ICCV 2021 · 14pp · [DOI](https://doi.org/10.1109/ICCV48922.2021.00986) · [PDF](https://arxiv.org/pdf/2103.14030). Reintroduces a hierarchy and local windows, making ViT a practical general-purpose backbone for detection and segmentation.
27. **Masked Autoencoders Are Scalable Vision Learners (MAE)** — He, Chen, Xie, Li, Dollár, Girshick · CVPR 2022 · 14pp · [DOI](https://doi.org/10.1109/CVPR52688.2022.01553) · [PDF](https://arxiv.org/pdf/2111.06377). Masks most of an image and trains a ViT to reconstruct it — BERT-style self-supervised pretraining that scales vision without labels.

### Foundation models — language supervision & promptable vision
*Read last: these treat the backbone as a general visual encoder and pair it with language, self-supervision, prompting, or generation — and one last paper opens the 3D frontier.*
28. **Learning Transferable Visual Models from Natural Language Supervision (CLIP)** — Radford et al. · ICML 2021 · 48pp · [arXiv](https://arxiv.org/abs/2103.00020) · [PDF](https://arxiv.org/pdf/2103.00020). Contrastive image–text pretraining yields zero-shot classification and the vision encoder behind modern multimodal systems.
   - **Video** — [CLIP explained (Yannic Kilcher)](https://www.youtube.com/watch?v=NfnWJUyUJYU). The contrastive objective and why it transfers zero-shot.
29. **DINOv2: Learning Robust Visual Features without Supervision** — Oquab et al. · TMLR 2024 · 32pp · [arXiv](https://arxiv.org/abs/2304.07193) · [PDF](https://arxiv.org/pdf/2304.07193). Self-distillation at scale gives a frozen encoder whose features transfer to classification, segmentation, and depth with no fine-tuning — the self-supervised counterpart to CLIP.
30. **High-Resolution Image Synthesis with Latent Diffusion Models (Stable Diffusion)** — Rombach, Blattmann, Lorenz, Esser, Ommer · CVPR 2022 · 45pp · [DOI](https://doi.org/10.1109/CVPR52688.2022.01042) · [PDF](https://arxiv.org/pdf/2112.10752). Runs diffusion in a compressed latent space, making high-res text-to-image generation practical.
   - **Companion** — [What are Diffusion Models? (Lilian Weng)](https://lilianweng.github.io/posts/2021-07-11-diffusion-models/). The clearest single write-up of the diffusion math this paper builds on.
31. **Segment Anything (SAM)** — Kirillov et al. · ICCV 2023 · 30pp · [DOI](https://doi.org/10.1109/ICCV51070.2023.00371) · [PDF](https://arxiv.org/pdf/2304.02643). A promptable segmentation foundation model trained on a billion masks — segmentation's zero-shot moment.
   - **Companion** — [Segment Anything (Meta AI blog)](https://ai.meta.com/blog/segment-anything-foundation-model-image-segmentation/). Project overview, the SA-1B dataset, and the interactive demo.
32. **NeRF: Representing Scenes as Neural Radiance Fields for View Synthesis** — Mildenhall, Srinivasan, Tancik, Barron, Ramamoorthi, Ng · ECCV 2020 · 25pp · [DOI](https://doi.org/10.1007/978-3-030-58452-8_24) · [PDF](https://arxiv.org/pdf/2003.08934). Fits a small network to a scene's radiance and renders photorealistic novel views — the paper that opened the neural-rendering and 3D-reconstruction frontier.

<!--html-->
<div class="why">
<b>One toolkit, reused four times.</b> A <em>backbone</em> (AlexNet → ResNet → ViT) learns
general features once. <em>Detection</em> adds a head that predicts boxes; <em>segmentation</em>
adds one that predicts masks; <em>foundation models</em> keep the encoder and swap the
objective for language alignment (CLIP), prompting (SAM), or generation (diffusion). Read
the backbones first and every later paper reads as "the same features, a different head."
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Understanding Deep Learning** — Simon J.D. Prince · 2023 · 541pp · [PDF](https://github.com/udlbook/udlbook/releases/download/v5.0.3/UnderstandingDeepLearning_02_09_26_C.pdf). Modern, visual treatment of CNNs, ResNets, and Vision Transformers — the best free entry point to the architectures above.
- **FREE** **Computer Vision: Algorithms and Applications (2nd ed.)** — Richard Szeliski · 2022 · 1230pp · [page](https://szeliski.org/Book/). The comprehensive reference for vision as a field, from geometry to recognition; free draft PDF on the author's site.
- **FREE** **Deep Learning** — Goodfellow, Bengio, Courville · 2016 · 800pp · [page](https://www.deeplearningbook.org/). Chapter 9 (Convolutional Networks) is the standard theory reference for the backbone papers.

## Key terms

- **backbone** — the pretrained classification network (VGG, ResNet, ViT) reused as a feature extractor by detectors and segmenters.
- **convolution** — a spatially-shared filter that exploits image locality; the core operation of a CNN.
- **residual / skip connection** — adding a layer's input to its output so gradients flow through very deep stacks.
- **dense connectivity** — connecting each layer to every later one so features are reused throughout the network (DenseNet).
- **batch normalization** — normalizing activations within a mini-batch to stabilize and speed training.
- **channel attention** — reweighting a feature map's channels by learned importance, as in Squeeze-and-Excitation.
- **region proposal** — candidate object boxes a two-stage detector classifies and refines (the RPN in Faster R-CNN).
- **anchor** — a predefined reference box of fixed scale/aspect that a detector regresses from.
- **anchor-free detection** — predicting boxes directly at each location instead of regressing from predefined anchors (FCOS).
- **NMS (non-maximum suppression)** — a post-process that removes overlapping duplicate detections.
- **RoI pooling** — extracting a fixed-size feature map from an arbitrary region for per-box prediction.
- **semantic vs. instance segmentation** — labeling every pixel by class vs. separating individual object instances.
- **dilated (atrous) convolution** — a convolution with gaps between sampled positions, widening the receptive field without downsampling (DeepLab).
- **feature pyramid** — multi-scale feature maps so one network handles objects of very different sizes.
- **patch embedding** — splitting an image into fixed patches and treating each as a token for a Transformer.
- **self-supervised learning** — learning representations from unlabeled data via a pretext task such as masking or self-distillation.
- **masked image modeling** — a self-supervised task that hides image patches and trains the network to reconstruct them (MAE).
- **contrastive learning** — training paired examples (image–text in CLIP) to agree while pushing mismatches apart.
- **zero-shot** — applying a model to classes or prompts it was never explicitly trained to output.
- **latent diffusion** — running the denoising diffusion process in a compressed latent space rather than pixel space.
- **promptable segmentation** — producing a mask from a user prompt (point, box, text) at inference, as SAM does.
- **neural radiance field** — a network mapping 3D position and view direction to color and density, rendered to synthesize novel views (NeRF).
