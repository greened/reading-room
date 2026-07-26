# Compilers · Intermediate representations & dataflow

The IR you choose decides which analyses are easy and which are impossible; the
dataflow framework decides what those analyses can prove. This list reads the two
together, as a single arc: start with the *theory* of dataflow (a monotone function
on a lattice, solved to a fixed point), then the *shape* of control flow that makes
solving cheap (reducibility, intervals, dominance), then the *representation* that
made sparse analysis routine (SSA — building it, analyzing over it, and leaving it),
and finally the *graph IRs* — dependence graphs, sea-of-nodes, gated and
value-dependence forms, and today's reusable infrastructure — that fold control and
data into one structure. Muchnick's *Advanced Compiler Design* is the companion text
throughout.

> **How to read this list.** Representation and analysis are two sides of one coin.
> Read the foundations (Kildall → Kam–Ullman → Cousot) to see what "dataflow" *is*,
> then treat everything after as a search for representations that make those
> fixed-point computations cheaper and sharper — dominance for placing φ, SSA for
> sparsity, graph IRs for making dependences explicit. If you only read four: Kildall,
> Cytron et al., Ferrante–Ottenstein–Warren, and Click–Paleczny.

## Reading order

### Dataflow foundations — the fixed-point framework
*Start here: what a dataflow analysis IS — a monotone transfer function on a lattice, iterated to a fixed point — and how to solve it.*

1. **A Unified Approach to Global Program Optimization** — Gary Kildall · POPL 1973 · 14pp · [DOI](https://doi.org/10.1145/512927.512945) · [PDF](https://calhoun.nps.edu/server/api/core/bitstreams/54e90734-ceb5-4f4f-94f6-83e51cd2da73/content). Founded lattice-theoretic dataflow: the first unified fixed-point framework, of which constant folding, CSE, and liveness are all instances.

2. **Global Data Flow Analysis and Iterative Algorithms** — Kam, Ullman · JACM 1976 · 14pp · [DOI](https://doi.org/10.1145/321921.321938). The iterative (worklist) solver analyzed: when round-robin iteration converges, and how fast, in terms of the graph's loop-connectedness.

3. **Abstract Interpretation: A Unified Lattice Model** — Cousot, Cousot · POPL 1977 · 15pp · [DOI](https://doi.org/10.1145/512950.512973) · [PDF](https://www.di.ens.fr/~cousot/COUSOTpapers/publications.www/CousotCousot-POPL-77-ACM-p238--252-1977.pdf). The theory underneath dataflow: analyses are sound abstractions of a concrete semantics, with widening for termination. Explains *why* the lattice framework is correct.

4. **Precise Interprocedural Dataflow Analysis via Graph Reachability (IFDS)** — Horwitz, Reps, Sagiv · POPL 1995 · 14pp · [DOI](https://doi.org/10.1145/199448.199462) · [PDF](https://research.cs.wisc.edu/wpis/papers/popl95.pdf). Recasts a large class of dataflow problems as graph reachability, solved precisely across procedure boundaries — the modern solver behind much static analysis.

### Control-flow structure — reducibility, intervals, elimination
*Before you solve, understand the graph's shape: reducible flow graphs admit fast elimination methods and clean loop structure.*

5. **A Program Data Flow Analysis Procedure** — Allen, Cocke · CACM 1976 · 11pp · [DOI](https://doi.org/10.1145/360018.360025) · [PDF](https://amturing.acm.org/p137-allen.pdf). Introduced interval analysis — the classic elimination approach that exploits nested loop structure instead of blindly iterating.

6. **Characterizations of Reducible Flow Graphs** — Hecht, Ullman · JACM 1974 · 9pp · [DOI](https://doi.org/10.1145/321832.321835). The equivalent definitions of reducibility (the T1/T2 transformations, dominator back edges) that tell you when the fast methods apply.

7. **Structural Analysis: A New Approach to Flow Analysis** — Micha Sharir · Computer Languages 1980 · 13pp · [DOI](https://doi.org/10.1016/0096-0551(80)90007-7). Syntax-directed elimination that recovers high-level control constructs (if/while/…) from the CFG — the ancestor of region-based analysis and Muchnick's control-tree methods.

### Dominance
*SSA construction, loop detection, and structural analysis all rest on dominance; here is how to compute it — first optimally, then simply.*

8. **A Fast Algorithm for Finding Dominators in a Flowgraph** — Lengauer, Tarjan · ACM TOPLAS 1979 · 21pp · [DOI](https://doi.org/10.1145/357062.357071). The near-linear dominator algorithm; the theoretical reference every later method is measured against.

9. **A Simple, Fast Dominance Algorithm** — Cooper, Harvey, Kennedy · Rice CS Tech Report 2001 · 15pp · [PDF](https://c9x.me/compile/bib/quickdom.pdf). An iterative dominance algorithm that is asymptotically worse but faster in practice and trivial to implement — what most production compilers actually use.

### SSA form — construction
*The representation that made sparse analysis routine: one definition per name, joined at merges by φ. First the idea, then how to place φ efficiently, then how to build it in practice.*

10. **Global Value Numbers and Redundant Computations** — Rosen, Wegman, Zadeck · POPL 1988 · 16pp · [DOI](https://doi.org/10.1145/73560.73562). Introduced static single assignment form and used it to find value-equivalent redundancy — SSA's debut.

11. **Efficiently Computing SSA Form and the Control Dependence Graph** — Cytron, Ferrante, Rosen, Wegman, Zadeck · ACM TOPLAS 1991 · 40pp · [DOI](https://doi.org/10.1145/115372.115320) · [PDF](https://web.eecs.umich.edu/~mahlke/courses/583f23/reading/cytron_toplas_91.pdf). The dominance-frontier construction that made SSA cheap to build; the paper that made SSA the standard IR.

12. **Automatic Construction of Sparse Data Flow Evaluation Graphs** — Choi, Cytron, Ferrante · POPL 1991 · 12pp · [DOI](https://doi.org/10.1145/99583.99594). Generalizes the SSA idea to any dataflow problem: build a sparse graph so facts flow only where they can change, not through every program point.

13. **Simple and Efficient Construction of Static Single Assignment Form** — Braun, Buchwald, Hack, Leißa, Mallon, Zwinkau · CC 2013 · 20pp · [DOI](https://doi.org/10.1007/978-3-642-37051-9_6) · [PDF](https://c9x.me/compile/bib/braun13cc.pdf). On-the-fly SSA construction straight from an AST without a separate dominance pass — the method many modern compilers (and JITs) now use.

### SSA-based & sparse analysis
*SSA's payoff: analyses become sparse — propagate along def-use edges, prune with control, and combine passes that were separate over the CFG.*

14. **Constant Propagation with Conditional Branches (SCCP)** — Wegman, Zadeck · ACM TOPLAS 1991 · 30pp · [DOI](https://doi.org/10.1145/103135.103136) · [PDF](https://c9x.me/compile/bib/constpropssa.pdf). Sparse conditional constant propagation over SSA — folds constants and prunes dead branches in one pass, more precisely than either alone. A canonical SSA optimization.

15. **Global Code Motion / Global Value Numbering** — Cliff Click · PLDI 1995 · 12pp · [DOI](https://doi.org/10.1145/207110.207154) · [PDF](https://c9x.me/compile/bib/click-gvn.pdf). Schedules instructions late/early from data dependence alone and eliminates redundancy by value — the analyses that make a graph IR practical, and the bridge to sea-of-nodes.

### Out of SSA
*Real machines have no φ. Leaving SSA correctly — without introducing copies you can't color or schedule — is its own problem.*

16. **Translating Out of Static Single Assignment Form** — Sreedhar, Ju, Gillies, Santhanam · SAS 1999 · 17pp · [DOI](https://doi.org/10.1007/3-540-48294-6_13). The canonical destruction algorithm: handle the "lost copy" and "swap" problems by reasoning about interference among φ-related names.

17. **Revisiting Out-of-SSA Translation for Correctness, Code Quality, and Efficiency** — Boissinot, Hack, Grund, Dupont de Dinechin, Rastello · CGO 2009 · 12pp · [DOI](https://doi.org/10.1109/CGO.2009.19). Corrects subtle bugs in earlier methods and gives a fast, coalescing-aware destruction pass — the version to implement.

### Dependence graphs & graph IRs
*From linear IR to graphs that make dependences explicit — the basis for slicing, vectorization, and the graph IRs inside modern JITs.*

18. **Program Slicing** — Mark Weiser · IEEE TSE 1984 · 6pp · [DOI](https://doi.org/10.1109/TSE.1984.5010248). The motivating use of dependence: extract the sub-program affecting a given value. Slicing is why we want dependences reified in the IR.

19. **The Program Dependence Graph and Its Use in Optimization** — Ferrante, Ottenstein, Warren · ACM TOPLAS 1987 · 31pp · [DOI](https://doi.org/10.1145/24039.24041) · [PDF](https://web.eecs.umich.edu/~mahlke/courses/583f23/reading/ferrante_toplas_87.pdf). Made data *and* control dependences explicit in one graph — the foundation for slicing, vectorization, and every later graph IR.

20. **A Simple Graph-Based Intermediate Representation (sea of nodes)** — Click, Paleczny · IR'95 · 15pp · [DOI](https://doi.org/10.1145/202529.202534) · [PDF](https://www.oracle.com/technetwork/java/javase/tech/c2-ir95-150110.pdf). Fuses control and data into one graph where nodes float until scheduled — the IR behind HotSpot C2, V8 TurboFan, and Graal.
    - **SeaOfNodes/Simple** — [project](https://github.com/SeaOfNodes/Simple). Cliff Click's step-by-step teaching implementation of sea-of-nodes, with a written chapter per commit.

### Gated SSA & value-dependence IRs
*Make control a first-class value so data and control live in one graph — enabling demand-driven and functional-style optimization.*

21. **The Program Dependence Web** — Ballance, Maccabe, Ottenstein · PLDI 1990 · 15pp · [DOI](https://doi.org/10.1145/93542.93578). Gated SSA (γ/μ/η functions that *select* rather than merge) plus a combined control/data/demand-driven IR — the first executable dependence graph.

22. **Combined Code Motion and Register Allocation using the Value State Dependence Graph** — Johnson, Mycroft · CC 2003 · 16pp · [DOI](https://doi.org/10.1007/3-540-36579-6_1). The VSDG: a normalizing IR where equal computations are structurally identical, letting code motion and allocation be solved together — the value-dependence line that dispenses with explicit control flow.
    - **Optimizing Compilation with the Value State Dependence Graph** — [thesis, PDF](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-705.pdf). Alan Lawrence's Cambridge dissertation — the book-length treatment of the VSDG, its semantics, and how to sequentialize it.

### Modern IR infrastructure & rewriting
*Where IR design is now: reusable, retargetable infrastructure, and optimization by equivalence rather than by fixed rewrite order.*

23. **LLVM: A Compilation Framework for Lifelong Program Analysis & Transformation** — Lattner, Adve · CGO 2004 · 12pp · [DOI](https://doi.org/10.1109/CGO.2004.1281665) · [PDF](https://llvm.org/pubs/2004-01-30-CGO-LLVM.pdf). The typed SSA IR and pass infrastructure that became the industry's common substrate.
    - **LLVM Language Reference** — [docs](https://llvm.org/docs/LangRef.html). The living specification of the IR the paper introduced — the form you actually read and write.

24. **Equality Saturation: A New Approach to Optimization** — Tate, Stepp, Tatlock, Lerner · POPL 2009 · 13pp · [DOI](https://doi.org/10.1145/1480881.1480915) · [PDF](https://rosstate.org/publications/eqsat/eqsat_tate_popl09.pdf). The Program Expression Graph: represent *all* equivalent programs at once in an e-graph and extract the best, dodging phase-ordering. E-graphs as an IR.

25. **MLIR: Scaling Compiler Infrastructure for Domain Specific Computation** — Lattner, Amini, Bondhugula, Cohen, Davis, Pienaar, Riddle, Shpeisman, Vasilache, Zinenko · CGO 2021 · 21pp · [DOI](https://doi.org/10.1109/CGO51591.2021.9370308) · [PDF](https://arxiv.org/pdf/2002.11054). Multi-level, dialect-based IR: one framework in which domain-specific and low-level representations coexist and lower into one another. The current direction of IR design.
    - **MLIR project & Toy tutorial** — [mlir.llvm.org](https://mlir.llvm.org/docs/Tutorials/). Hands-on introduction to dialects, operations, and progressive lowering.

## Reference shelf — books

- **FREE** **SSA-based Compiler Design (the "SSA book")** — Rastello, Bouchez Tichadou (eds.) · 2022 · 412pp · [PDF](https://pfalcon.github.io/ssabook/latest/book-full.pdf). The definitive modern treatment of SSA — construction, destruction, φ, and SSA-based analyses and allocation — collecting most of this list's SSA thread in one place.
- **FREE** **Static Program Analysis** — Anders Møller, Michael Schwartzbach · 2024 · 210pp · [PDF](https://cs.au.dk/~amoeller/spa/spa.pdf). A modern, readable course text on lattices, monotone frameworks, fixed points, and abstract interpretation — the theory of the foundations section, worked in detail.
- **BUY** **Advanced Compiler Design and Implementation** — Steven Muchnick · 1997 · 856pp · [page](https://shop.elsevier.com/books/advanced-compiler-design-and-implementation/muchnick/978-0-08-050577-0). The companion text: HIR/MIR/LIR representations, interval and structural analysis, and the dataflow machinery, all in implementable detail.
- **BUY** **Compilers: Principles, Techniques, and Tools (the Dragon Book)** — Aho, Lam, Sethi, Ullman · 2nd ed. 2006 · 1009pp · [page](https://www.pearson.com/en-us/subject-catalog/p/compilers-principles-techniques-and-tools/P200000003472). The standard reference for the dataflow-analysis foundations, with careful proofs of the lattice and iterative-solver results.

## Key terms

- **lattice** — the partially ordered set of dataflow facts, with a meet (⊓) that combines facts at merges.
- **monotone framework** — a dataflow problem whose transfer functions never lose precision as inputs grow; guarantees a fixed point exists.
- **MFP vs MOP** — the maximal-fixed-point solution the iterative solver computes, versus the ideal meet-over-all-paths answer; equal when the framework is distributive.
- **transfer function** — the per-node map from facts-in to facts-out that a dataflow analysis iterates.
- **abstract interpretation** — the theory framing an analysis as a sound over-approximation of the concrete semantics, with widening for termination.
- **reducible flow graph** — a CFG whose loops are well-nested (collapsible by the T1/T2 transformations); admits fast elimination methods.
- **interval / structural analysis** — elimination-based analysis that exploits nested loop or syntactic control structure instead of blind iteration.
- **dominator / dominance frontier** — a node that lies on every path to another; the frontier is where a value's influence ends and φ-nodes are placed.
- **SSA form** — static single assignment: every name is defined once, with φ-functions merging definitions at control-flow joins.
- **φ-function** — a pseudo-instruction at a merge that selects the incoming definition according to the edge taken.
- **sparse dataflow** — propagating facts along def-use edges (not every program point), which SSA makes natural.
- **program dependence graph** — an IR making data and control dependences explicit edges; the basis for slicing and vectorization.
- **program slice** — the sub-program that can affect the value at a chosen point.
- **gated SSA** — SSA whose φ-like functions (γ/μ/η) encode the branch condition, making them executable and demand-driven.
- **sea of nodes** — a graph IR fusing control and data, where nodes float freely until a scheduling pass fixes their order.
- **value (state) dependence graph** — a normalizing, largely control-free IR in which equivalent computations are structurally identical.
- **e-graph** — a data structure representing many equivalent expressions compactly; the substrate for equality saturation.
