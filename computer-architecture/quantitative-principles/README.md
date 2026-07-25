# Computer architecture · Quantitative principles

The laws and models that frame architecture as a quantitative discipline — Amdahl,
Dennard, the memory wall, roofline, and the end-of-scaling arguments.

- **Validity of the Single Processor Approach to Achieving Large Scale Computing Capabilities** — Gene M. Amdahl, 1967, AFIPS. Origin of Amdahl's Law: the speedup bound from a serial fraction. [DOI](https://doi.org/10.1145/1465482.1465560)
- **The Case for the Reduced Instruction Set Computer** — Patterson, Ditzel, 1980, SIGARCH CAN. The manifesto that framed the RISC-vs-CISC debate. [DOI](https://doi.org/10.1145/641914.641917)
- **Design of Ion-Implanted MOSFETs with Very Small Physical Dimensions** — Dennard, Gaensslen, Yu, Rideout, Bassous, LeBlanc, 1974, IEEE JSSC. States Dennard scaling — the device-physics rule whose end reshaped everything. [DOI](https://doi.org/10.1109/JSSC.1974.1050511)
- **Hitting the Memory Wall: Implications of the Obvious** — Wulf, McKee, 1995, SIGARCH CAN. Coined the "memory wall." [DOI](https://doi.org/10.1145/216585.216588)
- **Amdahl's Law in the Multicore Era** — Hill, Marty, 2008, IEEE Computer. Amdahl for chip multiprocessors (symmetric/asymmetric/dynamic). [DOI](https://doi.org/10.1109/MC.2008.209) · [PDF](https://research.cs.wisc.edu/multifacet/papers/ieeecomputer08_amdahl_multicore.pdf)
- **The Future of Microprocessors** — Borkar, Chien, 2011, CACM. Energy efficiency, not transistor count, is the fundamental limiter. [DOI](https://doi.org/10.1145/1941487.1941507)
- **Roofline: An Insightful Visual Performance Model for Multicore Architectures** — Williams, Waterman, Patterson, 2009, CACM. Operational intensity vs compute/bandwidth ceilings. [DOI](https://doi.org/10.1145/1498765.1498785) · [PDF](https://escholarship.org/content/qt78h8v7mr/qt78h8v7mr.pdf)
- **Dark Silicon and the End of Multicore Scaling** — Esmaeilzadeh, Blem, St. Amant, Sankaralingam, Burger, 2011, ISCA. Post-Dennard power limits cap usable cores. [DOI](https://doi.org/10.1145/2000064.2000108) · [PDF](https://research.cs.wisc.edu/vertical/papers/2011/isca11-darksilicon.pdf)
- **A Mechanistic Performance Model for Superscalar Out-of-Order Processors** — Eyerman, Eeckhout, Karkhanis, Smith, 2009, ACM TOCS. Interval analysis explaining superscalar performance mechanistically. [DOI](https://doi.org/10.1145/1534909.1534910) · [PDF](https://users.elis.ugent.be/~leeckhou/papers/tocs09.pdf)
- **A New Golden Age for Computer Architecture** — Hennessy, Patterson, 2019, CACM. Turing Lecture: the turn to domain-specific architectures. [DOI](https://doi.org/10.1145/3282307) · [PDF](https://www.doc.ic.ac.uk/~wl/teachlocal/arch/papers/cacm19golden-age.pdf)
- **Power Struggles: Revisiting the RISC vs. CISC Debate on Contemporary ARM and x86 Architectures** — Blem, Menon, Sankaralingam, 2013, HPCA. Empirically shows ISA is largely irrelevant to power/performance on modern implementations. [DOI](https://doi.org/10.1109/HPCA.2013.6522302) · [PDF](http://research.cs.wisc.edu/vertical/papers/2013/hpca13-isa-power-struggles.pdf)
