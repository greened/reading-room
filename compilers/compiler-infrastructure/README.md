# Compilers · Modern infrastructure, polyhedral & tensor compilers

A modern compiler is less a monolithic program than reusable *infrastructure*: a
shared intermediate representation, passes that plug into it, and machinery for
optimizing across files, at link time, on the final binary, and at run time. This
guide walks that stack from the bottom up — start with the SSA-based IR and the LLVM
framework almost everything now assumes, climb through cross-module and
profile-guided optimization, then just-in-time and managed runtimes, then the
polyhedral model's algebra for loop nests, and finish with the domain-specific
tensor compilers that dominate machine learning.

> **How to read this list.** Read SSA and LLVM first — the property and the
> framework the rest of the field builds on. After that each section adds one layer:
> optimization that outlives a single translation unit (ThinLTO, AutoFDO, BOLT),
> compilation deferred to run time where profiles are exact but time is scarce
> (HotSpot, Truffle, copy-and-patch), the polyhedral model that turns loop nests
> into geometry, and finally the DSL and tensor compilers (Halide, TVM) that
> recombine all of it. Papers are ordered as a learning path, not by year.

## Reading order

### The reusable-IR foundation
*Start here: the intermediate representation and the SSA property that every modern framework is built on.*
1. **Efficiently Computing Static Single Assignment Form and the Control Dependence Graph** — Cytron, Ferrante, Rosen, Wegman, Zadeck · ACM TOPLAS 1991 · 40pp · [DOI](https://doi.org/10.1145/115372.115320) · [PDF](https://www.cs.utexas.edu/~pingali/CS380C/2010/papers/ssaCytron.pdf). The algorithm that made SSA practical; the representation under LLVM, GCC, HotSpot, and MLIR alike.
2. **LLVM: A Compilation Framework for Lifelong Program Analysis & Transformation** — Chris Lattner, Vikram Adve · CGO 2004 · 12pp · [DOI](https://doi.org/10.1109/CGO.2004.1281665) · [PDF](https://llvm.org/pubs/2004-01-30-CGO-LLVM.pdf). Launched LLVM, now the dominant reusable compiler infrastructure and the reference design for a typed SSA IR with pluggable passes.
   - **Companion** — [The Architecture of Open Source Applications: LLVM](https://aosabook.org/en/v1/llvm.html). Lattner's own chapter-length tour of how the pieces fit.
   - **Companion** — [LLVM Kaleidoscope tutorial](https://llvm.org/docs/tutorial/). Build a front end onto the IR in an afternoon.
3. **GENERIC and GIMPLE: A New Tree Representation for Entire Functions** — Jason Merrill · GCC Developers' Summit 2003 · 10pp · [PDF](https://gcc.gnu.org/pub/gcc/summit/2003/GENERIC%20and%20GIMPLE.pdf). The tree and three-address IRs at the heart of GCC's middle end — the other great production infrastructure, and a useful contrast to LLVM's design.
   - **Companion** — [GCC internals: GIMPLE](https://gcc.gnu.org/onlinedocs/gccint/GIMPLE.html). The living reference for the representation the paper introduced.
4. **MLIR: Scaling Compiler Infrastructure for Domain Specific Computation** — Lattner, Amini, Bondhugula, Cohen, Davis, Pienaar, Riddle, Shpeisman, Vasilache, Zinenko · CGO 2021 · 21pp · [DOI](https://doi.org/10.1109/CGO51591.2021.9370308) · [PDF](https://arxiv.org/pdf/2002.11054). The multi-level, dialect-based IR framework central to modern ML and accelerator stacks; SSA and LLVM, generalized so many IRs can coexist.
   - **Companion** — [mlir.llvm.org](https://mlir.llvm.org/). Dialects, the pass framework, and the rationale docs.

### Feedback-directed and cross-module optimization
*Once the IR outlives a single file, optimization can cross translation units — and be steered by real execution profiles.*
5. **ThinLTO: Scalable and Incremental LTO** — Teresa Johnson, Mehdi Amini, Xinliang David Li · CGO 2017 · 11pp · [DOI](https://doi.org/10.1109/CGO.2017.7863733) · [PDF](https://storage.googleapis.com/gweb-research2023-media/pubtools/4743.pdf). Whole-program optimization that actually scales, by summarizing modules and importing lazily — how LTO became usable on huge codebases.
6. **AutoFDO: Automatic Feedback-Directed Optimization for Warehouse-Scale Applications** — Dehao Chen, David Xinliang Li, Tipp Moseley · CGO 2016 · 12pp · [DOI](https://doi.org/10.1145/2854038.2854044) · [PDF](https://research.google.com/pubs/archive/45290.pdf). Feeds cheap hardware-sampled profiles back into the compiler, making profile-guided optimization deployable across a fleet.
7. **Optimizing Function Placement for Large-Scale Data-Center Applications (hfsort)** — Guilherme Ottoni, Bertrand Maher · CGO 2017 · 12pp · [DOI](https://doi.org/10.1109/CGO.2017.7863743). Uses call-graph profiles to lay functions out for instruction-cache locality — a profile-guided pass whose payoff is all in the binary's layout.
8. **BOLT: A Practical Binary Optimizer for Data Centers and Beyond** — Panchenko, Auler, Nell, Ottoni · CGO 2019 · 12pp · [DOI](https://doi.org/10.1109/CGO.2019.8661201) · [PDF](https://arxiv.org/pdf/1807.06735). The endpoint of this line: optimize the *linked binary* from a profile, after the compiler is done. State-of-the-art post-link optimization.

### JIT compilation and managed runtimes
*Move compilation to run time, where the profile is exact but the compile-time budget is tiny.*
9. **The Java HotSpot Server Compiler** — Michael Paleczny, Christopher Vick, Cliff Click · USENIX JVM 2001 · 13pp · [PDF](https://www.usenix.org/legacy/events/jvm01/full_papers/paleczny/paleczny.pdf). The canonical adaptive, profile-driven optimizing JIT, built on a sea-of-nodes SSA graph — still the template for production managed runtimes.
10. **Trace-based Just-in-Time Type Specialization for Dynamic Languages (TraceMonkey)** — Gal et al. · PLDI 2009 · 14pp · [DOI](https://doi.org/10.1145/1542476.1542528). Compiles hot *traces* rather than methods, specializing on observed types — the influential trace-JIT design for dynamic languages.
11. **One VM to Rule Them All** — Würthinger et al. · Onward! 2013 · 18pp · [DOI](https://doi.org/10.1145/2509578.2509581) · [PDF](https://lafo.ssw.uni-linz.ac.at/pub/papers/2013_Onward_OneVMToRuleThemAll.pdf). The Truffle/Graal thesis: write a plain AST interpreter and let partial evaluation turn it into an optimizing compiler. One runtime, many languages.
12. **Practical Partial Evaluation for High-Performance Dynamic Language Runtimes** — Würthinger et al. · PLDI 2017 · 15pp · [DOI](https://doi.org/10.1145/3062341.3062381) · [PDF](https://chrisseaton.com/rubytruffle/pldi17-truffle/pldi17-truffle.pdf). The engineering that made the previous paper's idea deliver competitive performance — the paper to read for how Truffle actually works.
13. **Copy-and-Patch Compilation** — Haoran Xu, Fredrik Kjolstad · OOPSLA 2021 · 30pp · [DOI](https://doi.org/10.1145/3485513) · [PDF](https://fredrikbk.com/publications/copy-and-patch.pdf). A fast baseline compiler built by stitching pre-built binary stencils together — orders of magnitude cheaper than a full JIT, and a fresh take on the tier-1 problem.

### The polyhedral model
*A mathematical framework that turns loop nests into geometry — the infrastructure under automatic parallelization and tiling.*
14. **Code Generation in the Polyhedral Model Is Easier Than You Think (CLooG)** — Cédric Bastoul · PACT 2004 · 10pp · [DOI](https://doi.org/10.1109/PACT.2004.1342537) · [PDF](http://icps.u-strasbg.fr/~bastoul/research/papers/Bas04-PACT.pdf). The code-generation half of the polyhedral pipeline: scan a union of polyhedra back into efficient loops. Read this first to make the model concrete.
15. **A Practical Automatic Polyhedral Parallelizer and Locality Optimizer (Pluto)** — Bondhugula, Hartono, Ramanujam, Sadayappan · PLDI 2008 · 13pp · [DOI](https://doi.org/10.1145/1375581.1375595) · [PDF](https://www.ece.lsu.edu/jxr/Publications-pdf/pldi08.pdf). The scheduling half: a cost model that picks tiling and parallelization automatically, making the polyhedral model a practical optimizer.
16. **Polly — Performing Polyhedral Optimizations on a Low-Level Intermediate Representation** — Grosser, Größlinger, Lengauer · Parallel Processing Letters 2012 · 27pp · [DOI](https://doi.org/10.1142/S0129626412500107). Brings the polyhedral model into LLVM IR, so it runs on ordinary programs rather than a special front end — how these ideas reach a production compiler.
17. **Polyhedral Parallel Code Generation for CUDA (PPCG)** — Verdoolaege, Juega, Cohen, Gómez, Tenllado, Catthoor · ACM TACO 2013 · 23pp · [DOI](https://doi.org/10.1145/2400682.2400713). Extends the model to generate GPU code with explicit memory hierarchies — the bridge from CPU loop nests to accelerators.

### DSL and tensor compilers
*Domain-specific IRs plus schedule search — the infrastructure behind today's image-processing and machine-learning stacks.*
18. **Halide: A Language and Compiler for Optimizing Parallelism, Locality, and Recomputation in Image Processing Pipelines** — Ragan-Kelley, Barnes, Adams, Paris, Durand, Amarasinghe · PLDI 2013 · 12pp · [DOI](https://doi.org/10.1145/2491956.2462176) · [PDF](https://people.csail.mit.edu/jrk/halide-pldi13.pdf). The algorithm/schedule separation that reshaped DSL and tensor compilers — write *what* to compute once, search over *how* separately.
   - **Companion** — [halide-lang.org](https://halide-lang.org/). Tutorials and the language reference.
19. **Learning to Optimize Halide with Tree Search and Random Programs** — Adams et al. · SIGGRAPH 2019 · 12pp · [DOI](https://doi.org/10.1145/3306346.3322967) · [PDF](https://halide-lang.org/papers/halide_autoscheduler_2019.pdf). Automates the schedule search Halide left to humans — the autoscheduler that closed much of the expert-vs-automatic gap.
20. **TVM: An Automated End-to-End Optimizing Compiler for Deep Learning** — Tianqi Chen et al. · OSDI 2018 · 16pp · [page](https://www.usenix.org/conference/osdi18/presentation/chen) · [PDF](https://arxiv.org/pdf/1802.04799). The archetypal end-to-end deep-learning compiler: a graph-level IR over a Halide-style tensor IR, lowered to many backends.
21. **Ansor: Generating High-Performance Tensor Programs for Deep Learning** — Lianmin Zheng et al. · OSDI 2020 · 19pp · [page](https://www.usenix.org/conference/osdi20/presentation/zheng) · [PDF](https://arxiv.org/pdf/2006.06762). Replaces TVM's template-guided tuning with hierarchical search over a much larger space — the auto-scheduling successor.
22. **Triton: An Intermediate Language and Compiler for Tiled Neural Network Computations** — Philippe Tillet, H. T. Kung, David Cox · MAPL 2019 · 10pp · [DOI](https://doi.org/10.1145/3315508.3329973) · [PDF](https://www.eecs.harvard.edu/~htk/publication/2019-mapl-tillet-kung-cox.pdf). A tile-level language and compiler that gives near-CUDA GPU performance from Python — now the default way many ML kernels are written.
23. **TASO: Optimizing Deep Learning Computation with Automatic Generation of Graph Substitutions** — Jia, Padon, Thomas, Warszawski, Zaharia, Aiken · SOSP 2019 · 16pp · [DOI](https://doi.org/10.1145/3341301.3359630) · [PDF](https://cs.stanford.edu/~zhihao/papers/sosp19.pdf). Generates *and verifies* graph-rewrite rules automatically instead of hand-writing them — infrastructure for the graph-level optimizer itself.
24. **Tensor Comprehensions: Framework-Agnostic High-Performance Machine Learning Abstractions** — Vasilache et al. · arXiv 2018 · 37pp · [PDF](https://arxiv.org/pdf/1802.04730). Closes the loop back to the polyhedral model: a tensor DSL JIT-compiled through polyhedral scheduling and autotuning. Read it last to see the two halves of this guide meet.

## Reference shelf — books

- **BUY** **Engineering a Compiler** — Cooper, Torczon · 2011 · 824pp · [page](https://shop.elsevier.com/books/engineering-a-compiler/cooper/978-0-12-088478-0). The modern optimizing-compiler text; the clearest treatment of SSA construction, dominance, and data-flow analysis behind the papers above.
- **BUY** **Optimizing Compilers for Modern Architectures** — Allen, Kennedy · 2001 · 790pp · [page](https://shop.elsevier.com/books/optimizing-compilers-for-modern-architectures/allen/978-1-55860-286-1). The dependence-analysis and loop-transformation groundwork the polyhedral work rests on.
- **FREE** **Static Program Analysis** — Møller, Schwartzbach · 2024 · 210pp · [PDF](https://cs.au.dk/~amoeller/spa/spa.pdf). Lattices, fixpoints, and inter-procedural analysis — the theory under the analyses every one of these frameworks runs.

## Key terms

- **IR (intermediate representation)** — the data structure passes operate on; the substrate of a reusable compiler.
- **SSA** — static single assignment: every variable is assigned exactly once, making data flow explicit.
- **dialect** — in MLIR, a self-contained set of IR operations and types, so multiple abstraction levels coexist in one module.
- **LTO / ThinLTO** — link-time optimization across translation units; ThinLTO makes it scale by summarizing modules.
- **PGO / FDO** — profile- (feedback-) guided optimization: recompile using measurements from real runs.
- **JIT** — just-in-time compilation: generate machine code at run time, when types and profiles are known.
- **partial evaluation** — specializing a program (e.g. an interpreter) to fixed inputs; Truffle's route from interpreter to compiler.
- **polyhedral model** — representing loop iterations as integer points in polyhedra so transformations become geometry.
- **tiling** — blocking a loop nest so its working set fits in cache or local memory.
- **schedule** — in Halide/TVM, the choice of loop order, tiling, and parallelism, kept separate from the algorithm.
- **autotuning** — searching a space of schedules or parameters and measuring to pick the fastest.
