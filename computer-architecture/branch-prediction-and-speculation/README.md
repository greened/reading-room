# Computer architecture · Branch prediction & speculation

Keeping deep pipelines fed: dynamic branch prediction and data-value speculation.

- **A Study of Branch Prediction Strategies** — James E. Smith, 1981, ISCA. The founding taxonomy; the saturating bimodal counter. [DOI](https://doi.org/10.5555/800052.801871) · [PDF](https://www.cs.binghamton.edu/~ghose/CS522/papers/smith81isca.pdf)
- **Two-Level Adaptive Training Branch Prediction** — Yeh, Patt, 1991, MICRO-24. History-register + pattern-table prediction; the template for correlating predictors. [DOI](https://doi.org/10.1145/123465.123475)
- **Combining Branch Predictors** — Scott McFarling, 1993, DEC WRL TN-36. Defined gshare and the tournament/combining predictor. [page](https://www.hpl.hp.com/techreports/Compaq-DEC/WRL-TN-36.html) · [PDF](https://www.ece.ucdavis.edu/~akella/270W05/mcfarling93combining.pdf)
- **Dynamic Branch Prediction with Perceptrons** — Jiménez, Lin, 2001, HPCA-7. The first neural (perceptron) predictor exploiting very long histories. [DOI](https://doi.org/10.1109/HPCA.2001.903263)
- **A Case for (Partially) Tagged Geometric History Length Branch Prediction (TAGE)** — Seznec, Michaud, 2006, JILP. Multiple geometric-length tagged tables; still the accuracy benchmark. [HAL](https://inria.hal.science/hal-03408381)
- **Value Locality and Load Value Prediction** — Lipasti, Wilkerson, Shen, 1996, ASPLOS-VII. Introduced value locality and load-value prediction. [DOI](https://doi.org/10.1145/237090.237173)
- **Exceeding the Dataflow Limit via Value Prediction** — Lipasti, Shen, 1996, MICRO-29. Predicting results to surpass the true-dependence (dataflow) ILP limit. [DOI](https://doi.org/10.5555/243846.243889)
- **Multiscalar Processors** — Sohi, Breach, Vijaykumar, 1995, ISCA. The speculative-multithreading paradigm: tasks executed speculatively in parallel. [DOI](https://doi.org/10.1145/223982.224451) · [PDF](https://ftp.cs.wisc.edu/sohi/papers/1995/isca.multiscalar.pdf)
