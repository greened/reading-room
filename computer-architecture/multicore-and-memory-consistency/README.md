# Computer architecture · Multicore & memory consistency

Shared-memory correctness and parallelism: consistency models, cache coherence,
synchronization, transactional memory, and the multicore scaling wall. The path
below starts from the gold-standard contract — sequential consistency — then builds
the coherence mechanism that makes many private caches behave like one memory,
relaxes that model for speed, shows how software actually synchronizes on top of it,
raises the abstraction with transactional memory, and ends at the hardware that made
multicore ubiquitous and the energy limit that capped it.

> **Coherence vs. consistency — keep them separate.** *Coherence* is about a single
> memory location: all processors must agree on the order of writes to it. *Consistency*
> (the memory model) is about how accesses to *different* locations may be reordered and
> observed across processors. Coherence is a mechanism; the consistency model is the
> programmer-visible contract. Most confusion in this area comes from conflating the two.

## Reading order

### The contract: sequential consistency
*Start here — the intuitive gold-standard model every later relaxation is measured against.*
1. **How to Make a Multiprocessor Computer That Correctly Executes Multiprocess Programs** — Leslie Lamport · IEEE TC 1979 · 2pp · [DOI](https://doi.org/10.1109/TC.1979.1675439) · [PDF](https://lamport.azurewebsites.net/pubs/multi.pdf). Two pages that define sequential consistency: the result of any execution is as if all operations ran in some single order respecting each processor's program order. The reference point for the whole area.

### Cache coherence: keeping one location consistent
*The mechanism that makes many private caches look like one memory — snooping first, then directories that scale.*
2. **A New Solution to Coherence Problems in Multicache Systems** — Lucien Censier, Paul Feautrier · IEEE TC 1978 · 7pp · [DOI](https://doi.org/10.1109/TC.1978.1675013) · [PDF](https://safari.ethz.ch/architecture/fall2020/lib/exe/fetch.php?media=a_new_solution_to_coherence_problems_in_multicache_systems.pdf). The original directory-based scheme: keep a central record of which caches hold each block instead of broadcasting. The idea behind every scalable coherent system.
3. **Using Cache Memory to Reduce Processor-Memory Traffic** — James Goodman · ISCA 1983 · 8pp · [DOI](https://doi.org/10.1145/800046.801647) · [PDF](https://safari.ethz.ch/architecture/fall2018/lib/exe/fetch.php?media=using_cache_memory_to_reduce_processor-memory_traffic.pdf). Introduces write-once snooping — the first bus-based coherence protocol, and the ancestor of every snoopy design.
4. **A Low-Overhead Coherence Solution for Multiprocessors with Private Cache Memories** — Mark Papamarcos, Janak Patel · ISCA 1984 · 7pp · [DOI](https://doi.org/10.1145/800015.808204) · [PDF](https://safari.ethz.ch/architecture/fall2020/lib/exe/fetch.php?media=a_low-overhead_coherence_solution_for_multiprocessors_with_private_cache_memories.pdf). The Illinois protocol — MESI — which added the Exclusive state so a private write needs no bus traffic. The snooping protocol still taught and shipped today.
5. **A Class of Compatible Cache Consistency Protocols and Their Support by the IEEE Futurebus** — Paul Sweazey, Alan Jay Smith · ISCA 1986 · 10pp · [DOI](https://doi.org/10.1145/17356.17404) · [PDF](https://pages.cs.wisc.edu/~markhill/restricted/isca86_moesi.pdf). Names the MOESI state space and shows the protocols form a compatible family — the taxonomy behind AMD's and others' coherence.
6. **The Directory-Based Cache Coherence Protocol for the DASH Multiprocessor** — Daniel Lenoski, James Laudon, Kourosh Gharachorloo, Anoop Gupta, John Hennessy · ISCA 1990 · 12pp · [DOI](https://doi.org/10.1145/325164.325132) · [PDF](https://people.eecs.berkeley.edu/~kubitron/cs258/handouts/papers/p148-lenoski.pdf). Snooping cannot scale past a shared bus; DASH shows a working distributed directory over a point-to-point network. The blueprint for scalable ccNUMA.
7. **The SGI Origin: A ccNUMA Highly Scalable Server** — James Laudon, Daniel Lenoski · ISCA 1997 · 11pp · [DOI](https://doi.org/10.1145/264107.264206) · [PDF](https://www.csl.cornell.edu/courses/ece5750/laudon.isca97.pdf). DASH's directory ideas taken to a shipping commercial machine — the canonical case study of production ccNUMA.

### Relaxing the model for speed
*Real hardware reorders memory accesses; these papers define what it may do and the contract that keeps programs correct.*
8. **Memory Access Buffering in Multiprocessors** — Michel Dubois, Christoph Scheurich, Fayé Briggs · ISCA 1986 · 9pp · [DOI](https://doi.org/10.1145/17356.17406) · [PDF](https://safari.ethz.ch/architecture/fall2024/lib/exe/fetch.php?media=duboismemoryaccessbuffering.pdf). Shows how write buffers and lock-up-free caches break sequential consistency, and defines *weak ordering* — the first principled relaxed model.
9. **Weak Ordering — A New Definition** — Sarita Adve, Mark Hill · ISCA 1990 · 13pp · [DOI](https://doi.org/10.1145/325164.325100) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-F03/handouts/papers/p363-adve.pdf). Reframes weak ordering as a contract: programs that are data-race-free see SC, and hardware is free to reorder everything else. The intellectual root of the data-race-free approach in modern language models.
10. **Memory Consistency and Event Ordering in Scalable Shared-Memory Multiprocessors** — Kourosh Gharachorloo, Daniel Lenoski, James Laudon, Phillip Gibbons, Anoop Gupta, John Hennessy · ISCA 1990 · 12pp · [DOI](https://doi.org/10.1109/ISCA.1990.134503) · [PDF](https://safari.ethz.ch/architecture/fall2020/lib/exe/fetch.php?media=memory_consistency_and_event_ordering_in_scalable_shared-memory_multiprocessors.pdf). Introduces release consistency: order memory only at acquire and release synchronization points. The model DASH implemented and the one that shaped later hardware.
11. **Shared Memory Consistency Models: A Tutorial** — Sarita Adve, Kourosh Gharachorloo · IEEE Computer 1996 · 11pp · [DOI](https://doi.org/10.1109/2.546611) · [PDF](http://sadve.cs.illinois.edu/Publications/computer96.pdf). The canonical map of the relaxed-consistency zoo — read it once you have seen a couple of concrete models and want the whole landscape.
12. **Foundations of the C++ Concurrency Memory Model** — Hans-J. Boehm, Sarita Adve · PLDI 2008 · 11pp · [DOI](https://doi.org/10.1145/1375581.1375591) · [PDF](http://rsim.cs.illinois.edu/Pubs/08PLDI.pdf). How the data-race-free idea became a real programming-language memory model — the basis of the C++11 and C11 standards every systems programmer now relies on.
13. **x86-TSO: A Rigorous and Usable Programmer's Model for x86 Multiprocessors** — Peter Sewell, Susmit Sarkar, Scott Owens, Francesco Zappa Nardelli, Magnus Myreen · CACM 2010 · 9pp · [DOI](https://doi.org/10.1145/1785414.1785443) · [PDF](https://www.cl.cam.ac.uk/~pes20/weakmemory/cacm.pdf). A precise, tested model of what x86 actually guarantees (total store order) after years of vague vendor prose — the model behind real reasoning about x86 concurrency.
    - **Hardware Memory Models** — Russ Cox · [research.swtch.com/hwmm](https://research.swtch.com/hwmm). A from-scratch modern explainer of SC, TSO, and relaxed models; the best on-ramp to this whole section.

### Synchronization: locks and lock-free
*How software actually coordinates on top of these models — and how to make it scale.*
14. **Algorithms for Scalable Synchronization on Shared-Memory Multiprocessors** — John Mellor-Crummey, Michael Scott · ACM TOCS 1991 · 45pp · [DOI](https://doi.org/10.1145/103727.103729) · [PDF](https://www.cs.rochester.edu/u/scott/papers/1991_TOCS_synch.pdf). The MCS lock and its kin: spin locally instead of on one shared line, so a lock scales to many cores. Still the reference for scalable locking.
15. **Wait-Free Synchronization** — Maurice Herlihy · ACM TOPLAS 1991 · 26pp · [DOI](https://doi.org/10.1145/114005.102808) · [PDF](https://cs.brown.edu/~mph/Herlihy91/p124-herlihy.pdf). Establishes the consensus hierarchy — which primitives (test-and-set, compare-and-swap) can build wait-free objects — the theoretical foundation of lock-free programming.
16. **Simple, Fast, and Practical Non-Blocking and Blocking Concurrent Queue Algorithms** — Maged Michael, Michael Scott · PODC 1996 · 9pp · [DOI](https://doi.org/10.1145/248052.248106) · [PDF](https://www.cs.rochester.edu/u/scott/papers/1996_PODC_queues.pdf). The Michael-Scott queue: the lock-free queue that actually ships (it is in java.util.concurrent). Where the theory meets a data structure people use.
17. **Read-Copy Update: Using Execution History to Solve Concurrency Problems** — Paul McKenney, John Slingwine · PDCS 1998 · 10pp · [PDF](http://www.rdrop.com/users/paulmck/RCU/rclockpdcsproof.pdf). RCU: readers run with near-zero overhead while updates publish new versions and defer reclamation until old readers finish. Now pervasive in the Linux kernel.
    - **What is RCU, Fundamentally?** — Paul McKenney, Jonathan Walpole · [LWN](https://lwn.net/Articles/262464/). The gentle introduction to grace periods and publish-subscribe, before the formal paper.

### Transactional memory
*Raising the abstraction: let the hardware make critical sections atomic instead of hand-rolled locks.*
18. **Transactional Memory: Architectural Support for Lock-Free Data Structures** — Maurice Herlihy, J. Eliot B. Moss · ISCA 1993 · 12pp · [DOI](https://doi.org/10.1145/165123.165164) · [PDF](https://courses.csail.mit.edu/6.895/fall03/handouts/papers/HerlihyMo93.pdf). Launched hardware transactional memory: a small set of coherence extensions that make a block of accesses atomic. Two decades later it shipped as Intel TSX.
19. **Transactional Memory Coherence and Consistency (TCC)** — Lance Hammond, Vicky Wong, Mike Chen, Christos Kozyrakis, Kunle Olukotun, et al. · ISCA 2004 · 12pp · [DOI](https://doi.org/10.1145/1028176.1006711) · [PDF](https://csl.stanford.edu/~christos/publications/2004.tcc.isca.pdf). The bold version: make transactions the *only* unit of coherence and consistency, replacing both cache coherence and the memory model at once.

### The multicore substrate and its wall
*The chips that made all of this everyday, and the energy limit that ended the free lunch.*
20. **Simultaneous Multithreading: Maximizing On-Chip Parallelism** — Dean Tullsen, Susan Eggers, Henry Levy · ISCA 1995 · 12pp · [DOI](https://doi.org/10.1145/223982.224449) · [PDF](https://www.cs.sfu.ca/~alaa/courses/cmpt450/fall2022/papers/tullsen-isca-1995.pdf). SMT: interleave several threads to fill a superscalar core's idle issue slots. The idea behind Intel Hyper-Threading and shared-memory parallelism on a single core.
21. **The Case for a Single-Chip Multiprocessor** — Kunle Olukotun, Basem Nayfeh, Lance Hammond, Ken Wilson, Kunyung Chang · ASPLOS 1996 · 10pp · [DOI](https://doi.org/10.1145/237090.237140) · [PDF](http://arsenalfc.stanford.edu/kunle/publications/hydra_ASPLOS_VII.pdf). Argues — years early — that many simple cores on one die beat one ever-wider core. The multicore turn, and why coherence and consistency became everyone's problem.
22. **Dark Silicon and the End of Multicore Scaling** — Hadi Esmaeilzadeh, Emily Blem, Renée St. Amant, Karthikeyan Sankaralingam, Doug Burger · ISCA 2011 · 12pp · [DOI](https://doi.org/10.1145/2000064.2000108) · [PDF](https://research.cs.wisc.edu/vertical/papers/2011/isca11-darksilicon.pdf). The utilization wall: with the end of Dennard scaling, a growing fraction of a chip must stay dark, capping the multicore free lunch and forcing specialization.

<!--html-->
<div class="why">
<b>The through-line.</b> Sequential consistency (Lamport) sets the ideal. Coherence
(Censier-Feautrier, Goodman, Papamarcos-Patel, DASH) makes a single location behave;
relaxed models (weak ordering, release consistency, TSO, the C++ model) trade strictness
for speed while keeping data-race-free programs correct. Software then coordinates with
scalable locks (MCS), lock-free structures, and RCU, or steps up to transactional memory.
All of it became everyone's problem once the single-chip multiprocessor arrived — and
Dark Silicon marks where simply adding cores stopped paying off.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **A Primer on Memory Consistency and Cache Coherence** — Vijay Nagarajan, Daniel Sorin, Mark Hill, David Wood · 2nd ed 2020 · 296pp · [PDF](https://pages.cs.wisc.edu/~markhill/papers/primer2020_2nd_edition.pdf). The definitive, open-access text on both halves of this topic; start here if you want a coherent narrative rather than papers.
- **FREE** **Is Parallel Programming Hard, And, If So, What Can You Do About It?** — Paul McKenney · 2023 · 662pp · [PDF](https://mirrors.edge.kernel.org/pub/linux/kernel/people/paulmck/perfbook/perfbook.2023.06.11a.pdf). Real-world scalable synchronization, memory ordering, and RCU from the Linux kernel's chief RCU maintainer.
- **BUY** **The Art of Multiprocessor Programming** — Maurice Herlihy, Nir Shavit, Victor Luchangco, Michael Spear · 2nd ed 2020 · 576pp · [page](https://shop.elsevier.com/books/the-art-of-multiprocessor-programming/herlihy/978-0-12-415950-1). Synchronization, lock-free data structures, and transactional memory from the theory up.

## Key terms

- **coherence** — every processor sees a single value for each memory location, with writes to it serialized into one order.
- **consistency (memory model)** — the rules for how reads and writes to *different* locations may be reordered and observed across processors.
- **sequential consistency (SC)** — the result is as if all operations ran in one interleaving that respects each thread's program order.
- **snooping** — cache controllers watch a shared bus to observe others' accesses and update their line state.
- **directory** — a per-block record of which caches hold a copy, letting coherence scale without broadcast.
- **MESI / MOESI** — cache-line state protocols (Modified, Owned, Exclusive, Shared, Invalid) that cut coherence traffic.
- **write buffer** — a queue that lets a processor retire a store before it reaches memory; a primary source of reordering.
- **release consistency** — a relaxed model that orders memory only at acquire and release synchronization points.
- **data-race-free (DRF)** — a program that synchronizes every conflicting access; DRF programs see SC even on relaxed hardware.
- **transactional memory** — hardware or software support that makes a block of memory operations appear atomic.
- **lock-free / wait-free** — progress guarantees for concurrent algorithms that avoid mutual-exclusion locks.
- **RCU** — read-copy-update; readers run with near-zero overhead while updates publish new versions and defer reclamation.
- **dark silicon** — the fraction of a chip that must stay powered off at once because of energy limits.
