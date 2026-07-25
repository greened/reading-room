# Computer architecture · Multicore & memory consistency

Shared-memory correctness and parallelism: consistency models, cache coherence,
transactional memory, SMT/CMP, and the scaling wall.

- **How to Make a Multiprocessor Computer That Correctly Executes Multiprocess Programs** — Leslie Lamport, 1979, IEEE TC. Defines sequential consistency. [DOI](https://doi.org/10.1109/TC.1979.1675439)
- **A New Solution to Coherence Problems in Multicache Systems** — Censier, Feautrier, 1978, IEEE TC. The directory-based coherence scheme behind scalable systems. [DOI](https://doi.org/10.1109/TC.1978.1675013)
- **A Low-Overhead Coherence Solution for Multiprocessors with Private Cache Memories** — Papamarcos, Patel, 1984, ISCA. The MESI/Illinois snooping protocol. [DOI](https://doi.org/10.1145/800015.808204)
- **Memory Consistency and Event Ordering in Scalable Shared-Memory Multiprocessors** — Gharachorloo, Lenoski, Laudon, Gibbons, Gupta, Hennessy, 1990, ISCA. Introduces release consistency. [DOI](https://doi.org/10.1109/ISCA.1990.134503)
- **Transactional Memory: Architectural Support for Lock-Free Data Structures** — Herlihy, Moss, 1993, ISCA. Launched hardware transactional memory. [DOI](https://doi.org/10.1145/165123.165164) · [PDF](https://courses.csail.mit.edu/6.895/fall03/handouts/papers/HerlihyMo93.pdf)
- **Simultaneous Multithreading: Maximizing On-Chip Parallelism** — Tullsen, Eggers, Levy, 1995, ISCA. SMT: interleaving threads to fill idle issue slots. [DOI](https://doi.org/10.1145/223982.224449) · [PDF](https://www.cs.sfu.ca/~alaa/courses/cmpt450/fall2022/papers/tullsen-isca-1995.pdf)
- **The Case for a Single-Chip Multiprocessor** — Olukotun, Nayfeh, Hammond, Wilson, Chang, 1996, ASPLOS-VII. The multicore turn. [DOI](https://doi.org/10.1145/237090.237140) · [PDF](http://arsenalfc.stanford.edu/kunle/publications/hydra_ASPLOS_VII.pdf)
- **Shared Memory Consistency Models: A Tutorial** — Adve, Gharachorloo, 1996, IEEE Computer. The canonical map of relaxed-consistency models. [DOI](https://doi.org/10.1109/2.546611)
- **Read-Copy Update: Using Execution History to Solve Concurrency Problems** — McKenney, Slingwine, 1998, PDCS. RCU: near-zero-overhead lock-free reads (now core to Linux).
- **Dark Silicon and the End of Multicore Scaling** — Esmaeilzadeh, Blem, St. Amant, Sankaralingam, Burger, 2011, ISCA. The utilization wall capping multicore scaling. [DOI](https://doi.org/10.1145/2000064.2000108)
