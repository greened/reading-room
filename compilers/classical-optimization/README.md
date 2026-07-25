# Compilers · Classical (scalar) optimization

The scalar optimizations that define the vocabulary of the field: constant
propagation, value numbering, redundancy elimination, strength reduction,
inlining, and partial evaluation.

- **A Catalogue of Optimizing Transformations** — Allen, Cocke, 1972, in *Design and Optimization of Compilers*. The first systematic catalogue (CSE, DCE, code motion, strength reduction, inlining). [PDF](https://www.clear.rice.edu/comp512/Lectures/Papers/1971-allen-catalog.pdf)
- **A Unified Approach to Global Program Optimization** — Gary A. Kildall, 1973, POPL. The dataflow foundation underlying constant propagation, CSE, and liveness. [DOI](https://doi.org/10.1145/512927.512945) · [PDF](https://calhoun.nps.edu/server/api/core/bitstreams/54e90734-ceb5-4f4f-94f6-83e51cd2da73/content)
- **An Algorithm for Reduction of Operator Strength** — Cocke, Kennedy, 1977, CACM. Replacing loop induction-variable multiplies with additions. [DOI](https://doi.org/10.1145/359863.359888)
- **An Analysis of Inline Substitution for a Structured Programming Language** — Robert W. Scheifler, 1977, CACM. Inlining as a cost-constrained optimization. [DOI](https://doi.org/10.1145/359810.359830)
- **Global Optimization by Suppression of Partial Redundancies** — Morel, Renvoise, 1979, CACM. The seminal partial-redundancy elimination (PRE), unifying CSE and LICM. [DOI](https://doi.org/10.1145/359060.359069)
- **Detecting Equality of Variables in Programs** — Alpern, Wegman, Zadeck, 1988, POPL. Congruence over SSA value graphs; the basis of global value numbering. [DOI](https://doi.org/10.1145/73560.73561)
- **Global Value Numbers and Redundant Computations** — Rosen, Wegman, Zadeck, 1988, POPL. GVN detecting equivalent expressions and second-order redundancy. [DOI](https://doi.org/10.1145/73560.73562)
- **Constant Propagation with Conditional Branches (SCCP)** — Wegman, Zadeck, 1991, ACM TOPLAS. Sparse conditional constant propagation with unreachable-branch pruning. [DOI](https://doi.org/10.1145/103135.103136) · [PDF](https://www.cs.utexas.edu/~pingali/CS380C/2010/papers/p291-wegman.pdf)
- **Lazy Code Motion** — Knoop, Rüthing, Steffen, 1992, PLDI. PRE recast as unidirectional analyses with computationally optimal placement. [DOI](https://doi.org/10.1145/143095.143136) · [PDF](http://rsim.cs.uiuc.edu/arch/qual_papers/compilers/knoop92.pdf)
- **Partial Evaluation and Automatic Program Generation** — Jones, Gomard, Sestoft, 1993, Prentice Hall. The definitive text; specialization and the Futamura projections. [book](https://www.itu.dk/people/sestoft/pebook/)
- **Global Code Motion / Global Value Numbering** — Cliff Click, 1995, PLDI. Separating value optimization from scheduling; standard in SSA compilers. [DOI](https://doi.org/10.1145/207110.207154)
