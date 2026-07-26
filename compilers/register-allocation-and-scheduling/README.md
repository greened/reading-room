# Compilers · Register allocation & instruction scheduling

The back end's job is to map an unbounded intermediate program onto finite hardware:
assign a small set of physical registers to arbitrarily many values, and order the
instructions so the pipeline stays busy. These two problems interfere, and this list
walks both. The path starts with register allocation as graph coloring, follows the
fixes that made coloring practical (coalescing, optimistic spilling), turns to the SSA
insight that made the interference graph chordal, detours through PBQP and the fast
linear-scan allocators that JITs use, then crosses over to instruction scheduling —
local, global, and loop (software) pipelining — and ends on the phase-ordering problem
of doing allocation and scheduling together.

> **How to read this list.** Read the register-allocation track (sections 1–6) and the
> scheduling track (sections 7–8) as two mostly independent strands, then close with
> section 9, which is about their interaction. Within each strand the order is
> pedagogical: the foundational model first, then the refinements and the theory that
> explains why they work. If you only read three papers, read Chaitin 1982 (the model),
> Hack 2006 (the SSA turn), and Fisher 1981 (global scheduling).

### The graph-coloring foundation
*Register allocation began as graph coloring — start with the model everything else refines.*
1. **Register Allocation via Coloring** — Chaitin, Auslander, Chandra, Cocke, Hopkins, Markstein · Computer Languages 1981 · 11pp · [DOI](https://doi.org/10.1016/0096-0551(81)90048-5). Cast register assignment as coloring the interference graph — the idea the whole field is built on.
2. **Register Allocation & Spilling via Graph Coloring** — Gregory J. Chaitin · SIGPLAN Compiler Construction 1982 · 8pp · [DOI](https://doi.org/10.1145/800230.806984) · [PDF](https://web.eecs.umich.edu/~mahlke/courses/583f12/reading/chaitin82.pdf). The canonical Chaitin allocator: a spill-cost model plus the simplify/spill loop. Read this one closely; it is the reference every later paper argues with.
3. **Register Allocation via Hierarchical Graph Coloring** — Callahan, Koblenz · PLDI 1991 · 12pp · [DOI](https://doi.org/10.1145/113445.113462). Colors a tree of tiles following program structure, so spill decisions land where the value is actually cold — an early move toward live-range splitting.

### Coloring, refined: coalescing and optimistic spilling
*A decade of fixes turned Chaitin's model into a production-quality allocator.*
4. **Improvements to Graph Coloring Register Allocation** — Briggs, Cooper, Torczon · ACM TOPLAS 1994 · 28pp · [DOI](https://doi.org/10.1145/177492.177575). Optimistic coloring (push a spill candidate and try to color it anyway) plus rematerialization — the "Chaitin-Briggs" allocator that became the standard.
5. **Iterated Register Coalescing** — George, Appel · ACM TOPLAS 1996 · 25pp · [DOI](https://doi.org/10.1145/229542.229546) · [PDF](https://www.cse.iitm.ac.in/~krishna/cs6013/george.pdf). Interleaves conservative coalescing with simplification so copies are removed without introducing spills — the coalescing method most compilers still describe.
6. **Optimistic Register Coalescing** — Park, Moon · PACT 1998 · 9pp · [DOI](https://doi.org/10.1109/PACT.1998.727246). Coalesce aggressively, then give back the moves that cause spills — recovering most of aggressive coalescing's wins while keeping iterated coalescing's safety.

### Spilling as its own problem
*Once coloring worked, where and how to spill became the real quality bottleneck.*
7. **Spill Code Minimization via Interference Region Spilling** — Bergner, Dahl, Engebretsen, O'Keefe · PLDI 1997 · 9pp · [DOI](https://doi.org/10.1145/258915.258941). Spills only over the region where a live range actually interferes, rather than everywhere — much less spill code for the same coloring.
8. **Optimal Spilling for CISC Machines with Few Registers** — Appel, George · PLDI 2001 · 26pp · [DOI](https://doi.org/10.1145/381694.378854) · [PDF](https://www.cs.princeton.edu/~appel/papers/spill.pdf). Splits the problem in two — an ILP finds optimal spill/live-range-split placement, then coloring handles the rest — and shows how much Chaitin-style spilling leaves on the table.

### The SSA turn: split allocation from coloring
*Under SSA the interference graph is chordal, so spilling, coloring, and coalescing decouple into separately-solvable phases.*
9. **Register Allocation via Coloring of Chordal Graphs** — Pereira, Palsberg · APLAS 2005 · 15pp · [DOI](https://doi.org/10.1007/11575467_21) · [PDF](http://www.cs.ucla.edu/~palsberg/paper/aplas05.pdf). The accessible statement of the key fact: SSA interference graphs are chordal and therefore colorable in polynomial time.
10. **Register Allocation for Programs in SSA Form** — Hack, Grund, Goos · CC 2006 · 16pp · [DOI](https://doi.org/10.1007/11688839_20) · [PDF](https://compilers.cs.uni-saarland.de/papers/ssara.pdf). Turns chordality into a full allocator: because the register pressure equals the max clique, spilling can be decided first, then coloring never fails. The blueprint for modern SSA-based allocation.
11. **On the Complexity of Register Coalescing** — Bouchez, Darte, Rastello · CGO 2007 · 13pp · [DOI](https://doi.org/10.1109/CGO.2007.26). The theory behind the SSA turn: coloring is easy under SSA, but coalescing (removing the copies out-of-SSA introduces) is the part that stays NP-complete. Read it to know which phase is actually hard.
12. **Register Allocation by Puzzle Solving** — Pereira, Palsberg · PLDI 2008 · 18pp · [DOI](https://doi.org/10.1145/1375581.1375609) · [PDF](http://www.cs.ucla.edu/~palsberg/paper/PereiraPalsberg08.pdf). Extends the SSA approach to real register files with aliasing (x86 sub-registers) by recasting assignment as a family of tractable puzzles.
13. **Register Spilling and Live-Range Splitting for SSA-Form Programs** — Braun, Hack · CC 2009 · 15pp · [DOI](https://doi.org/10.1007/978-3-642-00722-4_13) · [PDF](https://pp.ipd.kit.edu/uploads/publikationen/braun09cc.pdf). The spilling phase the SSA allocator needs: a fast, Belady-style heuristic that decides what to keep in registers before coloring runs.
14. **Revisiting Out-of-SSA Translation for Correctness, Code Quality and Efficiency** — Boissinot, Darte, Rastello, Dupont de Dinechin, Guillon · CGO 2009 · 12pp · [DOI](https://doi.org/10.1109/CGO.2009.19). How to leave SSA form correctly and cheaply — phi-elimination plus coalescing — the step that makes SSA-based allocation deployable.

### Allocation as numerical optimization: PBQP
*For irregular, aliased register files, recast the whole assignment as one combinatorial optimization.*
15. **Register Allocation for Irregular Architectures** — Scholz, Eckstein · LCTES 2002 · 10pp · [DOI](https://doi.org/10.1145/513829.513854). Models allocation, coalescing, and awkward register constraints together as a Partitioned Boolean Quadratic Problem (PBQP) — a good fit for embedded and DSP targets.
16. **Nearly Optimal Register Allocation with PBQP** — Hames, Scholz · JMLC 2006 · 16pp · [DOI](https://doi.org/10.1007/11860990_21). A practical PBQP solver that gets close to optimal in reasonable time — the version that later shipped as an LLVM allocator.

### Fast allocation for JITs
*When compile time is the budget, drop coloring for a single linear pass over live ranges.*
17. **Linear Scan Register Allocation** — Poletto, Sarkar · ACM TOPLAS 1999 · 19pp · [DOI](https://doi.org/10.1145/330249.330250) · [PDF](http://web.cs.ucla.edu/~palsberg/course/cs132/linearscan.pdf). The fast, non-coloring allocator over live intervals — near-linear time, the default for JITs.
18. **Linear Scan Register Allocation on SSA Form** — Wimmer, Franz · CGO 2010 · 10pp · [DOI](https://doi.org/10.1145/1772954.1772979) · [PDF](http://www.christianwimmer.at/Publications/Wimmer10a/Wimmer10a.pdf). Linear scan rebuilt on SSA, with lifetime holes and second-chance splitting — the HotSpot client and Graal allocator.
19. **Trace-based Register Allocation in a JIT Compiler** — Eisl, Grimmer, Simon, Würthinger, Mössenböck · PPPJ 2016 · 11pp · [DOI](https://doi.org/10.1145/2972206.2972211) · [PDF](http://ssw.jku.at/General/Staff/Eisl/papers/2016_PPPJ_TraceRA-preprint.pdf). Allocates one trace at a time, choosing a cheap or a careful strategy per trace — a tunable compile-time-vs-code-quality knob.

### Instruction scheduling
*The other half of the back end: order instructions to hide latency. Local first, then across blocks.*
20. **Efficient Instruction Scheduling for a Pipelined Architecture** — Gibbons, Muchnick · PLDI 1986 · 6pp · [DOI](https://doi.org/10.1145/12276.13312). The classic list-scheduling heuristic for a single basic block — the baseline every scheduler starts from.
21. **Trace Scheduling: A Technique for Global Microcode Compaction** — Joseph A. Fisher · IEEE TC 1981 · 13pp · [DOI](https://doi.org/10.1109/TC.1981.1675827) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-S12/handouts/papers/TraceScheduling.pdf). The founding paper of global scheduling: pick a likely path, schedule it as one big block, and fix up the off-path edges with compensation code.
22. **Global Instruction Scheduling for Superscalar Machines** — Bernstein, Rodeh · PLDI 1991 · 15pp · [DOI](https://doi.org/10.1145/113445.113466). Moves instructions across basic-block boundaries guided by the control/data dependence structure — global scheduling made practical for superscalars.

### Software pipelining & modulo scheduling
*Schedule loops so successive iterations overlap — the highest-value scheduling problem.*
23. **Some Scheduling Techniques and an Easily Schedulable Horizontal Architecture** — Rau, Glaeser · MICRO-14 1981 · 16pp · [DOI](https://doi.org/10.1145/1014192.802449). The origin of modulo scheduling and rotating registers — overlap iterations at a fixed initiation interval.
24. **Software Pipelining: An Effective Scheduling Technique for VLIW Machines** — Monica Lam · PLDI 1988 · 11pp · [DOI](https://doi.org/10.1145/53990.54022) · [PDF](https://suif.stanford.edu/papers/lam-sp.pdf). Modulo scheduling with hierarchical reduction for loops with control flow — the paper that made software pipelining a compiler technique.
25. **Iterative Modulo Scheduling** — B. Ramakrishna Rau · MICRO-27 1994 · 12pp · [DOI](https://doi.org/10.1145/192724.192731). The robust, widely-implemented algorithm: search for the smallest feasible initiation interval, backtracking when a schedule can't be found.
   - **Software Pipelining (survey)** — Allan, Jones, Lee, Allan · [DOI](https://doi.org/10.1145/212094.212131). ACM Computing Surveys 1995 — the map of the whole modulo-scheduling design space; read it to place these papers relative to each other.
26. **Swing Modulo Scheduling: A Lifetime-Sensitive Approach** — Llosa, González, Ayguadé, Valero · PACT 1996 · 7pp · [DOI](https://doi.org/10.1109/PACT.1996.554030). A modulo scheduler that also minimizes register pressure — the variant later adopted in GCC.

### The phase-ordering problem: allocation vs scheduling
*Allocation and scheduling fight over the same resource; who goes first, or can they be done together?*
27. **Code Scheduling and Register Allocation in Large Basic Blocks** — Goodman, Hsu · ICS 1988 · 11pp · [DOI](https://doi.org/10.1145/55364.55407). Names the tension — scheduling for latency raises register pressure — and switches strategy based on how many registers are free.
28. **Register Allocation with Instruction Scheduling: A New Approach** — Shlomit S. Pinter · PLDI 1993 · 10pp · [DOI](https://doi.org/10.1145/155090.155114). Builds a combined "parallelizable interference graph" so allocation preserves scheduling freedom — a principled attempt to solve both at once.

## Reference shelf — books

- **FREE** **SSA-based Compiler Design** — Rastello, Bouchez Tichadou (eds.) · 2022 · 412pp · [PDF](https://pfalcon.github.io/ssabook/latest/book-full.pdf). The unified modern treatment of SSA — including the chapters on SSA-based register allocation, spilling, and out-of-SSA that sections 9–14 draw on.
- **BUY** **Engineering a Compiler** — Cooper, Torczon · 2nd ed. 2011 · 824pp · [page](https://www.elsevier.com/books/engineering-a-compiler/cooper/978-0-12-088478-0). The clearest textbook treatment of graph-coloring allocation and list scheduling, from two of the Chaitin-Briggs authors.
- **BUY** **Modern Compiler Implementation in ML** — Andrew W. Appel · 1998 · 544pp · [page](https://www.cs.princeton.edu/~appel/modern/ml/). Builds an iterated-register-coalescing allocator step by step; the best hands-on path into George-Appel.
- **BUY** **Advanced Compiler Design and Implementation** — Steven S. Muchnick · 1997 · 856pp · [page](https://www.elsevier.com/books/advanced-compiler-design-and-implementation/muchnick/978-1-55860-320-2). Encyclopedic reference on both instruction scheduling and register allocation, with the algorithms spelled out.

## Key terms

- **interference graph** — a graph whose nodes are values and whose edges join values live at the same time; register assignment is a coloring of it.
- **coalescing** — merging the two ends of a copy into one value so the copy can be deleted, at the cost of a harder-to-color graph.
- **spilling** — when values outnumber registers, storing some to memory and reloading them at their uses.
- **rematerialization** — recomputing a cheap value at its use instead of spilling and reloading it.
- **live range / live interval** — the span of a program over which a value must be kept available; a *live interval* is its linearized approximation used by linear scan.
- **live-range splitting** — breaking one live range into pieces so only the hot part occupies a register.
- **chordal graph** — a graph in which every cycle of four or more nodes has a chord; SSA interference graphs are chordal, hence optimally colorable in polynomial time.
- **SSA / phi / out-of-SSA** — static single assignment gives each value one definition; phi-functions merge values at joins; out-of-SSA translation removes them before code generation.
- **register aliasing** — one physical register overlapping another (e.g. x86 AL/AX/EAX), which breaks plain graph coloring.
- **PBQP** — Partitioned Boolean Quadratic Problem; a cost-minimization formulation that captures allocation, coalescing, and aliasing together.
- **linear scan** — a near-linear-time allocator that walks live intervals in order instead of coloring a graph.
- **list scheduling** — the standard local scheduler: repeatedly issue a ready instruction chosen by a priority heuristic.
- **trace / global scheduling** — scheduling instructions across basic-block boundaries along a likely path, with compensation code on the off-path edges.
- **modulo scheduling** — software pipelining that overlaps loop iterations at a fixed *initiation interval* (II), the number of cycles between successive iteration starts.
- **phase ordering** — the problem that allocation and scheduling constrain each other, so the order (or integration) in which they run affects the result.
