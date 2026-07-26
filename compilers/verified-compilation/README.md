# Compilers · Verified compilation & superoptimization

Two ways to trust generated code: *prove* the compiler correct once and for all, or
*search* for better code and check each result. The papers below trace both lines,
from CompCert's end-to-end proof to equality saturation and stochastic search.

> **How to read this list.** Start with CompCert for the shape of a full correctness
> proof, then CakeML for a proof that reaches all the way to machine code. The
> second stage trades whole-compiler proofs for per-instance checking — Alive,
> equality saturation, and superoptimization — which is how these ideas reach
> production compilers like LLVM.

## Reading order

### Verified compilers
*Whole-compiler correctness: prove once that every run preserves semantics.*

1. **Formal Verification of a Realistic Compiler (CompCert)** — Xavier Leroy · CACM 2009 · 8pp · [DOI](https://doi.org/10.1145/1538788.1538814) · [PDF](https://xavierleroy.org/publi/compcert-CACM.pdf). The first mechanically verified optimizing C compiler; the reference point for verified compilation.
   - **The CompCert C compiler** — Leroy · [project page & manual](https://compcert.org/). The living artifact behind the paper.

2. **CakeML: A Verified Implementation of ML** — Kumar, Myreen, Norrish, Owens · POPL 2014 · 13pp · [DOI](https://doi.org/10.1145/2535838.2535841) · [PDF](https://cakeml.org/popl14.pdf). End-to-end verified compiler and runtime, with the proof reaching all the way to machine code.

3. **Formalizing the LLVM IR for Verified Program Transformations (Vellvm)** — Zhao, Nagarakatte, Martin, Zdancewic · POPL 2012 · 13pp · [DOI](https://doi.org/10.1145/2103656.2103709). Brings CompCert-style mechanized proof to the LLVM IR that real compilers use.

4. **Verasco: A Formally Verified C Static Analyzer** — Jourdan, Laporte, Blazy, Leroy, Pichardie · POPL 2015 · 13pp · [DOI](https://doi.org/10.1145/2676726.2676966) · [PDF](https://xavierleroy.org/publi/verasco-popl2015.pdf). A sound abstract-interpretation analyzer, proved correct in Coq and plugged into CompCert.

5. **Verified Peephole Optimizations for CompCert (Peek)** — Mullen, Zuck, Tatlock, Grossman · PLDI 2016 · 13pp · [DOI](https://doi.org/10.1145/2908080.2908109). A framework for adding *proven* peephole passes to CompCert without reproving the whole compiler.

### Checking optimizations, not the whole compiler
*Trade the whole-compiler proof for cheap checks on every transformation — how these ideas reach LLVM.*

6. **Translation Validation** — Pnueli, Siegel, Singerman · TACAS 1998 · 15pp · [DOI](https://doi.org/10.1007/BFb0054170). The founding idea: instead of proving the compiler, prove that *this* run preserved semantics.

7. **Rhodium: Automatically Proving Correctness of Compiler Optimizations** — Lerner, Millstein, Rice, Chambers · PLDI 2005 · 13pp · [DOI](https://doi.org/10.1145/1065010.1065040). Optimizations written in a DSL whose soundness is checked once, automatically.

8. **Finding and Understanding Bugs in C Compilers (Csmith)** — Yang, Chen, Eide, Regehr · PLDI 2011 · 12pp · [DOI](https://doi.org/10.1145/1993498.1993532). Random differential testing that found hundreds of bugs in GCC/LLVM — the empirical case for verifying and validating compilers.

9. **Provably Correct Peephole Optimizations with Alive** — Lopes, Menendez, Nagarakatte, Regehr · PLDI 2015 · 11pp · [DOI](https://doi.org/10.1145/2737924.2737965) · [PDF](https://users.cs.utah.edu/~regehr/papers/pldi15.pdf). SMT-based verification of LLVM peephole optimizations, now part of LLVM practice.

10. **Alive2: Bounded Translation Validation for LLVM** — Lopes, Lee, Hur, Liu, Regehr · PLDI 2021 · 15pp · [DOI](https://doi.org/10.1145/3453483.3454030). Validates each optimization *run* against the original — the successor to Alive, and a steady source of real LLVM miscompilation reports.

11. **egg: Fast and Extensible Equality Saturation** — Willsey et al. · POPL 2021 · 29pp · [DOI](https://doi.org/10.1145/3434304) · [PDF](https://arxiv.org/pdf/2004.03082). The practical e-graph library that made equality saturation broadly usable.

### Superoptimization: search for the best code, then check it
*Give up on rule-based rewriting and search the space of programs directly.*

12. **Superoptimizer — A Look at the Smallest Program** — Henry Massalin · ASPLOS 1987 · 5pp · [DOI](https://doi.org/10.1145/36206.36194) · [PDF](https://web.stanford.edu/class/cs343/resources/superoptimizer.pdf). The original: exhaustively search for the shortest instruction sequence with a given behavior.

13. **Denali: A Goal-directed Superoptimizer** — Joshi, Nelson, Randall · PLDI 2002 · 11pp · [DOI](https://doi.org/10.1145/512529.512566). Superoptimization driven by a matching engine and a theorem prover rather than brute force.

14. **Automatic Generation of Peephole Superoptimizers** — Bansal, Aiken · ASPLOS 2006 · 10pp · [DOI](https://doi.org/10.1145/1168857.1168906) · [PDF](https://theory.stanford.edu/~aiken/publications/papers/asplos06.pdf). Learns a peephole optimizer offline by superoptimizing over harvested code.

15. **Stochastic Superoptimization (STOKE)** — Schkufza, Sharma, Aiken · ASPLOS 2013 · 12pp · [DOI](https://doi.org/10.1145/2451116.2451150) · [PDF](https://theory.stanford.edu/~aiken/publications/papers/asplos13.pdf). Reframes superoptimization as MCMC search over programs.

16. **Souper: A Synthesizing Superoptimizer** — Sasnauskas, Chen, Collingbourne, Ketema, Taneja, Regehr · 2017 · 13pp · [arXiv](https://arxiv.org/abs/1711.04422) · [PDF](https://arxiv.org/pdf/1711.04422). An SMT-driven superoptimizer working directly on the LLVM IR.

<!--html-->
<div class="why">
<b>Two guarantees, two costs.</b> A <em>verified compiler</em> (CompCert, CakeML) proves
once that compilation preserves semantics for <em>every</em> input — expensive to build,
free forever after. <em>Per-instance checking</em> (Alive, equality saturation,
superoptimization) proves nothing about the compiler but validates each transformation it
applies — cheaper to adopt, and the route by which these ideas landed in LLVM.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Certified Programming with Dependent Types** — Adam Chlipala · 2013 · 400pp · [PDF](http://adam.chlipala.net/cpdt/cpdt.pdf). Building certified programs and proofs in Coq — the tooling behind CompCert-style proofs.
- **BUY** **Formal Semantics of Programming Languages** — Glynn Winskel · 1993 · 384pp · [page](https://mitpress.mit.edu/9780262731034/). The operational / denotational / axiomatic groundwork a correctness proof rests on.

## Key terms

- **translation validation** — checking that one compiler *run* preserved semantics, instead of proving the whole compiler.
- **equality saturation** — growing an e-graph of equivalent programs, then extracting the best, rather than applying rewrites in a fixed order.
- **e-graph** — a data structure compactly representing many equivalent expressions at once.
- **superoptimization** — searching for the optimal instruction sequence for a code fragment.
- **SMT** — satisfiability modulo theories; the solver technology Alive uses to discharge correctness conditions.
