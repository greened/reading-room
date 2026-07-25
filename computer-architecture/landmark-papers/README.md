# Computer architecture · landmark papers (survey)

A cross-cutting survey — the most important computer-architecture papers across the
area's subtopics, in a sensible reading order. Canonical, in-depth references live
in the sibling subtopic directories; this list gathers the standouts and points
back to them.

Printable guide: `reading-guide.html` → `reading-guide.pdf` (`make` from repo root).
Run `./fetch.sh` to download the openly-available PDFs.

1. **Amdahl, Validity of the Single Processor Approach** (1967) — the speedup ceiling. → *quantitative-principles*
2. **Tomasulo, An Efficient Algorithm for Exploiting Multiple Arithmetic Units** (1967) — out-of-order execution. → *superscalar-and-out-of-order*
3. **Smith, Cache Memories** (1982) — the cache design space. → *memory-systems-and-storage*
4. **Lamport, How to Make a Multiprocessor... Correctly** (1979) — sequential consistency. → *multicore-and-memory-consistency*
5. **Tullsen, Eggers & Levy, Simultaneous Multithreading** (1995) — SMT / Hyper-Threading. → *multicore-and-memory-consistency*
6. **Olukotun et al., The Case for a Single-Chip Multiprocessor** (1996) — the multicore turn. → *multicore-and-memory-consistency*
7. **Williams, Waterman & Patterson, Roofline** (2009) — the bound-and-bottleneck performance model. → *quantitative-principles*
8. **Lindholm et al., NVIDIA Tesla** (2008) — the SIMT GPU. → *domain-specific-accelerators*
9. **Barroso & Hölzle, The Datacenter as a Computer** (2009) — warehouse-scale computing. → *warehouse-scale-computing*
10. **Esmaeilzadeh et al., Dark Silicon and the End of Multicore Scaling** (2011) — the specialization pivot. → *multicore-and-memory-consistency*
11. **Jouppi et al., In-Datacenter Performance Analysis of a TPU** (2017) — the ML accelerator. → *domain-specific-accelerators*
12. **Kocher et al., Spectre Attacks** (2019) — speculative-execution side channels. → *hardware-security*

For depth on any theme, follow the subtopic pointer.

## Reference shelf — books

- **BUY** **Computer Architecture: A Quantitative Approach** — Hennessy, Patterson (6th ed., 2017). the definitive graduate reference on quantitative design. [page](https://shop.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1)
- **BUY** **Computer Organization and Design (RISC-V)** — Patterson, Hennessy (2nd ed., 2020). the standard undergraduate introduction. [page](https://shop.elsevier.com/books/computer-organization-and-design-risc-v-edition/patterson/978-0-12-820331-6)
- **BUY** **Modern Processor Design: Fundamentals of Superscalar Processors** — Shen, Lipasti (2005). the canonical deep dive on superscalar microarchitecture. [page](https://www.waveland.com/browse.php?t=624)
- **BUY** **Parallel Computer Architecture: A Hardware/Software Approach** — Culler, Singh, Gupta (1998). the foundational multiprocessor text (coherence, interconnects). [page](https://shop.elsevier.com/books/parallel-computer-architecture/culler/978-1-55860-343-1)
- **BUY** **Memory Systems: Cache, DRAM, Disk** — Jacob, Ng, Wang (2007). the most comprehensive memory-hierarchy volume. [page](https://shop.elsevier.com/books/memory-systems/jacob/978-0-12-379751-3)
- **BUY** **Digital Design and Computer Architecture (RISC-V)** — Harris, Harris (2021). bridges digital logic and architecture, gates up. [page](https://shop.elsevier.com/books/digital-design-and-computer-architecture-risc-v-edition/harris/978-0-12-820064-3)
- **BUY** **Programming Massively Parallel Processors** — Hwu, Kirk, El Hajj (4th ed., 2022). the standard GPU-architecture and CUDA reference. [page](https://shop.elsevier.com/books/programming-massively-parallel-processors/hwu/978-0-323-91231-0)
