# Computer architecture · Domain-specific accelerators

When Dennard scaling ended and general-purpose cores stopped getting faster for
free, performance had to come from specialization. This guide follows that shift
from first principles to production silicon. Start with *why* specialization
became inevitable and the one model — the roofline — you need to reason about any
accelerator. Then meet the systolic array, the 1982 idea every matrix engine
still descends from, and GPUs, the first commodity accelerator and the substrate
machine learning grew up on. From there the academic DNN-accelerator lineage
names the design space, sparsity and compression buy the next order of magnitude,
and the datacenter papers show those ideas hardening into deployed silicon — from
Google's TPU to a deterministic streaming processor and a chip built for
recommendation. A short detour asks how to keep that efficiency without giving up
flexibility, through open, reusable accelerator designs. The guide closes on the
frontier beyond a single die: chiplets, wafer-scale integration, and computing
inside memory.

> **How to read this list.** One distinction runs through all of it: *temporal*
> engines (vectors, SIMD) stream data past a fixed pipeline, while *spatial*
> engines (dataflow arrays) lay computation out in space and move data between
> neighbors. And one fact drives every design decision below — moving a number
> costs far more energy than computing on it, so the winning architectures are
> the ones that move data least.

## Reading order

### Why specialize
*The physics and economics that ended general-purpose scaling — read this first to know what problem every accelerator is solving.*

1. **A New Golden Age for Computer Architecture** — Hennessy, Patterson · CACM 2019 · 13pp · [DOI](https://doi.org/10.1145/3282307) · [PDF](https://www.doc.ic.ac.uk/~wl/teachlocal/arch/papers/cacm19golden-age.pdf). The Turing-lecture manifesto: with general-purpose scaling exhausted, domain-specific architectures are where the gains now live. The framing for this whole topic.
   - **Turing lecture** — [video](https://www.youtube.com/watch?v=ctwj53r07yI). David Patterson delivers the argument in person; the fastest way to absorb the motivation.

2. **Roofline: An Insightful Visual Performance Model for Multicore Architectures** — Williams, Waterman, Patterson · CACM 2009 · 10pp · [DOI](https://doi.org/10.1145/1498765.1498785) · [PDF](https://people.eecs.berkeley.edu/~kubitron/cs252/handouts/papers/RooflineVyNoYellow.pdf). The one model that tells you whether an accelerator is compute-bound or memory-bound, and therefore whether it can possibly help. You will apply it to every chip below.

### The systolic idea
*The single oldest idea in the field; every matrix engine here, the TPU included, is a descendant.*

3. **Why Systolic Architectures?** — H. T. Kung · IEEE Computer 1982 · 10pp · [DOI](https://doi.org/10.1109/MC.1982.1653825) · [PDF](https://www.eecs.harvard.edu/~htk/publication/1982-kung-why-systolic-architecture.pdf). The manifesto for rhythmic arrays of simple cells that pump data between neighbors — the blueprint modern matrix units still follow.

### GPUs: the first commodity accelerator
*Before purpose-built silicon, programmable GPUs proved throughput-oriented specialization pays — and became the platform ML was born on.*

4. **NVIDIA Tesla: A Unified Graphics and Computing Architecture** — Lindholm, Nickolls, Oberman, Montrym · IEEE Micro 2008 · 17pp · [DOI](https://doi.org/10.1109/MM.2008.31) · [PDF](https://www.cs.cmu.edu/afs/cs/academic/class/15869-f11/www/readings/lindholm08_tesla.pdf). The unified-shader/CUDA architecture that turned the GPU into a general-purpose throughput machine.

5. **NVIDIA A100 Tensor Core GPU: Performance and Innovation** — Choquette, Gandhi, Giroux, Stam, Krashinsky · IEEE Micro 2021 · 25pp · [DOI](https://doi.org/10.1109/MM.2021.3061394) · [PDF](https://arxiv.org/pdf/2008.07307). Where the GPU meets the DSA halfway: Tensor Cores, structured sparsity, and multi-instance partitioning bolt matrix-engine ideas onto a general processor.

### Naming the design space: the DNN accelerator lineage
*The academic line that turned "build a neural-net chip" into a vocabulary — memory-access energy first, then an instruction set that generalizes the family, then a taxonomy of dataflows.*

6. **DianNao: A Small-Footprint High-Throughput Accelerator for Ubiquitous Machine-Learning** — Chen, Du, Sun, Wang, Wu, Chen, Temam · ASPLOS 2014 · 15pp · [DOI](https://doi.org/10.1145/2541940.2541967) · [PDF](https://users.cs.duke.edu/~lkw34/papers/diannao-asplos2014.pdf). The compact accelerator that reframed DNN hardware around memory-access energy rather than raw MAC count — the paper that opened the modern lineage.

7. **DaDianNao: A Machine-Learning Supercomputer** — Chen, Luo, Liu, Zhang, He, Wang, Li, Chen, Xu, Sun, Temam · MICRO 2014 · 14pp · [DOI](https://doi.org/10.1109/MICRO.2014.58) · [PDF](https://pages.saclay.inria.fr/olivier.temam/files/eval/supercomputer.pdf). Scales DianNao to a multi-chip machine by keeping all the weights on-chip in eDRAM, eliminating the off-chip traffic that dominated energy.

8. **Cambricon: An Instruction Set Architecture for Neural Networks** — Liu, Du, Tao, Han, Luo, Xie, Chen, Chen · ISCA 2016 · 13pp · [DOI](https://doi.org/10.1109/ISCA.2016.42) · [PDF](https://reconfigdeeplearning.wordpress.com/wp-content/uploads/2017/02/2016-isca_cambricon-an-instruction-set-architecture-for-neural-networks_cyj.pdf). The DianNao family generalized: rather than hard-wire one network, define a compact load-store ISA of scalar, vector, and matrix operations covering the common neural-network primitives. The argument that an accelerator should expose an instruction set, not a fixed function.

9. **Eyeriss: A Spatial Architecture for Energy-Efficient Dataflow for CNNs** — Chen, Emer, Sze · ISCA 2016 · 13pp · [DOI](https://doi.org/10.1109/ISCA.2016.40) · [PDF](https://d1qx31qr3h6wln.cloudfront.net/publications/ISCA_2016_Eyeriss.pdf). Introduces the row-stationary dataflow and, crucially, a taxonomy that lets you compare any accelerator's data-reuse strategy. The vocabulary the field settled on.
   - **Efficient Processing of Deep Neural Networks: A Tutorial and Survey** — Sze, Chen, Yang, Emer · [PDF](https://arxiv.org/pdf/1703.09039). The 32-page companion survey that systematizes dataflows, quantization, and pruning across the whole design space.

### Buying orders of magnitude: sparsity and compression
*Once dense throughput was solved, the next wins came from not computing on the zeros — first in the weights, then the activations, then both.*

10. **EIE: Efficient Inference Engine on Compressed Deep Neural Network** — Han, Liu, Mao, Pu, Pedram, Horowitz, Dally · ISCA 2016 · 12pp · [DOI](https://doi.org/10.1109/ISCA.2016.30) · [PDF](https://arxiv.org/pdf/1602.01528). Runs inference directly on a pruned, quantized network kept in on-chip SRAM — skipping zero weights and activations instead of storing them.
    - **Deep Compression** — Han, Mao, Dally · [PDF](https://arxiv.org/pdf/1510.00149). The pruning-plus-quantization-plus-Huffman algorithm that produces the compressed model EIE is built to execute.

11. **Cnvlutin: Ineffectual-Neuron-Free Deep Neural Network Computing** — Albericio, Judd, Hetherington, Aamodt, Enright Jerger, Moshovos · ISCA 2016 · 13pp · [DOI](https://doi.org/10.1109/ISCA.2016.11) · [PDF](https://www.eecg.utoronto.ca/~enright/albericio-isca2016.pdf). Many activations are zero after ReLU, and multiplying by them is wasted work. Cnvlutin adds hardware that skips ineffectual (zero) activations at runtime — the activation half of the sparsity story, complementing EIE's weight-side compression.

12. **SCNN: An Accelerator for Compressed-sparse Convolutional Neural Networks** — Parashar, Rhu, Mukkara, Puglielli, Venkatesan, Khailany, Emer, Keckler, Dally · ISCA 2017 · 14pp · [DOI](https://doi.org/10.1145/3079856.3080254) · [PDF](https://arxiv.org/pdf/1708.04485). Exploits sparsity in *both* weights and activations at once with a Cartesian-product dataflow — the harder, more general sparsity problem.

### Into the datacenter: production silicon
*The ideas above, hardened into deployed hardware — at Google and Microsoft first, then across the industry as the design space filled in.*

13. **A Reconfigurable Fabric for Accelerating Large-Scale Datacenter Services (Catapult)** — Putnam et al. · ISCA 2014 · 12pp · [DOI](https://doi.org/10.1109/ISCA.2014.6853195) · [PDF](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/Catapult_ISCA_2014.pdf). Datacenter-scale FPGA acceleration, deployed on 1,632 servers to speed up Bing — the case that specialization scales to a fleet.

14. **In-Datacenter Performance Analysis of a Tensor Processing Unit (TPU)** — Jouppi et al. · ISCA 2017 · 17pp · [DOI](https://doi.org/10.1145/3079856.3080246) · [PDF](https://arxiv.org/pdf/1704.04760). Kung's systolic array, in production: a 256×256 matrix unit that is the landmark DSA case study, complete with a roofline analysis of why it wins.

15. **A Configurable Cloud-Scale DNN Processor for Real-Time AI (Brainwave)** — Fowers et al. · ISCA 2018 · 14pp · [DOI](https://doi.org/10.1109/ISCA.2018.00012) · [PDF](https://www.microsoft.com/en-us/research/uploads/prod/2018/06/ISCA18-Brainwave-CameraReady.pdf). Microsoft's answer to the TPU: a precision-adaptable FPGA soft-NPU tuned for low-latency, batch-one serving — the opposite corner of the design space.

16. **Think Fast: A Tensor Streaming Processor (TSP) for Accelerating Deep Learning Workloads (Groq)** — Abts et al. · ISCA 2020 · 14pp · [DOI](https://doi.org/10.1109/ISCA45697.2020.00023) · [PDF](https://groq.humain.ai/wp-content/uploads/2024/02/2020-Isca.pdf). A radically deterministic design: strip out caches, arbiters, and out-of-order issue and let the compiler statically schedule every operation and data movement cycle by cycle, so latency is exactly predictable — the opposite philosophy to a cache-rich GPU.

17. **MTIA: First Generation Silicon Targeting Meta's Recommendation Systems** — Firoozshahian et al. · ISCA 2023 · 13pp · [DOI](https://doi.org/10.1145/3579371.3589348). Recommendation models, not vision or language, dominate datacenter inference at Meta, and their huge embedding tables are memory-bound in a way matrix engines are not. Silicon shaped by that workload — the reminder that the dominant DSA workload is often the one outside the ML-hardware spotlight.

### Scaling the TPU into a supercomputer
*One inference chip becomes a training machine, and interconnect and system design move to the foreground.*

18. **A Domain-Specific Supercomputer for Training Deep Neural Networks** — Jouppi, Yoon, Kurian, Li, Patil, Laudon, Young, Patterson · CACM 2020 · 12pp · [DOI](https://doi.org/10.1145/3360307) · [PDF](https://gwern.net/doc/ai/scaling/hardware/2020-jouppi.pdf). TPU v2/v3: adding the bfloat16 arithmetic, HBM, and a custom torus interconnect that turn a single accelerator into a training pod.

19. **TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning** — Jouppi et al. · ISCA 2023 · 14pp · [DOI](https://doi.org/10.1145/3579371.3589350) · [PDF](https://arxiv.org/pdf/2304.01433). Optical circuit switches make the interconnect topology itself reconfigurable, plus dedicated hardware for embeddings — where system-level co-design now dominates the win.

20. **Ten Lessons From Three Generations Shaped Google's TPUv4i** — Jouppi et al. · ISCA 2021 · 14pp · [DOI](https://doi.org/10.1109/ISCA52012.2021.00010) · [PDF](https://gwern.net/doc/ai/scaling/hardware/2021-jouppi.pdf). The inference-optimized sibling of the training TPUs, and a retrospective: ten lessons distilled across three chip generations about what actually mattered — backward compatibility, compiler co-design, and provisioning for the workload you will have, not the one you have now.

### Programmable and open accelerators
*Fixed-function silicon is fast but brittle. This line keeps the efficiency while restoring flexibility — and builds the designs in the open, as reusable generators and stacks rather than one-off chips.*

21. **VTA: A Hardware-Software Blueprint for Flexible Deep Learning Acceleration** — Moreau et al. · IEEE Micro 2019 · 7pp · [DOI](https://doi.org/10.1109/MM.2019.2928962) · [PDF](https://arxiv.org/pdf/1807.04188). An open, customizable deep-learning accelerator paired with a compiler (TVM) that targets it. It makes the hardware/software contract explicit and hackable, so the accelerator and its code generator can be co-designed in the open rather than behind a vendor wall.

22. **Gemmini: Enabling Systematic Deep-Learning Architecture Evaluation via Full-Stack Integration** — Genc et al. · DAC 2021 · 6pp · [DOI](https://doi.org/10.1109/DAC18074.2021.9586216) · [PDF](https://arxiv.org/pdf/1911.09925). A generator, not a chip: parameterize a systolic-array accelerator and emit RTL plus the full software stack, so architects can evaluate a whole design space end-to-end instead of one point. The tooling that makes accelerator design reproducible.

### Beyond a single die
*The current frontier: when one reticle-limited chip is not enough, scale out in the package, across a whole wafer, or into the memory itself.*

23. **Simba: Scaling Deep-Learning Inference with Multi-Chip-Module-Based Architecture** — Shao et al. · MICRO 2019 · 14pp · [DOI](https://doi.org/10.1145/3352460.3358302) · [PDF](https://people.eecs.berkeley.edu/~ysshao/assets/papers/shao2019-micro.pdf). A 36-chiplet package that trades one big die for many small ones, and confronts the non-uniform latency that chiplet interconnect introduces.

24. **Cerebras Architecture Deep Dive: Hardware/Software Co-Design for Deep Learning** — Sean Lie · IEEE Micro 2023 · 13pp · [DOI](https://doi.org/10.1109/MM.2023.3256384) · [PDF](https://8968533.fs1.hubspotusercontent-na2.net/hubfs/8968533/IEEE%20Micro%202023-03%20Hot%20Chips%2034%20Cerebras%20Architecture%20Deep%20Dive.pdf). The other extreme from chiplets: keep the whole wafer as one chip, with distributed SRAM and a fine-grained dataflow fabric built for unstructured sparsity.
    - **Fast Stencil-Code Computation on a Wafer-Scale Processor** — Rocki et al. · [PDF](https://arxiv.org/pdf/2010.03660). What it takes to actually program the wafer: mapping an HPC stencil across 850,000 cores at SC20.

25. **PRIME: A Novel Processing-in-Memory Architecture for Neural Network Computation in ReRAM-Based Main Memory** — Chi, Li, Xu, Zhang, Zhao, Liu, Wang, Xie · ISCA 2016 · 13pp · [DOI](https://doi.org/10.1109/ISCA.2016.13) · [PDF](https://cseweb.ucsd.edu/~jzhao/files/PRIME_isca2016.pdf). Turns ReRAM main memory into the compute unit: reconfigure crossbar arrays to either store data or perform the matrix-vector multiply in place, so weights never move to a separate engine — the digital-PIM counterpart to ISAAC's fully analog approach.

26. **ISAAC: A Convolutional Neural Network Accelerator with In-Situ Analog Arithmetic in Crossbars** — Shafiee et al. · ISCA 2016 · 13pp · [DOI](https://doi.org/10.1109/ISCA.2016.12) · [PDF](https://www.cs.utah.edu/~rajeev/pubs/isca16.pdf). The most radical break: do the matrix-vector multiply as analog current summation inside a memristor crossbar, erasing the memory/compute boundary the roofline is built on.

## Reference shelf — books

- **BUY** **Efficient Processing of Deep Neural Networks** — Sze, Chen, Yang, Emer · 2020 · 341pp · [page](https://link.springer.com/book/10.1007/978-3-031-01766-7). The book-length treatment of the Eyeriss authors' framework; the single best text for the DNN-accelerator design space.
- **BUY** **Computer Architecture: A Quantitative Approach (6th ed.)** — Hennessy, Patterson · 2017 · 936pp · [page](https://shop.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1). Chapter 7, "Domain-Specific Architectures," is the textbook grounding for everything here, written by the authors of the Golden Age lecture.

## Key terms

- **systolic array** — a grid of simple cells that rhythmically pass data to their neighbors, reusing each operand many times before it leaves the array.
- **dataflow (spatial vs temporal)** — spatial engines lay computation out across many PEs and route data between them; temporal engines (SIMD/vector) stream data through one fixed pipeline.
- **row-stationary** — Eyeriss's dataflow that keeps a row of filter weights resident in each PE to maximize local reuse.
- **operational / arithmetic intensity** — FLOPs performed per byte moved; the x-axis of the roofline and the number that decides compute- vs memory-bound.
- **DSA** — domain-specific architecture: hardware specialized for one problem class, trading generality for efficiency.
- **MAC** — multiply-accumulate, the primitive operation of every neural-network layer and the unit accelerators are counted in.
- **eDRAM** — embedded DRAM; denser than SRAM, used by DaDianNao to hold weights on-chip.
- **chiplet / MCM** — a small die integrated with others in one multi-chip-module package instead of a single large monolithic die.
- **wafer-scale integration** — building one enormous processor from an entire wafer rather than dicing it into separate chips.
- **PIM / in-memory computing** — performing computation inside the memory array itself (e.g., analog crossbars) to avoid moving data to a separate compute unit.
- **ReRAM crossbar** — a grid of resistive memory cells that performs an analog matrix-vector multiply in place via Ohm's and Kirchhoff's laws.
- **statically-scheduled (deterministic) dataflow** — the compiler fixes every operation and data movement at compile time, so the hardware needs no caches or arbiters and its latency is exactly predictable.
- **embedding table** — a large learned lookup table mapping sparse categorical IDs to dense vectors; the memory-bound heart of recommendation models.
- **accelerator generator** — parameterized hardware that emits RTL (and often a matching software stack) for a whole family of designs rather than a single fixed chip.
- **structured vs unstructured sparsity** — zeros arranged in a hardware-friendly pattern versus scattered arbitrarily; the former is far easier to accelerate.
- **TOPS · W⁻¹** — tera-operations per second per watt, the efficiency figure of merit accelerators are compared on.
