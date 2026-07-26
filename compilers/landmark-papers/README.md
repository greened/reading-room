# Compilers · Landmark papers (a survey)

Twelve papers a compiler engineer should have read at least once — the slice across
this whole area, one or two standouts per subtopic, each pointing back to the
directory that treats it in depth. Read them as a path, not by date: first the
analysis frameworks and the SSA representation every modern optimizer assumes
(Kildall, Cousot & Cousot, Cytron et al.), then the pointer analysis that most
transforms depend on, the scalar optimization and the register allocator behind the
back end, the loop-and-dependence machinery that feeds vectorization and the
polyhedral model, the reusable infrastructure the field standardized on (LLVM,
MLIR), and finally the work on *trusting* a compiler's output (CompCert, Alive). For
depth on any theme, follow the arrow to its subtopic.

> **The through-line.** The subtopics are not independent — each rests on the one
> before it. Dataflow analysis supplies the basic question, *what is true at this
> program point?*, together with the fixed-point machinery to answer it soundly; SSA
> is the representation that made those analyses sparse and cheap enough to run
> everywhere, and so became the substrate the classical scalar optimizations —
> constant propagation, value numbering, redundancy elimination, dead-code
> elimination — are all phrased over. Those transforms hand off to the back end,
> where register allocation and instruction scheduling map an unbounded value space
> onto a finite machine, while loop and dependence analysis open the orthogonal axis
> of reordering and parallelizing whole iteration spaces. All of it is finally
> packaged as reusable infrastructure — a common IR and the passes that plug into it
> — and once a compiler is this powerful the last question is whether to *trust* it:
> prove it correct once and for all, or validate each run as it happens.

> **How to read this survey.** Each entry is a landmark, not the last word — the
> subtopic directory it points to lists the surrounding work: the predecessors, the
> refinements, and the production systems that grew out of it. Read top to bottom;
> the order builds the machinery an optimizer rests on before spending it on
> transformations, then climbs to infrastructure and correctness.

> **How these lists are organized.** This directory holds two kinds of guide. *This*
> file is the survey — a single curated shelf of twelve papers that spans the whole
> area, at most one or two per theme, meant to be read start to finish in an evening.
> The eight subtopic directories beside it (`intermediate-representations-and-dataflow/`,
> `classical-optimization/`, and the rest) are the in-depth guides: each is a full
> reading path of its own, with the predecessors, competing approaches, and follow-on
> systems the survey has room only to gesture at. The arrow (→) at the end of every
> entry below names the subtopic directory that treats that paper in depth — follow it
> when a landmark makes you want the rest of the story, and use the `## Going deeper`
> index at the foot of this page as the map of where each arrow leads.

## Reading order

### Foundations — the machinery every optimizer rests on
*Start here: what an analysis IS (a fixed point on a lattice), why approximating it is sound, and the representation that finally made it sparse.*
1. **A Unified Approach to Global Program Optimization** — Gary Kildall · POPL 1973 · 14pp · [DOI](https://doi.org/10.1145/512927.512945) · [PDF](https://calhoun.nps.edu/server/api/core/bitstreams/54e90734-ceb5-4f4f-94f6-83e51cd2da73/content). The first unified lattice-theoretic dataflow framework, of which constant folding, CSE, and liveness are all instances. → intermediate-representations-and-dataflow/
2. **Abstract Interpretation: A Unified Lattice Model** — Patrick Cousot, Radhia Cousot · POPL 1977 · 15pp · [DOI](https://doi.org/10.1145/512950.512973) · [PDF](https://www.di.ens.fr/~cousot/publications.www/CousotCousot-POPL-77-ACM-p238--252-1977.pdf). The theory beneath dataflow: an analysis as a sound over-approximation of the semantics, with widening for termination. → abstract-interpretation/
3. **Efficiently Computing Static Single Assignment Form and the Control Dependence Graph** — Cytron, Ferrante, Rosen, Wegman, Zadeck · ACM TOPLAS 1991 · 40pp · [DOI](https://doi.org/10.1145/115372.115320) · [PDF](https://web.eecs.umich.edu/~mahlke/courses/583f23/reading/cytron_toplas_91.pdf). The dominance-frontier construction that made SSA cheap to build — the representation under LLVM, GCC, and MLIR alike. → intermediate-representations-and-dataflow/

### The enabling analysis — what memory a pointer can reach
*Before most transforms are safe you must know what each pointer may refer to; this is the analysis nearly everything else is only as precise as.*
4. **Points-to Analysis in Almost Linear Time** — Bjarne Steensgaard · POPL 1996 · 10pp · [DOI](https://doi.org/10.1145/237721.237727) · [PDF](https://www.cs.cornell.edu/courses/cs711/2005fa/papers/steensgaard-popl96.pdf). Unification-based points-to analysis, one of the two poles (with Andersen's inclusion model) the whole field interpolates between. → pointer-analysis/

### Classic optimization and the back end
*With the framework, SSA, and aliasing in hand: eliminate redundant computation, then map an unbounded value space onto finite registers.*
5. **Lazy Code Motion** — Jens Knoop, Oliver Rüthing, Bernhard Steffen · PLDI 1992 · 11pp · [DOI](https://doi.org/10.1145/143095.143136) · [PDF](http://rsim.cs.uiuc.edu/arch/qual_papers/compilers/knoop92.pdf). Recasts partial-redundancy elimination as clean unidirectional analyses with optimal placement — the version compilers actually implement. → classical-optimization/
6. **Register Allocation & Spilling via Graph Coloring** — Gregory J. Chaitin · SIGPLAN Compiler Construction 1982 · 8pp · [DOI](https://doi.org/10.1145/800230.806984) · [PDF](https://web.eecs.umich.edu/~mahlke/courses/583f12/reading/chaitin82.pdf). Cast register assignment as coloring the interference graph — the model the whole back end is built on. → register-allocation-and-scheduling/

### Loops, dependence, and parallelism
*The other half of optimization — reorder and parallelize loops once dependence proves it legal, first as vectors, then as polyhedral geometry.*
7. **Automatic Translation of FORTRAN Programs to Vector Form** — Randy Allen, Ken Kennedy · ACM TOPLAS 1987 · 52pp · [DOI](https://doi.org/10.1145/29873.29875) · [PDF](http://rsim.cs.uiuc.edu/arch/qual_papers/compilers/allen87.pdf). The foundational dependence-based loop vectorization algorithm. → vectorization-and-parallelization/
8. **A Practical Automatic Polyhedral Parallelizer and Locality Optimizer (Pluto)** — Bondhugula, Hartono, Ramanujam, Sadayappan · PLDI 2008 · 13pp · [DOI](https://doi.org/10.1145/1375581.1375595) · [PDF](https://www.ece.lsu.edu/jxr/Publications-pdf/pldi08.pdf). The cost model that made the polyhedral model usable, tiling for parallelism and locality at once. → vectorization-and-parallelization/

### Reusable infrastructure
*A modern compiler is less a program than shared infrastructure — a common IR and passes that plug into it, generalized until many IRs coexist.*
9. **LLVM: A Compilation Framework for Lifelong Program Analysis & Transformation** — Chris Lattner, Vikram Adve · CGO 2004 · 12pp · [DOI](https://doi.org/10.1109/CGO.2004.1281665) · [PDF](https://llvm.org/pubs/2004-01-30-CGO-LLVM.pdf). The typed SSA IR and pluggable-pass framework that became the industry's common substrate. → compiler-infrastructure/
10. **MLIR: Scaling Compiler Infrastructure for Domain Specific Computation** — Lattner, Amini, Bondhugula, Cohen, Davis, Pienaar, Riddle, Shpeisman, Vasilache, Zinenko · CGO 2021 · 21pp · [DOI](https://doi.org/10.1109/CGO51591.2021.9370308) · [PDF](https://arxiv.org/pdf/2002.11054). Multi-level, dialect-based IR in which domain-specific and low-level representations coexist and lower into one another. → compiler-infrastructure/

### Trusting the output — verification and validation
*The field's answer to "is the optimized code still correct?": prove the whole compiler once, or check each transformation as it runs.*
11. **Formal Verification of a Realistic Compiler (CompCert)** — Xavier Leroy · CACM 2009 · 8pp · [DOI](https://doi.org/10.1145/1538788.1538814) · [PDF](https://xavierleroy.org/publi/compcert-CACM.pdf). The first mechanically verified optimizing C compiler — the reference point for whole-compiler correctness. → verified-compilation/
12. **Provably Correct Peephole Optimizations with Alive** — Lopes, Menendez, Nagarakatte, Regehr · PLDI 2015 · 11pp · [DOI](https://doi.org/10.1145/2737924.2737965) · [PDF](https://users.cs.utah.edu/~regehr/papers/pldi15.pdf). SMT-based verification of LLVM peephole optimizations, now part of everyday LLVM practice. → verified-compilation/

## Reading paths

*Four routes through the list, depending on what you're after.*

- **Building a compiler, front to back.** The machinery first — dataflow (1) and SSA (3) — then the classical optimizations phrased over it (5), the back end (6), and the reusable infrastructure that ties it together (9, 10). Path: 1 → 3 → 5 → 6 → 9 → 10.
- **Program analysis in depth.** The theory first: lattices and fixed points (1), then abstract interpretation (2) as the general soundness framework, then the analysis that makes everything downstream precise — pointer analysis (4). Path: 1 → 2 → 4.
- **Loops and parallelism.** The dependence-based line: classical vectorization (7), then the modern polyhedral model (8) — read once SSA (3) is in hand. Path: 3 → 7 → 8.
- **Trusting the output.** When correctness matters: prove the whole compiler once (11), or validate each optimization as it runs (12). Path: 11 → 12.

## Reference shelf — books

- **BUY** **Compilers: Principles, Techniques, and Tools (the Dragon Book)** — Aho, Lam, Sethi, Ullman · 2nd ed. 2006 · 1009pp · [page](https://www.pearson.com/en-us/subject-catalog/p/compilers-principles-techniques-and-tools/P200000003472). The canonical survey of lexing, parsing, semantics, and code generation.
- **BUY** **Advanced Compiler Design and Implementation** — Steven S. Muchnick · 1997 · 856pp · [page](https://shop.elsevier.com/books/advanced-compiler-design-and-implementation/muchnick/978-0-08-050577-0). The deepest single-volume treatment of production optimization and SSA-era analyses.
- **BUY** **Engineering a Compiler** — Keith Cooper, Linda Torczon · 3rd ed. 2022 · 848pp · [page](https://shop.elsevier.com/books/engineering-a-compiler/cooper/978-0-12-815412-0). The modern engineering-focused course text on SSA construction, value numbering, and coloring allocation.
- **BUY** **Modern Compiler Implementation in ML** — Andrew W. Appel · 1998 · 544pp · [page](https://www.cs.princeton.edu/~appel/modern/ml/). Builds a complete compiler end to end, iterated-register-coalescing allocator included.
- **BUY** **Optimizing Compilers for Modern Architectures** — Randy Allen, Ken Kennedy · 2001 · 790pp · [page](https://shop.elsevier.com/books/optimizing-compilers-for-modern-architectures/allen/978-1-55860-286-1). The reference on dependence analysis, loop transforms, and parallelization.
- **BUY** **Principles of Program Analysis** — Flemming Nielson, Hanne Riis Nielson, Chris Hankin · 1999 · 452pp · [page](https://link.springer.com/book/10.1007/978-3-662-03811-6). A rigorous unifying treatment of dataflow, control-flow, and abstract-interpretation analyses.
- **FREE** **Crafting Interpreters** — Robert Nystrom · 2021 · 640pp · [book](https://craftinginterpreters.com/). Builds a tree-walk then a bytecode interpreter from scratch, free in full online.

## Going deeper

Each survey entry above ends with an arrow to one of these directories; each is a full
reading path in its own right. Follow the one whose theme you want the rest of the
story on.

- **intermediate-representations-and-dataflow/** — How the IR you choose decides which
  analyses are cheap, read together with the dataflow theory that says what those
  analyses can prove. It runs from the foundations — Kildall's lattice framework and
  Kam–Ullman's convergence theory — through the dominance-frontier SSA construction of
  Cytron et al. to the graph IRs that fold control and data into one structure:
  Ferrante–Ottenstein–Warren's program dependence graph and Click–Paleczny's
  sea-of-nodes. The standouts are Kildall's unified framework, the Cytron et al. SSA
  algorithm, and the sea-of-nodes IR that production JITs adopted.
- **classical-optimization/** — The scalar transformations that define the field's
  working vocabulary: constant propagation and folding, value numbering and global value
  numbering, partial-redundancy elimination, strength reduction, dead-code elimination,
  and inlining. The path runs from the local, ad-hoc form of each transform to its
  global, SSA-based reformulation, and finally to the view that unifies many of them as
  one idea. The standouts are Wegman–Zadeck's sparse conditional constant propagation,
  Knoop–Rüthing–Steffen's lazy code motion, and the Futamura projections that recast the
  whole area as partial evaluation.
- **register-allocation-and-scheduling/** — The back end's twin problems: mapping an
  unbounded value space onto a finite register file, and ordering instructions so a
  pipelined machine stays busy. Chaitin's 1982 graph-coloring model anchors allocation,
  Hack's SSA-based allocation is the turn that showed the interference graph is chordal
  and so easy to color, and Fisher's trace scheduling opens the scheduling track that
  closes on the phase-ordering problem of doing both at once. The standouts are Chaitin's
  coloring allocator, SSA-based allocation, and trace scheduling.
- **vectorization-and-parallelization/** — Turning a sequential loop into SIMD lanes or
  many cores without changing what it computes, all resting on dependence analysis to
  prove the reordering legal. It builds from Allen–Kennedy's dependence-based
  vectorization through the polyhedral model — Feautrier's affine scheduling and
  Bondhugula's Pluto cost model — out to superword-level parallelism for short vectors
  and the work-stealing runtimes (Cilk) that scale it across processors. The standouts
  are Allen–Kennedy, Feautrier's scheduling, and Pluto.
- **pointer-analysis/** — Deciding what each pointer may refer to, the enabling analysis
  nearly every other one is only as precise as. Hind's survey fixes the design axes —
  flow-, context-, field-, and object-sensitivity — along which every algorithm trades
  precision for scale; Andersen's inclusion-based model and Steensgaard's almost-linear
  unification model are the two poles the rest of the field interpolates between and
  scales up to whole programs. The standouts are Andersen's and Steensgaard's analyses
  and Hind's survey.
- **abstract-interpretation/** — The theory of sound static analysis by approximation,
  founded on Cousot & Cousot's 1977 and 1979 papers on Galois connections and fixpoints.
  From that base it treats each design choice in turn — numeric domains (intervals,
  octagons, polyhedra), widening and narrowing for convergence, interprocedural summaries
  via IFDS/IDE, shape analysis for the heap, and CEGAR for automatic refinement — and
  ends on the Astrée analyzer proving avionics code free of run-time errors. The
  standouts are the Cousots' founding papers, the IFDS framework, and Astrée.
- **compiler-infrastructure/** — The modern compiler seen as reusable infrastructure: a
  shared IR, pluggable passes, and machinery for optimizing across translation units, at
  link time, on the binary, and at run time. It spans LLVM and MLIR, cross-module and
  profile-guided optimization (ThinLTO, AutoFDO, BOLT), the JIT and managed runtimes
  (HotSpot, Truffle/Graal), and the polyhedral and tensor/DSL compilers (Pluto, Halide,
  TVM) that specialize the substrate for one domain. The standouts are LLVM, MLIR, and
  Halide.
- **verified-compilation/** — Two ways to trust generated code: prove the compiler
  correct once and for all, or check each transformation as it runs. The first line runs
  through CompCert's mechanized C compiler and CakeML reaching all the way down to
  verified machine code; the second, translation validation, runs from Pnueli's original
  formulation through Alive and Alive2 for LLVM peepholes to the superoptimizers (STOKE,
  Souper) that search for better code and verify the result. The standouts are CompCert,
  Alive2, and CakeML.

## Key terms

The vocabulary these papers assume, cutting across every subtopic above.

- **SSA (static single assignment)** — an IR in which every variable is assigned
  exactly once, so each use has one unambiguous definition; the representation LLVM,
  GCC, and MLIR all build on.
- **dataflow lattice** — the ordered set of facts an analysis tracks (e.g. "constant,
  variable, or unknown"), whose meet operation combines facts arriving on different
  paths and guarantees a unique solution.
- **fixed point** — the stable solution a dataflow analysis iterates toward: the point
  at which one more pass over the program changes nothing.
- **dominance frontier** — the set of program points where two control paths merge and
  a value's definition can no longer be assumed; where SSA construction places its φ
  (phi) nodes.
- **PRE (partial-redundancy elimination)** — hoisting a computation that is redundant on
  *some* but not all incoming paths so it is evaluated once; lazy code motion is its
  canonical formulation.
- **value numbering** — assigning the same symbolic number to computations that provably
  yield the same value so a redundant one can be replaced by the earlier result; global
  value numbering (GVN) does this across a whole function's SSA form.
- **register allocation / graph coloring** — assigning a program's unbounded values to a
  finite register file by coloring the interference graph so that no two
  simultaneously-live values share a register.
- **interference graph** — a graph whose nodes are values and whose edges join values
  live at the same time; a valid register assignment is a proper coloring of it.
- **instruction scheduling** — reordering the instructions in a block or region to hide
  functional-unit and memory latency and keep a pipelined or VLIW machine busy, subject
  to the dependences that fix which orderings are legal.
- **dependence** — an ordering constraint between two operations (they touch the same
  location, one writing) that must be preserved; loop-carried dependences decide when a
  loop can be vectorized or parallelized.
- **polyhedral model** — representing loop nests and their iteration spaces as integer
  polyhedra so that tiling, fusion, and parallelization become affine transformations of
  geometry.
- **points-to / alias analysis** — computing, for each pointer, the set of memory
  locations it may refer to; two pointers *alias* when their points-to sets overlap.
- **abstract interpretation** — a framework for sound static analysis that computes a
  decidable over-approximation of a program's exact (uncomputable) behavior, connected to
  the concrete semantics by a Galois connection.
- **widening** — an operator that accelerates or forces termination of a fixpoint
  iteration over an infinite-height domain by jumping to a safe over-approximation.
- **lowering** — rewriting a program from a higher-level, more abstract IR into one
  closer to the machine; in MLIR this proceeds dialect by dialect, each dialect a
  self-contained set of operations and types that lowers into the next.
- **translation validation** — verifying that a single compiler *run* preserved
  semantics, checking the output rather than proving the whole compiler correct.
