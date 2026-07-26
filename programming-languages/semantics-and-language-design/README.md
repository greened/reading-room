# Programming languages · Semantics & language design

What does a program *mean*? This guide follows the answers historically and
pedagogically: first a minimal model of computation and the earliest languages built
on it, then the three classical ways to pin meaning down — **operational** (how a
program runs), **denotational** (what it maps to mathematically), and **axiomatic**
(what you can prove about it) — then the ideas that language design grew from that
core: **type structure and polymorphism**, the **syntactic/reduction** methods that
dominate modern PL theory, **monads** for structuring effects, and finally **abstract
interpretation**, semantics reused as sound approximation. Read the sections in order;
within each, read top to bottom.

> **How to read this list.** You do not need all of it to start. Read Church and
> McCarthy for the roots, one paper from each of the three semantics styles
> (Plotkin, Scott–Strachey, Hoare), then jump to whichever line you care about —
> types, reduction semantics, or monads. The older denotational papers are the
> heaviest going; the operational and syntactic papers are the most directly useful
> if you build languages or compilers today.

## Reading order

### Foundations — computation, and the first languages
*Start at the roots: a minimal model of computation, and the languages that first took meaning seriously.*

1. **An Unsolvable Problem of Elementary Number Theory** — Alonzo Church · American J. of Mathematics 1936 · 19pp · [DOI](https://doi.org/10.2307/2371045) · [PDF](https://www.ics.uci.edu/~lopes/teaching/inf212W12/readings/church.pdf). Introduces the λ-calculus — the substitution-and-application model that every functional language and most semantics rest on.
   - **A Tutorial Introduction to the Lambda Calculus** — Raúl Rojas · [PDF](https://arxiv.org/pdf/1503.09060). Seventeen pages that get you from β-reduction to Church encodings and fixed points; read it first if the λ-calculus is new.

2. **Recursive Functions of Symbolic Expressions and Their Computation by Machine, Part I** — John McCarthy · CACM 1960 · 34pp · [DOI](https://doi.org/10.1145/367177.367199) · [PDF](https://www-formal.stanford.edu/jmc/recursive.pdf). Defined LISP and `eval` — a language whose interpreter is written in the language itself, launching functional programming.

3. **The Mechanical Evaluation of Expressions** — Peter J. Landin · Computer Journal 1964 · 13pp · [DOI](https://doi.org/10.1093/comjnl/6.4.308) · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Landin64.pdf). The SECD machine: the first precise abstract machine for evaluating expressions, the ancestor of every operational account of a functional language.

4. **The Next 700 Programming Languages** — Peter J. Landin · CACM 1966 · 10pp · [DOI](https://doi.org/10.1145/365230.365257) · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Landin66.pdf). Frames the whole family of languages around one small applicative core (ISWIM) — the case that syntax is sugar over a semantic kernel.

5. **Can Programming Be Liberated from the von Neumann Style?** — John Backus · CACM 1978 · 29pp · [DOI](https://doi.org/10.1145/359576.359579) · [PDF](https://worrydream.com/refs/Backus-CanProgrammingBeLiberated.pdf). Backus's Turing lecture: a manifesto for algebra-of-programs language design over word-at-a-time imperative code — read it for *why* you would choose a semantics.

### The three semantics styles — operational
*How a program runs, step by step: the style that dominates modern PL research and mechanized proofs.*

6. **A Structural Approach to Operational Semantics** — Gordon D. Plotkin · 1981 / JLAP 2004 · 134pp · [DOI](https://doi.org/10.1016/j.jlap.2004.05.001) · [PDF](https://homepages.inf.ed.ac.uk/gdp/publications/sos_jlap.pdf). The Aarhus lecture notes that founded structural operational semantics (SOS): meaning as inductively-defined transition rules over syntax. Long, but the source; sample the early chapters.

7. **Definitional Interpreters for Higher-Order Programming Languages** — John C. Reynolds · ACM Annual Conf. 1972 · 35pp · [DOI](https://doi.org/10.1145/800194.805852) · [PDF](https://www.cs.tufts.edu/~nr/cs257/archive/john-reynolds/definterps.pdf). Meta-circular vs. definitional interpreters, and *defunctionalization* — the bridge from an interpreter you can read to a machine you can implement.

### The three semantics styles — denotational
*What a program maps to as a mathematical object; the deepest and most demanding of the three.*

8. **Fundamental Concepts in Programming Languages** — Christopher Strachey · lectures 1967 / HOSC 2000 · 39pp · [DOI](https://doi.org/10.1023/A:1010000313106) · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Strachey67.pdf). The vocabulary the field still uses: l-values vs. r-values, first-class values, parametric vs. ad-hoc polymorphism. Read before the heavier denotational papers.

9. **Toward a Mathematical Semantics for Computer Languages** — Dana Scott & Christopher Strachey · Oxford PRG-6 1971 · 49pp · [PDF](https://www.cs.ox.ac.uk/files/3228/PRG06.pdf). The founding statement of denotational semantics: programs denote elements of domains, and recursion is a least fixed point.

10. **Continuations: A Mathematical Semantics for Handling Full Jumps** — Christopher Strachey & Christopher Wadsworth · Oxford PRG-11 1974 / HOSC 2000 · 18pp · [DOI](https://doi.org/10.1023/A:1010026413531). The denotational meaning of jumps and control via continuations — the concept that later reappears everywhere from compilers to `call/cc`.

### The three semantics styles — axiomatic
*Meaning as what you can prove: assertions and the pre/postcondition method.*

11. **An Axiomatic Basis for Computer Programming** — C. A. R. Hoare · CACM 1969 · 6pp · [DOI](https://doi.org/10.1145/363235.363259) · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Hoare69.pdf). Introduces Hoare logic and the `{P} C {Q}` triple — reasoning about programs as deduction, the root of program verification.

### Types, abstraction, and polymorphism
*Language design through type structure: universally-quantified types, inference, and the theorems types buy you.*

12. **Towards a Theory of Type Structure** — John C. Reynolds · Programming Symposium 1974 · 18pp · [DOI](https://doi.org/10.1007/3-540-06859-7_148) · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Reynolds74.pdf). The polymorphic (second-order) λ-calculus — System F — giving abstraction over types a precise semantics.

13. **A Theory of Type Polymorphism in Programming** — Robin Milner · JCSS 1978 · 28pp · [DOI](https://doi.org/10.1016/0022-0000(78)90014-4) · [PDF](https://homepages.inf.ed.ac.uk/wadler/papers/papers-we-love/milner-type-polymorphism.pdf). Let-polymorphism and the type-inference discipline behind ML, Haskell, and every language with inferred generics.

14. **Principal Type-Schemes for Functional Programs** — Luís Damas & Robin Milner · POPL 1982 · 7pp · [DOI](https://doi.org/10.1145/582153.582176) · [PDF](https://steshaw.org/hm/milner-damas.pdf). Algorithm W: proves inference finds a principal (most general) type, making Hindley–Milner practical.

15. **Types, Abstraction and Parametric Polymorphism** — John C. Reynolds · IFIP 1983 · 11pp · [PDF](https://people.mpi-sws.org/~dreyer/tor/papers/reynolds.pdf). Parametricity: a polymorphic function must behave *uniformly* at every type — the semantic meaning of "generic".

16. **Theorems for Free!** — Philip Wadler · FPCA 1989 · 13pp · [DOI](https://doi.org/10.1145/99370.99404) · [PDF](https://people.mpi-sws.org/~dreyer/tor/papers/wadler.pdf). Turns Reynolds's parametricity into free theorems you can read straight off a polymorphic type — the accessible way in.

17. **On Understanding Types, Data Abstraction, and Polymorphism** — Luca Cardelli & Peter Wegner · Computing Surveys 1985 · 42pp · [DOI](https://doi.org/10.1145/6041.6042) · [PDF](http://lucacardelli.name/Papers/OnUnderstanding.A4.pdf). The survey that organized the whole design space — universal vs. ad-hoc polymorphism, subtyping, abstraction — into one map.
   - **Propositions as Types** — Philip Wadler · [VIDEO](https://www.youtube.com/watch?v=IOiZatlZtGU). The Curry–Howard correspondence for a general audience: types are propositions, programs are proofs. A superb hour on why any of this matters.

### Reduction semantics and syntactic type soundness
*A purely syntactic account of evaluation, control, and state — and the soundness proof method it made routine.*

18. **The Syntactic Theories of Sequential Control and State** — Matthias Felleisen & Robert Hieb · TCS 1992 · 36pp · [DOI](https://doi.org/10.1016/0304-3975(92)90014-7) · [PDF](https://www2.ccs.neu.edu/racket/pubs/tcs92-fh.pdf). Evaluation contexts and reduction semantics: a calculus for control and mutable state without leaving the syntax.

19. **On the Expressive Power of Programming Languages** — Matthias Felleisen · SCP 1991 · 45pp · [DOI](https://doi.org/10.1016/0167-6423(91)90036-W) · [PDF](https://www2.ccs.neu.edu/racket/pubs/scp91-felleisen.pdf). A formal definition of what it means for one language feature to be "more expressive" than another — macro-expressibility, via the same reduction machinery.

20. **A Syntactic Approach to Type Soundness** — Andrew K. Wright & Matthias Felleisen · Information and Computation 1994 · 57pp · [DOI](https://doi.org/10.1006/inco.1994.1093). Progress-and-preservation: the standard, teachable recipe for proving a type system sound, built directly on reduction semantics.

### Structuring meaning — monads and modular semantics
*Once meaning is compositional, structure the effects: monads unify state, exceptions, and I/O and let semantics be assembled from parts.*

21. **Notions of Computation and Monads** — Eugenio Moggi · Information and Computation 1991 · 29pp · [DOI](https://doi.org/10.1016/0890-5401(91)90052-4) · [PDF](https://person.dibris.unige.it/moggi-eugenio/ftp/ic91.pdf). The insight that "a computation producing an A" is a monad — one abstraction covering state, exceptions, continuations, and nondeterminism.

22. **The Essence of Functional Programming** — Philip Wadler · POPL 1992 · 14pp · [DOI](https://doi.org/10.1145/143165.143169). Brings Moggi's monads down to earth as a programming technique for structuring interpreters and effects — no category theory required.
   - **Monads for Functional Programming** — Philip Wadler · [PDF](https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf). Wadler's open, tutorial-length treatment of the same material; the best free entry point to monads.

23. **Imperative Functional Programming** — Simon Peyton Jones & Philip Wadler · POPL 1993 · 15pp · [DOI](https://doi.org/10.1145/158511.158524) · [PDF](https://www.cs.tufts.edu/~nr/cs257/archive/simon-peyton-jones/imperative.pdf). Monadic I/O: how a pure language does real side effects without losing referential transparency — the design that shipped in Haskell.

24. **Monad Transformers and Modular Interpreters** — Sheng Liang, Paul Hudak & Mark Jones · POPL 1995 · 42pp · [DOI](https://doi.org/10.1145/199448.199528) · [PDF](http://cs.yale.edu/publications/techreports/tr1109.pdf). Builds a language's semantics by stacking feature modules (state, exceptions, continuations) as monad transformers — modular denotational semantics in practice.

### Semantics as approximation
*Reuse a language's semantics as a sound over-approximation — the theory under every static analyzer.*

25. **Abstract Interpretation: A Unified Lattice Model for Static Analysis** — Patrick & Radhia Cousot · POPL 1977 · 15pp · [DOI](https://doi.org/10.1145/512950.512973) · [PDF](https://www.di.ens.fr/~cousot/publications.www/CousotCousot-POPL-77-ACM-p238--252-1977.pdf). The lattice / Galois-connection theory that makes an analysis provably sound with respect to the language's semantics.

## Reference shelf — books

- **FREE** **Structure and Interpretation of Computer Programs** — Harold Abelson & Gerald Jay Sussman · 2nd ed. 1996 · 657pp · [PDF](https://web.mit.edu/6.001/6.037/sicp.pdf). Learn semantics by writing evaluators; the metacircular evaluator makes McCarthy's `eval` concrete.
- **FREE** **Programming Languages: Application and Interpretation** — Shriram Krishnamurthi · 2007 · 231pp · [PDF](https://www.plai.org/3/2/PLAI%20Version%203.2.2%20electronic.pdf). Builds interpreters that *are* the semantics — state, control, and types, one feature at a time.
- **BUY** **Types and Programming Languages** — Benjamin C. Pierce · 2002 · 645pp · [page](https://mitpress.mit.edu/9780262162098/). The standard modern text for operational semantics, type systems, and syntactic soundness proofs.
- **BUY** **Formal Semantics of Programming Languages** — Glynn Winskel · 1993 · 384pp · [page](https://mitpress.mit.edu/9780262731034/). The operational / denotational / axiomatic groundwork, worked through carefully.
- **BUY** **Practical Foundations for Programming Languages** — Robert Harper · 2nd ed. 2016 · 512pp · [page](https://www.cs.cmu.edu/~rwh/pfpl.html). A uniform, judgement-based development of statics and dynamics across a wide range of language features.

## Key terms

- **operational semantics** — meaning given by rules describing how a program executes, step by step (small-step / SOS) or as a whole (big-step).
- **denotational semantics** — meaning given by mapping each program to a mathematical object (an element of a domain).
- **axiomatic semantics** — meaning given by the assertions provable about a program, as in Hoare logic.
- **domain** — a partially ordered set with limits, used to give meaning to recursion as a least fixed point.
- **continuation** — a first-class representation of "the rest of the computation", used to model jumps and control.
- **parametric polymorphism** — one definition usable at many types, behaving uniformly across all of them (System F, ML generics).
- **parametricity** — the property that a polymorphic program cannot inspect the types it is instantiated at, yielding "free theorems".
- **evaluation context** — a program with a hole marking where the next reduction step happens; the core device of reduction semantics.
- **progress & preservation** — the two lemmas of a syntactic type-soundness proof: well-typed terms don't get stuck, and stay well-typed as they reduce.
- **monad** — an abstraction packaging a notion of computation (state, exceptions, I/O) so effects compose and can be added modularly.
- **abstract interpretation** — sound approximation of a program's semantics over an abstract domain, connected to the concrete one by a Galois connection.
</content>
