# Compilers · Register allocation & instruction scheduling

Graph-coloring, coalescing, linear scan, and the SSA-era allocators; plus global
instruction scheduling and software pipelining.

- **Register Allocation via Coloring** — Chaitin, Auslander, Chandra, Cocke, Hopkins, Markstein, 1981, Computer Languages. Cast register assignment as coloring the interference graph. [DOI](https://doi.org/10.1016/0096-0551(81)90048-5)
- **Register Allocation & Spilling via Graph Coloring** — Gregory J. Chaitin, 1982, SIGPLAN Compiler Construction. The canonical Chaitin allocator: spill-cost model + simplify/spill. [DOI](https://doi.org/10.1145/800230.806984) · [PDF](https://web.eecs.umich.edu/~mahlke/courses/583f12/reading/chaitin82.pdf)
- **Improvements to Graph Coloring Register Allocation** — Briggs, Cooper, Torczon, 1994, ACM TOPLAS. Optimistic coloring + rematerialization (Chaitin-Briggs). [DOI](https://doi.org/10.1145/177492.177575)
- **Iterated Register Coalescing** — George, Appel, 1996, ACM TOPLAS. Conservative coalescing interleaved with simplification. [DOI](https://doi.org/10.1145/229542.229546) · [PDF](https://www.cse.iitm.ac.in/~krishna/cs6013/george.pdf)
- **Linear Scan Register Allocation** — Poletto, Sarkar, 1999, ACM TOPLAS. The fast non-coloring allocator over live intervals; ideal for JITs. [DOI](https://doi.org/10.1145/330249.330250) · [PDF](http://web.cs.ucla.edu/~palsberg/course/cs132/linearscan.pdf)
- **Trace Scheduling** — Joseph A. Fisher, 1981, IEEE TC. The founding paper of global instruction scheduling across basic blocks. [DOI](https://doi.org/10.1109/TC.1981.1675827) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-S12/handouts/papers/TraceScheduling.pdf)
- **Some Scheduling Techniques and an Easily Schedulable Horizontal Architecture** — Rau, Glaeser, 1981, MICRO-14. Origin of modulo scheduling and rotating registers. [DOI](https://doi.org/10.1145/1014192.802449)
- **Software Pipelining: An Effective Scheduling Technique for VLIW Machines** — Monica Lam, 1988, PLDI. Modulo scheduling with hierarchical reduction. [DOI](https://doi.org/10.1145/53990.54022) · [PDF](https://suif.stanford.edu/papers/lam-sp.pdf)
- **Optimal Spilling for CISC Machines with Few Registers** — Appel, George, 2001, PLDI. ILP-optimal live-range splitting + spill placement. [DOI](https://doi.org/10.1145/381694.378854)
- **Register Allocation via Coloring of Chordal Graphs** — Pereira, Palsberg, 2005, APLAS. SSA interference graphs are chordal → optimal polynomial coloring. [DOI](https://doi.org/10.1007/11575467_21) · [PDF](http://www.cs.ucla.edu/~palsberg/paper/aplas05.pdf)
- **Register Allocation for Programs in SSA Form** — Hack, Grund, Goos, 2006, CC. Chordality → separate spilling, optimal coloring, coalescing phases. [DOI](https://doi.org/10.1007/11688839_20) · [PDF](https://compilers.cs.uni-saarland.de/papers/ssara.pdf)
- **Register Allocation by Puzzle Solving** — Pereira, Palsberg, 2008, PLDI. Handles register aliasing (e.g. x86) as tractable puzzle-solving. [DOI](https://doi.org/10.1145/1375581.1375609) · [PDF](http://www.cs.ucla.edu/~palsberg/paper/PereiraPalsberg08.pdf)
- **Revisiting Out-of-SSA Translation for Correctness, Code Quality and Efficiency** — Boissinot, Darte, Rastello, Dupont de Dinechin, Guillon, 2009, CGO. Correct/efficient phi-elimination + coalescing for SSA-based allocation. [DOI](https://doi.org/10.1109/CGO.2009.19)
- **Linear Scan Register Allocation on SSA Form** — Wimmer, Franz, 2010, CGO. Linear scan + SSA (HotSpot client allocator). [DOI](https://doi.org/10.1145/1772954.1772979)
- **Trace-based Register Allocation in a JIT Compiler** — Eisl, Grimmer, Simon, Würthinger, Mössenböck, 2016, PPPJ. Per-trace strategies trading compile time vs code quality. [DOI](https://doi.org/10.1145/2972206.2972211)
