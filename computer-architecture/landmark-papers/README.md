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
