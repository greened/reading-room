# Programming languages · Program logics & verified systems

How do you *prove* a program does what its specification says? This list follows that
question from its origins to industrial-scale proofs. Start with the foundations that
say what a program even *means* as a logical object (Floyd, Hoare, Dijkstra), pause on
the classic objection that such proofs can never be socially trusted, then watch the
logic grow to handle the two things that break naive Hoare logic — concurrency and the
mutable heap. Separation logic tames aliasing; a decade of concurrent logics (RGSep,
abstract predicates, Views) then converges on Iris. The last two stretches turn logic
into *tools* (proof-carrying code, Dafny, VeriFast, VST) and then into whole verified
systems (seL4, CertiKOS, CompCert, CakeML, RustBelt).

> **How to read this list.** Read the first three in order — they build one idea:
> a program is a predicate transformer, and correctness is a proof about assertions.
> Read De Millo–Lipton–Perlis next as the counterpoint that every later paper is
> implicitly answering. From there the sections are roughly chronological *and*
> conceptual: concurrency first exposes the limits of Hoare logic, separation logic
> repairs them, a decade of concurrent logics converges on Iris, and the tools and
> systems sections show the ideas paying off.

## Reading order

### Foundations — what does it mean to prove a program correct?
*The three papers that turned "the program works" into a mathematical statement; read them in order.*

1. **Assigning Meanings to Programs** — Robert W. Floyd · Symp. Applied Math. 1967 · 14pp · [PDF](https://people.eecs.berkeley.edu/~necula/Papers/FloydMeaning.pdf). Attaches assertions to the edges of a flowchart and proves they are preserved — the first real method for proving a program correct.

2. **An Axiomatic Basis for Computer Programming** — C. A. R. Hoare · CACM 1969 · 6pp · [DOI](https://doi.org/10.1145/363235.363259) · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Hoare69.pdf). The Hoare triple `{P} C {Q}` and the inference rules for it — the grammar every later program logic extends.
   - **Software Foundations, Vol. 2 (Programming Language Foundations)** — [book](https://softwarefoundations.cis.upenn.edu/plf-current/). Hoare logic built up mechanically in Coq, with exercises; the gentlest hands-on companion to this paper.

3. **Guarded Commands, Nondeterminacy and Formal Derivation of Programs** — Edsger W. Dijkstra · CACM 1975 · 15pp · [DOI](https://doi.org/10.1145/360933.360975) · [PDF](https://www.cs.utexas.edu/users/EWD/ewd04xx/EWD472.PDF). Weakest-precondition predicate transformers plus guarded commands — proofs run *backwards* from the postcondition, and correctness drives program construction.

### The counterpoint
*Read this before the machine-checked papers: it is the objection they answer.*

4. **Social Processes and Proofs of Theorems and Programs** — De Millo, Lipton, Perlis · CACM 1979 · 10pp · [DOI](https://doi.org/10.1145/359104.359106) · [PDF](https://www.cs.umd.edu/~gasarch/BLOGPAPERS/social.pdf). The famous argument that program proofs, unlike mathematical ones, get no social vetting and so cannot be trusted — the challenge that mechanized proof (seL4, CompCert) was later built to meet.

### Concurrency breaks naive Hoare logic
*Shared state defeats the sequential rules; these two papers are the first repairs.*

5. **An Axiomatic Proof Technique for Parallel Programs I** — Susan Owicki, David Gries · Acta Informatica 1976 · 22pp · [DOI](https://doi.org/10.1007/BF00268134). Extends Hoare logic to shared-variable concurrency via *interference freedom* — every thread's proof must survive every other thread's steps.

6. **Tentative Steps Toward a Development Method for Interfering Programs** — Cliff B. Jones · ACM TOPLAS 1983 · 24pp · [DOI](https://doi.org/10.1145/69575.69577). Introduces *rely/guarantee*: summarize what a thread assumes about interference and what it promises, so threads can be verified compositionally instead of pairwise.

### Separation logic — reasoning locally about the heap
*Aliasing is what really breaks Hoare logic; separation logic's frame rule fixes it, then scales to concurrency.*

7. **Local Reasoning about Programs that Alter Data Structures** — O'Hearn, Reynolds, Yang · CSL 2001 · 19pp · [DOI](https://doi.org/10.1007/3-540-44802-0_1) · [PDF](http://www0.cs.ucl.ac.uk/staff/p.ohearn/papers/localreasoning.pdf). The frame rule and the idea that a proof should mention only the cells a command actually touches — start here for separation logic.

8. **Separation Logic: A Logic for Shared Mutable Data Structures** — John C. Reynolds · LICS 2002 · 20pp · [DOI](https://doi.org/10.1109/LICS.2002.1029817) · [PDF](https://www.cs.cmu.edu/~jcr/seplogic.pdf). The definitive exposition: separating conjunction, the points-to assertion, and inductive predicates for lists and trees.

9. **Resources, Concurrency, and Local Reasoning** — Peter W. O'Hearn · TCS 2007 · 19pp · [DOI](https://doi.org/10.1016/j.tcs.2006.12.035) · [PDF](http://www0.cs.ucl.ac.uk/staff/p.ohearn/papers/concur04.pdf). Concurrent separation logic: ownership of heap can be transferred between threads, so races and resource protocols become provable facts.
   - **A Semantics for Concurrent Separation Logic** — Stephen Brookes · TCS 2007 · 80pp · [PDF](https://www.cs.cmu.edu/~brookes/papers/seplogicrevisedfinal.pdf). The soundness model that made O'Hearn's logic trustworthy; the two shared the 2016 Gödel Prize.

### Marrying rely/guarantee and separation — a decade of concurrent logics
*The decade Iris later distills: each paper adds one mechanism — a local/shared split, transferable permissions for fork/join, abstract predicates, and finally a single framework they all instantiate.*

10. **A Marriage of Rely/Guarantee and Separation Logic (RGSep)** — Viktor Vafeiadis, Matthew Parkinson · CONCUR 2007 · 16pp · [DOI](https://doi.org/10.1007/978-3-540-74407-8_18) · [PDF](https://people.mpi-sws.org/~viktor/papers/concur2007-marriage.pdf). Splits state into thread-local and shared, using the frame rule on each and rely/guarantee across the boundary — the first clean marriage of interference reasoning with separation logic.

11. **Deny-Guarantee Reasoning** — Mike Dodds, Xinyu Feng, Matthew Parkinson, Viktor Vafeiadis · ESOP 2009 · 15pp · [DOI](https://doi.org/10.1007/978-3-642-00590-9_26) · [PDF](https://people.mpi-sws.org/~viktor/papers/esop2009-denyguarantee.pdf). Recasts rely/guarantee as transferable permissions, so dynamically forked and joined threads — not just statically nested parallel blocks — can be verified compositionally.

12. **Concurrent Abstract Predicates** — Dinsdale-Young, Dodds, Gardner, Parkinson, Vafeiadis · ECOOP 2010 · 25pp · [DOI](https://doi.org/10.1007/978-3-642-14107-2_24) · [PDF](https://www.doc.ic.ac.uk/~pg/publications/Dinsdale-Young2010Concurrent.pdf). Gives a concurrent data structure an abstract specification — a *fiction of disjointness* — so clients reason as if they owned it while the implementation proof hides the sharing underneath.

13. **Views: Compositional Reasoning for Concurrent Programs** — Dinsdale-Young, Birkedal, Gardner, Parkinson, Yang · POPL 2013 · 14pp · [DOI](https://doi.org/10.1145/2429069.2429104) · [PDF](https://www.doc.ic.ac.uk/~pg/publications/Dinsdale-Young2013Views.pdf). Shows that rely/guarantee, separation logic, and concurrent abstract predicates are all instances of one construction — the abstraction Iris turns into a usable logic.

14. **Iris: Monoids and Invariants as an Orthogonal Basis for Concurrent Reasoning** — Jung, Swasey, Sieczkowski, Svendsen, Turon, Birkedal, Dreyer · POPL 2015 · 14pp · [DOI](https://doi.org/10.1145/2676726.2676980) · [PDF](https://iris-project.org/pdfs/2015-popl-iris1-final.pdf). Distills the decade above to two primitives — user-defined resources and invariants — the foundation modern proofs (including RustBelt) are built on.
    - **Iris from the Ground Up** — Jung, Krebbers, Jourdan, Bizjak, Birkedal, Dreyer · JFP 2018 · 73pp · [PDF](https://people.mpi-sws.org/~dreyer/papers/iris-ground-up/paper.pdf). The self-contained journal treatment that derives all of Iris from its base logic; the reference to keep open.

### Specifying behavior — contracts, subtyping, refinement types
*Once you can prove `{P} C {Q}`, the question becomes where P and Q come from; these fix the vocabulary of specifications.*

15. **A Behavioral Notion of Subtyping** — Barbara Liskov, Jeannette Wing · ACM TOPLAS 1994 · 31pp · [DOI](https://doi.org/10.1145/197320.197383) · [PDF](https://www.cs.cmu.edu/~wing/publications/LiskovWing94.pdf). Makes the substitution principle precise with subtype pre/postcondition and history constraints — the semantics behind design-by-contract.

16. **Liquid Types** — Rondon, Kawaguchi, Jhala · PLDI 2008 · 11pp · [DOI](https://doi.org/10.1145/1375581.1375602) · [PDF](https://goto.ucsd.edu/~rjhala/papers/liquid_types.pdf). Refinement types (`{v:int | v > 0}`) with the predicates inferred automatically, so lightweight verification rides along with ordinary type checking.

### From logic to tools — automated verification
*Proofs are only useful if a machine can build or check them; these are the tool ideas that made verification practical.*

17. **Proof-Carrying Code** — George C. Necula · POPL 1997 · 14pp · [DOI](https://doi.org/10.1145/263699.263712) · [PDF](https://homes.cs.washington.edu/~mernst/teaching/6.893/readings/necula-popl97.pdf). Untrusted code ships with a machine-checkable proof of a safety policy — verification moves to the producer, checking stays cheap for the consumer.

18. **Dafny: An Automatic Program Verifier for Functional Correctness** — K. Rustan M. Leino · LPAR-16 2010 · 22pp · [DOI](https://doi.org/10.1007/978-3-642-17511-4_20) · [PDF](https://leino.science/papers/krml203.pdf). A language whose specifications are discharged by an SMT solver — the most approachable on-ramp to writing verified code.
    - **Dafny language & tutorial** — [dafny.org](https://dafny.org/). The living toolchain and interactive tutorial behind the paper.

19. **The VeriFast Program Verifier** — Bart Jacobs, Frank Piessens · KU Leuven Tech. Report CW-520 2008 · 5pp · [PDF](https://people.cs.kuleuven.be/~bart.jacobs/verifast/verifast.pdf). A separation-logic verifier for real C and Java with fast, predictable checking driven by symbolic execution over programmer annotations.
    - **VeriFast** — [github.com/verifast/verifast](https://github.com/verifast/verifast). The open-source verifier and its example suite.

20. **Verified Software Toolchain (VST)** — Andrew W. Appel · ESOP 2011 · 17pp · [DOI](https://doi.org/10.1007/978-3-642-19718-5_1) · [PDF](https://www.cs.princeton.edu/~appel/papers/vst.pdf). A separation-logic program logic for C, proved sound in Coq down to CompCert's assembly — so a proof about your C source is a proof about the code that actually runs.

21. **Mostly-Automated Verification of Low-Level Programs (Bedrock)** — Adam Chlipala · PLDI 2011 · 12pp · [DOI](https://doi.org/10.1145/1993498.1993526) · [PDF](http://adam.chlipala.net/papers/BedrockPLDI11/BedrockPLDI11.pdf). A Coq library that discharges most separation-logic verification conditions automatically, bringing SMT-like automation to foundational, machine-checked proofs.

### The payoff — whole verified systems
*The end state the whole field was aiming at: machine-checked proofs of software people actually run.*

22. **seL4: Formal Verification of an OS Kernel** — Klein et al. · SOSP 2009 · 14pp · [DOI](https://doi.org/10.1145/1629575.1629596) · [PDF](https://plsyssec.github.io/cse227-spring25/papers/sel4.pdf). The first machine-checked functional-correctness proof of a general-purpose OS kernel — the concrete answer to De Millo et al.
    - **seL4 project** — [sel4.systems](https://sel4.systems/). The verified microkernel, its proofs, and their ongoing maintenance.

23. **CertiKOS: An Extensible Architecture for Building Certified Concurrent OS Kernels** — Gu, Shao, Chen, Wu, Kim, Sjöberg, Costanzo · OSDI 2016 · 19pp · [PDF](https://www.usenix.org/system/files/conference/osdi16/osdi16-gu.pdf). Where seL4 proved a *sequential* kernel correct, CertiKOS extends the guarantee to fine-grained concurrency through a stack of certified abstraction layers.

24. **Formal Verification of a Realistic Compiler (CompCert)** — Xavier Leroy · CACM 2009 · 9pp · [DOI](https://doi.org/10.1145/1538788.1538814) · [PDF](https://xavierleroy.org/publi/compcert-CACM.pdf). End-to-end machine-checked semantic preservation for an optimizing C compiler — verification extended from a program to the tool that compiles it.
    - **The CompCert C compiler** — [compcert.org](https://compcert.org/). The living artifact behind the paper.

25. **CakeML: A Verified Implementation of ML** — Kumar, Myreen, Norrish, Owens · POPL 2014 · 13pp · [DOI](https://doi.org/10.1145/2535838.2535841) · [PDF](https://cakeml.org/popl14.pdf). A compiler *and runtime* verified end to end in HOL4, with the correctness theorem reaching all the way to the generated machine code.
    - **CakeML project** — [cakeml.org](https://cakeml.org/). The verified compiler, its proofs, and successive bootstrapped releases.

26. **RustBelt: Securing the Foundations of the Rust Programming Language** — Jung, Jourdan, Krebbers, Dreyer · POPL 2018 · 34pp · [DOI](https://doi.org/10.1145/3158154) · [PDF](https://plv.mpi-sws.org/rustbelt/popl18/paper.pdf). The first formal safety proof for a realistic Rust subset, built in Iris — where program logic meets a language millions actually ship.
    - **RustBelt project** — [plv.mpi-sws.org/rustbelt](https://plv.mpi-sws.org/rustbelt/). Papers, Coq proofs, and follow-on work.

<!--html-->
<div class="why">
<b>Why the order is not chronological.</b> The field advanced by repair: Hoare logic
works until you add <em>concurrency</em> (Owicki–Gries, rely/guarantee) and a
<em>mutable heap</em> (separation logic). The concurrent logics between separation
logic and Iris (RGSep, deny-guarantee, abstract predicates, Views) are the decade Iris
finally distills. Read that way, seL4, CertiKOS, CompCert, CakeML and RustBelt are not
a grab-bag of verified artifacts but the point where the accumulated logic finally
scaled to software people run — the standing reply to "Social Processes."
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Concrete Semantics: With Isabelle/HOL** — Tobias Nipkow, Gerwin Klein · 2014 · 308pp · [PDF](http://concrete-semantics.org/concrete-semantics.pdf). Operational semantics and Hoare logic developed as *machine-checked* proofs in Isabelle — the working companion to this whole list.
- **FREE** **Program Logics for Certified Compilers** — Appel, Dockins, Hobor, Beringer, Dodds, Stewart, Blazy, Leroy · 2014 · 469pp · [PDF](https://www.cs.princeton.edu/~appel/papers/plcc.pdf). The theory and Coq engineering behind VST — separation logic carried all the way down to CompCert assembly.
- **BUY** **Verification of Sequential and Concurrent Programs** — Apt, de Boer, Olderog · 2009 · 502pp · [page](https://link.springer.com/book/10.1007/978-1-84882-745-5). The systematic textbook for Hoare logic, Owicki–Gries, and rely/guarantee — sections 5 and 8 above in one place.
- **BUY** **Program Proofs** — K. Rustan M. Leino · 2023 · 350pp · [page](https://mitpress.mit.edu/9780262546232/program-proofs/). Learning to write verified programs in Dafny, from the language's designer.

## Key terms

- **Hoare triple** — `{P} C {Q}`: if precondition P holds and command C terminates, postcondition Q holds.
- **weakest precondition** — `wp(C, Q)`: the weakest P making `{P} C {Q}` valid; Dijkstra's backward predicate transformer.
- **loop invariant** — an assertion preserved by every iteration; supplying it is the crux of a loop proof.
- **separating conjunction** — `P * Q`: P and Q hold on *disjoint* portions of the heap.
- **frame rule** — from `{P} C {Q}` infer `{P * R} C {Q * R}`; the rule that makes heap reasoning local.
- **rely / guarantee** — a thread's assumption about others' interference (rely) and its own promise about its steps (guarantee).
- **interference freedom** — the Owicki–Gries condition that no thread's step invalidates another thread's proof.
- **concurrent separation logic** — separation logic in which heap ownership is transferred between threads, so races and resource protocols become provable.
- **shared region** — a piece of heap governed by a protocol that several threads may touch, split off from thread-local state (RGSep).
- **abstract predicate** — an opaque assertion that exports a data structure's specification while hiding its internal sharing (CAP).
- **refinement type** — a base type narrowed by a logical predicate, e.g. `{v:int | v > 0}`.
- **SMT** — satisfiability modulo theories; the solver back-end behind Dafny, VeriFast, and Liquid Types.
- **proof-carrying code** — machine code shipped with a checkable proof that it obeys a stated safety policy.
