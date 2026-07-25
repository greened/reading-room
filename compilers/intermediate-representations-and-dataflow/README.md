# Compilers · Intermediate representations & dataflow

IR design and the dataflow-analysis frameworks every optimizer rests on — from
flow-graph reducibility and interval/structural analysis through SSA and the
sea-of-nodes graph. (Muchnick's *Advanced Compiler Design* is the companion text.)

- **A Unified Approach to Global Program Optimization** — Gary A. Kildall, 1973, POPL. Founded lattice-theoretic dataflow: the first unified fixed-point framework. [DOI](https://doi.org/10.1145/512927.512945) · [PDF](https://calhoun.nps.edu/server/api/core/bitstreams/54e90734-ceb5-4f4f-94f6-83e51cd2da73/content)
- **Characterizations of Reducible Flow Graphs** — Hecht, Ullman, 1974, JACM. Equivalent characterizations of reducibility (T1/T2, dominator back edges). [DOI](https://doi.org/10.1145/321832.321835)
- **Testing Flow Graph Reducibility** — Robert E. Tarjan, 1974, JCSS. Efficient DFS + union-find reducibility test. [DOI](https://doi.org/10.1016/S0022-0000(74)80049-8)
- **A Program Data Flow Analysis Procedure** — Allen, Cocke, 1976, CACM. Introduced interval analysis (the classic elimination approach). [DOI](https://doi.org/10.1145/360018.360025) · [PDF](https://amturing.acm.org/p137-allen.pdf)
- **A Fast and Usually Linear Algorithm for Global Flow Analysis** — Graham, Wegman, 1976, JACM. Near-linear elimination for reducible graphs. [DOI](https://doi.org/10.1145/321921.321939)
- **Monotone Data Flow Analysis Frameworks** — Kam, Ullman, 1977, Acta Informatica. Generalized Kildall to monotone functions; MFP vs MOP. [DOI](https://doi.org/10.1007/BF00290339)
- **Structural Analysis: A New Approach to Flow Analysis** — Micha Sharir, 1980, Computer Languages. Syntax-directed elimination over control-flow constructs. [DOI](https://doi.org/10.1016/0096-0551(80)90007-7)
- **The Program Dependence Graph and Its Use in Optimization** — Ferrante, Ottenstein, Warren, 1987, ACM TOPLAS. Made data and control dependences explicit; basis for slicing/vectorization. [DOI](https://doi.org/10.1145/24039.24041) · [PDF](https://web.eecs.umich.edu/~mahlke/courses/583f23/reading/ferrante_toplas_87.pdf)
- **Global Value Numbers and Redundant Computations** — Rosen, Wegman, Zadeck, 1988, POPL. SSA + value numbering for value-equivalent redundancy. [DOI](https://doi.org/10.1145/73560.73562)
- **The Program Dependence Web** — Ballance, Maccabe, Ottenstein, 1990, PLDI. Gated SSA + a control/data/demand-driven IR. [DOI](https://doi.org/10.1145/93542.93578)
- **Efficiently Computing SSA Form and the Control Dependence Graph** — Cytron, Ferrante, Rosen, Wegman, Zadeck, 1991, ACM TOPLAS. The dominance-frontier SSA construction; made SSA the standard IR. [DOI](https://doi.org/10.1145/115372.115320)
- **A Simple Graph-Based Intermediate Representation** — Click, Paleczny, 1995, IR'95. The sea-of-nodes IR behind HotSpot C2, V8 TurboFan, and other JITs. [DOI](https://doi.org/10.1145/202529.202534)
