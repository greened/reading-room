# Compilers · Vectorization & parallelization

How a compiler takes an ordinary sequential loop and makes it run on SIMD lanes,
many cores, or both — without changing what it computes. Everything here rests on one
analysis: *dependence*. The path below starts there (which iterations must run before
which), builds the algebra of loop transforms that dependence makes legal, cashes it in
first for SIMD vectorization and then for the polyhedral model that unifies the
transforms, and finally scales out to multiprocessors — from static auto-parallelization
to work-stealing task runtimes and speculative execution.

> **How to read this list.** Read the first two sections in order — dependence analysis
> is the ground floor, and nothing later is safe without it. After that the four
> application sections (vectorization, the polyhedral model, auto-parallelization,
> task & speculative parallelism) are largely independent; pick the one you need. The
> polyhedral section is the deep end: read the transform section first so you can see
> what the affine machinery is generalizing.

## Reading order

### Dependence analysis — the ground floor
*You cannot legally reorder or parallelize a loop until you know which iterations depend on which; start here.*
1. **Practical Dependence Testing** — Goff, Kennedy, Tseng · PLDI 1991 · 16pp · [DOI](https://doi.org/10.1145/113445.113448) · [PDF](https://people.cs.rutgers.edu/~uli/cs516/spring2020/readings/PracticalDependenceTesting-PLDI1991.pdf). Classifies subscripts as ZIV/SIV/MIV and applies the cheapest sufficient test to each — the design most production compilers still follow.
2. **The Omega Test: a Fast and Practical Integer Programming Algorithm for Dependence Analysis** — William Pugh · Supercomputing 1991 · 19pp · [DOI](https://doi.org/10.1145/125826.125848) · [PDF](http://www.cs.umd.edu/~pugh/papers/omega.pdf). The *exact* test: integer programming over the iteration space when the cheap tests are inconclusive.

### From dependences to transformations
*Dependences say what is legal; a small algebra of loop transforms turns that freedom into faster code.*
3. **Advanced Compiler Optimizations for Supercomputers** — Padua, Wolfe · CACM 1986 · 18pp · [DOI](https://doi.org/10.1145/7902.7904). The catalog — interchange, fusion, distribution, skewing, scalar expansion — and the vocabulary the rest of this list assumes. Read it first for the names.
4. **A Loop Transformation Theory and an Algorithm to Maximize Parallelism** — Wolf, Lam · IEEE TPDS 1991 · 20pp · [DOI](https://doi.org/10.1109/71.97902) · [PDF](https://suif.stanford.edu/papers/wolf91b.pdf). The unimodular framework: interchange, skewing, and reversal become integer matrices, and legality is a test on the transformed dependence vectors.
5. **A Data Locality Optimizing Algorithm** — Wolf, Lam · PLDI 1991 · 15pp · [DOI](https://doi.org/10.1145/113445.113449) · [PDF](https://suif.stanford.edu/papers/wolf91a.pdf). Applies the unimodular theory plus tiling to maximize reuse — the paper that tied loop transforms to the memory hierarchy.
6. **Compiler Optimizations for Improving Data Locality** — Carr, McKinley, Tseng · ASPLOS 1994 · 11pp · [DOI](https://doi.org/10.1145/195473.195557) · [PDF](https://www.cs.utexas.edu/~mckinley/papers/asplos-1994.pdf). A cost model that drives loop permutation by estimated cache cost — the pragmatic counterpart to the theory above.
7. **Maximizing Loop Parallelism and Improving Data Locality via Loop Fusion and Distribution** — Kennedy, McKinley · LCPC 1993 · 20pp · [DOI](https://doi.org/10.1007/3-540-57659-2_18) · [PDF](https://www.cs.utexas.edu/~mckinley/papers/lcpc-1993.pdf). The complementary pair: fuse to share data and cut synchronization, distribute to expose parallelism (and why fusing for locality is NP-hard).
8. **The Cache Performance and Optimizations of Blocked Algorithms** — Lam, Rothberg, Wolf · ASPLOS 1991 · 12pp · [DOI](https://doi.org/10.1145/106972.106981) · [PDF](https://suif.stanford.edu/papers/lam-asplos91.pdf). The definitive study of tiling: why blocking works, and why the best block size depends on cache interference, not just cache size.

### Vectorization
*The first big payoff of the dependence + transform machinery: turning loops — and straight-line code — into SIMD.*
9. **Conversion of Control Dependence to Data Dependence** — Allen, Kennedy, Porterfield, Warren · POPL 1983 · 13pp · [DOI](https://doi.org/10.1145/567067.567085). If-conversion: rewrite control flow as predicated data flow so a vectorizer can see through branches. Read it before the next paper.
10. **Automatic Translation of FORTRAN Programs to Vector Form** — Allen, Kennedy · ACM TOPLAS 1987 · 52pp · [DOI](https://doi.org/10.1145/29873.29875) · [PDF](http://rsim.cs.uiuc.edu/arch/qual_papers/compilers/allen87.pdf). The foundational dependence-based loop vectorization algorithm — distribution over the dependence graph, cycle by cycle.
11. **Exploiting Superword Level Parallelism with Multimedia Instruction Sets (SLP)** — Larsen, Amarasinghe · PLDI 2000 · 12pp · [DOI](https://doi.org/10.1145/349299.349320) · [PDF](https://groups.csail.mit.edu/cag/slp/SLP-PLDI-2000.pdf). The other route to SIMD: pack isomorphic scalar operations *within a basic block*. The basis of the LLVM and GCC SLP vectorizers.
    - **Auto-Vectorization in LLVM** — [LLVM docs](https://llvm.org/docs/Vectorizers.html). How the loop- and SLP-vectorizers are wired into a production compiler today.
12. **Auto-Vectorization of Interleaved Data for SIMD** — Nuzman, Rosen, Zaks · PLDI 2006 · 12pp · [DOI](https://doi.org/10.1145/1133255.1133997). Vectorizing strided / interleaved accesses via generated pack-and-unpack code — the work behind GCC's loop vectorizer.

### The polyhedral model
*One algebraic framework — iteration spaces as polyhedra, transforms as affine maps — that subsumes the ad-hoc transforms above.*
13. **Dataflow Analysis of Array and Scalar References** — Paul Feautrier · IJPP 1991 · 31pp · [DOI](https://doi.org/10.1007/BF01407931). Exact array dataflow: for each array read, *which* write produced the value. The analysis the whole model is built on.
14. **Some Efficient Solutions to the Affine Scheduling Problem, Part I** — Paul Feautrier · IJPP 1992 · 35pp · [DOI](https://doi.org/10.1007/BF01407835). Recasts scheduling as parametric linear programming — the mathematical core of polyhedral optimization.
15. **A Practical Automatic Polyhedral Parallelizer and Locality Optimizer (Pluto)** — Bondhugula, Hartono, Ramanujam, Sadayappan · PLDI 2008 · 13pp · [DOI](https://doi.org/10.1145/1375581.1375595) · [PDF](https://www.ece.lsu.edu/jxr/Publications-pdf/pldi08.pdf). The cost model that made the model usable: one affine formulation that tiles for parallelism *and* locality at once.
    - **PLUTO** — [project page](http://pluto-compiler.sourceforge.net/). The open-source polyhedral tiler this paper describes.
16. **The Polyhedral Model Is More Widely Applicable Than You Think** — Benabderrahmane, Pouchet, Cohen, Bastoul · CC 2010 · 21pp · [DOI](https://doi.org/10.1007/978-3-642-11970-5_16) · [PDF](https://inria.hal.science/inria-00551087/file/BPCB10-CC.pdf). Extends the model past static-control loops to data-dependent control flow — the step toward applying it to real code.
17. **Polly — Polyhedral Optimization in LLVM** — Grosser, Zheng, Aloor, Simbürger, Größlinger, Pouchet · IMPACT 2011 · 6pp · [PDF](https://perso.ens-lyon.fr/christophe.alias/impact2011/impact-07.pdf). The model inside a production compiler: extract polyhedral regions from LLVM IR, optimize, regenerate.
    - **Polly** — [project page](https://polly.llvm.org/). The living LLVM subproject.

### Auto-parallelization for multiprocessors
*Scale from one SIMD unit to many cores: find independent iterations, then whole loop nests, then fall back to run-time checks.*
18. **Maximizing Multiprocessor Performance with the SUIF Compiler** — Hall, Anderson, Amarasinghe, Murphy, Liao, Bugnion, Lam · IEEE Computer 1996 · 6pp · [DOI](https://doi.org/10.1109/2.546613). The end-to-end system view: how dependence, transforms, and interprocedural analysis combine to auto-parallelize real programs.
19. **Maximizing Parallelism and Minimizing Synchronization with Affine Partitions** — Lim, Lam · Parallel Computing 1998 · 31pp · [DOI](https://doi.org/10.1016/S0167-8191(98)00021-0) · [PDF](https://suif.stanford.edu/papers/lim98.pdf). Loop parallelization as affine partitioning — the generalization of unimodular transforms to whole loop nests across processors.
20. **The LRPD Test: Speculative Run-Time Parallelization of Loops with Privatization and Reduction Parallelization** — Rauchwerger, Padua · PLDI 1995 · 15pp · [DOI](https://doi.org/10.1145/207110.207148). When static dependence analysis can't decide, run the loop as a DOALL and check for cross-iteration conflicts at run time, rolling back if it was wrong.

### Task parallelism & speculative execution
*When parallelism is irregular or can't be proven static, don't partition loops — spawn tasks and balance them, or speculate and roll back.*
21. **Scheduling Multithreaded Computations by Work Stealing** — Blumofe, Leiserson · JACM 1999 · 29pp · [DOI](https://doi.org/10.1145/324133.324234) · [PDF](https://www.csd.uwo.ca/~mmorenom/CS433-CS9624/Resources/Scheduling_multithreaded_computations_by_work_stealing.pdf). The theory first: a randomized work-stealing scheduler with provable time and space bounds. The backbone of every modern task runtime.
22. **The Implementation of the Cilk-5 Multithreaded Language** — Frigo, Leiserson, Randall · PLDI 1998 · 12pp · [DOI](https://doi.org/10.1145/277650.277725) · [PDF](https://pages.cs.wisc.edu/~markhill/restricted/pldi98_cilk.pdf). The theory made cheap: the work-first principle and the THE protocol make spawning a task cost barely more than a function call.
    - **A Minicourse on Multithreaded Programming** — Leiserson, Prokop · [PDF](https://ocw.mit.edu/courses/6-895-theory-of-parallel-systems-sma-5509-fall-2003/9cf3ee7891b56e3e966928ba8dced3f3_minicourse.pdf). Lecture notes deriving the work/span model and the work-stealing bound from scratch — the gentlest on-ramp to the two papers above.
23. **Multiscalar Processors** — Sohi, Breach, Vijaykumar · ISCA 1995 · 12pp · [DOI](https://doi.org/10.1145/223982.224451) · [PDF](https://ftp.cs.wisc.edu/sohi/papers/1995/isca.multiscalar.pdf). Speculation in hardware: split a sequential program into tasks and run them in parallel, squashing on a misspeculated dependence. The architectural root of thread-level speculation.
24. **A Scalable Approach to Thread-Level Speculation** — Steffan, Colohan, Zhai, Mowry · ISCA 2000 · 12pp · [DOI](https://doi.org/10.1145/342001.339650) · [PDF](https://www.cs.cmu.edu/~zhaia/publications/tlds_isca00.pdf). Extends speculative parallelization across a cache-coherent multiprocessor, so software can parallelize loops the compiler can't prove safe.

<!--html-->
<div class="why">
<b>One analysis, four payoffs.</b> Dependence analysis (sections 1–2) is the single
foundation. The transform algebra (3–8) turns legal reorderings into locality and
parallelism; vectorization (9–12) spends it on SIMD lanes; the polyhedral model (13–17)
replaces the ad-hoc transforms with one affine formulation; and multiprocessor
parallelization (18–24) scales it out — statically when dependence can prove
independence, and via run-time tests, work-stealing, or speculation when it cannot.
</div>
<!--/html-->

## Reference shelf — books

- **BUY** **Optimizing Compilers for Modern Architectures: A Dependence-Based Approach** — Randy Allen, Ken Kennedy · 2001 · 790pp · [page](https://www.amazon.com/Optimizing-Compilers-Modern-Architectures-Dependence-based/dp/1558602860). The definitive text on dependence, loop transforms, vectorization, and parallelization — the book behind most of this list.
- **BUY** **High Performance Compilers for Parallel Computing** — Michael Wolfe · 1996 · 570pp · [page](https://www.amazon.com/High-Performance-Compilers-Parallel-Computing/dp/0805327304). Dependence testing, restructuring transforms, and parallelization from a compiler lead who built them.
- **BUY** **Dependence Analysis** — Utpal Banerjee · 1997 · 216pp · [page](https://link.springer.com/book/10.1007/978-1-4757-2589-3). The Banerjee inequalities and the GCD test, formalized (the "Loop Transformations for Restructuring Compilers" series).

## Key terms

- **data dependence** — an ordering constraint between two iterations that touch the same location: flow (write→read), anti (read→write), or output (write→write).
- **distance / direction vector** — how a dependence relates iterations of a loop nest; the signs (`<`, `=`, `>`) tell a transform what it may reorder.
- **ZIV / SIV / MIV** — subscripts with zero, single, or multiple index variables; the classification that picks which (cheap-to-exact) dependence test to run.
- **GCD test** — a fast necessary condition: a linear subscript equation has an integer solution only if the GCD of its coefficients divides the constant term.
- **Banerjee test** — a bounds-based sufficient test for independence, checking whether the dependence equation has a real solution inside the loop limits.
- **unimodular transformation** — a loop reordering (interchange, skew, reversal) expressed as an integer matrix with determinant ±1, so it is invertible and iteration-count preserving.
- **loop skewing** — adding an outer index to an inner bound to expose wavefront parallelism in a dependent nest.
- **tiling / blocking** — splitting a loop into blocks sized to the cache so reused data stays resident.
- **DOALL / DOACROSS** — a fully parallel loop (no cross-iteration dependence) versus one that runs in parallel with explicit synchronization on the dependences it does have.
- **superword-level parallelism (SLP)** — SIMD found by packing isomorphic scalar operations in straight-line code, rather than across loop iterations.
- **polyhedral model** — representing an iteration space as a parametric polyhedron and each transform as an affine map, so scheduling and tiling become linear programming.
- **affine schedule** — an affine function assigning a logical time to each statement instance; the object polyhedral optimizers search for.
- **privatization / reduction** — giving each iteration its own copy of a variable, or recognizing an associative accumulation, to remove a dependence that would otherwise serialize a loop.
- **if-conversion** — replacing control dependence with predicated (data-dependent) execution so branchy code can be vectorized.
- **work stealing** — a scheduler in which idle workers steal tasks from busy ones' queues; provably efficient and the basis of Cilk-style runtimes.
- **thread-level speculation (TLS)** — executing sequential regions in parallel optimistically and rolling back when a run-time dependence violation is detected.
