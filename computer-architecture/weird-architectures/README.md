# Computer architecture · Weird / unconventional architectures

The roads less taken: dataflow machines, transport-triggered and decoupled
designs, systolic and VLIW, massively-parallel SIMD, and tiled processors.

- **A Preliminary Architecture for a Basic Data-Flow Processor** — Dennis, Misunas, 1974, ISCA. The seminal static dataflow processor. [DOI](https://doi.org/10.1145/642089.642111)
- **Executing a Program on the MIT Tagged-Token Dataflow Architecture** — Arvind, Nikhil, 1990, IEEE TC. Dynamic (tagged-token) dataflow. [DOI](https://doi.org/10.1109/12.48862)
- **Monsoon: An Explicit Token-Store Architecture** — Papadopoulos, Culler, 1990, ISCA. The explicit token-store design that made dynamic dataflow buildable. [DOI](https://doi.org/10.1145/325164.325117)
- **MOVE: A Framework for High-Performance Processor Design** — Corporaal, Mulder, 1991, Supercomputing. Transport-triggered architectures (program the data movement). [DOI](https://doi.org/10.1145/125826.126159)
- **Why Systolic Architectures?** — H. T. Kung, 1982, IEEE Computer. The systolic-array paradigm (also foundational to modern ML accelerators). [DOI](https://doi.org/10.1109/MC.1982.1653825)
- **The WM Computer Architecture** — Wm. A. Wulf, 1988, SIGARCH CAN. An unconventional streaming design treating operand streams as first-class. [DOI](https://doi.org/10.1145/44571.44577)
- **Decoupled Access/Execute Computer Architectures** — James E. Smith, 1982, ISCA. Splitting memory-access from execution into decoupled queues. [DOI](https://doi.org/10.1145/1067649.801719)
- **Very Long Instruction Word Architectures and the ELI-512** — Joseph A. Fisher, 1983, ISCA. The founding VLIW paper (with trace scheduling). [DOI](https://doi.org/10.1145/800046.801649)
- **The Manchester Prototype Dataflow Computer** — Gurd, Kirkham, Watson, 1985, CACM. The most complete built-and-measured tagged-token dataflow machine. [DOI](https://doi.org/10.1145/2465.2468)
- **Data Parallel Algorithms** — Hillis, Steele, 1986, CACM. The Connection Machine article crystallizing massively-parallel SIMD. [DOI](https://doi.org/10.1145/7902.7903)
- **The Transputer** — Colin Whitby-Strevens, 1985, ISCA. INMOS's message-passing, on-chip-links processor (with occam/CSP). [DOI](https://doi.org/10.1145/327070.327269)
- **Baring It All to Software: Raw Machines** — Waingold, Taylor, et al., 1997, IEEE Computer. The tiled, software-exposed Raw architecture, prefiguring spatial accelerators. [DOI](https://doi.org/10.1109/2.612254)
