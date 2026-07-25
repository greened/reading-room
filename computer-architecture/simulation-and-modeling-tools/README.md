# Computer architecture · Simulation & modeling tools

The infrastructure of the field: cycle-level and full-system simulators, power/area
models, DRAM models, instrumentation, and sampling methodology.

- **The gem5 Simulator** — Binkert, Beckmann, Black, Reinhardt, Saidi, Basu, Hestness, Hower, Krishna, Sardashti, Sen, Sewell, Shoaib, Vaish, Hill, Wood, 2011, SIGARCH CAN. The M5+GEMS merger that became the de facto full-system, cycle-level simulator. [DOI](https://doi.org/10.1145/2024716.2024718) · [PDF](https://research.cs.wisc.edu/multifacet/papers/can11_gem5.pdf)
- **The gem5 Simulator: Version 20.0+** — Lowe-Power et al., 2020, arXiv. The decade-later community retrospective and standard modern citation. [arXiv](https://arxiv.org/abs/2007.03152) · [PDF](https://arxiv.org/pdf/2007.03152)
- **The SimpleScalar Tool Set, Version 2.0** — Burger, Austin, 1997, SIGARCH CAN. The dominant execution-driven microarchitecture simulator of its era. [DOI](https://doi.org/10.1145/268806.268810)
- **Wattch: A Framework for Architectural-Level Power Analysis and Optimizations** — Brooks, Tiwari, Martonosi, 2000, ISCA. The first widely-adopted architectural dynamic-power model. [DOI](https://doi.org/10.1145/339647.339657)
- **McPAT: An Integrated Power, Area, and Timing Modeling Framework** — Li, Ahn, Strong, Brockman, Tullsen, Jouppi, 2009, MICRO-42. The standard multicore power/area/timing companion to perf simulators. [DOI](https://doi.org/10.1145/1669112.1669172)
- **DRAMSim2: A Cycle Accurate Memory System Simulator** — Rosenfeld, Cooper-Balis, Jacob, 2011, IEEE CAL. A widely-used cycle-accurate DRAM model. [DOI](https://doi.org/10.1109/L-CA.2011.4)
- **ZSim: Fast and Accurate Microarchitectural Simulation of Thousand-Core Systems** — Sanchez, Kozyrakis, 2013, ISCA. Instruction-driven timing + bound-weave parallelization at thousand-core scale. [DOI](https://doi.org/10.1145/2485922.2485963) · [PDF](http://hdl.handle.net/1721.1/90820)
- **Sniper: Exploring the Level of Abstraction for Scalable and Accurate Parallel Multi-Core Simulation** — Carlson, Heirman, Eeckhout, 2011, SC. Popularized interval simulation for large multicores. [DOI](https://doi.org/10.1145/2063384.2063454)
- **Pin: Building Customized Program Analysis Tools with Dynamic Instrumentation** — Luk, Cohn, Muth, Patil, Klauser, Lowney, Wallace, Reddi, Hazelwood, 2005, PLDI. The DBI framework underpinning countless trace-driven tools. [DOI](https://doi.org/10.1145/1065010.1065034)
- **CACTI: An Enhanced Cache Access and Cycle Time Model** — Wilton, Jouppi, 1996, IEEE JSSC. The analytical cache/SRAM access-time/area/energy model embedded in later tools. [DOI](https://doi.org/10.1109/4.509850)
- **Automatically Characterizing Large Scale Program Behavior (SimPoint)** — Sherwood, Perelman, Hamerly, Calder, 2002, ASPLOS-X. Phase analysis making long workloads tractable to simulate. [DOI](https://doi.org/10.1145/605397.605403) · [PDF](https://escholarship.org/content/qt9bm2g3p7/qt9bm2g3p7.pdf)
- **Simics: A Full System Simulation Platform** — Magnusson et al., 2002, IEEE Computer. The landmark commercial full-system functional simulator. [DOI](https://doi.org/10.1109/2.982916)
