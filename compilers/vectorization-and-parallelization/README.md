# Compilers · Vectorization & parallelization

Dependence-based auto-vectorization and auto-parallelization: dependence testing,
loop transforms, the polyhedral model, SIMD/SLP, work-stealing task parallelism,
and thread-level speculation.

- **Automatic Translation of FORTRAN Programs to Vector Form** — Allen, Kennedy, 1987, ACM TOPLAS. The foundational dependence-based loop vectorization framework. [DOI](https://doi.org/10.1145/29873.29875) · [PDF](http://rsim.cs.uiuc.edu/arch/qual_papers/compilers/allen87.pdf)
- **Practical Dependence Testing** — Goff, Kennedy, Tseng, 1991, PLDI. ZIV/SIV/MIV subscript tests that made dependence testing practical. [DOI](https://doi.org/10.1145/113445.113448) · [PDF](https://people.cs.rutgers.edu/~uli/cs516/spring2020/readings/PracticalDependenceTesting-PLDI1991.pdf)
- **A Data Locality Optimizing Algorithm** — Wolf, Lam, 1991, PLDI. Unimodular loop transforms + tiling for reuse and locality. [DOI](https://doi.org/10.1145/113445.113449)
- **Maximizing Multiprocessor Performance with the SUIF Compiler** — Hall, Anderson, Amarasinghe, Murphy, Liao, Bugnion, Lam, 1996, IEEE Computer. End-to-end automatic parallelization for shared-memory multiprocessors. [DOI](https://doi.org/10.1109/2.546613)
- **Maximizing Parallelism and Minimizing Synchronization with Affine Partitions** — Lim, Lam, 1998, Parallel Computing. Loop parallelization as affine partitioning. [DOI](https://doi.org/10.1016/S0167-8191(98)00021-0) · [PDF](https://suif.stanford.edu/papers/lim98.pdf)
- **The Implementation of the Cilk-5 Multithreaded Language** — Frigo, Leiserson, Randall, 1998, PLDI. The work-first principle + THE protocol; cheap work-stealing tasks. [DOI](https://doi.org/10.1145/277650.277725) · [PDF](https://pages.cs.wisc.edu/~markhill/restricted/pldi98_cilk.pdf)
- **Scheduling Multithreaded Computations by Work Stealing** — Blumofe, Leiserson, 1999, JACM. Provably efficient randomized work-stealing; the backbone of task runtimes. [DOI](https://doi.org/10.1145/324133.324234) · [PDF](https://www.csd.uwo.ca/~mmorenom/CS433-CS9624/Resources/Scheduling_multithreaded_computations_by_work_stealing.pdf)
- **Exploiting Superword Level Parallelism with Multimedia Instruction Sets (SLP)** — Larsen, Amarasinghe, 2000, PLDI. Basic-block SIMD packing; the LLVM/GCC SLP basis. [DOI](https://doi.org/10.1145/349299.349320) · [PDF](https://groups.csail.mit.edu/cag/slp/SLP-PLDI-2000.pdf)
- **A Scalable Approach to Thread-Level Speculation** — Steffan, Colohan, Zhai, Mowry, 2000, ISCA. Coherence-based TLS to speculatively parallelize sequential code. [DOI](https://doi.org/10.1145/342001.339650) · [PDF](https://www.cs.cmu.edu/~zhaia/publications/tlds_isca00.pdf)
- **Some Efficient Solutions to the Affine Scheduling Problem, Part I** — Paul Feautrier, 1992, IJPP. Loop scheduling as parametric linear programming (polyhedral foundation). [DOI](https://doi.org/10.1007/BF01407835)
- **Auto-Vectorization of Interleaved Data for SIMD** — Nuzman, Rosen, Zaks, 2006, PLDI. Vectorizing strided/interleaved accesses via pack/unpack. [DOI](https://doi.org/10.1145/1133255.1133997)
- **A Practical Automatic Polyhedral Parallelizer and Locality Optimizer (Pluto)** — Bondhugula, Hartono, Ramanujam, Sadayappan, 2008, PLDI. Cost-model affine scheduling that tiles for parallelism + locality. [DOI](https://doi.org/10.1145/1375581.1375595) · [PDF](https://www.ece.lsu.edu/jxr/Publications-pdf/pldi08.pdf)
