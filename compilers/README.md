# Compilers

Reading lists for compiler construction and optimization, organized by subtopic.
Each subtopic directory holds the canonical, annotated paper references (verified,
with DOI + open-PDF links where a free copy exists). **[landmark-papers/](landmark-papers/)**
is the cross-cutting survey — the most important papers across the whole area,
rendered as a printable guide.

## Subtopics
- **[landmark-papers/](landmark-papers/)** — the area survey (start here; printable PDF)
- **[intermediate-representations-and-dataflow/](intermediate-representations-and-dataflow/)** — IR design, reducibility, dataflow frameworks, SSA, PDG, sea-of-nodes
- **[classical-optimization/](classical-optimization/)** — scalar opts: SCCP, value numbering, PRE, strength reduction, inlining, partial evaluation
- **[register-allocation-and-scheduling/](register-allocation-and-scheduling/)** — graph coloring, coalescing, linear scan, SSA-based allocation, scheduling, software pipelining
- **[vectorization-and-parallelization/](vectorization-and-parallelization/)** — dependence analysis, loop transforms, polyhedral, SLP, work-stealing, TLS
- **[pointer-analysis/](pointer-analysis/)** — alias analysis: Andersen/Steensgaard through context/flow/object sensitivity at scale
- **[abstract-interpretation/](abstract-interpretation/)** — numeric domains, widening/narrowing, IFDS, shape analysis, Astrée
- **[compiler-infrastructure/](compiler-infrastructure/)** — reusable frameworks, polyhedral, and tensor/DSL compilers (LLVM, Pluto, Halide, TVM, MLIR, BOLT)
- **[verified-compilation/](verified-compilation/)** — verified compilation and superoptimization (CompCert, CakeML, Alive, egg, STOKE)
