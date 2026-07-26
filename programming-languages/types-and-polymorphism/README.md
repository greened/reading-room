# Programming languages · Types, polymorphism & abstraction

A type system is a lightweight proof that a program can't go wrong, and the whole
subject is a search for how much of that proof a compiler can supply on its own. This
guide follows one path: start where types touch everyday code — automatic inference in
the ML tradition — then climb to the calculus underneath it (System F and parametric
polymorphism), see how the same machinery explains data abstraction, cover the *other*
polymorphism (overloading, via type classes), add subtyping and bounded quantification,
push types to their logical limit with dependent types and Curry-Howard, and finish with
the practical inference tricks real compilers use once Hindley-Milner's guarantees break.

> **Three kinds of polymorphism.** Christopher Strachey's old split, sharpened by
> Cardelli and Wegner, is the map for this whole list. *Parametric* polymorphism (one
> definition, uniform over all types — System F, ML generics), *ad-hoc* polymorphism
> (one name, different code per type — overloading, type classes), and *subtype*
> polymorphism (a value of one type usable where another is expected). Read the intro
> paragraph first, then take the sections in order; each builds vocabulary the next one
> assumes. Foundations come first on purpose, but the ordering is pedagogical, not
> chronological.

### Type inference and the ML tradition
*Start where types meet everyday programming: inferring them automatically, so the programmer rarely writes one down.*
1. **The Principal Type-Scheme of an Object in Combinatory Logic** — J. Roger Hindley · Trans. AMS 1969 · 32pp · [DOI](https://doi.org/10.2307/1995158). The origin of the *principal type* — every typable term has a single most-general type that all its types are instances of. The "H" in Hindley-Milner; paywalled, so a DOI only.
2. **A Theory of Type Polymorphism in Programming** — Robin Milner · JCSS 1978 · 28pp · [DOI](https://doi.org/10.1016/0022-0000(78)90014-4) · [PDF](https://homepages.inf.ed.ac.uk/wadler/papers/papers-we-love/milner-type-polymorphism.pdf). Let-polymorphism and Algorithm W: rediscovers principal types for a real language and proves that well-typed programs don't go wrong.
3. **Principal Type-Schemes for Functional Programs** — Luís Damas, Robin Milner · POPL 1982 · 6pp · [DOI](https://doi.org/10.1145/582153.582176) · [PDF](https://steshaw.org/hm/milner-damas.pdf). The tight, formal statement of the Hindley-Milner system, with soundness and completeness of inference — the paper everyone cites.
4. **Basic Polymorphic Typechecking** — Luca Cardelli · Sci. Comput. Program. 1987 · 29pp · [DOI](https://doi.org/10.1016/0167-6423(87)90019-0) · [PDF](http://lucacardelli.name/Papers/BasicTypechecking.pdf). How to actually *build* a Hindley-Milner checker — unification, the occurs check, generalization — with running code. Read it right after the theory to make the algorithm concrete.

### Parametric polymorphism and System F
*The calculus behind "one definition, uniform over every type," and what quantifying over types actually buys you.*
5. **Interprétation fonctionnelle et élimination des coupures (System F)** — Jean-Yves Girard · Thèse d'État, Paris VII 1972 · 230pp · [PDF](http://girard.perso.math.cnrs.fr/These.pdf). The birth of the second-order (polymorphic) lambda calculus, invented for proof theory, with the reducibility method that proves it terminating. In French; use the companion below as the English gateway.
   - **Proofs and Types** — Girard, Lafont, Taylor · [PDF](http://www.paultaylor.eu/stable/prot.pdf). The standard English text on System F and the Curry-Howard view — the accessible way in.
6. **Towards a Theory of Type Structure** — John C. Reynolds · Programming Symposium (LNCS 19) 1974 · 18pp · [DOI](https://doi.org/10.1007/3-540-06859-7_148) · [PDF](https://www.cis.upenn.edu/~stevez/cis670/pdfs/Reynolds74.pdf). System F, discovered independently from a programming-language angle, with the representation-independence intuition that later became parametricity.
7. **Types, Abstraction and Parametric Polymorphism** — John C. Reynolds · IFIP Information Processing 1983 · 11pp · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Reynolds83.pdf). Makes "parametric" precise: a polymorphic function must act *uniformly*, formalized by relations preserved across types — the abstraction theorem.
8. **Theorems for Free!** — Philip Wadler · FPCA 1989 · 13pp · [DOI](https://doi.org/10.1145/99370.99404) · [PDF](https://people.mpi-sws.org/~dreyer/tor/papers/wadler.pdf). Turns Reynolds's parametricity into a cookbook: a function's *type alone* implies theorems about it. The payoff of the previous paper, in one sitting.

### Data abstraction and existential types
*The mirror image of universal quantification: hiding a type is exactly quantifying over it existentially — this is what modules and abstract data types mean.*
9. **On Understanding Types, Data Abstraction, and Polymorphism** — Luca Cardelli, Peter Wegner · ACM Comput. Surv. 1985 · 42pp · [DOI](https://doi.org/10.1145/6041.6042) · [PDF](http://lucacardelli.name/Papers/OnUnderstanding.A4.pdf). The synthesis that organizes the whole field — universal vs. existential quantification, subtyping, and bounded quantification, all in the Fun calculus. The map for everything below.
10. **Abstract Types Have Existential Type** — John C. Mitchell, Gordon Plotkin · ACM TOPLAS 1988 · 33pp · [DOI](https://doi.org/10.1145/44501.45065) · [PDF](https://theory.stanford.edu/~jcm/papers/mitch-plotkin-88.pdf). The precise result: an abstract data type is an existential type, `pack`/`open` its introduction and elimination — the type-theoretic foundation of modules.

### Ad-hoc polymorphism done principledly
*The other polymorphism: resolving an operation by the type it is used at, and how Haskell turned unruly overloading into something with a semantics.*
11. **How to Make ad-hoc Polymorphism Less ad hoc** — Philip Wadler, Stephen Blott · POPL 1989 · 17pp · [DOI](https://doi.org/10.1145/75277.75283) · [PDF](https://people.csail.mit.edu/dnj/teaching/6898/papers/wadler88.pdf). Introduces *type classes* and the dictionary-passing translation — overloading with a principled type system and a compilation story.
12. **A System of Constructor Classes** — Mark P. Jones · FPCA 1993 · 10pp · [DOI](https://doi.org/10.1145/165180.165190) · [PDF](https://web.cecs.pdx.edu/~mpj/pubs/fpca93.pdf). Lifts type classes to type constructors, giving `Functor` and `Monad` their types — the step that made the class system genuinely higher-order.

### Subtyping and bounded quantification
*Types related by inclusion, driven by object-oriented needs — and where the theory runs into its decidability limits.*
13. **F-Bounded Polymorphism for Object-Oriented Programming** — Canning, Cook, Hill, Olthoff, Mitchell · FPCA 1989 · 8pp · [DOI](https://doi.org/10.1145/99370.99392) · [PDF](https://www.cs.utexas.edu/~wcook/papers/FBound89/CookFBound89.pdf). Bounds a type variable by a type that mentions the variable itself — the pattern behind recursive generic interfaces (Java's `<T extends Comparable<T>>`).
14. **An Extension of System F with Subtyping (F-sub)** — Cardelli, Martini, Mitchell, Scedrov · Inf. Comput. 1994 · 44pp · [DOI](https://doi.org/10.1006/inco.1994.1013) · [PDF](http://lucacardelli.name/Papers/FSub.A4.pdf). The canonical calculus combining parametric polymorphism with subtyping, plus its equational theory — the workhorse model for typed object-oriented languages.
15. **Bounded Quantification is Undecidable** — Benjamin C. Pierce · Inf. Comput. 1994 · 35pp · [DOI](https://doi.org/10.1145/143165.143228). The sharp negative result: subtype checking in full F-sub is undecidable, which is *why* real languages restrict it. A DOI only — no legal open copy.

### Dependent types and the Curry-Howard correspondence
*Push types to their logical limit: propositions as types, proofs as programs — the road to Coq, Agda, and modern proof assistants.*
16. **The Formulae-as-Types Notion of Construction** — William A. Howard · 1980 (circulated 1969) · 12pp · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Howard80.pdf). The Curry-Howard correspondence written down: propositions are types, proofs are terms, proof normalization is evaluation.
   - **Propositions as Types** — Philip Wadler · [VIDEO](https://www.youtube.com/watch?v=IOiZatlZtGU). A superb hour-long talk that makes the correspondence click before you read the primary sources.
17. **Intuitionistic Type Theory** — Per Martin-Löf · Bibliopolis 1984 (Padua lectures) · 57pp · [PDF](https://raw.githubusercontent.com/michaelt/martin-lof/master/pdfs/Bibliopolis-Book-retypeset-1984.pdf). The type theory where types may depend on values, with dependent products and sums — the foundation Agda, Coq, and Lean all descend from.
18. **The Calculus of Constructions** — Thierry Coquand, Gérard Huet · Inf. Comput. 1988 · 26pp · [DOI](https://doi.org/10.1016/0890-5401(88)90005-3). Unifies polymorphism and dependent types in one calculus at the top of the lambda cube — the theory Coq is built on. Paywalled, so a DOI only.

### Practical inference beyond ML: higher-rank, local, bidirectional
*How real compilers keep inference usable once first-class polymorphism, subtyping, and GADTs break Hindley-Milner's completeness.*
19. **Putting Type Annotations to Work** — Martin Odersky, Konstantin Läufer · POPL 1996 · 14pp · [DOI](https://doi.org/10.1145/237721.237729) · [PDF](https://publikationen.bibliothek.kit.edu/44298/776748). Extends Hindley-Milner with explicit higher-rank annotations, so polymorphic arguments can be typed where full inference is impossible — the algorithm GHC still uses.
20. **Local Type Inference** — Benjamin C. Pierce, David N. Turner · ACM TOPLAS 2000 · 44pp · [DOI](https://doi.org/10.1145/345099.345100) · [PDF](https://www.cis.upenn.edu/~bcpierce/papers/lti-toplas.pdf). Inference that flows types only between adjacent nodes, for languages with subtyping and explicit polymorphism where global inference is undecidable.
21. **Practical Type Inference for Arbitrary-Rank Types** — Peyton Jones, Vytiniotis, Weirich, Shields · JFP 2007 · 82pp · [DOI](https://doi.org/10.1017/S0956796806006034) · [PDF](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/putting.pdf). The thorough, implementation-oriented account of higher-rank inference — bidirectional propagation and subsumption — worked out for a real compiler.
22. **Complete and Easy Bidirectional Typechecking for Higher-Rank Polymorphism** — Jana Dunfield, Neelakantan Krishnaswami · ICFP 2013 · 14pp · [DOI](https://doi.org/10.1145/2500365.2500582) · [PDF](https://arxiv.org/pdf/1306.6032). The clean, teachable bidirectional algorithm — sound, complete, decidable — that most modern implementations start from. The PDF is the extended version with full proofs.
23. **OutsideIn(X): Modular Type Inference with Local Assumptions** — Vytiniotis, Peyton Jones, Schrijvers, Sulzmann · JFP 2011 · 80pp · [DOI](https://doi.org/10.1017/S0956796811000098) · [PDF](https://simon.peytonjones.org/assets/pdfs/outsideinx.pdf). GHC's inference engine for GADTs and type families: how to stay principled when local equality assumptions make naive generalization unsound.

<!--html-->
<div class="why">
<b>One idea, three faces.</b> Universal quantification (<em>∀</em>) is parametric
polymorphism — a term that works uniformly at every type (System F, ML generics).
Existential quantification (<em>∃</em>) is data abstraction — a package that hides which
type it uses (modules, ADTs). Bounded quantification (<em>∀ X &lt;: T</em>) marries
polymorphism to subtyping — a term uniform over every <em>subtype</em> of a bound. The
same quantifier machinery, read three ways, organizes almost everything on this list;
the practical-inference section is the long tail of making it decidable in a compiler.
</div>
<!--/html-->

## Reference shelf — books

- **BUY** **Types and Programming Languages** — Benjamin C. Pierce · 2002 · 623pp · [page](https://www.cis.upenn.edu/~bcpierce/tapl/). The standard graduate text; the single book that ties inference, System F, subtyping, and existentials together.
- **BUY** **Advanced Topics in Types and Programming Languages** — Benjamin C. Pierce (ed.) · 2005 · 574pp · [page](https://www.cis.upenn.edu/~bcpierce/attapl/). The follow-on volume — dependent types, F-sub metatheory, type inference — one chapter per topic.
- **FREE** **Practical Foundations for Programming Languages** — Robert Harper · 2016 · 512pp · [page](https://www.cs.cmu.edu/~rwh/pfpl.html). A modern, uniform treatment built on judgments and rules; the second edition's draft is free from the author's page.
- **FREE** **Software Foundations (Vol. 2: Programming Language Foundations)** — Pierce et al. · [book](https://softwarefoundations.cis.upenn.edu/). Type systems and their soundness proofs, mechanized in Coq — the hands-on complement to the papers above.

## Key terms

- **principal type** — the single most-general type of a term, of which all its other types are instances.
- **let-polymorphism** — Hindley-Milner's rule that generalizes a type only at `let` bindings, keeping inference decidable.
- **parametric polymorphism** — one definition that behaves uniformly across all types (System F, ML generics).
- **ad-hoc polymorphism** — one name, different implementations chosen by type (overloading, type classes).
- **subtype polymorphism** — using a value of one type wherever a supertype is expected.
- **System F** — the second-order lambda calculus: types may quantify universally over types (`∀X. …`).
- **universal type** — `∀X. T`, a value usable at every instantiation of `X`; the type of a parametric term.
- **existential type** — `∃X. T`, a package that hides a concrete type; the type of an abstract data type or module.
- **bounded quantification** — quantifying over all subtypes of a bound (`∀ X <: T. …`).
- **F-bounded polymorphism** — a bound that mentions the quantified variable itself (`X <: F[X]`).
- **parametricity** — the theorem that a parametric term respects relations across types, yielding "free theorems."
- **Curry-Howard correspondence** — propositions are types, proofs are programs, proof normalization is evaluation.
- **dependent type** — a type that may mention (depend on) a value, e.g. `Vector n`.
- **higher-rank type** — a type with `∀` to the left of an arrow, so a function may take a polymorphic argument.
- **bidirectional typing** — splitting the checker into a *checking* mode (type given) and a *synthesis* mode (type inferred), so annotations are needed only where inference can't decide.
- **predicative / impredicative** — whether a quantified variable may be instantiated with a type that itself contains quantifiers; impredicative instantiation makes full inference undecidable.
- **dictionary-passing** — compiling type classes by passing a record of the overloaded operations as a hidden argument.
