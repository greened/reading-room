# Computer architecture · Hardware security

Microarchitectural side channels and transient-execution attacks — from timing
and power analysis through cache attacks, RowHammer, and Spectre/Meltdown.

- **Timing Attacks on Implementations of Diffie-Hellman, RSA, DSS, and Other Systems** — Paul C. Kocher, 1996, CRYPTO. Founded timing side-channel attacks. [DOI](https://doi.org/10.1007/3-540-68697-5_9)
- **Differential Power Analysis** — Kocher, Jaffe, Jun, 1999, CRYPTO. Power traces leak cryptographic keys. [DOI](https://doi.org/10.1007/3-540-48405-1_25)
- **Cache Attacks and Countermeasures: The Case of AES** — Osvik, Shamir, Tromer, 2006, CT-RSA. Systematized cache-timing attacks (incl. Prime+Probe). [DOI](https://doi.org/10.1007/11605805_1)
- **Flipping Bits in Memory Without Accessing Them (RowHammer)** — Kim, Daly, Kim, et al., 2014, ISCA. Repeated DRAM row access flips bits in adjacent rows. [DOI](https://doi.org/10.1145/2678373.2665726)
- **FLUSH+RELOAD: A High Resolution, Low Noise, L3 Cache Side-Channel Attack** — Yarom, Falkner, 2014, USENIX Security. A precise shared-cache channel underpinning many later attacks. [page](https://www.usenix.org/conference/usenixsecurity14/technical-sessions/presentation/yarom)
- **Last-Level Cache Side-Channel Attacks are Practical** — Liu, Yarom, Ge, Heiser, Lee, 2015, IEEE S&P. Practical cross-core/cross-VM Prime+Probe via the shared LLC. [DOI](https://doi.org/10.1109/SP.2015.43)
- **Meltdown: Reading Kernel Memory from User Space** — Lipp, Schwarz, Gruss, et al., 2018, USENIX Security. Out-of-order execution reads protected kernel memory. [page](https://www.usenix.org/conference/usenixsecurity18/presentation/lipp) · [PDF](https://arxiv.org/pdf/1801.01207)
- **Foreshadow: Extracting the Keys to the Intel SGX Kingdom** — Van Bulck, Minkin, Weisse, et al., 2018, USENIX Security. An L1TF transient-execution attack defeating SGX. [page](https://www.usenix.org/conference/usenixsecurity18/presentation/van-bulck)
- **Spectre Attacks: Exploiting Speculative Execution** — Kocher, Horn, Fogh, et al., 2019, IEEE S&P. Speculation steered to leak secrets across boundaries — a new attack class. [DOI](https://doi.org/10.1109/SP.2019.00002) · [PDF](https://arxiv.org/pdf/1801.01203)
