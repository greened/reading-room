# Computer architecture · Landmark papers (a survey)

Twelve papers a computer architect should have met at least once — one or two
standouts sliced from each subtopic of the area, each pointing back to the directory
that treats it in depth. Read them as a path, not by date: start with the
quantitative laws that bound every design (Amdahl, roofline), then the machinery of a
single fast core (Tomasulo's out-of-order engine and the branch predictor that keeps
it fed) and the memory hierarchy behind it (Smith's cache survey); cross from one core
to many with sequential consistency (Lamport); watch general-purpose scaling give way
to specialized silicon (the TPU) and to the datacenter-as-a-computer (Google's
cluster); see how architects evaluate designs before building them (gem5) and how the
speculation that made cores fast came back to bite them (Spectre); and close on a road
not taken (VLIW) and the machine whose ISA-as-contract idea organizes everything else
(System/360). For depth on any theme, follow the arrow to its subtopic.

> **How to read this survey.** Each entry is a landmark, not the last word — the
> subtopic directory it points to lists the surrounding work: the predecessors, the
> refinements, and the production systems that grew out of it. The order is
> conceptual, not chronological: it climbs from the laws that bound a design, up
> through one fast core and its memory, out to many cores and to specialized and
> warehouse-scale machines, and finally to the tools, the security fallout, and the
> machines that set the vocabulary.

## Reading order

### Ground rules — how we measure and what bounds us
*Start here: architecture is a quantitative discipline, so before any mechanism, fix what caps a design and the one model architects reason with.*
1. **Validity of the Single Processor Approach to Achieving Large Scale Computing Capabilities** — Gene Amdahl · AFIPS 1967 · 4pp · [DOI](https://doi.org/10.1145/1465482.1465560) · [PDF](https://web.archive.org/web/20191029093307id_/http://www-inst.eecs.berkeley.edu/~n252/paper/Amdahl.pdf). The origin of Amdahl's Law: however many processors you add, a fixed serial fraction caps the speedup — the first and most durable limit every later design runs into. → quantitative-principles/
2. **Roofline: An Insightful Visual Performance Model for Multicore Architectures** — Williams, Waterman, Patterson · CACM 2009 · 11pp · [DOI](https://doi.org/10.1145/1498765.1498785) · [PDF](https://escholarship.org/content/qt78h8v7mr/qt78h8v7mr.pdf). The back-of-the-envelope model architects still reach for: plot attainable performance against operational intensity and one picture shows whether a design is compute- or bandwidth-bound. → quantitative-principles/

### The high-performance core — parallelism in one instruction stream
*With the limits in view, the first lever is overlapping instructions within a single thread — and keeping that wide core fed past its branches.*
3. **An Efficient Algorithm for Exploiting Multiple Arithmetic Units** — Robert M. Tomasulo · IBM J. R&D 1967 · 9pp · [DOI](https://doi.org/10.1147/rd.111.0025) · [PDF](https://www.cs.virginia.edu/~evans/greatworks/tomasulo.pdf). Reservation stations, register renaming, and the common data bus — the dynamic-scheduling engine at the heart of every out-of-order core built since. → superscalar-and-out-of-order/
4. **Combining Branch Predictors** — Scott McFarling · DEC WRL TN-36 1993 · 29pp · [PDF](https://www.ece.ucdavis.edu/~akella/270W05/mcfarling93combining.pdf). A wide out-of-order core stalls without accurate branch prediction; this defined gshare and the tournament predictor that most 1990s cores shipped — the template later predictors refine. → branch-prediction-and-speculation/

### Feeding the core — the memory hierarchy
*A fast core starves without a memory system that hides latency; it is one idea repeated at every scale.*
5. **Cache Memories** — Alan Jay Smith · ACM Computing Surveys 1982 · 58pp · [DOI](https://doi.org/10.1145/356887.356892) · [PDF](https://home.engineering.iastate.edu/~zzhang/courses/cpre581-f05/reading/smith-csur82-cache.pdf). The survey that systematized cache design — placement, replacement, line size, write policy — and the single best foundation for the whole hierarchy behind every fast core. → memory-systems-and-storage/

### From one core to many
*When a single core could no longer get faster for free, keeping many cores' views of memory correct became everyone's problem.*
6. **How to Make a Multiprocessor Computer That Correctly Executes Multiprocess Programs** — Leslie Lamport · IEEE TC 1979 · 2pp · [DOI](https://doi.org/10.1109/TC.1979.1675439) · [PDF](https://lamport.azurewebsites.net/pubs/multi.pdf). Two pages that define sequential consistency — the gold-standard shared-memory contract against which every coherence protocol and relaxed model is measured. → multicore-and-memory-consistency/

### When general-purpose scaling ended — specialize, and scale out
*Post-Dennard, performance comes from silicon specialized to a workload, and from treating the whole datacenter as one machine.*
7. **In-Datacenter Performance Analysis of a Tensor Processing Unit (TPU)** — Jouppi et al. · ISCA 2017 · 17pp · [DOI](https://doi.org/10.1145/3079856.3080246) · [PDF](https://arxiv.org/pdf/1704.04760). A systolic matrix unit in production — the landmark domain-specific-accelerator case study, complete with the roofline analysis of why it wins. → domain-specific-accelerators/
8. **Web Search for a Planet: The Google Cluster Architecture** — Barroso, Dean, Hölzle · IEEE Micro 2003 · 7pp · [DOI](https://doi.org/10.1109/MM.2003.1196112) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//archive/googlecluster-ieee.pdf). Reliable planet-scale search built from unreliable commodity parts — the paper that reframed the datacenter itself as the unit of design. → warehouse-scale-computing/

### Studying the machine — and where it bites back
*How architects evaluate a design before there is silicon, and the security cost of the speculation that made cores fast.*
9. **The gem5 Simulator** — Binkert et al. · SIGARCH CAN 2011 · 7pp · [DOI](https://doi.org/10.1145/2024716.2024718) · [PDF](https://research.cs.wisc.edu/multifacet/papers/can11_gem5.pdf). Architecture advances by simulation before silicon; the M5+GEMS merger became the field's de facto full-system, cycle-level simulator and the tool most studies here were run on. → simulation-and-modeling-tools/
10. **Spectre Attacks: Exploiting Speculative Execution** — Kocher, Horn, Fogh, et al. · IEEE S&P 2019 · 16pp · [DOI](https://doi.org/10.1109/SP.2019.00002) · [PDF](https://arxiv.org/pdf/1801.01203). The speculation that makes cores fast also leaks secrets: training the branch predictor to speculate past a security check opened a whole class of transient-execution attacks. → hardware-security/

### The roads not taken, and the machines that set the vocabulary
*Close with an unconventional design that pushed the boundary, and the landmark machine whose ISA endured long after its hardware.*
11. **Very Long Instruction Word Architectures and the ELI-512** — Joseph A. Fisher · ISCA 1983 · 11pp · [DOI](https://doi.org/10.1145/800046.801649) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-S09/handouts/papers/p263-fisher.pdf). The founding VLIW paper: expose all the parallelism statically and let the compiler pack very wide instructions — the road-not-taken whose ideas resurface in DSPs, GPUs, and Itanium. → weird-architectures/
12. **Architecture of the IBM System/360** — Amdahl, Blaauw, Brooks · IBM J. R&D 1964 · 15pp · [DOI](https://doi.org/10.1147/rd.82.0087) · [PDF](https://people.eecs.berkeley.edu/~culler/courses/cs252-s05/papers/amdahl.pdf). The founding statement that an instruction set is a durable contract spanning many implementations — the architecture-vs-microarchitecture distinction that organizes the whole field. → important-machines/

## Reference shelf — books

- **BUY** **Computer Architecture: A Quantitative Approach** — Hennessy, Patterson · 6th ed. 2017 · 936pp · [page](https://shop.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1). The definitive graduate reference and the source of the quantitative method used throughout this survey.
- **BUY** **Computer Organization and Design (RISC-V)** — Patterson, Hennessy · 2nd ed. 2020 · 712pp · [page](https://shop.elsevier.com/books/computer-organization-and-design-risc-v-edition/patterson/978-0-12-820331-6). The standard undergraduate introduction, and the gentlest on-ramp to the whole area.
- **BUY** **Modern Processor Design: Fundamentals of Superscalar Processors** — Shen, Lipasti · 2005 · 642pp · [page](https://www.waveland.com/browse.php?t=624). The canonical deep dive on superscalar microarchitecture — the home base for the Tomasulo and branch-prediction entries.
- **BUY** **Parallel Computer Architecture: A Hardware/Software Approach** — Culler, Singh, Gupta · 1998 · 1025pp · [page](https://shop.elsevier.com/books/parallel-computer-architecture/culler/978-1-55860-343-1). The foundational multiprocessor text on coherence, consistency, and interconnects — the book behind the Lamport entry.
- **BUY** **Memory Systems: Cache, DRAM, Disk** — Jacob, Ng, Wang · 2007 · 1017pp · [page](https://shop.elsevier.com/books/memory-systems/jacob/978-0-12-379751-3). The most comprehensive single volume on the memory-and-storage hierarchy, from SRAM cells to disk mechanics.
- **BUY** **Digital Design and Computer Architecture (RISC-V)** — Harris, Harris · 2021 · 584pp · [page](https://shop.elsevier.com/books/digital-design-and-computer-architecture-risc-v-edition/harris/978-0-12-820064-3). Bridges digital logic and architecture from the gates up, for readers who want the substrate under the ISA.
- **BUY** **Programming Massively Parallel Processors** — Hwu, Kirk, El Hajj · 4th ed. 2022 · 580pp · [page](https://shop.elsevier.com/books/programming-massively-parallel-processors/hwu/978-0-323-91231-0). The standard GPU-architecture and CUDA reference — the companion to the accelerator entry.

## Going deeper

- **quantitative-principles/** — the iron law, Amdahl and Gustafson, Moore and Dennard scaling, the memory and power walls, roofline, and the "new golden age."
- **superscalar-and-out-of-order/** — dynamic scheduling, register renaming, precise state, the ILP limit studies, and speculation on memory and data values.
- **branch-prediction-and-speculation/** — saturating counters through two-level, gshare, perceptron, and TAGE, plus target, confidence, and value prediction.
- **memory-systems-and-storage/** — the hierarchy from caches and NUCA through DRAM scheduling and translation to RAID, flash, and persistent memory.
- **multicore-and-memory-consistency/** — sequential consistency, coherence protocols, relaxed models, synchronization, transactional memory, and the multicore wall.
- **domain-specific-accelerators/** — systolic arrays, GPUs, the DNN-accelerator lineage, sparsity, and datacenter silicon (TPU, Catapult, wafer-scale).
- **warehouse-scale-computing/** — the datacenter as one machine: storage, MapReduce and Spark, cluster scheduling, networks, and disaggregation.
- **simulation-and-modeling-tools/** — cycle-level and full-system simulators, dynamic instrumentation, sampling methodology, and power/area/thermal/DRAM models.
- **hardware-security/** — timing and power side channels, cache primitives, Rowhammer, transient execution (Meltdown/Spectre/MDS), and trusted-execution enclaves.
- **weird-architectures/** — dataflow, VLIW/EPIC, decoupled and systolic pipelines, SIMD and multithreaded machines, and tiled/reconfigurable fabrics.
- **important-machines/** — the landmark machines and ISAs, from System/360 and the CDC 6600 through the Cray-1, VAX, RISC/MIPS, Alpha, and x86.

## Key terms

- **the iron law** — execution time = instructions × cycles-per-instruction × cycle time; every speedup acts on one of the three factors.
- **Amdahl's Law** — the serial fraction of a workload caps its parallel speedup, however many processors you add.
- **operational intensity** — operations performed per byte of memory traffic; the roofline's x-axis, and the number that decides compute- vs bandwidth-bound.
- **out-of-order execution** — issuing instructions as their operands become ready rather than in program order, to hide latency.
- **speculation** — executing past an unresolved branch or dependence on a prediction and rolling back when wrong; the source of both performance and Spectre.
- **memory hierarchy** — a small fast store backed by a large slow one, managed so the fast store almost always holds what is needed.
- **sequential consistency** — the shared-memory contract in which the result is as if all operations ran in one interleaving respecting each thread's program order.
- **cache coherence** — the mechanism keeping many private caches agreeing on the value of each shared location; distinct from the consistency model above.
- **domain-specific architecture (DSA)** — hardware specialized to one problem class, trading generality for efficiency once general-purpose scaling ended.
- **systolic array** — a grid of simple cells that rhythmically pass data to their neighbors, reusing each operand many times before it leaves the array.
- **ISA vs. microarchitecture** — the programmer-visible instruction-set contract, versus how one particular chip implements it.
