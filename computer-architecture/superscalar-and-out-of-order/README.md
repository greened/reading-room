# Computer architecture · Superscalar & out-of-order execution

The datapath of high-performance cores: dynamic scheduling, register renaming,
precise state, wide issue, and the limits of instruction-level parallelism. The path
below starts with the two original dynamic-scheduling engines, adds the machinery that
makes speculation *safe* (precise state), pins down the vocabulary and design space,
asks how much parallelism is actually out there, then shows how real machines chase it
past the obvious limits — widening the front end, then scaling the window without
melting the clock — and ends in three shipped cores that assemble every idea.

> **How to read this list.** Read the CDC 6600 and Tomasulo first: every modern core is
> still one of these two mechanisms (a scoreboard, or reservation stations with
> renaming) made precise and made wide. Next comes the precise-state work that turned
> out-of-order execution from a curiosity into something you can build a real ISA on.
> Only then are the survey, the limit studies, and the speculation papers worth reading —
> they all argue over how far to push those first two engines. The last two sections are
> the modern refinement: how to keep widening and deepening the window when the issue
> logic, register file, and memory latency all fight back.

## Reading order

### The two original engines
*Where out-of-order execution began; every core since descends from one of these two.*
1. **Parallel Operation in the Control Data 6600** — James E. Thornton · AFIPS FJCC 1964 · 8pp · [DOI](https://doi.org/10.1145/1464039.1464045) · [PDF](https://bitsavers.org/pdf/afips/1964-10_%2326_Part_2.pdf). The CDC 6600 scoreboard: the first hardware dynamic instruction scheduling. (Open PDF is the full AFIPS proceedings scan; the paper begins at p. 33.)
2. **An Efficient Algorithm for Exploiting Multiple Arithmetic Units** — Robert M. Tomasulo · IBM J. R&D 1967 · 9pp · [DOI](https://doi.org/10.1147/rd.111.0025) · [PDF](https://www.cs.virginia.edu/~evans/greatworks/tomasulo.pdf). Reservation stations, register renaming, and the common data bus — the algorithm at the heart of every OoO core.
   - **Companion** — [VIDEO](https://www.youtube.com/watch?v=P-mXr9adbCc). Onur Mutlu's CMU lecture walks the scoreboard, Tomasulo, and the reorder buffer on a whiteboard; the fastest way to internalize items 1–4.

### Making speculation safe: precise state
*Out-of-order execution is only usable if the machine can still present in-order architectural state on an interrupt or misprediction; these define how.*
3. **Implementation of Precise Interrupts in Pipelined Processors** — James E. Smith, Andrew R. Pleszkun · ISCA 1985 · 9pp · [DOI](https://doi.org/10.1145/327070.327125) · [PDF](https://www.ardent-tool.com/CPU/docs/AMD/anatomy/misc/articles/smith.pdf). Introduces the reorder buffer and in-order retirement — the standard way to keep precise state under out-of-order completion. (Open PDF is the extended IEEE Trans. Computers 1988 version.)
4. **HPS, a New Microarchitecture: Rationale and Introduction** — Yale Patt, Wen-mei Hwu, Michael Shebanow · MICRO-18 1985 · 6pp · [DOI](https://doi.org/10.1145/18927.18916) · [PDF](https://hps.ece.utexas.edu/pub/patt_micro18.pdf). "Restricted dataflow": the blueprint for aggressive OoO with checkpoint/recovery that later cores followed.
5. **Instruction Issue Logic for High-Performance, Interruptible, Multiple Functional Unit, Pipelined Computers** — Gurindar S. Sohi · IEEE Trans. Computers 1990 · 11pp · [DOI](https://doi.org/10.1109/12.48865) · [PDF](https://www.eecs.harvard.edu/cs146-246/sohi-ruu.pdf). The register update unit (RUU): a single structure unifying issue, renaming, and precise interrupts — the most concrete "how to build it" of this group.

### Naming the machine: the canonical models
*With the pieces in place, these give the vocabulary and the design space you'll use to reason about any core.*
6. **The Microarchitecture of Superscalar Processors** — James E. Smith, Gurindar S. Sohi · Proceedings of the IEEE 1995 · 16pp · [DOI](https://doi.org/10.1109/5.476078) · [PDF](https://minds.wisconsin.edu/bitstream/1793/9476/1/file_1.pdf). The canonical survey that fixed the field's vocabulary (fetch, dispatch, issue, complete, retire); read this to organize everything else.
7. **The Design Space of Register Renaming Techniques** — Dezső Sima · IEEE Micro 2000 · 14pp · [DOI](https://doi.org/10.1109/40.877952). Systematizes renaming into scope, rename-buffer layout, mapping method, and rename rate — the taxonomy behind RATs, physical register files, and merged register files.

### How much parallelism is really there?
*Before building ever-wider machines, know the ceiling; these two limit studies set the terms of the debate for a decade.*
8. **Available Instruction-Level Parallelism for Superscalar and Superpipelined Machines** — Norman P. Jouppi, David W. Wall · ASPLOS 1989 · 11pp · [DOI](https://doi.org/10.1145/68182.68207) · [PDF](https://web.archive.org/web/2020id_/https://www.hpl.hp.com/techreports/Compaq-DEC/WRL-89-7.pdf). Measures how much ILP realistic hardware can find, and how superscalar and superpipelined designs compare. (Open PDF is the extended WRL Research Report 89/7.)
9. **Limits of Instruction-Level Parallelism** — David W. Wall · ASPLOS-IV 1991 · 13pp · [DOI](https://doi.org/10.1145/106972.106991) · [PDF](https://web.archive.org/web/20220116144814id_/https://www.hpl.hp.com/techreports/Compaq-DEC/WRL-93-6.pdf). The landmark study on realistically available ILP under perfect and imperfect prediction — the number that told architects where speculation had to go next. (Open PDF is the fuller WRL Research Report 93/6.)

### Beating the dataflow limit: speculating on data and memory
*The limit studies motivated speculating past true dependences — on memory ordering, then on values themselves.*
10. **Memory Dependence Prediction Using Store Sets** — George Z. Chrysos, Joel S. Emer · ISCA 1998 · 12pp · [DOI](https://doi.org/10.1145/279361.279378) · [PDF](https://people.csail.mit.edu/emer/media/papers/1990s/1998/1998.06.isca.storesets.pdf). Store-sets memory disambiguation: lets loads speculate past stores accurately, the scheme the Alpha 21264 shipped.
11. **Value Locality and Load Value Prediction** — Mikko H. Lipasti, Christopher B. Wilkerson, John Paul Shen · ASPLOS 1996 · 10pp · [DOI](https://doi.org/10.1145/237090.237173) · [PDF](https://pharm.ece.wisc.edu/mikko/oldpapers/asplos7.pdf). Observes that loads often return the same value and predicts it — the opening move in value prediction, which speculates *through* true data dependences.

### Feeding and widening the machine
*Wide issue is worthless if you can't fetch fast enough or there aren't enough independent instructions in one thread; four different answers, from a wider fetch to splitting the stream across engines.*
12. **Trace Cache: a Low Latency Approach to High Bandwidth Instruction Fetching** — Eric Rotenberg, Steve Bennett, James E. Smith · MICRO-29 1996 · 11pp · [DOI](https://doi.org/10.1109/MICRO.1996.566447) · [PDF](https://www.eecs.harvard.edu/cs146-246/micro.trace-cache.pdf). Caches dynamic instruction traces so a wide front end can fetch past taken branches — later shipped as the Pentium 4's execution trace cache.
13. **Multiscalar Processors** — Gurindar S. Sohi, Scott E. Breach, T. N. Vijaykumar · ISCA 1995 · 12pp · [DOI](https://doi.org/10.1145/223982.224451) · [PDF](https://ftp.cs.wisc.edu/sohi/papers/1995/isca.multiscalar.pdf). Splits one program across cooperating processing units to reach ILP a single window can't — the road not taken by mainstream cores, and still influential.
14. **Trace Processors** — Eric Rotenberg, Quinn Jacobson, Yiannakis Sazeides, James E. Smith · MICRO-30 1997 · 12pp · [DOI](https://doi.org/10.1109/MICRO.1997.645805) · [PDF](https://ftp.cs.wisc.edu/sohi/papers/1997/micro.trace-processors.pdf). Builds a distributed core around the trace: hierarchical registers and multiple processing elements each run one trace, so the effective window grows without a single monolithic issue window — the multiscalar idea fused with the trace cache.
15. **Simultaneous Multithreading: Maximizing On-Chip Parallelism** — Dean M. Tullsen, Susan J. Eggers, Henry M. Levy · ISCA 1995 · 12pp · [DOI](https://doi.org/10.1109/isca.1995.524578) · [PDF](https://cseweb.ucsd.edu/~tullsen/isca95.pdf). When one thread runs dry, fill the wide issue width from several — the idea behind Hyper-Threading and modern SMT cores.

### Scaling the window without melting the clock
*Making the window wide and deep runs into quadratic wakeup/bypass/register cost and the memory wall; these are the refinements that let real cores keep scaling.*
16. **Complexity-Effective Superscalar Processors** — Subbarao Palacharla, Norman P. Jouppi, James E. Smith · ISCA 1997 · 13pp · [DOI](https://doi.org/10.1145/264107.264201) · [PDF](https://ftp.cs.wisc.edu/sohi/papers/1997/isca.complexity.pdf). Shows which structures (wakeup, selection, bypass) grow quadratically and cap the clock, then proposes a clustered, dependence-steered issue window — the framing paper for every later scaling trick.
    - **Companion** — [PDF](https://bpb-us-w2.wpmucdn.com/sites.coecis.cornell.edu/dist/7/587/files/2023/06/Palacharla_1997_Complexity.pdf). The authors' 2pp ISCA@50 retrospective, with the benefit of 25 years of hindsight on what actually shipped.
17. **Reducing the Complexity of the Register File in Dynamic Superscalar Processors** — Rajeev Balasubramonian, Sandhya Dwarkadas, David H. Albonesi · MICRO-34 2001 · 12pp · [DOI](https://doi.org/10.1109/MICRO.2001.991122) · [PDF](https://www.csl.cornell.edu/~albonesi/research/papers/micro01.pdf). A two-level, banked physical register file that keeps the fast structure small — the direct attack on the register-file cost Palacharla flags.
18. **Runahead Execution: An Alternative to Very Large Instruction Windows for Out-of-Order Processors** — Onur Mutlu, Jared Stark, Chris Wilkerson, Yale N. Patt · HPCA 2003 · 12pp · [DOI](https://doi.org/10.1109/HPCA.2003.1183532) · [PDF](https://hps.ece.utexas.edu/pub/mutlu_hpca03.pdf). Rather than build a huge window, keep executing speculatively past a stalling L2 miss purely to generate prefetches — buying memory-level parallelism with a small window.
19. **Checkpoint Processing and Recovery: Towards Scalable Large Instruction Window Processors** — Haitham Akkary, Ravi Rajwar, Srikanth T. Srinivasan · MICRO-36 2003 · 12pp · [DOI](https://doi.org/10.1109/MICRO.2003.1253246) · [PDF](https://microarch.org/micro36/html/pdf/akkary-CheckpointProcessing.pdf). Replaces the per-instruction reorder buffer with sparse checkpoints and aggressive register reclamation, so a very large window needs no correspondingly large cycle-critical structures.
20. **Continual Flow Pipelines** — Srikanth T. Srinivasan, Ravi Rajwar, Haitham Akkary, Amit Gandhi, Mike Upton · ASPLOS 2004 · 13pp · [DOI](https://doi.org/10.1145/1024393.1024407) · [PDF](https://pages.cs.wisc.edu/~rajwar/papers/asplos04.pdf). Drains miss-dependent instructions out of the scheduler and register file into a slice buffer and replays them when the miss returns — a large effective window with small scheduler and register file.
21. **Pipeline Gating: Speculation Control for Energy Reduction** — Srilatha Manne, Artur Klauser, Dirk Grunwald · ISCA 1998 · 10pp · [DOI](https://doi.org/10.1109/ISCA.1998.694769) · [PDF](https://users.cs.utah.edu/~rajeev/cs7810/papers/manne98.pdf). Wide speculation wastes energy on wrong-path work; gate the front end when branch confidence is low — the power counterpart to all the performance-chasing above.
    - **Companion** — [PDF](https://sites.coecis.cornell.edu/isca50retrospective/files/2023/06/MANNE_1998_PIPELINE.pdf). The authors' 2pp ISCA@50 retrospective on how confidence estimation and speculation control aged.

### Three machines that put it all together
*See the ideas above as shipped silicon, from three very different design philosophies.*
22. **The MIPS R10000 Superscalar Microprocessor** — Kenneth C. Yeager · IEEE Micro 1996 · 13pp · [DOI](https://doi.org/10.1109/40.491460) · [PDF](https://ece552.ece.wisc.edu/mipsr10000.pdf). The first widely shipped commercial OoO core to use a physical register file with map tables and an active list — textbook renaming made real, and the concrete model most courses teach.
23. **The Alpha 21264 Microprocessor** — Richard E. Kessler · IEEE Micro 1999 · 13pp · [DOI](https://doi.org/10.1109/40.755465). A clean, aggressive OoO core: register renaming, a large instruction window, store-sets memory speculation, and a clustered integer datapath.
    - **Conference version** — [PDF](https://userpages.umbc.edu/~squire/images/alpha21264a.pdf). The 6pp ICCD 1998 precursor ("The Alpha 21264 Microprocessor Architecture"), open access.
24. **The Microarchitecture of the Pentium 4 Processor** — Glenn Hinton et al. · Intel Technology Journal 2001 · 13pp · [PDF](http://www.ecs.umass.edu/ece/koren/ece568/papers/Pentium4.pdf). NetBurst: a very deep pipeline, an execution trace cache, and a double-pumped ALU — the contrasting bet on frequency over width.

<!--html-->
<div class="why">
<b>One window, two mechanisms.</b> Strip away four decades of engineering and every
out-of-order core is still either a <em>scoreboard</em> (CDC 6600 — track readiness in a
central table) or <em>reservation stations with renaming</em> (Tomasulo — let each
operation wait on a tag and grab its inputs off a broadcast bus). Everything after is
about making that engine <em>precise</em> (reorder buffer, RUU), <em>wide</em> (trace
cache, trace/multiscalar processors, SMT), and <em>speculative</em> — past branches, past
memory ordering, even past data values — because the limit studies showed the parallelism
is only there if you are willing to guess. The last turn is <em>scale</em>: once wakeup,
bypass, the register file, and memory latency all push back, the wins come from clustering,
smaller cycle-critical structures, checkpoints, and running ahead — not from a bigger
monolithic window.
</div>
<!--/html-->

## Reference shelf — books

- **BUY** **Modern Processor Design: Fundamentals of Superscalar Processors** — John Paul Shen, Mikko H. Lipasti · 2013 · 642pp · [page](https://www.waveland.com/browse.php?t=624). The standard graduate text on superscalar organization; the natural home base for every paper above.
- **BUY** **Superscalar Microprocessor Design** — Mike Johnson · 1991 · 288pp · [page](https://openlibrary.org/isbn/0138756341). The first book to systematize fetch / rename / dispatch / completion, written from the HPS-era design experience. (ISBN 0-13-875634-1)
- **BUY** **Computer Architecture: A Quantitative Approach** — John L. Hennessy, David A. Patterson · 6th ed. 2017 · 936pp · [page](https://shop.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1). Chapter 3 ("Instruction-Level Parallelism and Its Exploitation") is the quantitative companion to this whole list.

## Key terms

- **scoreboard** — a central table tracking which registers and functional units are busy, used to issue instructions out of order while stalling on hazards (CDC 6600).
- **reservation station** — a buffer holding a waiting operation and its operands (or the tags it is waiting for), so the operation can fire as soon as its inputs are ready (Tomasulo).
- **register renaming** — mapping architectural registers to a larger pool of physical/rename registers to remove false (WAR/WAW) dependences.
- **register alias table (RAT)** — the map from architectural to physical registers that renaming maintains and checkpoints.
- **physical register file (PRF)** — a single pool of physical registers holding both in-flight and committed values, addressed through the rename map; the R10000/21264 organization Sima's taxonomy calls the merged file.
- **reorder buffer (ROB)** — a FIFO that holds results until instructions retire in program order, giving precise interrupts under out-of-order completion.
- **precise interrupt** — an interrupt or exception at which architectural state is exactly as if instructions executed strictly in order up to the faulting one.
- **in-order retirement (commit)** — committing results to architectural state in program order, even though execution finished out of order.
- **checkpoint recovery** — restoring state to a saved snapshot rather than unwinding a per-instruction buffer, so the window can grow without a large ROB (CPR).
- **wakeup and select** — the issue-logic step that flags ready operations (wakeup) and picks which fire this cycle (select); its delay grows with window size and issue width.
- **clustered microarchitecture** — splitting the issue window, register file, and bypass network into smaller clusters to keep per-cluster delay low, at the cost of inter-cluster forwarding.
- **instruction-level parallelism (ILP)** — independent instructions that can execute concurrently; the resource all of this hardware exists to harvest.
- **memory-level parallelism (MLP)** — overlapping several outstanding cache misses so their latencies hide behind one another; what runahead and continual-flow pipelines chase.
- **memory disambiguation** — deciding at run time whether a load and an earlier store touch the same address, so loads can be reordered ahead of stores safely.
- **value prediction** — predicting an instruction's result to break a true data dependence speculatively.
- **trace cache** — an instruction cache holding dynamic execution traces so a wide front end can fetch across taken branches in one access.
- **runahead execution** — continuing speculative execution past a stalling long-latency miss purely to prefetch, then discarding the results and restarting.
- **pipeline gating** — throttling the front end when branch confidence is low, to stop wrong-path instructions from wasting energy.
- **simultaneous multithreading (SMT)** — issuing instructions from several threads in the same cycle to fill a wide core's unused issue slots.
</content>
