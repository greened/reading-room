# Computer architecture · Simulation & modeling tools

The infrastructure of the field: cycle-level and full-system simulators, dynamic
instrumentation, sampling methodology, and the power, area, thermal, and memory
models that turn a timing trace into a design study. The path below starts with the
core simulation *engines*, then works outward through the tooling that feeds them,
the methods that make full-length runs affordable, the tricks that make them fast,
and finally the physical models and the accelerator/FPGA frontier.

> **How to read this list.** Start with the engines — SimpleScalar for the classic
> execution-driven model, Simics for full-system, gem5 for today's standard. Everything
> after that answers a practical question you hit the moment you try to use one: *How do
> I get a trace?* (instrumentation), *How do I avoid simulating a trillion instructions?*
> (sampling), *How do I make it fast?* (interval and parallel simulation), *What about
> energy, area, heat, and DRAM?* (physical models), and *What about GPUs and FPGAs?*
> (the accelerator frontier). Read the section rationales as the connective tissue.

## Reading order

### Core engines: execution-driven and full-system simulators
*Start here — the simulators everything else plugs into, from the classic microarchitecture model to the modern full-system standard.*

1. **The SimpleScalar Tool Set, Version 2.0** — Doug Burger, Todd Austin · UW-Madison Tech Report 1342 / SIGARCH CAN 1997 · 22pp · [DOI](https://doi.org/10.1145/268806.268810) · [PDF](https://research.cs.wisc.edu/techreports/1997/TR1342.pdf). The dominant execution-driven microarchitecture simulator of its era, and where a generation learned cycle-level modeling.

2. **Simics: A Full System Simulation Platform** — Peter Magnusson et al. · IEEE Computer 2002 · 9pp · [DOI](https://doi.org/10.1109/2.982916) · [PDF](https://studies.ac.upc.edu/doctorat/InstProf/Simics.pdf). The landmark commercial full-system functional simulator: boot a real, unmodified OS and its drivers, deterministically.

3. **The gem5 Simulator** — Nathan Binkert, Bradford Beckmann, Gabriel Black, Steven Reinhardt, Ali Saidi, Arkaprava Basu, Joel Hestness, Derek Hower, Tushar Krishna, Somayeh Sardashti, Rathijit Sen, Korey Sewell, Muhammad Shoaib, Nilay Vaish, Mark Hill, David Wood · SIGARCH CAN 2011 · 7pp · [DOI](https://doi.org/10.1145/2024716.2024718) · [PDF](https://research.cs.wisc.edu/multifacet/papers/can11_gem5.pdf). The M5+GEMS merger that became the de facto full-system, cycle-level simulator.
   - **Learning gem5** — [online book](https://www.gem5.org/documentation/learning_gem5/introduction/). Jason Lowe-Power's hands-on tutorial: the standard on-ramp to actually running gem5.

4. **The gem5 Simulator: Version 20.0+** — Jason Lowe-Power et al. · arXiv 2020 · 21pp · [arXiv](https://arxiv.org/abs/2007.03152) · [PDF](https://arxiv.org/pdf/2007.03152). The decade-later community retrospective and the standard modern citation.

### Feeding and observing the machine: dynamic binary instrumentation
*Simulators and analyses need traces and hooks; dynamic binary instrumentation is how you get them from real, unmodified binaries.*

5. **Pin: Building Customized Program Analysis Tools with Dynamic Instrumentation** — Chi-Keung Luk, Robert Cohn, Robert Muth, Harish Patil, Artur Klauser, Geoff Lowney, Steven Wallace, Vijay Janapa Reddi, Kim Hazelwood · PLDI 2005 · 11pp · [DOI](https://doi.org/10.1145/1065010.1065034) · [PDF](https://robert.muth.org/Papers/pldi_2005.pdf). The DBI framework underpinning countless trace-driven simulators and analysis tools.

6. **An Infrastructure for Adaptive Dynamic Optimization (DynamoRIO)** — Derek Bruening, Timothy Garnett, Saman Amarasinghe · CGO 2003 · 11pp · [DOI](https://doi.org/10.1109/CGO.2003.1191551) · [PDF](https://commit.csail.mit.edu/papers/2003/RIO-adaptive-CGO03.pdf). The runtime code-manipulation system beneath DynamoRIO — the general-purpose engine Pin's approach is often compared against.

7. **Valgrind: A Framework for Heavyweight Dynamic Binary Instrumentation** — Nicholas Nethercote, Julian Seward · PLDI 2007 · 12pp · [DOI](https://doi.org/10.1145/1250734.1250746) · [PDF](https://valgrind.org/docs/valgrind2007.pdf). Shadow-value instrumentation heavy enough to track every bit of memory state — the basis of Memcheck and Cachegrind.

### Making full-length runs tractable: sampling and phase analysis
*You cannot simulate trillions of instructions in cycle-level detail; measure a principled subset instead.*

8. **Automatically Characterizing Large Scale Program Behavior (SimPoint)** — Timothy Sherwood, Erez Perelman, Greg Hamerly, Brad Calder · ASPLOS 2002 · 13pp · [DOI](https://doi.org/10.1145/605397.605403) · [PDF](https://cseweb.ucsd.edu/~calder/papers/ASPLOS-02-SimPoint.pdf). Phase analysis: cluster a program's behavior and simulate a few representative intervals in full.
   - **SimPoint** — [project page](https://cseweb.ucsd.edu/~calder/simpoint/). The tool and the BBV methodology behind the paper.

9. **SMARTS: Accelerating Microarchitecture Simulation via Rigorous Statistical Sampling** — Roland Wunderlich, Thomas Wenisch, Babak Falsafi, James Hoe · ISCA 2003 · 14pp · [DOI](https://doi.org/10.1145/871656.859629) · [PDF](https://users.ece.cmu.edu/~jhoe/distribution/2003/isca03.pdf). Systematic sampling with confidence bounds — the statistically rigorous counterpart to SimPoint's phase clustering.

### Going faster: abstraction, interval models, and parallel simulation
*Two levers speed detailed timing simulation — raise the level of abstraction, or run cores in parallel.*

10. **Interval Simulation: Raising the Level of Abstraction in Architectural Simulation** — Davy Genbrugge, Stijn Eyerman, Lieven Eeckhout · HPCA 2010 · 12pp · [DOI](https://doi.org/10.1109/HPCA.2010.5416636) · [PDF](https://users.elis.ugent.be/~leeckhou/papers/hpca10.pdf). Models core timing as intervals between miss events rather than pipeline stages — the mechanistic idea behind Sniper.

11. **Sniper: Exploring the Level of Abstraction for Scalable and Accurate Parallel Multi-Core Simulation** — Trevor Carlson, Wim Heirman, Lieven Eeckhout · SC 2011 · 12pp · [DOI](https://doi.org/10.1145/2063384.2063454) · [PDF](https://users.elis.ugent.be/~leeckhou/papers/sc11.pdf). Interval simulation made practical and parallel for large multicores.

12. **ZSim: Fast and Accurate Microarchitectural Simulation of Thousand-Core Systems** — Daniel Sanchez, Christos Kozyrakis · ISCA 2013 · 12pp · [DOI](https://doi.org/10.1145/2485922.2485963) · [PDF](https://people.csail.mit.edu/sanchez/papers/2013.zsim.isca.pdf). Instruction-driven timing plus bound-weave parallelization that scales detailed simulation to thousands of cores.

13. **Graphite: A Distributed Parallel Simulator for Multicores** — Jason Miller, Harshad Kasture, George Kurian, Charles Gruenwald III, Nathan Beckmann, Christopher Celio, Jonathan Eastep, Anant Agarwal · HPCA 2010 · 12pp · [DOI](https://doi.org/10.1109/HPCA.2010.5416635) · [PDF](https://www.cs.cmu.edu/~beckmann/publications/papers/2010.hpca.graphite.pdf). Direct-execution simulation distributed across a cluster of machines, trading a little accuracy for scale.

### Power, area, and thermal models
*Performance is only half the story; these are the energy, area, and temperature companions that plug into a timing simulator.*

14. **CACTI: An Enhanced Cache Access and Cycle Time Model** — Steven Wilton, Norman Jouppi · IEEE JSSC 1996 · 12pp · [DOI](https://doi.org/10.1109/4.509850) · [PDF](https://web.archive.org/web/20191024051411id_/https://www.hpl.hp.com/techreports/Compaq-DEC/WRL-93-5.pdf). The analytical cache/SRAM access-time, area, and energy model embedded in nearly every later power tool; the PDF is the fuller WRL research-report version.

15. **Wattch: A Framework for Architectural-Level Power Analysis and Optimizations** — David Brooks, Vivek Tiwari, Margaret Martonosi · ISCA 2000 · 12pp · [DOI](https://doi.org/10.1145/339647.339657) · [PDF](https://mrmgroup.cs.princeton.edu/papers/isca2000.pdf). The first widely adopted architectural dynamic-power model, built on CACTI-style capacitance estimates.

16. **Temperature-Aware Microarchitecture (HotSpot)** — Kevin Skadron, Mircea Stan, Wei Huang, Sivakumar Velusamy, Karthik Sankaranarayanan, David Tarjan · ISCA 2003 · 12pp · [DOI](https://doi.org/10.1145/871656.859620) · [PDF](https://www.cs.virginia.edu/~skadron/Papers/hotspot_isca03.pdf). A compact RC thermal model that turns per-block power into on-chip temperature — the standard architectural thermal companion.
   - **HotSpot** — [project page](https://www.cs.virginia.edu/~skadron/lava/HotSpot/). The maintained tool and its documentation.

17. **McPAT: An Integrated Power, Area, and Timing Modeling Framework** — Sheng Li, Jung Ho Ahn, Richard Strong, Jay Brockman, Dean Tullsen, Norman Jouppi · MICRO 2009 · 12pp · [DOI](https://doi.org/10.1145/1669112.1669172) · [PDF](https://web.archive.org/web/20230529050350id_/https://www.hpl.hp.com/research/mcpat/micro09.pdf). The standard multicore power/area/timing model, designed to attach to a performance simulator like gem5.

### Memory-system models
*Main memory has its own timing and needs a dedicated model; these are the workhorses.*

18. **DRAMSim2: A Cycle Accurate Memory System Simulator** — Paul Rosenfeld, Elliott Cooper-Balis, Bruce Jacob · IEEE CAL 2011 · 4pp · [DOI](https://doi.org/10.1109/L-CA.2011.4) · [PDF](https://user.eng.umd.edu/~blj/papers/cal10-1.pdf). A widely used cycle-accurate DRAM model that many simulators bolt on for realistic memory timing.

19. **Ramulator: A Fast and Extensible DRAM Simulator** — Yoongu Kim, Weikun Yang, Onur Mutlu · IEEE CAL 2015 · 4pp · [DOI](https://doi.org/10.1109/LCA.2015.2414456) · [PDF](http://users.ece.cmu.edu/~omutlu/pub/ramulator_dram_simulator-ieee-cal15.pdf). The faster, more extensible successor covering DDRx, LPDDRx, GDDRx, HBM, and many academic proposals from one codebase.
   - **Ramulator** — [source](https://github.com/CMU-SAFARI/ramulator). The extensible standards-driven simulator described in the paper.
   - **Computer Architecture (ETH Zürich, Fall 2020)** — [VIDEO](https://www.youtube.com/playlist?list=PL5Q2soXY2Zi9xidyIgBxUz7xRPS-wisBN). Onur Mutlu's full course; the memory-system lectures are an excellent companion to the DRAM models here.

### Accelerators and FPGA-accelerated simulation
*Where the field went next: detailed GPU models and hardware-accelerated full-system simulation.*

20. **Analyzing CUDA Workloads Using a Detailed GPU Simulator (GPGPU-Sim)** — Ali Bakhoda, George Yuan, Wilson Fung, Henry Wong, Tor Aamodt · ISPASS 2009 · 12pp · [DOI](https://doi.org/10.1109/ISPASS.2009.4919648) · [PDF](https://people.ece.ubc.ca/aamodt/papers/gpgpusim.ispass09.pdf). The detailed GPU timing simulator that opened microarchitecture research on massively parallel accelerators.
   - **GPGPU-Sim** — [project page](http://www.gpgpu-sim.org/). The simulator and its GPUWattch energy model.

21. **Accel-Sim: An Extensible Simulation Framework for Validated GPU Modeling** — Mahmoud Khairy, Zhesheng Shen, Tor Aamodt, Timothy Rogers · ISCA 2020 · 14pp · [DOI](https://doi.org/10.1109/ISCA45697.2020.00047) · [PDF](https://people.ece.ubc.ca/~aamodt/publications/papers/accelsim.isca2020.pdf). Trace-driven, rigorously validated modern GPU simulation — the current standard for accelerator studies.
   - **Accel-Sim** — [framework](https://accel-sim.github.io/). The tuning and validation toolchain around the simulator.

22. **FireSim: FPGA-Accelerated Cycle-Exact Scale-Out System Simulation in the Public Cloud** — Sagar Karandikar, Howard Mao, Donggyu Kim, David Biancolin, Alon Amid, Dayeol Lee, Nathan Pemberton, Emmanuel Amaro, Colin Schmidt, Aditya Chopra, Qijing Huang, Kyle Kovacs, Borivoje Nikolic, Randy Katz, Jonathan Bachrach, Krste Asanović · ISCA 2018 · 14pp · [DOI](https://doi.org/10.1109/ISCA.2018.00014) · [PDF](https://sagark.org/assets/pubs/firesim-isca2018.pdf). Cycle-exact RTL simulation accelerated on cloud FPGAs, scaled out to model whole clusters of RISC-V systems.
   - **FireSim** — [project site](https://fires.im/). The open platform and its documentation.

<!--html-->
<div class="why">
<b>Timing, then everything around it.</b> A performance simulator answers <em>how many
cycles</em>; a real design study also needs <em>how</em> you drove it (instrumentation),
<em>how little</em> of the workload you can afford to run (sampling), <em>how fast</em>
the model itself is (interval and parallel simulation), and <em>what it costs</em> in
energy, area, heat, and memory latency (the physical models). The sections above are that
toolchain, in the order you assemble it.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Learning gem5** — Jason Lowe-Power · online · [book](https://learning.gem5.org/book/index.html). A build-it-up tutorial that takes you from a first SimObject to full-system runs — the practical companion to the gem5 papers.
- **BUY** **Computer Architecture: A Quantitative Approach** — John Hennessy, David Patterson · 6th ed 2017 · 936pp · [page](https://shop.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1). The field's bible, and the source of the quantitative, simulation-driven evaluation mindset these tools serve.
- **BUY** **Memory Systems: Cache, DRAM, Disk** — Bruce Jacob, Spencer Ng, David Wang · 2007 · 1017pp · [page](https://shop.elsevier.com/books/memory-systems/jacob/978-0-12-379751-3). The definitive reference behind DRAMSim and the memory-timing detail those models encode.

## Key terms

- **execution-driven simulation** — the simulator itself executes the workload's instructions, so timing feedback can affect the path taken (contrast trace-driven).
- **trace-driven simulation** — the simulator replays a pre-recorded instruction/address trace; simpler and faster, but blind to timing-dependent behavior.
- **full-system simulation** — modeling enough of the machine (CPU, devices, I/O) to boot and run an unmodified OS, not just user code.
- **cycle-level / cycle-accurate** — resolving behavior to individual clock cycles; "accurate" implies validation against real hardware.
- **dynamic binary instrumentation (DBI)** — inserting analysis code into a running binary without recompiling it (Pin, DynamoRIO, Valgrind).
- **interval simulation** — a mechanistic core model that advances time in intervals between miss events instead of simulating each pipeline stage.
- **bound-weave** — ZSim's two-phase scheme that runs cores in parallel (bound) then reconciles their interactions (weave) for scalable detailed timing.
- **SimPoint / basic-block vector (BBV)** — a fingerprint of execution phases used to pick a few representative intervals to simulate in full.
- **warm-up** — running (without measuring) to fill caches, branch predictors, and TLBs so a sampled measurement isn't cold-start biased.
- **IPC** — instructions per cycle; the headline throughput metric most of these simulators report.
