# Computer architecture · Memory systems & storage

Caches and replacement, on-chip cache networks, DRAM scheduling and reliability,
and the storage stack from RAID through flash and persistent memory.

- **Cache Memories** — Alan Jay Smith, 1982, ACM Computing Surveys. The foundational survey that systematized cache design. [DOI](https://doi.org/10.1145/356887.356892)
- **Improving Direct-Mapped Cache Performance by the Addition of a Small Fully-Associative Cache and Prefetch Buffers** — Norman P. Jouppi, 1990, ISCA. Victim caches and stream buffers. [DOI](https://doi.org/10.1109/ISCA.1990.134547)
- **An Adaptive, Non-Uniform Cache Structure (NUCA)** — Kim, Burger, Keckler, 2002, ASPLOS-X. A large cache as a network of banks with distance-dependent latency. [DOI](https://doi.org/10.1145/605432.605420)
- **A Case for Redundant Arrays of Inexpensive Disks (RAID)** — Patterson, Gibson, Katz, 1988, SIGMOD. The RAID taxonomy. [DOI](https://doi.org/10.1145/50202.50214)
- **Memory Access Scheduling** — Rixner, Dally, Kapasi, Mattson, Owens, 2000, ISCA. Reordering DRAM accesses to exploit bank/row state. [DOI](https://doi.org/10.1109/ISCA.2000.854384)
- **Adaptive Insertion Policies for High Performance Caching (DIP)** — Qureshi, Jaleel, Patt, Steely, Emer, 2007, ISCA. Set-dueling + dynamic insertion; thrash-resistant LRU at near-zero cost. [DOI](https://doi.org/10.1145/1273440.1250709)
- **High Performance Cache Replacement Using Re-Reference Interval Prediction (RRIP)** — Jaleel, Theobald, Steely, Emer, 2010, ISCA. SRRIP/DRRIP: scan/thrash-resistant replacement. [DOI](https://doi.org/10.1145/1815961.1815971)
- **Flipping Bits in Memory Without Accessing Them (RowHammer)** — Kim, Daly, Kim, Fallin, Lee, Lee, Wilkerson, Lai, Mutlu, 2014, ISCA. DRAM disturbance errors: a scaling reliability/security problem. [DOI](https://doi.org/10.1145/2678373.2665726)
- **The Design and Implementation of a Log-Structured File System** — Rosenblum, Ousterhout, 1992, ACM TOCS. The log-structured design behind modern flash/copy-on-write storage. [DOI](https://doi.org/10.1145/146941.146943)
- **DFTL: A Flash Translation Layer Employing Demand-Based Selective Caching of Page-Level Address Mappings** — Gupta, Kim, Urgaonkar, 2009, ASPLOS. The reference demand-paged FTL for SSDs. [DOI](https://doi.org/10.1145/1508284.1508271)
- **Better I/O Through Byte-Addressable, Persistent Memory (BPFS)** — Condit, Nightingale, Frost, Ipek, Lee, Burger, Coetzee, 2009, SOSP. An early influential NVM programming/consistency model. [DOI](https://doi.org/10.1145/1629575.1629589)
