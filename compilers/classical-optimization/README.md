# Compilers · Classical (scalar) optimization

The scalar optimizations that define the vocabulary of the field: constant
propagation and folding, value numbering, redundancy elimination, strength
reduction, dead-code elimination, inlining, and partial evaluation. Read it as a
path from the machinery to the transformations: first the *analysis framework*
(the catalogue, dataflow lattices, their convergence theory, and the SSA
representation that makes them sparse), then the *value-based* optimizations
(constant propagation, value numbering, GVN), then *redundancy elimination and
code motion* (PRE, lazy code motion, global code motion), then *strength
reduction* and *dead-code elimination*, then the *interprocedural*
transformations (inlining, tail calls), and finally *specialization* — partial
evaluation and the Futamura projections, the idea that subsumes many of the
earlier ones.

> **How to read this list.** Almost everything here is a dataflow analysis feeding
> a rewrite, so start with Kildall's framework and Kam–Ullman's convergence theory
> — every later paper is written against them. The value-numbering and PRE lines
> then split into two idioms for "don't compute the same thing twice": *congruence*
> (are these two expressions equal?) and *availability* (has this expression
> already been computed on the way here?). Watch how SSA, once it arrives, makes
> both sparse.

## Reading order

### Foundations: the catalogue, the dataflow framework, and SSA
*Start here: the vocabulary of transformations, the analysis framework they all run on, when that analysis is guaranteed to converge, and the SSA representation that later makes every value-based optimization sparse.*
1. **A Catalogue of Optimizing Transformations** — Frances Allen, John Cocke · in *Design and Optimization of Compilers* (Rustin, ed.) 1972 · 30pp · [WEB](https://archive.org/details/designoptimizati0000vari). The first systematic catalogue — CSE, dead-code elimination, code motion, strength reduction, inlining — and still the naming scheme the field uses.
2. **A Unified Approach to Global Program Optimization** — Gary Kildall · POPL 1973 · 13pp · [DOI](https://doi.org/10.1145/512927.512945) · [PDF](https://calhoun.nps.edu/server/api/core/bitstreams/54e90734-ceb5-4f4f-94f6-83e51cd2da73/content). The dataflow lattice framework underlying constant propagation, CSE, and liveness — the single most reused idea in the topic.
   - **Static Program Analysis** — [PDF](https://cs.au.dk/~amoeller/spa/spa.pdf). Møller and Schwartzbach's free lecture notes are the clearest modern explanation of the lattices and fixed-point iteration Kildall introduced.
3. **Monotone Data Flow Analysis Frameworks** — John Kam, Jeffrey Ullman · Acta Informatica 1977 · 13pp · [DOI](https://doi.org/10.1007/BF00290339). Pins down when iterative dataflow converges and how the iterative solution relates to the meet-over-all-paths ideal — the theory beneath Kildall.
4. **Efficiently Computing Static Single Assignment Form and the Control Dependence Graph** — Ron Cytron, Jeanne Ferrante, Barry Rosen, Mark Wegman, Kenneth Zadeck · ACM TOPLAS 1991 · 40pp · [DOI](https://doi.org/10.1145/115372.115320) · [PDF](https://www.cs.utexas.edu/~pingali/CS380C/2010/papers/ssaCytron.pdf). The dominance-frontier algorithm that made SSA construction practical — the representation nearly every optimization below is now written against.
   - **SSA-based Compiler Design** — [PDF](https://pfalcon.github.io/ssabook/latest/book-full.pdf). The community "SSA book" (Rastello, ed.): a free, book-length treatment of building on and optimizing in SSA form.
5. **Automatic Construction of Sparse Data Flow Evaluation Graphs** — Jong-Deok Choi, Ron Cytron, Jeanne Ferrante · POPL 1991 · 12pp · [DOI](https://doi.org/10.1145/99583.99594). Generalizes SSA's sparseness to any monotone dataflow problem — skip the nodes that only pass facts through, so the analyses above run on a graph the size of the interesting events, not the program.

### Constant propagation and folding
*The simplest value optimization, and the one that shows why analysis and rewriting belong together — then how to fuse it with its neighbours and stretch it from constants to ranges.*
6. **Constant Propagation with Conditional Branches (SCCP)** — Mark Wegman, Kenneth Zadeck · ACM TOPLAS 1991 · 30pp · [DOI](https://doi.org/10.1145/103135.103136) · [PDF](https://www.cs.utexas.edu/~pingali/CS380C/2010/papers/p291-wegman.pdf). Sparse conditional constant propagation: fold constants and prune unreachable branches in one pass, each enabling the other. Still the algorithm in production compilers.
7. **Combining Analyses, Combining Optimizations** — Cliff Click, Keith Cooper · ACM TOPLAS 1995 · 16pp · [DOI](https://doi.org/10.1145/201059.201061). Runs conditional constant propagation, global value numbering, and unreachable-code elimination as one combined analysis that beats any sequential ordering of them — the intuition behind HotSpot's server compiler.
8. **Accurate Static Branch Prediction by Value Range Propagation** — Jason Patterson · PLDI 1995 · 12pp · [DOI](https://doi.org/10.1145/207110.207117) · [PDF](https://www.lighterra.com/papers/valuerangeprop/Patterson1995-ValueRangeProp.pdf). Generalizes constant propagation from single values to *ranges*, propagated with edge weights — the ancestor of the range/known-bits analyses in every modern compiler.

### Value numbering and redundant computation
*"Are these two computations the same value?" — from congruence over the value graph to a practical algorithm.*
9. **Detecting Equality of Variables in Programs** — Bowen Alpern, Mark Wegman, Kenneth Zadeck · POPL 1988 · 11pp · [DOI](https://doi.org/10.1145/73560.73561). Congruence partitioning over the SSA value graph — the formal basis of global value numbering.
10. **Global Value Numbers and Redundant Computations** — Barry Rosen, Mark Wegman, Kenneth Zadeck · POPL 1988 · 16pp · [DOI](https://doi.org/10.1145/73560.73562). GVN detecting equivalent expressions and the second-order redundancy that simpler CSE misses.
11. **Value Numbering** — Preston Briggs, Keith Cooper, Taylor Simpson · Software—Practice & Experience 1997 · 24pp · [PDF](https://www.cs.tufts.edu/~nr/cs257/archive/keith-cooper/value-numbering.pdf). The practical account: hash-based local, dominator-based, and SCC-based value numbering, and how they trade cost against what they catch.
    - **Engineering a Compiler** — [page](https://shop.elsevier.com/books/engineering-a-compiler/cooper/978-0-12-815412-0). Cooper and Torczon's chapters on value numbering are the gentlest on-ramp to this line of work.

### Partial redundancy elimination and code motion
*Availability, not congruence: don't recompute what a path already computed — and move computations to where they pay off.*
12. **Global Optimization by Suppression of Partial Redundancies (PRE)** — Étienne Morel, Claude Renvoise · CACM 1979 · 8pp · [DOI](https://doi.org/10.1145/359060.359069). The seminal PRE, unifying CSE and loop-invariant code motion through a bidirectional dataflow formulation.
13. **Lazy Code Motion** — Jens Knoop, Oliver Rüthing, Bernhard Steffen · PLDI 1992 · 11pp · [DOI](https://doi.org/10.1145/143095.143136) · [PDF](http://rsim.cs.uiuc.edu/arch/qual_papers/compilers/knoop92.pdf). Recasts PRE as clean unidirectional analyses with computationally- and lifetime-optimal placement — the version compilers actually implement.
14. **Effective Partial Redundancy Elimination** — Preston Briggs, Keith Cooper · PLDI 1994 · 12pp · [DOI](https://doi.org/10.1145/178243.178257). Global reassociation and value numbering *before* PRE reshape expressions so more redundancies become visible — the preprocessing that makes lazy code motion pay off in practice.
15. **Global Code Motion / Global Value Numbering** — Cliff Click · PLDI 1995 · 12pp · [DOI](https://doi.org/10.1145/207110.207154). Separates *what value to compute* from *where to schedule it*; the SSA-era standard for hoisting and sinking.
16. **Value-Based Partial Redundancy Elimination** — Thomas VanDrunen, Antony Hosking · CC 2004 · 18pp · [DOI](https://doi.org/10.1007/978-3-540-24723-4_12) · [PDF](https://link.springer.com/content/pdf/10.1007/978-3-540-24723-4_12.pdf). GVN-PRE: fuses the two idioms above, eliminating a redundancy whenever *some equal value* is already available, not just a syntactically identical expression — the form of PRE in LLVM's lineage.

### Strength reduction
*Trade an expensive operation for a cheap one along an induction variable — first classically, then in SSA, then as a special case of PRE.*
17. **An Algorithm for Reduction of Operator Strength** — John Cocke, Ken Kennedy · CACM 1977 · 7pp · [DOI](https://doi.org/10.1145/359863.359888). Replaces loop induction-variable multiplies with additions — the classic strength reduction.
18. **Operator Strength Reduction** — Keith Cooper, Taylor Simpson, Christopher Vick · ACM TOPLAS 2001 · 23pp · [DOI](https://doi.org/10.1145/504709.504710) · [PDF](https://www.cs.rice.edu/~keith/Publications/OSR.pdf). The modern SSA-based reformulation, driven by the value graph and far simpler to implement.
19. **Strength Reduction via SSAPRE** — Robert Kennedy, Fred Chow, Peter Dahl, Shin-Ming Liu, Raymond Lo, Mark Streich · CC 1998 · 15pp · [DOI](https://doi.org/10.1007/BFb0026428) · [PDF](https://link.springer.com/content/pdf/10.1007/BFb0026428.pdf). Recasts strength reduction as an instance of SSA-based partial redundancy elimination — one framework subsuming both code motion and strength reduction.

### Dead-code elimination
*The mirror image of PRE: remove — or sink — computations whose results a path never uses.*
20. **Partial Dead Code Elimination** — Jens Knoop, Oliver Rüthing, Bernhard Steffen · PLDI 1994 · 12pp · [DOI](https://doi.org/10.1145/178243.178256). Sinks assignments that are dead on some paths but live on others — the code-motion dual of PRE.

### Interprocedural: inlining and calls
*Cross the procedure boundary — first by substitution, then by making the call itself disappear.*
21. **An Analysis of Inline Substitution for a Structured Programming Language** — Robert Scheifler · CACM 1977 · 8pp · [DOI](https://doi.org/10.1145/359810.359830). Frames inlining as a cost-constrained optimization rather than a heuristic hack — the enabler for most interprocedural work.
22. **Debunking the "Expensive Procedure Call" Myth** — Guy Steele · MIT AI Memo 443, 1977 · 23pp · [PDF](https://dspace.mit.edu/bitstream/handle/1721.1/5753/AIM-443.pdf). Proper tail calls make a call as cheap as a GOTO — the origin of tail-call optimization, argued in the "LAMBDA: The Ultimate GOTO" style.

### Specialization: partial evaluation
*The unifying view — many optimizations above are special cases of precomputing what depends only on known inputs.*
23. **Partial Evaluation of Computation Process—An Approach to a Compiler-Compiler** — Yoshihiko Futamura · Higher-Order and Symbolic Computation 1999 (orig. 1971) · 11pp · [DOI](https://doi.org/10.1023/A:1010095604496). The Futamura projections: specialize an interpreter to a program and you get a compiled program; specialize the specializer and you get a compiler.
24. **Tutorial Notes on Partial Evaluation** — Charles Consel, Olivier Danvy · POPL 1993 · 9pp · [DOI](https://doi.org/10.1145/158511.158707). The clearest short entry point: binding-time analysis, the online/offline distinction, and how specialization mechanizes the folding and propagation seen earlier in this list.
25. **Partial Evaluation and Automatic Program Generation** — Neil Jones, Carsten Gomard, Peter Sestoft · Prentice Hall 1993 · 415pp · [book](https://www.itu.dk/people/sestoft/pebook/). The definitive treatment of specialization, binding-time analysis, and the Futamura projections; full text free online.

<!--html-->
<div class="why">
<b>Two idioms for "don't compute it twice."</b> <em>Value numbering / GVN</em> asks whether
two expressions are provably the <em>same value</em> (congruence over the value graph);
<em>availability-based</em> PRE and lazy code motion ask whether an expression has
<em>already been computed</em> on the way to this point (a dataflow property). They overlap
but neither subsumes the other — production compilers run both, which is why this list
gives each its own line back to the source. GVN-PRE (Van Drunen &amp; Hosking) finally fuses them.
</div>
<!--/html-->

## Reference shelf — books

- **BUY** **Advanced Compiler Design and Implementation** — Steven Muchnick · 1997 · 856pp · [page](https://books.google.com/books?id=Pq7pHwG1_OkC). The encyclopedic reference — a chapter-length treatment of essentially every optimization on this list.
- **BUY** **Engineering a Compiler** — Keith Cooper, Linda Torczon · 3rd ed. 2022 · 848pp · [page](https://shop.elsevier.com/books/engineering-a-compiler/cooper/978-0-12-815412-0). Cooper's own textbook; the clearest modern treatment of value numbering, PRE, and operator strength reduction.
- **BUY** **Compilers: Principles, Techniques, and Tools** (the "Dragon Book") — Aho, Lam, Sethi, Ullman · 2nd ed. 2006 · 1009pp · [page](https://www.pearson.com/en-us/subject-catalog/p/compilers-principles-techniques-and-tools/P200000003472). The standard reference for the dataflow foundations and the classic transformations.

## Key terms

- **available expression** — one already computed on every path to a point, with no operand redefined since; the property CSE exploits.
- **partial redundancy** — a computation redundant on some but not all paths; PRE inserts copies to make it fully redundant, then removes it.
- **code motion** — relocating a computation to a better point (e.g. out of a loop) without changing the program's results.
- **value numbering** — giving equal "numbers" to expressions that provably compute the same value, so duplicates can be reused.
- **congruence** — the equivalence relation on SSA values that global value numbering computes to decide when two expressions are equal.
- **induction variable** — a variable that changes by a constant amount each loop iteration; the handle strength reduction grabs.
- **strength reduction** — replacing an expensive operation (a multiply) with a cheaper one (an add) along an induction variable.
- **monotone framework** — a dataflow analysis whose transfer functions are monotone over a lattice, which guarantees a least fixed point.
- **meet-over-all-paths (MOP)** — the ideal dataflow solution combining facts over every path; iterative analysis reaches it for distributive frameworks.
- **SSA** — static single assignment; each variable is assigned once, which makes the value-based optimizations here sparse and cheap.
- **dominance frontier** — the set of blocks where a definition's influence ends; where SSA construction places φ-functions.
- **sparse evaluation graph** — a reduced graph carrying a dataflow problem only through the nodes that generate or use its facts, skipping pass-through blocks.
- **value range** — an interval (or set of intervals) a variable is known to lie in; range propagation generalizes constant propagation to these.
- **reassociation** — rewriting an expression's operand grouping (using associativity/commutativity) to expose more redundancy or loop invariance.
- **specialization / partial evaluation** — precomputing the parts of a program that depend only on its known (static) inputs.
- **binding-time analysis** — the partial-evaluation phase that labels each computation static (known now) or dynamic (deferred to run time).
- **Futamura projection** — specializing an interpreter to a program yields a compiled program; specializing the specializer yields a compiler.
- **dead code** — computations whose results are never used; dead-code elimination removes them (partial DCE sinks the ones dead only on some paths).
