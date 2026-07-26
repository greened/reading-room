# Computer architecture · Memory systems & storage

The whole field is one idea repeated at every scale: a small fast store backed by
a large slow one, managed so the fast store almost always has what you need. These
papers walk that idea from the top down — the founding notion of an automatic
hierarchy and the tools to reason about it, then a single cache (avoiding and hiding
misses), replacement policy, on-chip scaling, DRAM main memory, address translation,
and finally the storage stack from disk through flash to persistent and
disaggregated memory. Read them in the order below rather than by date; each section
says why it sits where it does.

> **How to read this list.** Start with Atlas, Bélády, Mattson, and Smith to get the
> vocabulary and the *measurement* mindset — miss ratios, stack distance, and the
> optimal bound everything else is judged against. After that each section descends
> one level down the hierarchy, so a mechanism you meet early (prefetch, replacement,
> scheduling) shows up again, transformed, in flash FTLs and memory controllers later.

## Reading order

### The memory hierarchy, from first principles
*Begin with the idea that a two-level store can be managed automatically, and with the tools for reasoning about any hierarchy — everything below is an instance of this.*
1. **One-Level Storage System (Atlas)** — Kilburn, Edwards, Lanigan, Sumner · IRE Trans. Electronic Computers 1962 · 12pp · [DOI](https://doi.org/10.1109/TEC.1962.5219356) · [PDF](https://www.dcs.gla.ac.uk/~wpc/grcs/kilburn.pdf). The origin of virtual memory and demand paging: make core + drum look like one large store to the programmer. Every hierarchy since is this trick repeated.
2. **A Study of Replacement Algorithms for a Virtual-Storage Computer (MIN)** — László Bélády · IBM Systems Journal 1966 · 24pp · [DOI](https://doi.org/10.1147/sj.52.0078). Defines the optimal offline replacement policy (evict the line reused farthest in the future) — the unbeatable bound every real cache policy is measured against.
3. **Evaluation Techniques for Storage Hierarchies** — Mattson, Gecsei, Slutz, Traiger · IBM Systems Journal 1970 · 40pp · [DOI](https://doi.org/10.1147/sj.92.0078). Stack distances and the inclusion property: one pass over a trace yields the miss ratio for *all* cache sizes at once. Still how cache studies are run.
4. **Cache Memories** — Alan Jay Smith · ACM Computing Surveys 1982 · 58pp · [DOI](https://doi.org/10.1145/356887.356892) · [PDF](https://home.engineering.iastate.edu/~zzhang/courses/cpre581-f05/reading/smith-csur82-cache.pdf). The survey that systematized cache design — fetch, placement, replacement, line size, write policy, splits. The single best foundation for everything that follows.

### Making one cache fast
*With the hierarchy in place, the game becomes avoiding and hiding misses in a single cache.*
5. **Lockup-Free Instruction Fetch/Prefetch Cache Organization** — David Kroft · ISCA 1981 · 7pp · [DOI](https://dl.acm.org/doi/10.5555/800052.801868) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-F03/handouts/papers/p195-kroft.pdf). Miss Status Holding Registers: let a cache keep serving hits while misses are outstanding. Non-blocking caches are the reason out-of-order cores tolerate memory latency at all.
6. **Improving Direct-Mapped Cache Performance by Adding a Small Fully-Associative Cache and Prefetch Buffers** — Norman P. Jouppi · ISCA 1990 · 10pp · [DOI](https://doi.org/10.1109/ISCA.1990.134547) · [PDF](http://bitsavers.trailing-edge.com/pdf/dec/tech_reports/WRL-TN-14.pdf). Victim caches remove conflict misses cheaply; stream buffers prefetch sequential lines. Two ideas that still ship in real caches.
7. **Effective Hardware-Based Data Prefetching for High-Performance Processors** — Tien-Fu Chen, Jean-Loup Baer · IEEE Trans. Computers 1995 · 15pp · [DOI](https://doi.org/10.1109/12.381947). The Reference Prediction Table: learn per-instruction access *strides* and prefetch ahead of them. The canonical stride prefetcher.
8. **Prefetching Using Markov Predictors** — Doug Joseph, Dirk Grunwald · ISCA 1997 · 12pp · [DOI](https://doi.org/10.1145/264107.264207) · [PDF](https://safari.ethz.ch/architecture/fall2022/lib/exe/fetch.php?media=joseph_isca97.pdf). When accesses aren't strided, learn the *correlation* between misses. The bridge from regular to irregular prefetching.

### Choosing what to keep
*Given a fixed cache, replacement and insertion policy is where large, near-free wins hide.*
9. **Adaptive Insertion Policies for High Performance Caching (DIP)** — Qureshi, Jaleel, Patt, Steely, Emer · ISCA 2007 · 11pp · [DOI](https://doi.org/10.1145/1273440.1250709) · [PDF](https://www.jaleels.org/ajaleel/publications/isca2007-dip.pdf). Set dueling picks between LRU and a thrash-resistant insertion policy at run time — near-zero hardware, big wins on scans and thrashing.
10. **High Performance Cache Replacement Using Re-Reference Interval Prediction (RRIP)** — Jaleel, Theobald, Steely, Emer · ISCA 2010 · 12pp · [DOI](https://doi.org/10.1145/1815961.1815971) · [PDF](https://www.jaleels.org/ajaleel/publications/isca2010-rrip.pdf). Predict *when* a line will be reused instead of just tracking recency; SRRIP/DRRIP are scan- and thrash-resistant and now common in real LLCs.

### Scaling the on-chip cache
*Once a cache spans a chip, wire delay turns a monolithic array into a network — location becomes latency.*
11. **An Adaptive, Non-Uniform Cache Structure (NUCA)** — Changkyu Kim, Doug Burger, Steve Keckler · ASPLOS 2002 · 12pp · [DOI](https://doi.org/10.1145/605397.605420) · [PDF](https://users.cs.utah.edu/~rajeev/cs7810/papers/kim02.pdf). A large cache as a network of banks with distance-dependent latency, migrating hot lines closer. The model for every modern many-banked last-level cache.

### Main memory: DRAM scheduling, stacking, reliability
*Off-chip DRAM has physical state — the order you issue requests, the geometry you build, and the ways it fails all shape performance.*
- **Watch first — Main Memory and DRAM Basics (Onur Mutlu, CMU 18-447)** — [lecture video](https://www.youtube.com/watch?v=ZLCy3pG7Rc0). Banks, rows, and DRAM timing, and why request ordering matters — the backdrop for the three papers below.
12. **Memory Access Scheduling** — Rixner, Dally, Kapasi, Mattson, Owens · ISCA 2000 · 11pp · [DOI](https://doi.org/10.1109/ISCA.2000.854384) · [PDF](https://www.cs.rice.edu/CS/Architecture/docs/rixner-isca00.pdf). Reorder DRAM references (FR-FCFS) to exploit open rows and bank parallelism. The foundation of every memory controller scheduler since.
13. **Parallelism-Aware Batch Scheduling** — Onur Mutlu, Thomas Moscibroda · ISCA 2008 · 12pp · [DOI](https://doi.org/10.1109/ISCA.2008.7) · [PDF](https://people.inf.ethz.ch/omutlu/pub/parbs_isca08.pdf). When many cores share DRAM, naive scheduling starves threads; PAR-BS batches requests for fairness *and* bank-level parallelism.
14. **3D-Stacked Memory Architectures for Multi-Core Processors** — Gabriel H. Loh · ISCA 2008 · 12pp · [DOI](https://doi.org/10.1109/ISCA.2008.15) · [PDF](https://www.cs.cmu.edu/~18742/papers/Loh2008.pdf). Stack DRAM dies on the processor over through-silicon vias for enormous bandwidth. The architecture that became High-Bandwidth Memory (HBM).
15. **Flipping Bits in Memory Without Accessing Them (RowHammer)** — Kim, Daly, Kim, Fallin, Lee, Lee, Wilkerson, Lai, Mutlu · ISCA 2014 · 12pp · [DOI](https://doi.org/10.1145/2678373.2665726) · [PDF](https://people.inf.ethz.ch/omutlu/pub/dram-row-hammer_isca14.pdf). Hammering one DRAM row flips bits in its neighbors — a scaling reliability flaw that became a security problem.
   - **Companion** — [Exploiting the DRAM rowhammer bug](https://googleprojectzero.blogspot.com/2015/03/exploiting-dram-rowhammer-bug-to-gain.html). Google Project Zero's writeup turning RowHammer into a kernel-privilege exploit — the paper's consequences, made concrete.

### Address translation
*The hierarchy only feels like "one level" if translation is cheap; TLBs and page-walk caching keep it so.*
16. **Translation Caching: Skip, Don't Walk (the Page Table)** — Thomas Barr, Alan Cox, Scott Rixner · ISCA 2010 · 12pp · [DOI](https://doi.org/10.1145/1815961.1815970) · [PDF](https://www.cs.rice.edu/CS/Architecture/docs/barr-isca10.pdf). A taxonomy of MMU caches that shortcut the radix-tree page walk. Why TLB misses stay cheap as address spaces and virtualization deepen the page table.

### The storage stack: disk, flash, persistent memory
*Below DRAM the same hierarchy ideas meet mechanical latency, flash's erase-before-write, and byte-addressable non-volatile memory.*
17. **A Case for Redundant Arrays of Inexpensive Disks (RAID)** — David Patterson, Garth Gibson, Randy Katz · SIGMOD 1988 · 8pp · [DOI](https://doi.org/10.1145/50202.50214) · [PDF](https://www.cs.cmu.edu/~garth/RAIDpaper/Patterson88.pdf). Trade many cheap disks for the reliability and bandwidth of one expensive one. The taxonomy (RAID 0–5) that named the storage-reliability design space.
18. **The Design and Implementation of a Log-Structured File System** — Mendel Rosenblum, John Ousterhout · ACM TOCS 1992 · 27pp · [DOI](https://doi.org/10.1145/146941.146943) · [PDF](https://web.stanford.edu/~ouster/cgi-bin/papers/lfs.pdf). Treat the disk as an append-only log to make writes sequential. The copy-on-write idea behind modern flash, WAFL, and ZFS-style file systems.
19. **Design Tradeoffs for SSD Performance** — Agrawal, Prabhakaran, Wobber, Davis, Manasse, Panigrahy · USENIX ATC 2008 · 14pp · [PDF](https://www.usenix.org/legacy/events/usenix08/tech/full_papers/agrawal/agrawal.pdf). How an SSD's internal parallelism, mapping, and cleaning interact — the systems framing of what a flash device actually is.
20. **DFTL: A Flash Translation Layer Employing Demand-Based Selective Caching of Page-Level Address Mappings** — Aayush Gupta, Youngjae Kim, Bhuvan Urgaonkar · ASPLOS 2009 · 12pp · [DOI](https://doi.org/10.1145/1508284.1508271) · [PDF](https://pdfs.semanticscholar.org/5016/c8c7f2795f9f6828edbedd0f1a587863ea6d.pdf). The reference demand-paged FTL: keep only hot address mappings on-chip. How SSDs hide erase-before-write and wear behind a block interface.
21. **Architecting Phase Change Memory as a Scalable DRAM Alternative** — Benjamin Lee, Engin Ipek, Onur Mutlu, Doug Burger · ISCA 2009 · 12pp · [DOI](https://doi.org/10.1145/1555754.1555758) · [PDF](https://www.seas.upenn.edu/~leebcc/documents/lee2009-isca.pdf). Makes slow, wear-limited PCM viable as main memory via buffering, partial writes, and wear management. The paper that put non-volatile main memory on the architecture agenda.
22. **Better I/O Through Byte-Addressable, Persistent Memory (BPFS)** — Condit, Nightingale, Frost, Ipek, Lee, Burger, Coetzee · SOSP 2009 · 14pp · [DOI](https://doi.org/10.1145/1629575.1629589) · [PDF](https://www.sigops.org/s/conferences/sosp/2009/papers/condit-sosp09.pdf). A file system for byte-addressable NVM with an atomic-update discipline (short-circuit shadow paging) — an early, influential persistent-memory consistency model.

### Beyond the box: disaggregation
*The last move detaches memory from the server and reaches it across a fabric.*
23. **Disaggregated Memory for Expansion and Sharing in Blade Servers** — Lim, Chang, Mudge, Ranganathan, Reinhardt, Wenisch · ISCA 2009 · 12pp · [DOI](https://doi.org/10.1145/1555754.1555789) · [PDF](https://safari.ethz.ch/architecture/fall2021/lib/exe/fetch.php?media=isca09-disaggregate.pdf). A network-attached "memory blade" that servers page into — the architectural root of today's CXL and rack-scale memory pooling.

<!--html-->
<div class="why">
<b>One idea, every scale.</b> A cache line, a DRAM row buffer, a TLB entry, an FTL
mapping, and a paged-in remote blade are all the same move: a small fast tier caching
a large slow one. The recurring levers — <em>what to fetch</em> (prefetch),
<em>what to keep</em> (replacement/insertion), <em>what order to service</em>
(scheduling), and <em>how to translate</em> (paging/FTL) — reappear top to bottom.
Read the list and you're really learning one mechanism five times.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Operating Systems: Three Easy Pieces** — Remzi & Andrea Arpaci-Dusseau · 2018 · 700pp · [book](https://pages.cs.wisc.edu/~remzi/OSTEP/). Free, superbly clear chapters on paging & TLBs, RAID, log-structured file systems, and flash-based SSDs — the systems-side companion to the hardware papers above.
- **BUY** **Computer Architecture: A Quantitative Approach** — John Hennessy, David Patterson · 6th ed. 2017 · 936pp · [page](https://shop.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1). Chapter 2 and Appendix B are the standard textbook treatment of caches and the memory hierarchy.
- **BUY** **Memory Systems: Cache, DRAM, Disk** — Bruce Jacob, Spencer Ng, David Wang · 2007 · 1017pp · [page](https://shop.elsevier.com/books/memory-systems/jacob/978-0-12-379751-3). The most thorough single reference on the entire memory-and-storage stack, from SRAM cells to disk mechanics.

## Key terms

- **miss ratio** — fraction of accesses not satisfied by a cache level; the primary figure of merit throughout.
- **stack distance** — how many distinct lines were touched since a line's last use; the basis of one-pass, all-sizes miss-ratio simulation.
- **MIN / Bélády's optimal** — the unrealizable policy that evicts the line reused farthest in the future; the lower bound on misses.
- **MSHR** — Miss Status Holding Register; lets a non-blocking cache track outstanding misses and keep serving hits.
- **victim cache** — a small fully-associative buffer holding recently evicted lines to undo conflict misses.
- **stream buffer** — a prefetch queue that runs ahead of sequential accesses without polluting the cache.
- **stride / Markov prefetch** — predicting future addresses from constant strides, or from learned miss-to-miss correlations.
- **insertion / replacement policy** — where a new line enters the recency order (DIP) and which line leaves (LRU, RRIP).
- **NUCA** — Non-Uniform Cache Architecture; a banked cache where hit latency depends on a line's physical distance.
- **row buffer** — the sense-amp latch holding an open DRAM row; a hit here is far faster than opening a new row.
- **FR-FCFS** — First-Ready, First-Come-First-Served; the DRAM scheduling policy that prioritizes row-buffer hits.
- **bank-level parallelism** — overlapping accesses to independent DRAM banks to hide activation/precharge latency.
- **RowHammer** — repeated activations of one DRAM row flipping bits in adjacent rows; a reliability and security flaw.
- **TLB / page-walk cache** — hardware that caches virtual-to-physical translations and intermediate page-table nodes.
- **RAID** — Redundant Array of Inexpensive Disks; striping plus parity for bandwidth and fault tolerance.
- **log-structured** — writing all updates sequentially to an append-only log, cleaning free space in the background.
- **FTL** — Flash Translation Layer; the SSD firmware mapping logical blocks onto flash pages, hiding erase-before-write.
- **write amplification / wear leveling** — extra physical writes caused by flash cleaning, and spreading them to prolong device life.
- **PCM / persistent memory** — non-volatile, byte-addressable memory (e.g. phase-change) usable as slow, durable main memory.
- **memory disaggregation** — detaching memory from the server so it can be pooled and shared across a fabric (e.g. CXL).
</content>
</invoke>
