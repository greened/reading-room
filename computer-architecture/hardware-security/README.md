# Computer architecture · Hardware security

How secrets leak out of the microarchitecture, and how hardware tries to hold them
in. The path runs from the original crypto side channels (timing, power) through the
reusable cache primitives that made those attacks routine, to Rowhammer's bit flips,
the transient-execution earthquake of Meltdown and Spectre and the MDS aftershocks,
the hardware defenses that answer them, and finally the positive side of the ledger —
trusted-execution enclaves, roots of trust, and constant-time code. Read it in that
order: each attack class assumes the primitives of the one before, and the defenses
only make sense once you have seen what they must stop.

> **How to read this list.** Three attacker moves recur. A *side channel* only
> *observes* — it times a cache line or measures power to infer a secret. A *fault
> attack* (Rowhammer) *disturbs* — it corrupts memory the CPU never let it write. A
> *transient-execution attack* (Meltdown, Spectre, MDS) makes the CPU *compute on a
> secret it will roll back*, then reads the trace left behind. Keep asking which move
> a paper uses; the defenses are organized the same way.

### Foundations: timing and power leak secrets
*Start here — the original side channels, before caches entered the picture: computation takes time and draws power, and both depend on the key.*
1. **Timing Attacks on Implementations of Diffie-Hellman, RSA, DSS, and Other Systems** — Paul Kocher · CRYPTO 1996 · 10pp · [DOI](https://doi.org/10.1007/3-540-68697-5_9) · [PDF](https://paulkocher.com/doc/TimingAttacks.pdf). Founded the field: the time a modular exponentiation takes depends on the secret exponent, so measuring it recovers the key.
2. **Differential Power Analysis** — Kocher, Jaffe, Jun · CRYPTO 1999 · 10pp · [DOI](https://doi.org/10.1007/3-540-48405-1_25) · [PDF](https://paulkocher.com/doc/DifferentialPowerAnalysis.pdf). A device's power draw leaks the bits it is manipulating; statistics over many traces pull the key out of the noise. The reason "leakage" is now a hardware design constraint.
3. **Cache-timing Attacks on AES** — Daniel J. Bernstein · tech report 2005 · 37pp · [PDF](https://cr.yp.to/antiforgery/cachetiming-20050414.pdf). The wake-up call that table-lookup AES is not constant-time: cache hits and misses on the S-box tables leak the key. Motivates everything in the next section.

### Cache side channels: the reusable primitives
*These techniques turn the shared cache into a general-purpose probe; almost every later attack, including Spectre, uses one of them as its readout.*
4. **Cache Missing for Fun and Profit** — Colin Percival · BSDCan 2005 · 13pp · [PDF](https://www.daemonology.net/papers/htt.pdf). Simultaneous multithreading lets one thread spy on another's cache footprint — the first practical, general cache side channel.
5. **Cache Attacks and Countermeasures: The Case of AES** — Osvik, Shamir, Tromer · CT-RSA 2006 · 25pp · [DOI](https://doi.org/10.1007/11605805_1) · [PDF](https://cs.tau.ac.il/~tromer/papers/cache.pdf). Systematized cache attacks and named **Prime+Probe**: fill a cache set, let the victim run, then time your own lines to see which it evicted.
6. **FLUSH+RELOAD: A High Resolution, Low Noise, L3 Cache Side-Channel Attack** — Yarom, Falkner · USENIX Security 2014 · 15pp · [page](https://www.usenix.org/conference/usenixsecurity14/technical-sessions/presentation/yarom) · [PDF](https://www.usenix.org/system/files/conference/usenixsecurity14/sec14-paper-yarom.pdf). The sharpest primitive: flush a shared (deduplicated) line, wait, then time its reload to learn whether the victim touched it. The readout channel behind Meltdown and Spectre.
7. **Last-Level Cache Side-Channel Attacks are Practical** — Liu, Yarom, Ge, Heiser, Lee · IEEE S&P 2015 · 18pp · [DOI](https://doi.org/10.1109/SP.2015.43) · [PDF](https://web.archive.org/web/2019id_/https://palms.ee.princeton.edu/system/files/SP_vfinal.pdf). Lifts Prime+Probe to the shared last-level cache, so it works cross-core and cross-VM without shared memory — the cloud threat model.
8. **Cache Template Attacks: Automating Attacks on Inclusive Last-Level Caches** — Gruss, Spreitzer, Mangard · USENIX Security 2015 · 17pp · [page](https://www.usenix.org/conference/usenixsecurity15/technical-sessions/presentation/gruss) · [PDF](https://www.usenix.org/system/files/conference/usenixsecurity15/sec15-paper-gruss.pdf). Profiles which addresses leak what, automating Flush+Reload against arbitrary binaries — keystroke timing, crypto, and more.
9. **Flush+Flush: A Fast and Stealthy Cache Attack** — Gruss, Maurice, Wagner, Mangard · DIMVA 2016 · 21pp · [DOI](https://doi.org/10.1007/978-3-319-40667-1_14) · [PDF](https://arxiv.org/pdf/1511.04594). Attacks (and builds covert channels) using only the timing of the flush instruction itself, causing no cache misses — a direct answer to miss-counting detectors.

### Rowhammer: when reading memory rewrites it
*A different move entirely — not observing state but corrupting it. Placed after the cache section because the exploits reuse cache-eviction tricks to hammer fast.*
10. **Flipping Bits in Memory Without Accessing Them: RowHammer** — Kim, Daly, Kim, Mutlu, et al. · ISCA 2014 · 12pp · [DOI](https://doi.org/10.1145/2678373.2665726) · [PDF](https://users.ece.cmu.edu/~yoonguk/papers/kim-isca14.pdf). Hammering one DRAM row flips bits in its neighbors — a reliability defect that is really a security hole.
    - **Exploiting the DRAM rowhammer bug to gain kernel privileges** — [Project Zero](https://googleprojectzero.blogspot.com/2015/03/exploiting-dram-rowhammer-bug-to-gain.html). Seaborn and Dullien turned the defect into a working privilege-escalation exploit — the moment Rowhammer became a weapon.
11. **Flip Feng Shui: Hammering a Needle in the Software Stack** — Razavi, Gras, Bosman, Preneel, Giuffrida, Bos · USENIX Security 2016 · 19pp · [page](https://www.usenix.org/conference/usenixsecurity16/technical-sessions/presentation/razavi) · [PDF](https://www.usenix.org/system/files/conference/usenixsecurity16/sec16_paper_razavi.pdf). Uses memory deduplication to place a victim's page over a flippable bit, then hammers to forge RSA keys — Rowhammer with surgical aim.
12. **Drammer: Deterministic Rowhammer Attacks on Mobile Platforms** — van der Veen, Fratantonio, Lindorfer, et al. · CCS 2016 · 15pp · [DOI](https://doi.org/10.1145/2976749.2978406) · [PDF](https://vvdveen.com/publications/drammer.pdf). Deterministic root on stock Android using predictable physical-memory allocation — Rowhammer escapes the lab and the x86 server.

### Transient execution: Meltdown and Spectre
*The earthquake: speculation and out-of-order execution compute on data they later discard, and the cache primitives above read the residue. Meltdown first — it is the simpler, exception-driven case.*
13. **Meltdown: Reading Kernel Memory from User Space** — Lipp, Schwarz, Gruss, et al. · USENIX Security 2018 · 16pp · [page](https://www.usenix.org/conference/usenixsecurity18/presentation/lipp) · [PDF](https://arxiv.org/pdf/1801.01207). Out-of-order execution transiently reads kernel memory before the fault retires, then leaks it through the cache — the flaw behind kernel-page-table isolation.
    - **Meltdown project site** — [meltdownattack.com](https://meltdownattack.com/). Plain-language explainer, FAQ, and proof-of-concept code from the authors.
14. **Spectre Attacks: Exploiting Speculative Execution** — Kocher, Horn, Fogh, et al. · IEEE S&P 2019 · 16pp · [DOI](https://doi.org/10.1109/SP.2019.00002) · [PDF](https://arxiv.org/pdf/1801.01203). Trains the branch predictor to speculate past a bounds check (or into a chosen gadget) and leak across a security boundary — a whole new attack class, and much harder to fix than Meltdown.
    - **Spectre project site** — [spectreattack.com](https://spectreattack.com/). The companion explainer and variant taxonomy from the disclosing team.

### Microarchitectural data sampling and enclave attacks
*The aftershocks: instead of a chosen address, sample whatever data happens to be in transit through CPU buffers — and use it to break Intel SGX.*
15. **Foreshadow: Extracting the Keys to the Intel SGX Kingdom** — Van Bulck, Minkin, Weisse, et al. · USENIX Security 2018 · 18pp · [page](https://www.usenix.org/conference/usenixsecurity18/presentation/van-bulck) · [PDF](https://foreshadowattack.eu/foreshadow.pdf). The L1 Terminal Fault: transient reads of the L1 cache pierce SGX's encryption boundary and recover the enclave's attestation keys.
16. **RIDL: Rogue In-Flight Data Load** — van Schaik, Milburn, Österlund, et al. · IEEE S&P 2019 · 20pp · [DOI](https://doi.org/10.1109/SP.2019.00087) · [PDF](https://mdsattacks.com/files/ridl.pdf). Leaks data straight from internal line-fill and load buffers with no address at all — the MDS family, independent of the address-space defenses that stopped Meltdown.
    - **MDS attacks site** — [mdsattacks.com](https://mdsattacks.com/). The unified RIDL / Fallout / ZombieLoad hub, with demos and CPU-vulnerability tables.
17. **ZombieLoad: Cross-Privilege-Boundary Data Sampling** — Schwarz, Lipp, Moghimi, et al. · CCS 2019 · 16pp · [DOI](https://doi.org/10.1145/3319535.3354252) · [PDF](https://zombieloadattack.com/zombieload.pdf). Samples data from stale fill-buffer entries across threads, processes, and enclaves — the sibling of RIDL, with a different microarchitectural source.
18. **A Systematic Evaluation of Transient Execution Attacks and Defenses** — Canella, Van Bulck, Schwarz, et al. · USENIX Security 2019 · 18pp · [page](https://www.usenix.org/conference/usenixsecurity19/presentation/canella) · [PDF](https://arxiv.org/pdf/1811.05441). The map of the whole zoo: a clean taxonomy of Meltdown- vs Spectre-type attacks and a sober assessment of which defenses actually work. Read this to consolidate the section above.

### Defending speculation in hardware
*Now the responses: if the danger is secret-dependent state left by transient instructions, hide that state or forbid it from forming.*
19. **InvisiSpec: Making Speculative Execution Invisible in the Cache Hierarchy** — Yan, Choi, Skarlatos, Morrison, Fletcher, Torrellas · MICRO 2018 · 14pp · [DOI](https://doi.org/10.1109/MICRO.2018.00042) · [PDF](http://iacoma.cs.uiuc.edu/iacoma-papers/micro18.pdf). Buffers speculative loads so they leave no cache trace until they are known safe — closing the Spectre readout channel in the microarchitecture.
20. **DAWG: A Defense Against Cache Timing Attacks in Speculative Execution** — Kiriansky, Lebedev, Amarasinghe, Devadas, Emer · MICRO 2018 · 14pp · [DOI](https://doi.org/10.1109/MICRO.2018.00083) · [PDF](https://people.csail.mit.edu/vlk/dawg-micro18.pdf). Partitions the cache into isolated ways so one security domain cannot observe another's hits and misses at all — a structural, not speculative-only, defense.
21. **Speculative Taint Tracking (STT): A Comprehensive Protection for Speculatively Accessed Data** — Yu, Yan, Khyzha, Morrison, Torrellas, Fletcher · MICRO 2019 · 15pp · [DOI](https://doi.org/10.1145/3352460.3358274) · [PDF](http://iacoma.cs.uiuc.edu/iacoma-papers/micro19_2.pdf). Taints speculatively loaded values and blocks any instruction that would turn them into an observable event — a principled, covers-all-channels answer to Spectre.

### Trusted execution: secure processors and enclaves
*The positive program: build hardware that isolates code and data even from privileged software. Read chronologically here — SGX and TrustZone are the industrial descendants of XOM and AEGIS.*
22. **Architectural Support for Copy and Tamper Resistant Software (XOM)** — Lie, Thekkath, Mitchell, et al. · ASPLOS 2000 · 10pp · [DOI](https://doi.org/10.1145/378993.379237) · [PDF](https://security.csl.toronto.edu/wp-content/uploads/2018/06/lie-asplos2000.pdf). The founding idea of an untrusted OS on trusted hardware: execute-only memory that even the operating system cannot read or tamper with.
23. **AEGIS: Architecture for Tamper-Evident and Tamper-Resistant Processing** — Suh, Clarke, Gassend, van Dijk, Devadas · ICS 2003 · 18pp · [DOI](https://doi.org/10.1145/782814.782838) · [PDF](https://csg.csail.mit.edu/pubs/memos/Memo-461/memo-461.pdf). Adds memory integrity/encryption and a physical root of trust (a PUF) to a single-chip secure processor — the template modern enclaves follow.
24. **Innovative Instructions and Software Model for Isolated Execution (Intel SGX)** — McKeen, Alexandrovich, Berenzon, et al. · HASP 2013 · 8pp · [DOI](https://doi.org/10.1145/2487726.2488368) · [PDF](https://web.archive.org/web/2019id_/http://css.csail.mit.edu/6.858/2015/readings/intel-sgx.pdf). The design note that shipped enclaves to billions of CPUs — and the target of Foreshadow above.
    - **Intel SGX Explained** — Costan, Devadas · [PDF](https://web.archive.org/web/2019id_/https://eprint.iacr.org/2016/086.pdf). A book-length (118pp) reverse-engineered reference on SGX internals; the deep dive when the 8-page note is not enough.
25. **Demystifying Arm TrustZone: A Comprehensive Survey** — Pinto, Santos · ACM Computing Surveys 2019 · 36pp · [DOI](https://doi.org/10.1145/3291047) · [PDF](https://www.dpss.inesc-id.pt/~nsantos/papers/pinto_acsur19.pdf). The other dominant TEE: the secure-world/normal-world split on Arm, its systems, and its attack surface, surveyed in one place.

### Roots of trust: PUFs, attestation, and secure boot
*Every scheme above assumes a secret the hardware can keep and a way to prove its own state. This section is where that assumption is actually cashed out.*
26. **Physical One-Way Functions** — Pappu, Recht, Taylor, Gershenfeld · Science 2002 · 5pp · [DOI](https://doi.org/10.1126/science.1074376) · [PDF](https://people.eecs.berkeley.edu/~brecht/papers/02.PapEA.powf.pdf). The origin of the PUF idea: manufacturing randomness in a physical medium gives a unique, unclonable, tamper-evident identity.
27. **Silicon Physical Random Functions** — Gassend, Clarke, van Dijk, Devadas · CCS 2002 · 13pp · [DOI](https://doi.org/10.1145/586110.586132) · [PDF](https://people.csail.mit.edu/devadas/pubs/spuf.pdf). Realizes the PUF in ordinary CMOS using gate-delay variation — the practical root of trust behind AEGIS-style key generation.
28. **Bootstrapping Trust in Commodity Computers** — Parno, McCune, Perrig · IEEE S&P 2010 · 16pp · [DOI](https://doi.org/10.1109/SP.2010.32) · [PDF](https://netsec.ethz.ch/publications/papers/PaMcPe2010.pdf). The survey that ties the room together: TPMs, measured/secure boot, and remote attestation — how a machine proves what software it is running.

### Writing code that doesn't leak: constant-time
*Hardware can hide state, but software still has to stop generating secret-dependent behavior. This closes the loop back to Bernstein's AES.*
29. **Verifying Constant-Time Implementations** — Almeida, Barbosa, Barthe, Dupressoir, Emmi · USENIX Security 2016 · 19pp · [page](https://www.usenix.org/conference/usenixsecurity16/technical-sessions/presentation/almeida) · [PDF](https://www.usenix.org/system/files/conference/usenixsecurity16/sec16_paper_almeida.pdf). Makes "constant-time" a machine-checkable property: prove that neither timing nor memory-access patterns depend on secrets.
30. **FaCT: A DSL for Timing-Sensitive Computation** — Cauligi, Soeller, Brown, et al. · PLDI 2019 · 16pp · [DOI](https://doi.org/10.1145/3314221.3314605) · [PDF](https://cseweb.ucsd.edu/~dstefan/pubs/cauligi:2019:fact.pdf). Lets you write natural code and compile it to constant-time machine code — so defending the software side does not mean hand-writing branch-free assembly.

## Reference shelf — books

- **FREE** **Security Engineering (3rd ed.), Ch. 19: Side Channels** — Ross Anderson · 2020 · 27pp · [PDF](https://www.cl.cam.ac.uk/archive/rja14/Papers/SEv3-ch19.pdf). The textbook chapter on timing, power, and emanation side channels; the whole book is free at the author's [page](https://www.cl.cam.ac.uk/archive/rja14/book.html).
- **FREE** **Security Engineering (3rd ed.), Ch. 18: Tamper Resistance** — Ross Anderson · 2020 · 39pp · [PDF](https://www.cl.cam.ac.uk/archive/rja14/Papers/SEv3-ch18.pdf). Physical tamper resistance and evidence — the systems context for PUFs, secure processors, and enclaves.
- **BUY** **The Hardware Hacking Handbook** — Colin O'Flynn, Jasper van Woudenberg · 2021 · 512pp · [page](https://nostarch.com/hardwarehacking). Hands-on power/EM side-channel analysis and fault injection — the practical companion to the DPA and constant-time papers.
- **BUY** **Power Analysis Attacks: Revealing the Secrets of Smart Cards** — Mangard, Oswald, Popp · 2007 · 338pp · [page](https://link.springer.com/book/10.1007/978-0-387-38162-6). The standard reference behind differential power analysis and its countermeasures.

## Key terms

- **side channel** — leaking a secret through a system's physical or timing behavior rather than its logical outputs.
- **covert channel** — a channel used deliberately by cooperating parties to move data past a security policy.
- **Prime+Probe** — fill a cache set, let the victim run, then re-time your own lines to detect which the victim evicted.
- **Flush+Reload** — flush a shared line, wait, then time its reload to learn whether the victim accessed it.
- **speculative execution** — running instructions before their control/data dependencies resolve, rolling back on a misprediction.
- **transient execution** — speculatively/out-of-order instructions whose architectural effects are squashed but whose microarchitectural traces persist.
- **Rowhammer** — repeatedly activating a DRAM row to induce bit flips in adjacent rows.
- **L1TF** — L1 Terminal Fault, the transient-execution flaw exploited by Foreshadow.
- **MDS** — microarchitectural data sampling: leaking in-flight data from CPU buffers (RIDL, ZombieLoad, Fallout).
- **TEE / enclave** — a hardware-isolated environment (SGX, TrustZone) that protects code and data even from privileged software.
- **PUF** — physical unclonable function: a circuit whose manufacturing variation yields a unique, unclonable challenge-response identity.
- **remote attestation** — a signed report by which a platform proves its software state to a remote verifier.
- **constant-time** — code whose timing and memory-access pattern are independent of secret data.
