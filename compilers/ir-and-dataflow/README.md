# Compilers · IR & dataflow foundations

The intermediate-representation and dataflow-analysis machinery every optimizer
rests on.

- **A Unified Approach to Global Program Optimization** — Gary A. Kildall, 1973, POPL. *foundational.* Founds the lattice / monotone-framework view of iterative dataflow analysis. [DOI](https://doi.org/10.1145/512927.512945) · [PDF](https://haoxintu.github.io/files/1-A%20Unified%20Approach%20to%20Global%20Program%20Optimization.pdf)
- **Efficiently Computing Static Single Assignment Form and the Control Dependence Graph** — Cytron, Ferrante, Rosen, Wegman, Zadeck, 1991, ACM TOPLAS. *foundational.* The dominance-frontier SSA-construction algorithm that made SSA the default IR. [DOI](https://doi.org/10.1145/115372.115320) · [PDF](https://www.cs.utexas.edu/~pingali/CS380C/2010/papers/ssaCytron.pdf)
- **A Simple Graph-Based Intermediate Representation** — Cliff Click, Michael Paleczny, 1995, IR'95. *foundational.* The sea-of-nodes IR underpinning HotSpot's C2 and later JIT/IR design. [DOI](https://doi.org/10.1145/202530.202534) · [PDF](https://www.oracle.com/technetwork/java/javase/tech/c2-ir95-150110.pdf)
