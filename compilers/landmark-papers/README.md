# Compilers · landmark papers (survey)

A cross-cutting survey — the ~12 most important compiler papers across the area's
subtopics, in a suggested reading order (foundations first, then the post-2002
landmarks). The canonical, in-depth references live in the sibling subtopic
directories; this list gathers the standouts and points back to them.

Printable guide: `reading-guide.html` → `reading-guide.pdf` (run `make` from the
repo root). Run `./fetch.sh` to download the openly-available PDFs.

## Foundations (pre-2002)
1. **Kildall, A Unified Approach to Global Program Optimization** (1973) — dataflow as a lattice framework. → *ir-and-dataflow*
2. **Cytron et al., Efficiently Computing SSA and the Control Dependence Graph** (1991) — SSA construction. → *ir-and-dataflow*
3. **Cousot & Cousot, Abstract Interpretation** (1977) — the theory of sound static analysis. → *analysis-and-abstract-interpretation*
4. **Chaitin, Register Allocation and Spilling via Graph Coloring** (1982) — the graph-coloring formulation. → *register-allocation-and-scheduling*
5. **Knoop, Rüthing & Steffen, Lazy Code Motion** (1992) — optimal partial-redundancy elimination. → *redundancy-and-vectorization*

## Modern landmarks (post-2002)
6. **Lattner & Adve, LLVM** (2004) — the reusable compiler infrastructure. → *compiler-infrastructure*
7. **Bondhugula et al., Pluto** (2008) — practical polyhedral optimization. → *compiler-infrastructure*
8. **Leroy, CompCert — Formal Verification of a Realistic Compiler** (2009) — verified compilation. → *verified-compilation*
9. **Ragan-Kelley et al., Halide** (2013) — algorithm/schedule separation for DSLs. → *compiler-infrastructure*
10. **Schkufza, Sharma & Aiken, STOKE — Stochastic Superoptimization** (2013) — search-based optimization. → *verified-compilation*
11. **Lopes et al., Alive** (2015) — SMT-verified peephole optimizations. → *verified-compilation*
12. **Lattner et al., MLIR** (2021) — multi-level, dialect-based IR. → *compiler-infrastructure*
