# Computer architecture · Superscalar & out-of-order execution

The datapath of high-performance cores: dynamic scheduling, register renaming,
precise state, wide issue, and the limits of instruction-level parallelism.

- **An Efficient Algorithm for Exploiting Multiple Arithmetic Units** — Robert M. Tomasulo, 1967, IBM J. R&D. Reservation stations + register renaming + the common data bus. [DOI](https://doi.org/10.1147/rd.111.0025) · [PDF](https://www.cs.virginia.edu/~evans/greatworks/tomasulo.pdf)
- **Parallel Operation in the Control Data 6600** — James E. Thornton, 1964, AFIPS. The CDC 6600 scoreboard: the first dynamic instruction scheduling. [DOI](https://doi.org/10.1145/1464039.1464045)
- **Implementation of Precise Interrupts in Pipelined Processors** — Smith, Pleszkun, 1985, ISCA. The reorder buffer and precise interrupts (in-order retirement). [DOI](https://doi.org/10.1145/327070.327125) · [PDF](https://courses.cs.washington.edu/courses/cse590g/04sp/Smith-1985-Implementation-of-Precise-Interrupts-in-Pipelined-Processors.pdf)
- **HPS, a New Microarchitecture: Rationale and Introduction** — Patt, Hwu, Shebanow, 1985, MICRO-18. Restricted dataflow: the blueprint for aggressive OoO speculation. [DOI](https://doi.org/10.1145/18927.18916)
- **Superscalar Microprocessor Design** — Mike Johnson, 1991, Prentice Hall. The first book systematizing fetch/rename/dispatch/completion. (ISBN 0-13-875634-1)
- **The Microarchitecture of Superscalar Processors** — Smith, Sohi, 1995, Proceedings of the IEEE. The canonical survey defining the field's vocabulary. [DOI](https://doi.org/10.1109/5.476078)
- **Limits of Instruction-Level Parallelism** — David W. Wall, 1991, ASPLOS-IV. The landmark limit study on realistically available ILP. [DOI](https://doi.org/10.1145/106972.106991)
- **Memory Dependence Prediction Using Store Sets** — Chrysos, Emer, 1998, ISCA. Store-sets memory disambiguation for accurate speculative load/store reordering. [DOI](https://doi.org/10.1145/279361.279378)
