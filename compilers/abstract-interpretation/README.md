# Compilers · Abstract interpretation

The theory of sound static analysis by approximation. A program's exact behavior is
uncomputable, so we compute a decidable over-approximation instead — and abstract
interpretation is the framework that says exactly when such an approximation is *sound*.
The path below starts with that framework (Galois connections, fixpoints), then treats
each design choice in turn: which numeric domain to use, how to make the fixpoint
converge with widening, how to cross procedure boundaries (IFDS/IDE), how to abstract
the heap (shape analysis), how to carry the idea to functional and logic programs, and
how to refine an abstraction that is too coarse (CEGAR). It ends where the theory pays
off: the Astrée analyzer proving avionics code free of run-time errors, and Verasco
proving the analyzer itself correct.

> **How to read this list.** Begin with the founding framework — Cousot & Cousot
> 1977/79 define what "sound approximation" means and how to *derive* an analysis from a
> semantics rather than invent one and hope. Everything after is a choice of abstraction.
> Read the foundations in order; then the later sections are largely independent, so jump
> to the numeric domains, the heap, or the industrial analyzers as your interest dictates.
> The two big TOPLAS shape-analysis papers are references to dip into, not front-to-back
> reads.

## Reading order

### The founding framework
*Start here: the theory that defines the field — sound approximation of a program's semantics as fixpoints in a lattice.*

1. **Abstract Interpretation: A Unified Lattice Model for Static Analysis of Programs by Construction or Approximation of Fixpoints** — Patrick Cousot, Radhia Cousot · POPL 1977 · 15pp · [DOI](https://doi.org/10.1145/512950.512973) · [PDF](https://www.di.ens.fr/~cousot/publications.www/CousotCousot-POPL-77-ACM-p238--252-1977.pdf). The founding paper: sound analysis as fixpoint approximation in a lattice. Read it first even though the notation is dense — every later paper is a special case.
   - **Abstract Interpretation in a Nutshell** — [Patrick Cousot's overview](https://www.di.ens.fr/~cousot/AI/). A short, self-contained tour of the core idea, gentler than the paper.
   - **MIT 16.399: Abstract Interpretation** — [course page](https://web.mit.edu/16.399/www/). Cousot's full graduate course — slides and notes that unpack the framework.

2. **Systematic Design of Program Analysis Frameworks** — Patrick Cousot, Radhia Cousot · POPL 1979 · 14pp · [DOI](https://doi.org/10.1145/567752.567778) · [PDF](https://pcousot.github.io/publications/CousotCousot-POPL-79-ACM-p269--282-1979.pdf). Galois connections and the recipe for deriving a correct-by-construction analysis from a formal semantics. This is the paper that makes soundness a matter of definition, not proof-after-the-fact.

3. **Comparing the Galois Connection and Widening/Narrowing Approaches to Abstract Interpretation** — Patrick Cousot, Radhia Cousot · PLILP 1992 · 27pp · [DOI](https://doi.org/10.1007/3-540-55844-6_142) · [PDF](https://pcousot.github.io/publications/CousotCousot-PLILP-92-LNCS-n631-p269--295-1992.pdf). Reconciles the two abstraction styles and formalizes widening/narrowing for domains that have no best abstraction — essential before the numeric-domain papers.

### Numeric abstract domains
*The analysis is only as sharp as its domain; these climb from non-relational intervals to fully relational polyhedra, then trade precision back for speed.*

4. **Static Determination of Dynamic Properties of Programs** — Patrick Cousot, Radhia Cousot · ISOP 1976 · 25pp · [PDF](https://www.di.ens.fr/~cousot/COUSOTpapers/publications.www/CousotCousot-ISOP-76-Dunod-p106--130-1976.pdf). The paper that predates the 1977 framework and introduces the interval domain — the simplest useful abstraction, and the concrete example the theory generalizes.

5. **Affine Relationships Among Variables of a Program** — Michael Karr · Acta Informatica 1976 · 19pp · [DOI](https://doi.org/10.1007/BF00268497). The first inference of affine *equalities* among variables — the relational idea, before the lattice framework existed to name it.

6. **Automatic Discovery of Linear Restraints Among Variables of a Program** — Patrick Cousot, Nicolas Halbwachs · POPL 1978 · 14pp · [DOI](https://doi.org/10.1145/512760.512770) · [PDF](https://www.di.ens.fr/~cousot/publications.www/CousotHalbwachs-POPL-78-ACM-p84--97-1978.pdf). The convex-polyhedra domain: linear *inequalities* among variables, the most precise (and most expensive) classical relational domain.

7. **Scalable Analysis of Linear Systems Using Mathematical Programming** — Sriram Sankaranarayanan, Henny Sipma, Zohar Manna · VMCAI 2005 · 17pp · [DOI](https://doi.org/10.1007/978-3-540-30579-8_2). Template polyhedra: fix the constraint shapes in advance and recover most of polyhedra's precision at a fraction of the cost.

8. **A New Numerical Abstract Domain Based on Difference-Bound Matrices** — Antoine Miné · PADO 2001 · 18pp · [DOI](https://doi.org/10.1007/3-540-44978-7_10). The "zones" domain — constraints of the form x − y ≤ c — a cheap weakly-relational middle ground between intervals and polyhedra.

9. **The Octagon Abstract Domain** — Antoine Miné · HOSC 2006 · 70pp · [DOI](https://doi.org/10.1007/s10990-006-8609-1). The widely deployed ±x ± y ≤ c domain; the journal version is the definitive reference on weakly-relational domains and their transfer functions.
   - **APRON numerical abstract domain library** — [library & docs](https://antoinemine.github.io/Apron/doc/). The de-facto library implementing intervals, octagons, and polyhedra behind one API — how these domains reach real analyzers.

### Making fixpoints converge — widening and iteration
*Infinite-height domains do not terminate on their own; widening/narrowing and iteration order are what make analysis finish — and stay precise.*

10. **Efficient Chaotic Iteration Strategies with Widenings** — François Bourdoncle · FMPTA 1993 · 14pp · [DOI](https://doi.org/10.1007/BFb0039704). Where to apply widening in the control-flow graph, and in what order to iterate, so that the analysis converges quickly without needless precision loss.

11. **Lookahead Widening** — Denis Gopan, Thomas Reps · CAV 2006 · 15pp · [DOI](https://doi.org/10.1007/11817963_41). A refinement that regains much of the precision naïve widening throws away, by exploring a loop's behavior before extrapolating.

### Interprocedural analysis
*Real programs have procedures; these reduce context-sensitive analysis to efficient graph problems.*

12. **Precise Interprocedural Dataflow Analysis via Graph Reachability (IFDS)** — Thomas Reps, Susan Horwitz, Mooly Sagiv · POPL 1995 · 14pp · [DOI](https://doi.org/10.1145/199448.199462) · [PDF](https://research.cs.wisc.edu/wpis/papers/popl95.pdf). Reduces a large class of context-sensitive interprocedural problems to polynomial-time graph reachability — the workhorse behind many production analyses.

13. **Precise Interprocedural Dataflow Analysis with Applications to Constant Propagation (IDE)** — Mooly Sagiv, Thomas Reps, Susan Horwitz · TCS 1996 · 40pp · [DOI](https://doi.org/10.1016/0304-3975(96)00072-2). Generalizes IFDS from set problems to *environment transformers*, extending the graph-reachability idea to constant propagation and beyond.

### Heap and shape analysis
*Pointers and the heap are where abstraction is hardest; shape analysis abstracts unbounded, dynamically allocated structures soundly.*

14. **Solving Shape-Analysis Problems in Languages with Destructive Updating** — Mooly Sagiv, Thomas Reps, Reinhard Wilhelm · TOPLAS 1998 · 59pp · [DOI](https://doi.org/10.1145/271510.271517) · [PDF](https://research.cs.wisc.edu/wpis/papers/toplas98a.pdf). Shape graphs for sound reasoning about the heap under destructive pointer updates — the foundation of the field.

15. **Parametric Shape Analysis via 3-Valued Logic (TVLA)** — Mooly Sagiv, Thomas Reps, Reinhard Wilhelm · TOPLAS 2002 · 78pp · [DOI](https://doi.org/10.1145/514188.514190) · [PDF](https://research.cs.wisc.edu/wpis/papers/toplas02.pdf). The parametric, instantiable heap-abstraction methodology: choose predicates, get an analysis. A reference to dip into, not read cover to cover.

16. **A Local Shape Analysis Based on Separation Logic** — Dino Distefano, Peter O'Hearn, Hongseok Yang · TACAS 2006 · 16pp · [DOI](https://doi.org/10.1007/11691372_19). Recasts shape analysis in separation logic, whose *local reasoning* is what later made heap analysis scale (and led to Facebook's Infer).

### Beyond imperative code — functional and logic programs
*Abstract interpretation is a semantics-level idea, not a C-only trick; here it is applied to other paradigms.*

17. **Higher-Order Abstract Interpretation (and Application to Comportment Analysis Generalizing Strictness, Termination, Projection and PER Analysis)** — Patrick Cousot, Radhia Cousot · ICCL 1994 · 18pp · [DOI](https://doi.org/10.1109/ICCL.1994.288389). Lifts the framework to higher-order functional languages, unifying strictness, termination, and projection analyses as one construction.

18. **A Practical Framework for the Abstract Interpretation of Logic Programs** — Maurice Bruynooghe · Journal of Logic Programming 1991 · 34pp · [DOI](https://doi.org/10.1016/0743-1066(91)90004-9). The standard framework for analyzing Prolog-style programs — abstract substitutions and the and/or trees that later powered mode and sharing analyses.

### Refinement and the model-checking connection
*Abstraction that is too coarse can be sharpened automatically; this line links abstract interpretation to model checking.*

19. **Construction of Abstract State Graphs with PVS** — Susanne Graf, Hassen Saïdi · CAV 1997 · 12pp · [DOI](https://doi.org/10.1007/3-540-63166-6_10). Predicate abstraction: abstract states by the truth of a finite set of predicates, discharging the transfer functions with a theorem prover.

20. **Counterexample-Guided Abstraction Refinement (CEGAR)** — Edmund Clarke, Orna Grumberg, Somesh Jha, Yuan Lu, Helmut Veith · CAV 2000 · 16pp · [DOI](https://doi.org/10.1007/10722167_15). Start coarse; when a spurious counterexample appears, refine the abstraction just enough to rule it out. The loop behind SLAM, BLAST, and modern software model checkers.

### Industrial scale and verified analyzers
*The payoff — abstract interpretation proving real safety-critical software correct, and analyzers proved correct themselves.*

21. **A Static Analyzer for Large Safety-Critical Software (Astrée)** — Bruno Blanchet, Patrick Cousot, Radhia Cousot, Jérôme Feret, Laurent Mauborgne, Antoine Miné, David Monniaux, Xavier Rival · PLDI 2003 · 12pp · [DOI](https://doi.org/10.1145/781131.781153) · [PDF](https://pcousot.github.io/publications/BlanchetCousotEtAl-PLDI03-USletter.pdf). The landmark industrial abstract interpreter: zero false alarms on Airbus flight-control code by specializing the domains to the program class.
    - **Astrée project page** — [ENS Astrée](https://www.astree.ens.fr/). The research analyzer behind the paper.
    - **Astrée (commercial)** — [AbsInt Astrée](https://www.absint.com/astree/index.htm). The productized analyzer now used in avionics and automotive certification.

22. **The ASTRÉE Analyzer** — Patrick Cousot, Radhia Cousot, Jérôme Feret, Laurent Mauborgne, Antoine Miné, David Monniaux, Xavier Rival · ESOP 2005 · 10pp · [DOI](https://doi.org/10.1007/978-3-540-31987-0_3) · [PDF](https://pcousot.github.io/publications/CousotEtAl-ESOP05.pdf). The design retrospective: which domains, which widenings, and which engineering choices made the zero-alarm result possible.

23. **Verasco: A Formally Verified C Static Analyzer** — Jacques-Henri Jourdan, Vincent Laporte, Sandrine Blazy, Xavier Leroy, David Pichardie · POPL 2015 · 13pp · [DOI](https://doi.org/10.1145/2676726.2676966) · [PDF](https://xavierleroy.org/publi/verasco-popl2015.pdf). A sound abstract-interpretation analyzer proved correct in Coq and plugged into CompCert — the framework turned back on itself.

<!--html-->
<div class="why">
<b>Why soundness is the whole point.</b> Every domain and operator above is chosen so the
result <em>over-approximates</em> all real executions: the abstract answer describes a
superset of what can actually happen. That is what lets an analyzer say "this program has
no run-time error" and mean it — the guarantee Astrée gives avionics code and Verasco
gives its own proofs. The cost is false alarms, and much of this literature is the fight
to keep abstraction cheap and precise enough that the alarms stay rare.
</div>
<!--/html-->

## Reference shelf — books

- **BUY** **Principles of Abstract Interpretation** — Patrick Cousot · 2021 · 833pp · [page](https://mitpress.mit.edu/9780262044905/principles-of-abstract-interpretation/). The definitive modern treatment, straight from the founder — the book to own once the papers hook you.
- **BUY** **Principles of Program Analysis** — Flemming Nielson, Hanne Riis Nielson, Chris Hankin · 1999 · 452pp · [page](https://link.springer.com/book/10.1007/978-3-662-03811-6). The standard textbook, placing abstract interpretation alongside dataflow, control-flow, and type/effect analysis.
- **BUY** **Introduction to Static Analysis: An Abstract Interpretation Perspective** — Xavier Rival, Kwangkeun Yi · 2020 · 308pp · [page](https://mitpress.mit.edu/9780262043410/introduction-to-static-analysis/). The gentlest on-ramp; you build a small analyzer as you read.

## Key terms

- **abstract domain** — the lattice of approximate program properties an analysis computes over (intervals, octagons, polyhedra, shape graphs).
- **Galois connection** — the paired abstraction (α) and concretization (γ) maps that make an abstraction sound by construction.
- **fixpoint** — the solution of the recursive equations describing a program's semantics; an analysis computes a sound abstract one.
- **widening (∇)** — an extrapolation operator that forces a fixpoint iteration to terminate on an infinite-height domain.
- **narrowing (∆)** — the companion operator that recovers precision lost to an over-eager widening.
- **relational domain** — one that tracks relationships *among* variables (octagons, polyhedra), unlike a non-relational domain that bounds each variable alone (intervals).
- **IFDS / IDE** — frameworks reducing interprocedural dataflow to graph reachability (IFDS) or to environment transformers (IDE).
- **shape analysis** — heap abstraction that soundly summarizes unbounded, dynamically allocated data structures.
- **predicate abstraction** — abstracting states by the truth values of a finite set of predicates.
- **CEGAR** — counterexample-guided abstraction refinement: refine the abstraction until spurious counterexamples disappear.
- **soundness** — the analysis over-approximates every real behavior, so a clean report is a genuine guarantee, at the price of possible false alarms.
