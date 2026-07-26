# Computer architecture · Quantitative principles

Computer architecture became a quantitative discipline once performance, power, and
area could be reasoned about with a few durable laws and models — Amdahl, Moore,
Dennard, the memory wall, roofline, and the end-of-scaling arguments. This guide reads
them as a path: first how we *measure* speed, then the scaling laws that made it free,
the bounds on parallel speedup, the walls where the free lunch ran out, and finally the
models architects use to design under those limits.

> **How to read this list.** Start with the metric — the iron law, honest benchmarking,
> and the standard suites — because every later argument is really a statement about one
> of its terms. Then take the two exponentials (Moore, Dennard) that shrank those terms
> for free, the speedup bounds (Amdahl, Gustafson) that cap what parallelism buys, and
> the walls — off-chip bandwidth, cache misses, and wire delay — that, together with the
> end of Dennard scaling, ended the free lunch. Close with the working models (Little's
> Law, roofline, mechanistic) and the design arguments that quantitative reasoning
> settles.

## Reading order

### Measuring performance: what "faster" means
*You cannot argue about limits until you fix how performance is measured — and how honestly you summarize it.*
1. **A Characterization of Processor Performance in the VAX-11/780** — Emer, Clark · ISCA 1984 · 10pp · [DOI](https://doi.org/10.1145/800015.808199) · [PDF](https://emer.org/Family/Joel/Professional/papers/1984-isca-vax.pdf). The measurement study behind the "iron law": execution time is instructions × cycles-per-instruction × cycle time, and you must measure all three.
2. **How Not to Lie with Statistics: The Correct Way to Summarize Benchmark Results** — Fleming, Wallace · CACM 1986 · 4pp · [DOI](https://doi.org/10.1145/5666.5673). Why the arithmetic mean of normalized results misleads and the geometric mean is the honest summary — the statistical basis of SPEC-style reporting.
3. **SPEC CPU2000: Measuring CPU Performance in the New Millennium** — John Henning · IEEE Computer 2000 · 8pp · [DOI](https://doi.org/10.1109/2.869367) · [PDF](https://open.spec.org/cpu2000/papers/COMPUTER_200007.JLH.pdf). How the industry-standard suite is actually built and reported — the workloads, the reference machine, and the base/peak rules that turn the honest-summary principle into a repeatable methodology.
    - **SPEC CPU benchmarks** — [SPEC](https://www.spec.org/cpu2000/). The living suite and run rules behind the paper.
4. **The Case for Application-Specific Benchmarking** — Seltzer, Krinsky, Smith, Zhang · HotOS 1999 · 6pp · [DOI](https://doi.org/10.1109/HOTOS.1999.798385) · [PDF](https://www.seltzer.com/assets/publications/The-Case-for-ApplicationSpecific-Benchmarking.pdf). The counterweight to a single suite score: it predicts little about the workload you actually run, so measure your application — or be misled.

### The scaling laws that powered the free lunch
*The two exponentials that gave four decades of "free" performance — and whose ends frame everything after.*
5. **Cramming More Components onto Integrated Circuits** — Gordon Moore · Electronics 1965 · 4pp · [DOI](https://doi.org/10.1109/N-SSC.2006.4785860) · [PDF](https://www.cs.utexas.edu/~fussell/courses/cs352h/papers/moore.pdf). The observation that became Moore's Law: transistor count per chip doubles on a fixed cadence, setting the industry's whole rhythm.
6. **Design of Ion-Implanted MOSFETs with Very Small Physical Dimensions** — Dennard, Gaensslen, Yu, Rideout, Bassous, LeBlanc · IEEE JSSC 1974 · 11pp · [DOI](https://doi.org/10.1109/JSSC.1974.1050511) · [PDF](http://web.archive.org/web/20260712090117id_/https://web.ece.ucsb.edu/courses/ECE225/225_W07Banerjee/reference/Dennard.pdf). States Dennard scaling — shrink a transistor and power density holds constant — the device-physics rule whose end reshaped everything after.
7. **A 30 Year Retrospective on Dennard's MOSFET Scaling Paper** — Mark Bohr · IEEE SSCS Newsletter 2007 · 5pp · [DOI](https://doi.org/10.1109/N-SSC.2007.4785534) · [PDF](https://www.eng.auburn.edu/~agrawvd/COURSE/READING/LOWP/Boh07.pdf). A process technologist revisits which of Dennard's rules held and which broke — the bridge from the 1974 device physics to why frequency scaling stalled in the mid-2000s.

### How far parallelism goes
*Once one core isn't enough, how much can more of them actually buy?*
8. **Validity of the Single Processor Approach to Achieving Large Scale Computing Capabilities** — Gene Amdahl · AFIPS 1967 · 4pp · [DOI](https://doi.org/10.1145/1465482.1465560) · [PDF](https://web.archive.org/web/20191029093307id_/http://www-inst.eecs.berkeley.edu/~n252/paper/Amdahl.pdf). Origin of Amdahl's Law: a fixed serial fraction caps speedup no matter how many processors you add.
9. **Reevaluating Amdahl's Law** — John Gustafson · CACM 1988 · 2pp · [DOI](https://doi.org/10.1145/42411.42415) · [PDF](https://web.archive.org/web/2017id_/http://www.johngustafson.net/pubs/pub13/amdahl.pdf). The optimistic counterpart: scale the problem with the machine and speedup grows nearly linearly — why massive parallelism is worthwhile after all.
10. **Amdahl's Law in the Multicore Era** — Hill, Marty · IEEE Computer 2008 · 6pp · [DOI](https://doi.org/10.1109/MC.2008.209) · [PDF](https://research.cs.wisc.edu/multifacet/papers/ieeecomputer08_amdahl_multicore.pdf). Applies Amdahl to chip multiprocessors, showing how symmetric, asymmetric, and dynamic core mixes change the speedup ceiling.

### The walls
*Where the free lunch first ran out: off-chip bandwidth, the cache misses behind it, on-chip wires, and the cost of a bigger core.*
11. **Hitting the Memory Wall: Implications of the Obvious** — Wulf, McKee · SIGARCH CAN 1995 · 5pp · [DOI](https://doi.org/10.1145/216585.216588) · [PDF](http://web.archive.org/web/20110704132034id_/http://www.cs.virginia.edu/papers/Hitting_Memory_Wall-wulf94.pdf). Coined the "memory wall": with processor speed outrunning DRAM, average access time comes to dominate performance.
12. **Evaluating Associativity in CPU Caches** — Hill, Smith · IEEE TC 1989 · 19pp · [DOI](https://doi.org/10.1109/12.40842) · [PDF](https://pages.cs.wisc.edu/~markhill/papers/toc89_cpu_cache_associativity.pdf). Source of the "three Cs" model — every miss is compulsory, capacity, or conflict — the vocabulary that turned cache design into a quantitative accounting of where the memory-wall traffic comes from.
13. **The Future of Wires** — Ho, Mai, Horowitz · Proc. IEEE 2001 · 15pp · [DOI](https://doi.org/10.1109/5.920580) · [PDF](https://www.princeton.edu/~rblee/ELE572Papers/Fall04Readings/ComputerArchitecture/ho01FutureofWires.pdf). As transistors shrank, wires did not get faster — global interconnect delay came to dominate, one of the physical reasons designs went multicore and tiled rather than bigger and monolithic.
14. **Coming Challenges in Microarchitecture and Architecture** — Ronen, Mendelson, Lai, Lu, Pollack, Shen · Proc. IEEE 2001 · 16pp · [DOI](https://doi.org/10.1109/5.915377). The source of Pollack's Rule — a core's performance rises only as the square root of its area — the diminishing-returns argument that pushed the field toward multicore.

### The end of Dennard scaling and the power wall
*When power stopped scaling with density, energy — not transistor count — became the limiter.*
15. **The Case for Energy-Proportional Computing** — Barroso, Hölzle · IEEE Computer 2007 · 5pp · [DOI](https://doi.org/10.1109/MC.2007.443) · [PDF](https://research.google.com/pubs/archive/33387.pdf). Machines run mostly at low utilization yet burn near-peak power there; argues energy use should track load — the framing for datacenter-scale efficiency.
16. **Dark Silicon and the End of Multicore Scaling** — Esmaeilzadeh, Blem, St. Amant, Sankaralingam, Burger · ISCA 2011 · 12pp · [DOI](https://doi.org/10.1145/2000064.2000108) · [PDF](https://research.cs.wisc.edu/vertical/papers/2011/isca11-darksilicon.pdf). Post-Dennard, the power budget forces much of a chip to stay dark at any instant — capping how many cores you can actually use.
17. **The Future of Microprocessors** — Borkar, Chien · CACM 2011 · 11pp · [DOI](https://doi.org/10.1145/1941487.1941507) · [PDF](http://web.archive.org/web/20240418165907/https://dl.acm.org/doi/pdf/10.1145/1941487.1941507). The industry statement of the same turn: energy efficiency, not transistor count, is now the fundamental limiter.
18. **Computing's Energy Problem (and What We Can Do About It)** — Mark Horowitz · ISSCC 2014 · 5pp · [DOI](https://doi.org/10.1109/ISSCC.2014.6757323) · [PDF](https://gwern.net/doc/cs/hardware/2014-horowitz-2.pdf). Quantifies where the joules actually go — instruction and data movement dwarf arithmetic — motivating specialization over general-purpose cores.
19. **Razor: A Low-Power Pipeline Based on Circuit-Level Timing Speculation** — Ernst, Kim, Das, Pant, Rao, Pham, Ziesler, Blaauw, Austin, Flautner, Mudge · MICRO 2003 · 12pp · [DOI](https://doi.org/10.1109/MICRO.2003.1253179) · [PDF](https://blaauw.engin.umich.edu/wp-content/uploads/sites/342/2018/02/Ernst-Razor-A-Low-Power-Pipeline-Based-on-Circuit-Level-Timing-Speculation.pdf). Run the voltage below the worst-case margin, detect the rare timing errors, and replay — reclaiming the guardband that static voltage/frequency scaling leaves on the table.

### Models for reasoning about a design
*Given the limits, the back-of-the-envelope models architects actually reach for.*
20. **A Proof for the Queuing Formula: L = λW** — John Little · Operations Research 1961 · 5pp · [DOI](https://doi.org/10.1287/opre.9.3.383). Little's Law: in steady state, occupancy equals arrival rate times latency — the identity behind sizing buffers, miss-status registers, and reorder windows, and why bandwidth and latency are two views of one number.
    - **Little's Law as Viewed on Its 50th Anniversary** — [PDF](https://www.informs.org/content/download/255808/2414681/file/little_paper.pdf). Little's own retrospective on what the law does and does not assume.
21. **Roofline: An Insightful Visual Performance Model for Multicore Architectures** — Williams, Waterman, Patterson · CACM 2009 · 11pp · [DOI](https://doi.org/10.1145/1498765.1498785) · [PDF](https://escholarship.org/content/qt78h8v7mr/qt78h8v7mr.pdf). Plots attainable performance against operational intensity, so one picture shows whether a kernel is compute- or bandwidth-bound.
    - **Roofline model** — [NERSC docs](https://docs.nersc.gov/tools/performance/roofline/). A practitioner's walkthrough of building and reading a roofline on real hardware.
22. **A Mechanistic Performance Model for Superscalar Out-of-Order Processors** — Eyerman, Eeckhout, Karkhanis, Smith · ACM TOCS 2009 · 37pp · [DOI](https://doi.org/10.1145/1534909.1534910) · [PDF](https://users.elis.ugent.be/~leeckhou/papers/tocs09.pdf). Interval analysis: a model that explains superscalar performance from first principles — miss events puncturing a steady-state issue rate — rather than by simulation alone.
23. **Microarchitecture Optimizations for Exploiting Memory-Level Parallelism** — Chou, Fahs, Abraham · ISCA 2004 · 12pp · [DOI](https://doi.org/10.1109/ISCA.2004.1310765) · [PDF](https://pages.cs.wisc.edu/~markhill/restricted/isca04_mlp.pdf). Concurrency applied to the memory system: overlapping cache misses — not the raw miss count — sets memory-bound performance, and this quantifies which microarchitectural features actually expose that parallelism.

### Design choices, quantified
*The same quantitative lens applied to the field's oldest design argument — and to what comes next.*
24. **The Case for the Reduced Instruction Set Computer** — Patterson, Ditzel · SIGARCH CAN 1980 · 9pp · [DOI](https://doi.org/10.1145/641914.641917) · [PDF](http://web.archive.org/web/20250723204031id_/https://dl.acm.org/doi/pdf/10.1145/641914.641917). The manifesto that framed RISC vs CISC as a quantitative trade rather than a matter of taste.
25. **Power Struggles: Revisiting the RISC vs. CISC Debate on Contemporary ARM and x86 Architectures** — Blem, Menon, Sankaralingam · HPCA 2013 · 12pp · [DOI](https://doi.org/10.1109/HPCA.2013.6522302) · [PDF](http://research.cs.wisc.edu/vertical/papers/2013/hpca13-isa-power-struggles.pdf). Measures modern ARM and x86 parts and finds the ISA is largely irrelevant to power and performance — the debate settled with data.
26. **A New Golden Age for Computer Architecture** — Hennessy, Patterson · CACM 2019 · 13pp · [DOI](https://doi.org/10.1145/3282307) · [PDF](https://www.doc.ic.ac.uk/~wl/teachlocal/arch/papers/cacm19golden-age.pdf). The synthesis: with the scaling laws spent, domain-specific architectures are where the gains now come from.
    - **Turing Lecture** — [ACM](https://www.acm.org/hennessy-patterson-turing-lecture). The 2017 Turing Award lecture this paper is drawn from.

<!--html-->
<div class="why">
<b>The whole arc in one breath.</b> For decades <em>Moore</em> gave more transistors and
<em>Dennard</em> gave them for free, so single cores got faster on their own. When Dennard
scaling ended, power — not transistor count — became the limiter (<em>Barroso</em>,
<em>Borkar</em>, <em>Horowitz</em>), <em>Pollack's rule</em> made bigger cores a bad deal,
and <em>Amdahl</em> capped how far multicore could carry us. What's left is to spend a fixed
power budget wisely: measure honestly (the iron law, geometric means, SPEC), model the
bottleneck (Little's Law, roofline), and specialize the hardware to the workload (the "new
golden age").
</div>
<!--/html-->

## Reference shelf — books

- **BUY** **Computer Architecture: A Quantitative Approach** — Hennessy, Patterson · 6th ed 2017 · 936pp · [page](https://www.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1). The canonical text; the source of the quantitative method, the iron law, and the Amdahl/energy framing used throughout this list.
- **FREE** **The Datacenter as a Computer: Designing Warehouse-Scale Machines** — Barroso, Hölzle, Ranganathan · 3rd ed 2018 · 209pp · [PDF](https://pages.cs.wisc.edu/~shivaram/cs744-readings/dc-computer-v3.pdf). Where energy-proportionality and total-cost-of-ownership dominate the design; the book-length case behind paper 15.

## Key terms

- **iron law of performance** — execution time = instructions × cycles-per-instruction × cycle time; every speedup acts on one of these three factors.
- **geometric mean** — the correct average for normalized ratios (SPEC scores); the arithmetic mean of ratios can reorder machines depending on the baseline chosen.
- **Amdahl's Law** — speedup is bounded by the fraction of work that stays serial, however many processors you add.
- **Gustafson's Law** — when the problem grows with the machine, achievable speedup grows nearly linearly with processor count.
- **Moore's Law** — the number of transistors on a chip roughly doubles on a fixed cadence (~2 years).
- **Dennard scaling** — as feature size shrinks, voltage and current scale with it so power density stays constant; its end is what capped clock frequency.
- **Pollack's Rule** — a core's performance grows about as the square root of its area (design complexity).
- **three Cs** — the classification of cache misses into compulsory, capacity, and conflict.
- **dark silicon** — the fraction of a chip that must stay unpowered at any instant to fit the power budget.
- **wire-delay scaling** — as feature size shrinks, gate delay falls but global-wire delay does not, so long interconnect — not logic — bounds the clock.
- **Little's Law** — in steady state, occupancy = arrival rate × latency; the bound relating outstanding requests, throughput, and latency.
- **memory-level parallelism (MLP)** — the number of independent memory accesses (typically cache misses) a machine keeps in flight at once.
- **operational intensity** — floating-point operations performed per byte of DRAM traffic; the x-axis of the roofline model.
- **energy-proportional** — power draw that scales with utilization, ideally falling toward zero at idle.
</content>
</invoke>
