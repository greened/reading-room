# Compilers · landmark papers (survey)

A cross-cutting survey — the ~12 most important compiler papers across the area's
subtopics, in a sensible reading order (the machinery every optimizer rests on,
then the reusable-infrastructure and verification landmarks). The canonical,
in-depth references live in the sibling subtopic directories; this list gathers
the standouts and points back to them.

Printable guide: `reading-guide.html` → `reading-guide.pdf` (run `make` from the
repo root). Run `./fetch.sh` to download the openly-available PDFs.

1. **Kildall, A Unified Approach to Global Program Optimization** (1973) — dataflow as a lattice framework. → *intermediate-representations-and-dataflow*
2. **Cytron et al., Efficiently Computing SSA and the Control Dependence Graph** (1991) — SSA construction. → *intermediate-representations-and-dataflow*
3. **Cousot & Cousot, Abstract Interpretation** (1977) — the theory of sound static analysis. → *abstract-interpretation*
4. **Chaitin, Register Allocation and Spilling via Graph Coloring** (1982) — the graph-coloring formulation. → *register-allocation-and-scheduling*
5. **Knoop, Rüthing & Steffen, Lazy Code Motion** (1992) — optimal partial-redundancy elimination. → *classical-optimization*
6. **Lattner & Adve, LLVM** (2004) — the reusable compiler infrastructure. → *compiler-infrastructure*
7. **Bondhugula et al., Pluto** (2008) — practical polyhedral optimization. → *compiler-infrastructure*
8. **Leroy, CompCert — Formal Verification of a Realistic Compiler** (2009) — verified compilation. → *verified-compilation*
9. **Ragan-Kelley et al., Halide** (2013) — algorithm/schedule separation for DSLs. → *compiler-infrastructure*
10. **Schkufza, Sharma & Aiken, STOKE — Stochastic Superoptimization** (2013) — search-based optimization. → *verified-compilation*
11. **Lopes et al., Alive** (2015) — SMT-verified peephole optimizations. → *verified-compilation*
12. **Lattner et al., MLIR** (2021) — multi-level, dialect-based IR. → *compiler-infrastructure*

For depth on any theme, follow the subtopic pointer (each subtopic dir lists more
papers than this survey includes).

## Reference shelf — books

- **BUY** **Compilers: Principles, Techniques, and Tools (Dragon Book)** — Aho, Lam, Sethi, Ullman (2nd ed., 2006). the canonical survey of lexing, parsing, semantics, and code generation. [page](https://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools)
- **BUY** **Advanced Compiler Design and Implementation** — Steven S. Muchnick (1997). the deepest single-volume treatment of production optimization and SSA-era analyses. [page](https://openlibrary.org/isbn/1558603204)
- **BUY** **Engineering a Compiler** — Cooper, Torczon (3rd ed., 2022). modern, engineering-focused course text. [page](https://shop.elsevier.com/books/engineering-a-compiler/cooper/978-0-12-815412-0)
- **BUY** **Modern Compiler Implementation in ML** — Andrew W. Appel (1998). builds a complete compiler end to end. [page](https://www.cs.princeton.edu/~appel/modern/ml/)
- **BUY** **Optimizing Compilers for Modern Architectures** — Allen, Kennedy (2001). the reference on dependence analysis, loop transforms, and parallelization. [page](https://shop.elsevier.com/books/optimizing-compilers-for-modern-architectures/allen/978-1-55860-286-1)
- **BUY** **Principles of Program Analysis** — Nielson, Nielson, Hankin (1999). rigorous unifying treatment of dataflow, CFA, abstract interpretation, type/effect analyses. [page](https://link.springer.com/book/10.1007/978-3-662-03811-6)
- **FREE** **Crafting Interpreters** — Robert Nystrom (2021). hands-on: builds a tree-walk and a bytecode interpreter from scratch (free HTML). [page](https://craftinginterpreters.com/)
