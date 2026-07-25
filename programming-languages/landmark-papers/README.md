# Programming languages · landmark papers (survey)

A cross-cutting survey — the most important programming-languages papers across the
area's subtopics, in a sensible reading order. Canonical, in-depth references live
in the sibling subtopic directories; this list gathers the standouts and points
back to them.

Printable guide: `reading-guide.html` → `reading-guide.pdf` (`make` from repo root).
Run `./fetch.sh` to download the openly-available PDFs.

1. **Landin, The Next 700 Programming Languages** (1966) — language design around a common core. → *semantics-and-language-design*
2. **Hoare, An Axiomatic Basis for Computer Programming** (1969) — Hoare logic. → *program-logics-and-verification*
3. **Reynolds, Towards a Theory of Type Structure** (1974) — System F / polymorphism. → *types-and-polymorphism*
4. **Cousot & Cousot, Abstract Interpretation** (1977) — sound static analysis. → *semantics-and-language-design*
5. **Milner, A Theory of Type Polymorphism** (1978) — Hindley-Milner inference. → *types-and-polymorphism*
6. **Wadler, Comprehending Monads** (1990) — effects in pure functional programming. → *monads-and-effects*
7. **Reynolds, Separation Logic** (2002) — local reasoning about the heap. → *program-logics-and-verification*
8. **Manson, Pugh & Adve, The Java Memory Model** (2005) — the first rigorous language memory model. → *concurrency-and-memory-models*
9. **Siek & Taha, Gradual Typing for Functional Languages** (2006) — mixing static and dynamic typing. → *practical-type-systems*
10. **Klein et al., seL4** (2009) — a machine-checked OS-kernel correctness proof. → *program-logics-and-verification*
11. **Batty et al., Mathematizing C++ Concurrency** (2011) — the C11/C++11 relaxed-memory model. → *concurrency-and-memory-models*
12. **Jung et al., RustBelt** (2018) — a formal safety proof for Rust. → *program-logics-and-verification*

For depth on any theme, follow the subtopic pointer.

## Reference shelf — books

- **BUY** **Types and Programming Languages (TAPL)** — Benjamin C. Pierce (2002). the standard graduate introduction to type systems. [page](https://www.cis.upenn.edu/~bcpierce/tapl/)
- **BUY** **Advanced Topics in Types and Programming Languages** — Pierce (ed.) (2005). deeper chapters: dependent types, effects, modules. [page](https://www.cis.upenn.edu/~bcpierce/attapl/)
- **FREE** **Practical Foundations for Programming Languages** — Robert Harper (2nd ed., 2016). reconstructs language features from type-structure first principles (free abridged PDF). [PDF](https://www.cs.cmu.edu/~rwh/pfpl/abbrev.pdf)
- **BUY** **The Formal Semantics of Programming Languages** — Glynn Winskel (1993). accessible first course in operational/denotational/axiomatic semantics. [page](https://mitpress.mit.edu/9780262731034/the-formal-semantics-of-programming-languages/)
- **FREE** **Software Foundations** — Pierce et al.. machine-checked (Coq/Rocq) course in logic, PL semantics, verification (free HTML). [page](https://softwarefoundations.cis.upenn.edu/)
- **FREE** **Concrete Semantics with Isabelle/HOL** — Nipkow, Klein (2014). operational semantics + verification, fully mechanized (free PDF). [PDF](https://concrete-semantics.org/concrete-semantics.pdf)
- **FREE** **Certified Programming with Dependent Types** — Adam Chlipala (2013). building certified programs and proofs in Coq (free PDF). [PDF](http://adam.chlipala.net/cpdt/cpdt.pdf)
