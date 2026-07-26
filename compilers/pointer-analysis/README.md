# Compilers · Pointer / alias analysis

One of the hardest static-analysis problems: deciding what each pointer may refer to.
Almost every other analysis — constant propagation, dead-code elimination, escape and
side-effect analysis, call-graph construction, bug finding — is only as precise as the
points-to sets it is handed. The reading path here starts with Hind's survey to fix the
design dimensions (flow-, context-, field-, object-sensitivity), then the two
foundational algorithms and the precision spectrum between them (Andersen's inclusion
vs. Steensgaard's unification), the flow- and context-sensitive tradition for C, the
tricks that scale inclusion-based analysis to real programs, the CFL-reachability and
demand-driven reframing, the BDD and declarative engines that made whole-program
context sensitivity practical, the object- and type-sensitivity that hit the sweet spot
for object-oriented code, and finally the frameworks that carry these ideas into LLVM,
C/C++, and modern Java.

> **How to read this list.** Read Hind first for the vocabulary — every later paper is
> a point in the design space he lays out. Then read Andersen and Steensgaard back to
> back: they are the two poles (precise-but-costly vs. fast-but-coarse) that the rest of
> the field interpolates between and scales up. After that the sections are roughly
> independent; pick the axis (scaling, demand-driven, object-sensitivity) you care about.

## Reading order

### Framing the problem
*Read this first: it names the design dimensions every later paper is a point within.*

1. **Pointer Analysis: Haven't We Solved This Problem Yet?** — Michael Hind · PASTE 2001 · 8pp · [DOI](https://doi.org/10.1145/379605.379665) · [PDF](https://www.cs.cornell.edu/courses/cs711/2005fa/papers/hind-paste01.pdf). The canonical survey: frames flow-, context-, field-sensitivity and the precision/scalability tradeoffs, and remains the best map of the territory.
   - **Companion** — [Pointer Analysis](https://yanniss.github.io/points-to-tutorial15.pdf). Smaragdakis & Balatsouras's monograph is the modern, worked-out version of the same map (also in the reference shelf).

### The two foundational algorithms
*Andersen (subset) vs. Steensgaard (unification) are the two poles; everything else interpolates or scales one of them.*

2. **Program Analysis and Specialization for the C Programming Language** — Lars Ole Andersen · PhD thesis (DIKU) 1994 · 43pp · [PDF](https://www.cs.cornell.edu/courses/cs711/2005fa/papers/andersen-thesis94.pdf). Origin of "Andersen-style" inclusion (subset-constraint) analysis: the precise-but-cubic baseline.

3. **Points-to Analysis in Almost Linear Time** — Bjarne Steensgaard · POPL 1996 · 10pp · [DOI](https://doi.org/10.1145/237721.237727) · [PDF](https://www.cs.cornell.edu/courses/cs711/2005fa/papers/steensgaard-popl96.pdf). "Steensgaard-style" unification analysis: precision traded for near-linear scale, the other pole.

4. **Fast and Accurate Flow-Insensitive Points-to Analysis** — Marc Shapiro, Susan Horwitz · POPL 1997 · 12pp · [DOI](https://doi.org/10.1145/263699.263703). A tunable family sitting *between* Andersen and Steensgaard, making the precision/cost dial explicit.

5. **Unification-Based Pointer Analysis with Directional Assignments** — Manuvir Das · PLDI 2000 · 12pp · [DOI](https://doi.org/10.1145/349299.349309) · [PDF](http://web.cs.ucla.edu/~palsberg/course/purdue/cs661/F01/papers/das-pldi00.pdf). "One-level flow": nearly Steensgaard's speed with much of Andersen's precision — the practical middle ground.

### Flow- and context-sensitivity for C
*The interprocedural aliasing tradition that first pinned down what "sensitivity" buys you.*

6. **A Safe Approximate Algorithm for Interprocedural Pointer Aliasing** — William Landi, Barbara Ryder · PLDI 1992 · 12pp · [DOI](https://doi.org/10.1145/143095.143137). The first practical interprocedural may-alias algorithm for C; it set the problem statement the field worked from.

7. **Efficient Flow-Sensitive Interprocedural Computation of Pointer-Induced Aliases and Side Effects** — Jong-Deok Choi, Michael Burke, Paul Carini · POPL 1993 · 13pp · [DOI](https://doi.org/10.1145/158511.158639). The foundational flow-sensitive interprocedural formulation, with the strong/weak-update machinery later work builds on.

8. **Context-Sensitive Interprocedural Points-to Analysis in the Presence of Function Pointers** — Maryam Emami, Rakesh Ghiya, Laurie Hendren · PLDI 1994 · 12pp · [DOI](https://doi.org/10.1145/178243.178264). Full context sensitivity for C with an invocation-graph treatment of function pointers — the classic account of on-the-fly call-graph construction.

### Scaling inclusion-based analysis
*How Andersen-style analysis was made fast enough for millions of lines.*

9. **Partial Online Cycle Elimination in Inclusion Constraint Graphs** — Manuel Fähndrich, Jeffrey Foster, Zhendong Su, Alexander Aiken · PLDI 1998 · 11pp · [DOI](https://doi.org/10.1145/277650.277667) · [PDF](https://theory.stanford.edu/~aiken/publications/papers/pldi98a.pdf). Collapsing cycles in the constraint graph — the key idea behind every fast inclusion solver since.

10. **Ultra-fast Aliasing Analysis using CLA (a million lines of C in a second)** — Nevin Heintze, Olivier Tardieu · PLDI 2001 · 10pp · [DOI](https://doi.org/10.1145/378795.378855) · [PDF](http://web.cs.ucla.edu/~palsberg/course/purdue/cs661/F01/papers/heintze-tardieu-pldi01.pdf). Field-based Andersen-style analysis engineered to enormous scale.

11. **The Ant and the Grasshopper: Fast and Accurate Pointer Analysis for Millions of Lines of Code** — Ben Hardekopf, Calvin Lin · PLDI 2007 · 10pp · [DOI](https://doi.org/10.1145/1250734.1250767) · [PDF](https://www.cs.utexas.edu/~lin/papers/pldi07.pdf). Lazy and hybrid cycle detection: large speedups over Fähndrich et al. with no precision loss.

12. **Flow-Sensitive Pointer Analysis for Millions of Lines of Code** — Ben Hardekopf, Calvin Lin · CGO 2011 · 10pp · [DOI](https://doi.org/10.1109/CGO.2011.5764696) · [PDF](https://www.cs.utexas.edu/~lin/papers/cgo11.pdf). Sparse, staged flow-sensitive analysis with strong updates — flow sensitivity finally made to scale.

### CFL-reachability and demand-driven analysis
*Reframe points-to as a graph-reachability problem, then compute only the queries you ask.*

13. **Precise Interprocedural Dataflow Analysis via Graph Reachability** — Thomas Reps, Susan Horwitz, Mooly Sagiv · POPL 1995 · 14pp · [DOI](https://doi.org/10.1145/199448.199462) · [PDF](https://research.cs.wisc.edu/wpis/papers/popl95.pdf). The IFDS/CFL-reachability framework that reframes context-sensitive interprocedural analysis (and, later, points-to) as language-reachability.

14. **Demand-Driven Points-to Analysis for Java** — Manu Sridharan, Denis Gopan, Lexin Shan, Rastislav Bodík · OOPSLA 2005 · 18pp · [DOI](https://doi.org/10.1145/1094811.1094817) · [PDF](https://manu.sridharan.net/files/oopsla05.pdf). Points-to as CFL-reachability over a program-expression graph, answering single-variable queries on demand.

15. **Refinement-Based Context-Sensitive Points-to Analysis for Java** — Manu Sridharan, Rastislav Bodík · PLDI 2006 · 17pp · [DOI](https://doi.org/10.1145/1133981.1134027) · [PDF](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2006/EECS-2006-31.pdf). Adds client-driven refinement, spending precision (field and call-site matching) only where a query needs it.

16. **Demand-Driven Alias Analysis for C** — Xin Zheng, Radu Rugina · POPL 2008 · 12pp · [DOI](https://doi.org/10.1145/1328438.1328464) · [PDF](https://web.archive.org/web/20170323174953id_/http://www.cs.cornell.edu/~rugina/papers/popl08.pdf). Carries the CFL-reachability, demand-driven idea back to C, where indirection through the heap makes the language harder.

### BDD and declarative engines
*Symbolic and relational back-ends that made whole-program context sensitivity tractable.*

17. **Points-to Analysis using BDDs** — Marc Berndl, Ondřej Lhoták, Feng Qian, Laurie Hendren, Navindra Umanee · PLDI 2003 · 12pp · [DOI](https://doi.org/10.1145/781131.781144) · [PDF](https://plg.uwaterloo.ca/~olhotak/pubs/pldi03.pdf). Represents the enormous points-to relation symbolically with binary decision diagrams — the enabling trick for what follows.

18. **Cloning-Based Context-Sensitive Pointer Alias Analysis Using BDDs** — John Whaley, Monica Lam · PLDI 2004 · 14pp · [DOI](https://doi.org/10.1145/996841.996859) · [PDF](https://web.archive.org/web/20260501175527id_/https://suif.stanford.edu/papers/pldi04.pdf). Fully context-sensitive inclusion analysis via call-path cloning, expressed in Datalog and solved with BDDs (bddbddb).
   - **Companion** — [bddbddb](https://sourceforge.net/projects/bddbddb/). The Datalog-to-BDD solver behind the paper.

19. **Strictly Declarative Specification of Sophisticated Points-to Analyses** — Martin Bravenboer, Yannis Smaragdakis · OOPSLA 2009 · 18pp · [DOI](https://doi.org/10.1145/1640089.1640108). Doop: whole analyses (including on-the-fly call graphs and exceptions) written as Datalog rules — declarative, and often faster than hand-coded engines.
   - **Companion** — [Doop framework](https://github.com/plast-lab/doop-mirror). The still-maintained Datalog analysis framework the paper introduced.

### Context choice for object-oriented programs
*For OO code the right kind of context — objects, not call sites — is what makes analysis both precise and affordable.*

20. **Scaling Java Points-to Analysis using Spark** — Ondřej Lhoták, Laurie Hendren · CC 2003 · 16pp · [DOI](https://doi.org/10.1007/3-540-36579-6_12) · [PDF](https://plg.uwaterloo.ca/~olhotak/pubs/cc03.pdf). The open, modular Java points-to framework (in Soot) that made the later OO comparisons reproducible.

21. **Parameterized Object Sensitivity for Points-to Analysis for Java** — Ana Milanova, Atanas Rountev, Barbara Ryder · ACM TOSEM 2005 · 41pp · [DOI](https://doi.org/10.1145/1044834.1044835) · [PDF](https://www.cs.rpi.edu/~milanova/docs/tosem05.pdf). Object sensitivity: use receiver objects as context — the dominant precision/scalability sweet spot for OO programs.

22. **Resolving and Exploiting the k-CFA Paradox** — Matthew Might, Yannis Smaragdakis, David Van Horn · PLDI 2010 · 11pp · [DOI](https://doi.org/10.1145/1806596.1806631) · [PDF](https://matt.might.net/papers/might2010mcfa.pdf). Explains *why* call-site (k-CFA) context is cheap for functional languages yet ruinous for OO, connecting the functional and pointer-analysis traditions.

23. **Pick Your Contexts Well: Understanding Object-Sensitivity** — Yannis Smaragdakis, Martin Bravenboer, Ondřej Lhoták · POPL 2011 · 13pp · [DOI](https://doi.org/10.1145/1926385.1926390) · [PDF](https://yanniss.github.io/typesens-popl11.pdf). The definitive account of context choice; introduces type sensitivity as a cheaper approximation of object sensitivity.

24. **Hybrid Context-Sensitivity for Points-to Analysis** — George Kastrinis, Yannis Smaragdakis · PLDI 2013 · 11pp · [DOI](https://doi.org/10.1145/2491956.2462191) · [PDF](https://yanniss.github.io/hybrid-context-pldi13.pdf). Combines call-site and object sensitivity selectively, capturing most of the precision of each at a fraction of the cost.

### Reaching modern languages and tools
*Where these ideas live now: production frameworks, C/C++, and demand-driven Java.*

- **In Defense of Soundiness: A Manifesto** — [PDF](https://yanniss.github.io/Soundiness-CACM.pdf). Read alongside this section: why real-world analyses are deliberately unsound in specific, understood ways ("soundy"), and why that is the honest state of practice.

25. **SVF: Interprocedural Static Value-Flow Analysis in LLVM** — Yulei Sui, Jingling Xue · CC 2016 · 5pp · [DOI](https://doi.org/10.1145/2892208.2892235) · [PDF](https://yuleisui.github.io/publications/cc16.pdf). The open, sparse value-flow framework that brought scalable pointer/alias analysis to the LLVM IR most compiler work targets.
   - **Companion** — [SVF](https://github.com/SVF-tools/SVF). The actively developed tool; the fastest way to run these algorithms on real IR.

26. **Structure-Sensitive Points-to Analysis for C and C++** — George Balatsouras, Yannis Smaragdakis · SAS 2016 · 21pp · [DOI](https://doi.org/10.1007/978-3-662-53413-7_5) · [PDF](https://yanniss.github.io/cclyzer-sas16.pdf). Handling the low-level reality of C/C++ — struct layout, casts, pointer arithmetic — that the OO and Java work could abstract away.

27. **Boomerang: Demand-Driven Flow- and Context-Sensitive Pointer Analysis for Java** — Johannes Späth, Lisa Nguyen Quang Do, Karim Ali, Eric Bodden · ECOOP 2016 · 26pp · [DOI](https://doi.org/10.4230/LIPIcs.ECOOP.2016.22) · [PDF](https://drops.dagstuhl.de/opus/volltexte/2016/6116/pdf/LIPIcs-ECOOP-2016-22.pdf). A modern, precise demand-driven engine (flow- and context-sensitive at once) that clients like taint analysis query directly.

<!--html-->
<div class="why">
<b>Inclusion vs. unification, in one sentence.</b> Andersen treats each assignment
<code>a = b</code> as a <em>subset</em> constraint (points-to(b) &sube; points-to(a)) and
solves the resulting graph &mdash; precise, but the closure is cubic. Steensgaard treats
the same assignment as an <em>equality</em> and merges the two objects into one
equivalence class &mdash; near-linear via union-find, but coarse, because merges are
never undone. Every later dimension (flow-, context-, field-, object-sensitivity) is an
axis of precision layered on top of that one choice, and most of this list is about
buying back precision or scale that the base algorithm gave away.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Pointer Analysis** — Yannis Smaragdakis, George Balatsouras · 2015 · 72pp · [PDF](https://yanniss.github.io/points-to-tutorial15.pdf). The Foundations and Trends monograph: the single best modern synthesis of the whole area, built around the declarative (Doop) formulation.
- **BUY** **Principles of Program Analysis** — Flemming Nielson, Hanne Riis Nielson, Chris Hankin · 1999 · 452pp · [page](https://link.springer.com/book/10.1007/978-3-662-03811-6). Situates pointer analysis inside the broader dataflow / constraint / abstract-interpretation framework the field draws on.
- **BUY** **Data Flow Analysis: Theory and Practice** — Uday Khedker, Amitabha Sanyal, Bageshri Karkare · 2009 · 400pp · [page](https://www.routledge.com/Data-Flow-Analysis-Theory-and-Practice/Khedker-Sanyal-Karkare/p/book/9780849328800). A rigorous, example-driven treatment with a strong chapter on pointer and alias analysis.

## Key terms

- **points-to set** — the set of abstract objects a pointer may refer to at some program point.
- **may-alias / must-alias** — two pointers *may* alias if some execution makes them point to the same object; they *must* alias if every execution does.
- **inclusion- (subset-) based** — Andersen's model: assignments impose subset constraints between points-to sets; precise but cubic.
- **unification-based** — Steensgaard's model: assignments merge objects into one equivalence class via union-find; near-linear but coarse.
- **flow-sensitivity** — respecting statement order (a per-program-point solution) instead of one summary for the whole procedure.
- **context-sensitivity** — distinguishing a procedure's behavior per caller/context (call-site k-CFA, object sensitivity, or type sensitivity).
- **field-sensitivity** — modeling distinct object fields separately rather than collapsing them.
- **object-sensitivity** — using receiver (allocation) objects, not call sites, as the context abstraction — the OO sweet spot.
- **heap abstraction** — the finite model of the unbounded heap, usually one abstract object per allocation site.
- **strong vs. weak update** — overwriting a points-to set (sound only when the target is a single concrete object) vs. merging into it.
- **CFL-reachability** — phrasing an analysis as reachability in a graph under a context-free language of legal paths (the basis of demand-driven analyses).
- **on-the-fly call graph** — building the call graph during the points-to analysis, since resolving indirect calls needs points-to facts and vice versa.
- **soundy** — sound except for a few well-understood, deliberately unsound features (reflection, native code) — the honest standard for real analyses.
