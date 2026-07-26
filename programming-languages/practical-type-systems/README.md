# Programming languages · Practical type systems

Type theory earns its keep when it meets real programs: legacy code that was
never typed, untrusted input, shared mutable memory, concurrent protocols, and
side effects. This guide follows the ideas that carried type theory out of the
calculus and into working languages. The reading path climbs in rungs — start
with **gradual typing** (how static types coexist with dynamic code), move to
**refinement types** (types that carry logical predicates), then **dependent
types** tamed for real programming, then **linear and ownership types** (tracking
*how* a value is used, the road to Rust), then **session types** (typing the
messages between processes), then **effect systems** (typing what a computation
*does*), then **information-flow types** (typing *where* a value's data may
travel), and close with **property-based testing**, the tool that takes over
where the type system stops.

> **How to read this list.** Each section is one rung of that ladder and reads
> well on its own, so dip into whichever problem you have — dynamic-to-static
> migration, richer specifications, safe memory, protocols, effects, security.
> But the sections are ordered so each borrows vocabulary from the last:
> consistency and blame set up refinement, refinement sets up dependency,
> linearity sets up sessions and effects, and effects set up information flow.

### Gradual typing: static and dynamic code in one program
*First, because it is the most immediate practical question — how do types coexist with the untyped code already in production?*

1. **Contracts for Higher-Order Functions** — Findler, Felleisen · ICFP 2002 · 12pp · [DOI](https://doi.org/10.1145/581478.581484) · [PDF](https://www2.ccs.neu.edu/racket/pubs/icfp2002-ff.pdf). The runtime-checking substrate gradual typing is built on, and the first correct account of *blame* for higher-order values.

2. **Gradual Typing for Functional Languages** — Siek, Taha · Scheme Workshop 2006 · 12pp · [PDF](http://scheme2006.cs.uchicago.edu/13-siek.pdf). Coins gradual typing and the *consistency* relation that lets typed and untyped code interoperate at a boundary.
   - **Companion** — [What is Gradual Typing?](https://wphomes.soic.indiana.edu/jsiek/what-is-gradual-typing/). Siek's own plain-English walkthrough of the idea and its design space.

3. **Well-Typed Programs Can't Be Blamed** — Wadler, Findler · ESOP 2009 · 32pp · [DOI](https://doi.org/10.1007/978-3-642-00590-9_1) · [PDF](https://users.cs.northwestern.edu/~robby/pubs/papers/esop2009-wf.pdf). The blame calculus and the blame theorem: when a boundary fails, the fault always lies with the less-typed side.

4. **The Design and Implementation of Typed Scheme** — Tobin-Hochstadt, Felleisen · POPL 2008 · 12pp · [DOI](https://doi.org/10.1145/1328438.1328486) · [PDF](https://www2.ccs.neu.edu/racket/pubs/popl08-thf.pdf). *Occurrence typing* — sound static types laid over idiomatic untyped code (Typed Racket) by reading the control flow programmers already write.

5. **Understanding TypeScript** — Bierman, Abadi, Torgersen · ECOOP 2014 · 25pp · [DOI](https://doi.org/10.1007/978-3-662-44202-9_11) · [PDF](https://users.soe.ucsc.edu/~abadi/Papers/FTS-submitted.pdf). A formal account of the type system that took gradual typing mainstream, including exactly where it is deliberately unsound.

6. **Safe & Efficient Gradual Typing for TypeScript** — Rastogi, Swamy, Fournet, Bierman, Vekris · POPL 2015 · 24pp · [DOI](https://doi.org/10.1145/2676726.2676971) · [PDF](https://arxiv.org/pdf/1411.3183). How to buy back soundness for TypeScript without paying ruinous runtime costs.

7. **Space-Efficient Gradual Typing** — Herman, Tomb, Flanagan · HOSC 2010 · 25pp · [DOI](https://doi.org/10.1007/s10990-011-9066-z) · [PDF](https://users.soe.ucsc.edu/~cormac/papers/hosc10.pdf). Casts pile up without bound as a value crosses a boundary back and forth; the fix is coercions that compose in constant space — the first serious reckoning with gradual typing's runtime cost.

8. **Is Sound Gradual Typing Dead?** — Takikawa, Feltey, Greenman, New, Vitek, Felleisen · POPL 2016 · 13pp · [DOI](https://doi.org/10.1145/2837614.2837630) · [PDF](https://www2.ccs.neu.edu/racket/pubs/popl16-tfgnvf.pdf). The empirical reckoning: the runtime cost of *fully* sound gradual typing, and why most languages settle for less.

9. **Abstracting Gradual Typing** — Garcia, Clark, Tanter · POPL 2016 · 14pp · [DOI](https://doi.org/10.1145/2837614.2837670) · [PDF](https://www.cs.ubc.ca/~rxg/agt.pdf). A recipe for *deriving* a gradual type system from a static one — read the dynamic type as an abstraction of the types it could stand for — turning gradual typing from a series of one-off designs into a method.

### Refinement types: types that carry logical predicates
*Next, because once a type can be optional it can also say more — attach a predicate and let a solver check it.*

10. **Refinement Types for ML** — Freeman, Pfenning · PLDI 1991 · 10pp · [DOI](https://doi.org/10.1145/113445.113468) · [PDF](https://www.cs.cmu.edu/~fp/papers/pldi91.pdf). The origin: intersection-typed refinements of ML datatypes, decidable by construction.

11. **Liquid Types** — Rondon, Kawaguchi, Jhala · PLDI 2008 · 11pp · [DOI](https://doi.org/10.1145/1375581.1375602) · [PDF](https://goto.ucsd.edu/~rjhala/papers/liquid_types.pdf). Refinements restricted to an SMT-decidable logic *with inference* — the form that made refinement types usable at scale.
    - **Companion** — [Programming with Refinement Types](https://ucsd-progsys.github.io/liquidhaskell-tutorial/). The hands-on LiquidHaskell tutorial; the fastest way to feel what these types buy you.

12. **Refinement Types for Haskell** — Vazou, Seidel, Jhala, Vytiniotis, Peyton Jones · ICFP 2014 · 15pp · [DOI](https://doi.org/10.1145/2628136.2628161) · [PDF](https://goto.ucsd.edu/~rjhala/papers/refinement_types_for_haskell.pdf). Liquid types retrofitted onto a lazy, higher-order production language — LiquidHaskell.

13. **Refinement Types for TypeScript** — Vekris, Cosman, Jhala · PLDI 2016 · 16pp · [DOI](https://doi.org/10.1145/2908080.2908110) · [PDF](https://ranjitjhala.github.io/static/refinement_types_for_typescript.pdf). Liquid refinement carried into a real imperative, mutable-heap language, taming JavaScript idioms like value-based overloading and reflection.

### Dependent types, made practical
*Then, because refinement is dependency held back for decidability; here it is let out, but disciplined for real programs.*

14. **Simple Unification-based Type Inference for GADTs** — Peyton Jones, Vytiniotis, Weirich, Washburn · ICFP 2006 · 12pp · [DOI](https://doi.org/10.1145/1159803.1159811) · [PDF](https://www.cs.tufts.edu/comp/150FP/archive/simon-peyton-jones/gadt-icfp.pdf). Generalized algebraic data types let a constructor refine the type of the value it builds, so pattern matching recovers type equalities — the pragmatic foothold that brought dependently-typed idioms into mainstream Haskell, with inference that stays predictable.

15. **Eliminating Array Bound Checking Through Dependent Types** — Xi, Pfenning · PLDI 1998 · 9pp · [DOI](https://doi.org/10.1145/277650.277732) · [PDF](https://www.cs.cmu.edu/~fp/papers/pldi98dml.pdf). Dependent types earning their keep on a concrete optimization: proving array accesses safe and dropping the checks.

16. **Dependent Types in Practical Programming** — Xi, Pfenning · POPL 1999 · 14pp · [DOI](https://doi.org/10.1145/292540.292560) · [PDF](https://www.cs.cmu.edu/~fp/papers/popl99.pdf). Dependent ML: a restricted, *decidable* dependent-type discipline that keeps type checking practical.

17. **Towards a Practical Programming Language Based on Dependent Type Theory** — Norell · PhD thesis, Chalmers 2007 · 166pp · [PDF](https://www.cse.chalmers.se/~ulfn/papers/thesis.pdf). The design of Agda — full dependent types as a language you can actually program in.
    - **Companion** — [Propositions as Types](https://www.youtube.com/watch?v=IOiZatlZtGU) — Philip Wadler (Strange Loop). The Curry–Howard correspondence that makes "programs are proofs" more than a slogan; the intuition under every dependently-typed language.

### Linear, ownership & resource types
*Next, because the other axis of practicality is not richer values but tighter use — types that count how often, and in what state, a value may be touched.*

18. **Typestate: A Programming Language Concept for Enhancing Software Reliability** — Strom, Yemini · IEEE TSE 1986 · 15pp · [DOI](https://doi.org/10.1109/TSE.1986.6312929). The original idea that the operations a variable permits depend on its *state*, not just its type — so reading before initialization or using a resource after it is closed becomes a compile-time error. The ancestor of borrow-checking and protocol types.
    - **Companion** — [Typestate-Oriented Programming](https://www.cs.cmu.edu/~aldrich/papers/onward2009-state.pdf) — Aldrich, Sunshine, Saini, Sparks · Onward! 2009 · 8pp. Typestate revisited as a first-class language feature two decades on; the clearest modern motivation.

19. **Ownership Types for Flexible Alias Protection** — Clarke, Potter, Noble · OOPSLA 1998 · 17pp · [DOI](https://doi.org/10.1145/286936.286947) · [PDF](https://www.cs.cornell.edu/courses/cs711/2005fa/papers/cpn-oopsla98.pdf). Types that bound where references may escape — the aliasing discipline behind ownership in later languages.

20. **Linear Haskell** — Bernardy, Boespflug, Newton, Peyton Jones, Spiwack · POPL 2018 · 36pp · [DOI](https://doi.org/10.1145/3158093) · [PDF](https://arxiv.org/pdf/1710.09756). Retrofits linear types onto a mainstream language without splitting it in two — linearity as a property of function arrows.

21. **RustBelt: Securing the Foundations of the Rust Programming Language** — Jung, Jourdan, Krebbers, Dreyer · POPL 2018 · 34pp · [DOI](https://doi.org/10.1145/3158154) · [PDF](https://people.mpi-sws.org/~dreyer/papers/rustbelt/paper.pdf). The first rigorous soundness proof for Rust's ownership-and-borrowing type system, including its `unsafe` core.

### Session types: typing communication
*Then, because ownership disciplines *values*; session types apply the same idea to *conversations* — the sequence of messages on a channel.*

22. **Language Primitives and Type Discipline for Structured Communication** — Honda, Vasconcelos, Kubo · ESOP 1998 · 17pp · [DOI](https://doi.org/10.1007/BFb0053567) · [PDF](https://www.di.fc.ul.pt/~vv/papers/honda.vasconcelos.kubo_language-primitives.pdf). Foundational *binary* session types: a type describes the protocol a two-party channel must follow.

23. **Multiparty Asynchronous Session Types** — Honda, Yoshida, Carbone · POPL 2008 · 12pp · [DOI](https://doi.org/10.1145/1328438.1328472) · [PDF](https://www.doc.ic.ac.uk/~yoshida/multiparty/multiparty.pdf). Global protocol types projected onto each participant, so a whole multi-party interaction type-checks end to end.

### Effect systems in practice
*Next, because a type can say not only what a value *is* but what a computation *does* — the effects it may perform.*

24. **The Type and Effect Discipline** — Talpin, Jouvelot · Information and Computation 1994 · 52pp · [DOI](https://doi.org/10.1006/inco.1994.1046). The framework that reconstructs both a principal type *and* a minimal effect for implicitly typed programs.

25. **Handlers of Algebraic Effects** — Plotkin, Pretnar · ESOP 2009 · 15pp · [DOI](https://doi.org/10.1007/978-3-642-00590-9_7) · [PDF](https://homepages.inf.ed.ac.uk/gdp/publications/Effect_Handlers.pdf). Effect *handlers* — the exception-handler generalization that turned effect systems into a programming construct.
    - **Companion** — [An Introduction to Algebraic Effects and Handlers](https://www.eff-lang.org/handlers-tutorial.pdf) — Pretnar. A gentle, example-driven tutorial in the Eff language.

26. **Koka: Programming with Row-Polymorphic Effect Types** — Leijen · MSFP 2014 · 27pp · [arXiv](https://arxiv.org/abs/1406.2061) · [PDF](https://arxiv.org/pdf/1406.2061). A working language that infers effect *rows* and makes a function's latent effects part of its type.
    - **Companion** — [The Koka language](https://koka-lang.github.io/koka/doc/index.html). The living implementation, with a book-length tour of effect handlers you can run in the browser.

27. **Retrofitting Effect Handlers onto OCaml** — Sivaramakrishnan, Dolan, White, Jaffer, Kelly, Madhavapeddy · PLDI 2021 · 16pp · [DOI](https://doi.org/10.1145/3453483.3454039) · [PDF](https://kcsrk.info/papers/drafts/retro-concurrency.pdf). How algebraic effects became a production feature: OCaml 5's effect handlers, added to a decades-old language without breaking its runtime, and the substrate for its new concurrency.

### Information-flow & security types
*Then, because a type can also police *where* information travels — who may observe a value — turning confidentiality and integrity into a static discipline.*

28. **JFlow: Practical Mostly-Static Information Flow Control** — Myers · POPL 1999 · 17pp · [DOI](https://doi.org/10.1145/292540.292561) · [PDF](https://www.cs.cornell.edu/andru/papers/popl99/popl99.pdf). Security labels attached to data in a real Java extension (Jif), checked by the type system so secrets cannot leak to public outputs — information-flow control made usable.

29. **Information Flow Inference for ML** — Pottier, Simonet · POPL 2002 · 13pp · [DOI](https://doi.org/10.1145/503272.503302) · [PDF](http://cristal.inria.fr/~simonet/publis/fpottier-simonet-popl02.pdf). Information-flow security recast as type *inference* for an ML-like language (FlowCaml): the programmer writes ordinary code and the compiler infers the flow constraints, with a proof of noninterference.

### Where types stop: property-based testing
*Last, because no practical type system checks everything; property-based testing is the type-adjacent tool that covers the rest.*

30. **QuickCheck: A Lightweight Tool for Random Testing of Haskell Programs** — Claessen, Hughes · ICFP 2000 · 12pp · [DOI](https://doi.org/10.1145/351240.351266) · [PDF](https://www.cis.upenn.edu/~bcpierce/courses/552-2008/resources/icfp-quickcheck.pdf). Specifications written as typed properties, checked against generated inputs — the idea now copied into every major language.
    - **Companion** — [Testing the Hard Stuff and Staying Sane](https://www.youtube.com/watch?v=zi0rHwfiX1Q) — John Hughes. War stories on catching deep bugs in real (C and Erlang) systems with QuickCheck.

## Reference shelf — books

- **BUY** **Types and Programming Languages** — Benjamin C. Pierce · 2002 · 645pp · [page](https://mitpress.mit.edu/9780262162098/types-and-programming-languages/). The standard first text; the vocabulary and proof techniques this whole list assumes.
- **BUY** **Advanced Topics in Types and Programming Languages** — Benjamin C. Pierce (ed.) · 2005 · 589pp · [page](https://mitpress.mit.edu/9780262162289/advanced-topics-in-types-and-programming-languages/). Dependent types, effects, linearity, and more at research depth — the natural sequel to TAPL.
- **FREE** **Programming Language Foundations in Agda** — Wadler, Kokke, Siek · 2022 · [book](https://plfa.github.io/). Learn dependent types by building the metatheory in Agda; the hands-on companion to the DML and Agda entries above.
- **FREE** **The Rust Programming Language** — Klabnik, Nichols · 2023 · [book](https://doc.rust-lang.org/book/). Ownership and borrowing as a working programmer meets them — the practical face of RustBelt's theory.

## Key terms

- **gradual typing** — a type system where fully-typed, fully-untyped, and partially-typed code interoperate, with checks inserted at the boundaries.
- **consistency** — the relation (not transitive) that says two types *may* agree once the dynamic type `?` is allowed to match anything.
- **blame** — the runtime attribution of a boundary failure to the party that broke its contract; a sound system blames only the less-typed side.
- **occurrence typing** — refining a variable's type along a control-flow path from the tests the program already performs.
- **refinement type** — a base type paired with a logical predicate, e.g. `{v:Int | v > 0}`.
- **liquid type** — a refinement type restricted to an SMT-decidable logic so refinements can be *inferred*, not just checked.
- **dependent type** — a type that may mention program values, e.g. an array type indexed by its length.
- **GADT** — a generalized algebraic data type whose constructors constrain their result type, so pattern matching recovers type equalities.
- **linear type** — a type whose values must be used exactly once, enabling safe in-place update and manual resource handling.
- **typestate** — the set of operations a value permits in its current *state*, a refinement of its type; using a value outside a valid state is a static error.
- **ownership / borrowing** — a discipline that gives each value a unique owner and controls aliasing, so memory is freed without a garbage collector.
- **session type** — a type describing the protocol (message sequence and choices) a communication channel must follow.
- **effect system** — a type discipline that tracks the side effects (state, exceptions, IO) a computation may perform.
- **algebraic effect / handler** — effects given by operations whose meaning is supplied by an enclosing handler, generalizing exception handling.
- **information-flow type** — a type annotated with a security label that constrains where a value's information may flow.
- **noninterference** — the security property that public outputs do not depend on secret inputs.
- **property-based testing** — checking a typed logical property against many randomly generated inputs, shrinking any counterexample found.
