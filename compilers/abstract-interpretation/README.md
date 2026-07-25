# Compilers · Abstract interpretation

The theory of sound static analysis by approximation — Galois connections,
numeric domains (intervals, octagons, polyhedra), widening/narrowing, IFDS, and
shape analysis — through to the industrial Astrée analyzer.

- **Abstract Interpretation: A Unified Lattice Model for Static Analysis…** — Patrick & Radhia Cousot, 1977, POPL. The founding framework: sound analysis by fixpoint approximation. [DOI](https://doi.org/10.1145/512950.512973) · [PDF](https://www.di.ens.fr/~cousot/publications.www/CousotCousot-POPL-77-ACM-p238--252-1977.pdf)
- **Automatic Discovery of Linear Restraints Among Variables of a Program** — Cousot, Halbwachs, 1978, POPL. The polyhedra domain: the first relational numeric domain. [DOI](https://doi.org/10.1145/512760.512770) · [PDF](https://www.di.ens.fr/~cousot/publications.www/CousotHalbwachs-POPL-78-ACM-p84--97-1978.pdf)
- **Systematic Design of Program Analysis Frameworks** — Cousot & Cousot, 1979, POPL. Galois connections and deriving analyses from a formal semantics. [DOI](https://doi.org/10.1145/567752.567778) · [PDF](https://pcousot.github.io/publications/CousotCousot-POPL-79-ACM-p269--282-1979.pdf)
- **Affine Relationships Among Variables of a Program** — Michael Karr, 1976, Acta Informatica. Pioneering inference of affine equalities among variables. [DOI](https://doi.org/10.1007/BF00268497)
- **Comparing the Galois Connection and Widening/Narrowing Approaches** — Cousot & Cousot, 1992, PLILP. Reconciles the two abstraction styles for infinite-height domains. [DOI](https://doi.org/10.1007/3-540-55844-6_142) · [PDF](https://pcousot.github.io/publications/CousotCousot-PLILP-92-LNCS-n631-p269--295-1992.pdf)
- **Precise Interprocedural Dataflow Analysis via Graph Reachability (IFDS)** — Reps, Horwitz, Sagiv, 1995, POPL. Reduces a large class of interprocedural problems to polynomial-time reachability. [DOI](https://doi.org/10.1145/199448.199462) · [PDF](https://research.cs.wisc.edu/wpis/papers/popl95.pdf)
- **Solving Shape-Analysis Problems in Languages with Destructive Updating** — Sagiv, Reps, Wilhelm, 1998, ACM TOPLAS. Shape graphs for sound reasoning about the heap. [DOI](https://doi.org/10.1145/271510.271517) · [PDF](https://research.cs.wisc.edu/wpis/papers/toplas98a.pdf)
- **Parametric Shape Analysis via 3-Valued Logic (TVLA)** — Sagiv, Reps, Wilhelm, 2002, ACM TOPLAS. The parametric, instantiable heap-abstraction methodology. [DOI](https://doi.org/10.1145/514188.514190) · [PDF](https://research.cs.wisc.edu/wpis/papers/toplas02.pdf)
- **A Static Analyzer for Large Safety-Critical Software (Astrée)** — Blanchet, Cousot, Cousot, Feret, Mauborgne, Miné, Monniaux, Rival, 2003, PLDI. The landmark industrial abstract interpreter (avionics). [DOI](https://doi.org/10.1145/781131.781153) · [PDF](https://pcousot.github.io/publications/BlanchetCousotEtAl-PLDI03-USletter.pdf)
- **The Octagon Abstract Domain** — Antoine Miné, 2006, HOSC. The widely used weakly-relational domain between intervals and polyhedra. [DOI](https://doi.org/10.1007/s10990-006-8609-1)
