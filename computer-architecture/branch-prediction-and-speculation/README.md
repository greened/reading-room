# Computer architecture · Branch prediction & speculation

Deep, wide pipelines only pay off if the machine can guess what comes next and
recover cheaply when it guesses wrong. This list follows that idea from the ground
up: start with the primitives every predictor still uses — the saturating counter,
the branch target buffer, and misprediction recovery — then add branch *history*
(two-level and correlating predictors), learn to *combine* predictors and fight
table aliasing, reach the modern accuracy frontier (perceptron and TAGE), turn from
predicting *direction* to predicting the *target* (returns, indirect jumps, fetch),
learn to score a prediction's *confidence*, and finally push speculation past control
flow entirely — into data values, addresses, and whole speculative threads.

> **How to read this list.** Read top to bottom: each section assumes the mechanism
> from the one before it. If you want the shape of the whole area first, read Smith's
> 1981 taxonomy and Mittal's survey (both under §1), then come back and work forward.
> Papers marked **DOI** only are paywalled; the rest have a free, legal open PDF.

### Foundations: counters, targets, and safe recovery
*Start here — the primitives every later predictor still refines: the saturating counter, the branch target buffer, and the recovery that makes speculating past a branch safe.*
1. **A Study of Branch Prediction Strategies** — James E. Smith · ISCA 1981 · 14pp · [PDF](https://www.cs.binghamton.edu/~ghose/CS522/papers/smith81isca.pdf). The founding taxonomy and the saturating 2-bit bimodal counter — the baseline every paper below is measured against.
   - **A Survey of Techniques for Dynamic Branch Prediction** — Sparsh Mittal · 2019 · 37pp · [PDF](https://arxiv.org/pdf/1804.00261). A modern map of the whole area; skim it to see where each paper here fits.
   - **Branch Prediction (ETH Zürich, Fall 2018, Lecture 9)** — Onur Mutlu · [VIDEO](https://www.youtube.com/watch?v=hl4eiN8ZMJg). A clear lecture tour of counters → two-level → gshare → perceptron → TAGE; good to watch first.
2. **Branch Prediction Strategies and Branch Target Buffer Design** — Johnny K. F. Lee, Alan Jay Smith · IEEE Computer 1984 · 17pp · [DOI](https://doi.org/10.1109/MC.1984.1658927). The systematic study that named the branch problem and defined the branch target buffer that supplies the predicted target.
3. **Checkpoint Repair for Out-of-Order Execution Machines** — Wen-mei Hwu, Yale N. Patt · ISCA 1987 · 9pp · [DOI](https://doi.org/10.1145/30350.30353) · [PDF](http://impact.crhc.illinois.edu/shared/Papers/p18-hwu.pdf). How to roll the machine back to a precise point after a misprediction — the recovery mechanism that makes aggressive speculation affordable.

### History matters: two-level and correlating predictors
*The central insight — condition the prediction on the recent pattern of outcomes, not just this branch's own bias.*
4. **Two-Level Adaptive Training Branch Prediction** — Tse-Yu Yeh, Yale N. Patt · MICRO 1991 · 11pp · [DOI](https://doi.org/10.1145/123465.123475). The history register + pattern table that lifted accuracy past the bimodal counter; the template for every correlating predictor.
5. **Improving the Accuracy of Dynamic Branch Prediction Using Branch Correlation** — Shien-Tai Pan, Kimming So, Joseph T. Rahmeh · ASPLOS 1992 · 9pp · [DOI](https://doi.org/10.1145/143365.143490) · [PDF](https://www.cs.binghamton.edu/~ghose/CS522/papers/pansorahmeh.pdf). Independent discovery that *other* branches' outcomes predict this one — correlation, the idea behind gselect.
6. **Alternative Implementations of Two-Level Adaptive Branch Prediction** — Tse-Yu Yeh, Yale N. Patt · ISCA 1992 · 11pp · [DOI](https://doi.org/10.1145/139669.139709) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-F03/handouts/papers/p451-yeh.pdf). The GAg/PAg/PAp design space: global vs. per-address history and pattern tables, with the vocabulary the field still uses.

### Combining predictors and fighting aliasing
*Real predictors mix components and spend their bits fighting table interference.*
7. **Combining Branch Predictors** — Scott McFarling · DEC WRL TN-36 1993 · 29pp · [PDF](https://www.ece.ucdavis.edu/~akella/270W05/mcfarling93combining.pdf). Defined gshare and the tournament/combining predictor that picks between components per branch — the design most 1990s cores shipped.
   - **Advanced Branch Prediction (ECE 752 lecture)** — Mikko Lipasti · 55pp · [PDF](https://ece752.ece.wisc.edu/lect09-adv-branch-prediction.pdf). Slide-level walk-through of gshare, aliasing, tournament, and neural predictors.
8. **An Analysis of Correlation and Predictability: What Makes Two-Level Branch Predictors Work** — Marius Evers, Sanjay J. Patel, Robert S. Chappell, Yale N. Patt · ISCA 1998 · 10pp · [DOI](https://doi.org/10.1145/279361.279368) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-F03/handouts/papers/p52-evers.pdf). *Why* history works — which correlations carry the predictability — turning the design from folklore into analysis.
9. **The YAGS Branch Prediction Scheme** — A. N. Eden, Trevor Mudge · MICRO 1998 · 9pp · [DOI](https://doi.org/10.1109/MICRO.1998.742770) · [PDF](https://tnm.engin.umich.edu/wp-content/uploads/sites/353/2017/12/1998.12.YAGS-branch-predictor.pdf). Tag the pattern-history entries so two branches stop corrupting each other — a clean answer to destructive aliasing.

### The accuracy frontier: neural and geometric-history predictors
*Where the field ended up: perceptrons over very long histories, and TAGE's tagged geometric tables — still the accuracy benchmark in championship competitions.*
10. **Dynamic Branch Prediction with Perceptrons** — Daniel A. Jiménez, Calvin Lin · HPCA 2001 · 10pp · [DOI](https://doi.org/10.1109/HPCA.2001.903263) · [PDF](https://www.cs.utexas.edu/~lin/papers/hpca01.pdf). The first neural predictor: a perceptron per branch exploits histories far longer than a pattern table can index.
11. **Fast Path-Based Neural Branch Prediction** — Daniel A. Jiménez · MICRO 2003 · 10pp · [DOI](https://doi.org/10.1109/MICRO.2003.1253199) · [PDF](https://www.cecs.uci.edu/~papers/micro03/pdf/jimenez-FastPath.pdf). Makes the perceptron practical — path-based indexing cuts latency to something a real pipeline can afford.
12. **A Case for (Partially) Tagged Geometric History Length Branch Prediction (TAGE)** — André Seznec, Pierre Michaud · JILP 2006 · 23pp · [PDF](https://jilp.org/vol8/v8paper1.pdf). Multiple tagged tables indexed with geometrically growing history lengths; still the accuracy reference point.
    - **Branch-prediction research** — André Seznec · [WEB](https://team.inria.fr/pacap/members/andre-seznec/branch-prediction-research/). TAGE-SC-L and the Championship Branch Prediction sources — the living artifact behind the paper.
13. **A New Case for the TAGE Branch Predictor** — André Seznec · MICRO 2011 · 11pp · [DOI](https://doi.org/10.1145/2155620.2155635) · [PDF](https://www.cs.cmu.edu/~18742/papers/Seznec2011.pdf). Cuts TAGE's hardware cost and bolts on a statistical corrector — the form modern cores actually build.

### Predicting the target, not just the direction
*Direction is only half the problem; returns, indirect jumps, and the fetch engine all need the target address.*
14. **Branch History Table Prediction of Moving Target Branches Due to Subroutine Returns** — David R. Kaeli, Philip G. Emma · ISCA 1991 · 9pp · [DOI](https://doi.org/10.1145/115952.115957). The return address stack: a call/return stack that nails the one target a BTB always gets wrong.
15. **Fast and Accurate Instruction Fetch and Branch Prediction** — Brad Calder, Dirk Grunwald · ISCA 1994 · 10pp · [DOI](https://doi.org/10.1145/192007.192011) · [PDF](https://cseweb.ucsd.edu/~calder/papers/ISCA-94.pdf). Co-designs the fetch engine and the BTB so a correct direction prediction actually delivers the right instructions next cycle.
16. **Target Prediction for Indirect Jumps** — Po-Yung Chang, Eric Hao, Yale N. Patt · ISCA 1997 · 10pp · [DOI](https://doi.org/10.1145/264107.264209). The target cache: use history to predict the *changing* targets of indirect jumps (switches, virtual calls), which a plain BTB cannot.
17. **Accurate Indirect Branch Prediction** — Karel Driesen, Urs Hölzle · ISCA 1998 · 12pp · [DOI](https://doi.org/10.1145/279361.279380) · [PDF](https://american.cs.ucdavis.edu/academic/readings/papers/driesen.pdf). Two-level and cascaded predictors for indirect branches — the accuracy story for polymorphic, object-oriented code.

### Knowing when not to trust a prediction
*A prediction you can score is a prediction you can act on — throttle, gate, or reverse speculation by its confidence.*
18. **Assigning Confidence to Conditional Branch Predictions** — Erik Jacobsen, Eric Rotenberg, James E. Smith · MICRO 1996 · 11pp · [DOI](https://doi.org/10.1109/MICRO.1996.566457) · [PDF](https://ftp.cs.wisc.edu/sohi/papers/1996/micro.confidence.pdf). Confidence estimation: know which predictions are likely wrong, so you can gate speculation, fetch both paths, or save energy.

### Beyond control flow: value and address speculation
*Speculation is not only about branches — predict data and addresses to break true (dataflow) dependences.*
19. **Value Locality and Load Value Prediction** — Mikko H. Lipasti, Christopher B. Wilkerson, John P. Shen · ASPLOS 1996 · 10pp · [DOI](https://doi.org/10.1145/237090.237173) · [PDF](https://pharm.ece.wisc.edu/mikko/oldpapers/asplos7.pdf). Introduced value locality and load-value prediction — loads often return the value they returned last time.
20. **Exceeding the Dataflow Limit via Value Prediction** — Mikko H. Lipasti, John P. Shen · MICRO 1996 · 12pp · [DOI](https://doi.org/10.1109/MICRO.1996.566464) · [PDF](https://pharm.ece.wisc.edu/mikko/oldpapers/micro29.pdf). Predicting results lets dependent instructions issue early, beating the true-dependence limit on ILP.
21. **The Predictability of Data Values** — Yiannakis Sazeides, James E. Smith · MICRO 1997 · 11pp · [DOI](https://doi.org/10.1109/MICRO.1997.645815) · [PDF](https://people.eecs.berkeley.edu/~kubitron/cs252/handouts/papers/smith_value.pdf). Classifies value predictability (last-value, stride, context) — the taxonomy that grounds every value predictor.
22. **Speculative Execution via Address Prediction and Data Prefetching** — José González, Antonio González · ICS 1997 · 8pp · [DOI](https://doi.org/10.1145/263580.263631). Predict a load's *address* early to prefetch and speculatively execute past it — control speculation's data-side cousin.

### Speculation at thread granularity
*Push speculation past the basic block to whole tasks executed in parallel.*
23. **Multiscalar Processors** — Gurindar S. Sohi, Scott E. Breach, T. N. Vijaykumar · ISCA 1995 · 12pp · [DOI](https://doi.org/10.1145/223982.224451) · [PDF](https://ftp.cs.wisc.edu/sohi/papers/1995/isca.multiscalar.pdf). Speculative multithreading: split a program into tasks and run them in parallel, speculating across control and data — where branch and value speculation meet parallelism.

## Reference shelf — books
- **BUY** **Modern Processor Design: Fundamentals of Superscalar Processors** — John Paul Shen, Mikko H. Lipasti · 2013 · 656pp · [page](https://www.waveland.com/browse.php?t=624). The textbook treatment of prediction, speculation, and recovery in a real out-of-order core.
- **BUY** **Computer Architecture: A Quantitative Approach** — John L. Hennessy, David A. Patterson · 6th ed. 2017 · 936pp · [page](https://shop.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1). Chapter 3 (ILP) is the standard first exposure to branch prediction and speculation.

## Key terms
- **saturating counter** — an *n*-bit up/down counter (usually 2-bit) whose high bit predicts taken/not-taken; adds hysteresis so one anomaly doesn't flip the prediction.
- **bimodal** — a table of saturating counters indexed by branch address; the simplest dynamic predictor.
- **BHR / PHT** — branch history register (recent outcomes) indexing a pattern history table of counters; the two levels of a two-level predictor.
- **global vs. local history** — global (GAg) uses one shared outcome history; local/per-address (PAp) keeps a separate history per branch.
- **gshare / gselect** — index the PHT by hashing (XOR / concatenation) the global history with the branch address to spread branches across the table.
- **aliasing / interference** — two branches mapping to the same table entry; *destructive* when their outcomes disagree. Tags (YAGS) and skewing reduce it.
- **tournament / combining predictor** — a meta-predictor that learns, per branch, which of several component predictors to trust.
- **perceptron predictor** — a neural predictor whose weighted sum over a long history yields the prediction; exploits histories too long to index a table.
- **TAGE** — tagged geometric-history-length predictor: several tagged tables at geometrically growing history lengths, longest matching tag wins.
- **BTB** — branch target buffer: a cache from branch address to predicted target, read in the fetch stage.
- **RAS** — return address stack: a hardware stack pushed on calls and popped on returns to predict return targets.
- **indirect branch** — a branch whose target is computed (switch, function pointer, virtual call); needs target-history prediction, not just a BTB.
- **confidence estimation** — a score for how likely a given prediction is correct, used to gate or throttle speculation.
- **value / address prediction** — predicting a load's result value or its address to break true data dependences.
- **misprediction recovery (squash)** — discarding wrong-path work and restoring precise state (via a reorder buffer or checkpoint) when a prediction is found wrong.
- **dataflow limit** — the ILP ceiling set by true data dependences; value prediction aims to exceed it.
