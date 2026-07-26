# Programming languages · Monads & algebraic effects

How do you do input, state, and exceptions in a language that forbids side effects?
Two answers dominate. *Monads* thread the effect through the types, one layer at a
time; *algebraic effects and handlers* name the operations and let a surrounding
handler decide what they mean. The papers below walk that arc: start with Wadler's
gentle case for monads, drop down to Moggi's semantics that justifies them, watch
monads reach real languages and learn to compose, meet the weaker and stronger
relatives (applicative functors, arrows), then follow the algebraic-effects line from
Plotkin and Power's theory to the handlers, languages, and libraries in use today.

## Reading order

### Why monads — structuring effects in a pure language
*Start with the programming problem monads solve, in Wadler's own unhurried exposition.*

1. **Comprehending Monads** — Philip Wadler · LFP 1990 · 19pp · [DOI](https://doi.org/10.1145/91556.91592) · [PDF](https://plv.mpi-sws.org/plerg/papers/comprehending-monads.pdf). Brings Moggi's monads into practical programming, framed through list comprehensions — the friendliest possible entry point.

2. **The Essence of Functional Programming** — Philip Wadler · POPL 1992 · 14pp · [DOI](https://doi.org/10.1145/143165.143169) · [PDF](https://www.st.cs.uni-saarland.de/edu/seminare/2005/advanced-fp/docs/wadler-essence-fp.pdf). Structures one interpreter many ways — state, exceptions, continuations — each as a monad, showing monads as a practical structuring device.

3. **Monads for functional programming** — Philip Wadler · Advanced Functional Programming (LNCS 925) 1995 · 31pp · [DOI](https://doi.org/10.1007/3-540-59451-5_2) · [PDF](https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf). The definitive tutorial; if any single paper makes monads click, it is this one.
   - **You Could Have Invented Monads!** — [blog](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html). Dan Piponi derives the monad interface from the need to compose "debuggable" functions — the best short companion to Wadler.

### The semantic foundation
*Where monads came from: Moggi's categorical account of what a "notion of computation" is.*

4. **Notions of Computation and Monads** — Eugenio Moggi · Information and Computation 1991 · 29pp · [DOI](https://doi.org/10.1016/0890-5401(91)90052-4) · [PDF](https://person.dibris.unige.it/moggi-eugenio/ftp/ic91.pdf). The origin: a monad is a model of a notion of computation, and effectful programs are Kleisli arrows. Read after Wadler so the categorical machinery has something concrete to attach to.

### Monads reach real languages
*From theory to Haskell: monadic I/O, and how to combine more than one effect at once.*

5. **Imperative Functional Programming** — Simon Peyton Jones, Philip Wadler · POPL 1993 · 15pp · [DOI](https://doi.org/10.1145/158511.158524) · [PDF](https://www.microsoft.com/en-us/research/wp-content/uploads/1993/01/imperative.pdf). Monadic I/O: how a pure language does genuine imperative computation without cheating. This is the design that shipped in Haskell.
   - **Tackling the Awkward Squad** — [PDF](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/mark.pdf). Peyton Jones' 46pp lecture notes on I/O, concurrency, exceptions, and FFI in a pure language — the practitioner's follow-through.

6. **Monad Transformers and Modular Interpreters** — Sheng Liang, Paul Hudak, Mark Jones · POPL 1995 · 11pp · [DOI](https://doi.org/10.1145/199448.199528) · [PDF](https://web.engr.oregonstate.edu/~walkiner/teaching/cs583-sp21/files/Liang-MonadTransformers.pdf). Stacking effects: build a monad from reusable transformer layers. The standard answer to "how do I use two effects at once" — and the pain point algebraic effects later set out to fix.

### Beyond monads — weaker and stronger relatives
*Two abstractions on either side of the monad: applicatives ask for less, arrows offer more.*

7. **Applicative Programming with Effects** — Conor McBride, Ross Paterson · JFP 2008 · 12pp · [DOI](https://doi.org/10.1017/S0956796807006326) · [PDF](https://www.staff.city.ac.uk/~ross/papers/Applicative.pdf). The applicative functor: weaker than a monad (no data-dependent sequencing) but more composable, and the right tool for effects whose structure is fixed in advance.

8. **Generalising Monads to Arrows** — John Hughes · Science of Computer Programming 2000 · 41pp · [DOI](https://doi.org/10.1016/S0167-6423(99)00023-4) · [PDF](https://www.cse.chalmers.se/~rjmh/Papers/arrows.pdf). Arrows abstract computations that a monad can't quite capture — static analysis of pipelines, dataflow, parsers. The other direction from applicatives.

### Algebraic effects and handlers
*The modern reframing: effects are operations of an algebraic theory, handlers are their interpreters.*

9. **Algebraic Operations and Generic Effects** — Gordon Plotkin, John Power · Applied Categorical Structures 2003 · 26pp · [DOI](https://doi.org/10.1023/A:1023064908962) · [PDF](https://homepages.inf.ed.ac.uk/gdp/publications/alg_ops_gen_effects.pdf). The theory: rather than take monads as given, present effects as operations satisfying equations. This is the foundation the whole algebraic-effects line rests on.
   - **What's Algebraic About Algebraic Effects and Handlers?** — [VIDEO](https://www.youtube.com/watch?v=atYp386EGo8). Andrej Bauer (OPLSS 2018) explains the algebra with almost no category theory; watch before wading into the paper. Companion notes: [arXiv 1807.05923](https://arxiv.org/abs/1807.05923).

10. **Handlers of Algebraic Effects** — Gordon Plotkin, Matija Pretnar · ESOP 2009 · 15pp · [DOI](https://doi.org/10.1007/978-3-642-00590-9_7) · [PDF](https://homepages.inf.ed.ac.uk/gdp/publications/Effect_Handlers.pdf). Handlers: a control construct that interprets the operations of #9, generalising exception handling to *any* effect. The pivot from theory to a usable programming feature.

### Effects in practice — languages and libraries
*How handlers became something you can program with: dedicated languages, row-typed effect systems, and library encodings.*

11. **Programming with Algebraic Effects and Handlers (Eff)** — Andrej Bauer, Matija Pretnar · JLAMP 2015 · 25pp · [DOI](https://doi.org/10.1016/j.jlamp.2014.02.001) · [PDF](https://arxiv.org/pdf/1203.1539). The Eff language: what it feels like to write real programs with algebraic effects and handlers.

12. **Koka: Programming with Row Polymorphic Effect Types** — Daan Leijen · MSFP 2014 · 27pp · [DOI](https://doi.org/10.4204/EPTCS.153.8) · [PDF](https://arxiv.org/pdf/1406.2061). Puts effects in the type system with row polymorphism, so a function's type states exactly which effects it may perform. The type-and-effect answer to the same problem.

13. **Data Types à la Carte** — Wouter Swierstra · JFP 2008 · 14pp · [DOI](https://doi.org/10.1017/S0956796808006758) · [PDF](https://webspace.science.uu.nl/~swier004/publications/2008-jfp.pdf). Free monads over composable signature functors — the technique behind combining effects as data, and the conceptual bridge to library-level effect systems.

14. **Extensible Effects: An Alternative to Monad Transformers** — Oleg Kiselyov, Amr Sabry, Cameron Swords · Haskell Symposium 2013 · 12pp · [DOI](https://doi.org/10.1145/2503778.2503791) · [PDF](https://okmij.org/ftp/Haskell/extensible/exteff.pdf). Effects as an open union interpreted by handlers, in a plain Haskell library — algebraic effects meeting monad transformers on the transformers' home turf.

## Reference shelf — books

- **FREE** **Category Theory for Programmers** — Bartosz Milewski · 2019 · 498pp · [PDF](https://github.com/hmemcpy/milewski-ctfp-pdf/releases/download/v1.3.0/category-theory-for-programmers.pdf). Functors, natural transformations, and monads from the categorical side, written for programmers — the background Moggi and Plotkin–Power assume.
- **BUY** **Programming in Haskell (2nd ed.)** — Graham Hutton · 2016 · 320pp · [page](https://www.cambridge.org/core/books/programming-in-haskell/8FED82E807EF4D5B57DA0DB02BA004F9). Chapters 12–14 are the gentlest hands-on path through functors, applicatives, and monads before you hit the papers.
