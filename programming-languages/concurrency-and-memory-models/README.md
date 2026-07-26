# Programming languages · Concurrency & memory models

Concurrency asks two different questions, and this list follows both. First, how do
we *describe* interacting processes at all — the message-passing tradition from CSP
through the pi-calculus and actors. Second, once threads share memory, what does a
read actually *return* — the consistency and memory-model tradition from sequential
consistency through the Java and C++ models to relaxed atomics. The path starts with
the one primitive both need, a partial order of events, then walks the message-passing
calculi, tackles the classic mutual-exclusion problem with nothing but reads and
writes, pivots to shared-memory correctness and the nonblocking data structures built
on it, lifts the model into real languages, descends to what actual hardware does, and
closes with transactional memory as an alternative discipline.

> **Two questions, one reading path.** Read top to bottom: process calculi first (how to
> model communication), then the mutual-exclusion algorithms and shared-memory
> consistency (what memory guarantees), then the language and hardware models that make
> those guarantees real. The two halves meet at *data-race-freedom* — the contract in
> paper 13 that both the Java and C++ models are built on.

## Reading order

### Ordering — the one primitive everything needs
*Concurrency has no global clock; every model below rests on a partial order of events.*

1. **Time, Clocks, and the Ordering of Events in a Distributed System** — Leslie Lamport · CACM 1978 · 8pp · [DOI](https://doi.org/10.1145/359545.359563) · [PDF](https://lamport.azurewebsites.net/pubs/time-clocks.pdf). Defines happens-before and logical clocks — the partial order of events that every model of concurrency below quietly assumes.

### Message-passing models — concurrency without shared memory
*The algebraic tradition: describe processes by how they communicate, then reason equationally.*

2. **Communicating Sequential Processes (CSP)** — C. A. R. Hoare · CACM 1978 · 12pp · [DOI](https://doi.org/10.1145/359576.359585) · [PDF](https://www.cs.cmu.edu/~crary/819-f09/Hoare78.pdf). The founding paper of message-passing concurrency: processes that interact only by synchronized communication, with no shared store.

3. **A Calculus of Communicating Systems (CCS)** — Robin Milner · LNCS 92, 1980 · 171pp · [DOI](https://doi.org/10.1007/3-540-10235-3). An algebraic, compositional theory of concurrent processes, with bisimulation as the notion of process equivalence.

4. **A Calculus of Mobile Processes, Part I (the pi-calculus)** — Milner, Parrow, Walker · Information and Computation 1992 · 40pp · [DOI](https://doi.org/10.1016/0890-5401(92)90008-4) · [PDF](https://www.cis.upenn.edu/~stevez/cis670/pdfs/pi-calculus.pdf). Extends CCS so channels themselves can be sent as messages — concurrency with a communication topology that changes as the program runs.

5. **A Universal Modular ACTOR Formalism for Artificial Intelligence** — Hewitt, Bishop, Steiger · IJCAI 1973 · 11pp · [PDF](https://www.ijcai.org/Proceedings/73/Papers/027B.pdf). The actor model: independent agents that communicate only by asynchronous messages — the lineage behind Erlang and Akka.
   - **Actors: A Model of Concurrent Computation in Distributed Systems** — Gul Agha · MIT 1986 · 204pp · [PDF](https://web.archive.org/web/2018/https://dspace.mit.edu/bitstream/handle/1721.1/6952/AITR-844.pdf). The dissertation that turned the actor idea into a rigorous operational model.

6. **Language Primitives and Type Discipline for Structured Communication-Based Programming** — Honda, Vasconcelos, Kubo · ESOP 1998 · 17pp · [DOI](https://doi.org/10.1007/BFb0053567). Introduces session types — types that describe a whole protocol on a channel, so the type checker rules out mismatched message exchanges.

### Mutual exclusion — the first shared-memory problem
*Before asking what a memory model guarantees, solve the canonical coordination problem with nothing but shared reads and writes.*

7. **Solution of a Problem in Concurrent Programming Control** — Edsger W. Dijkstra · CACM 1965 · 1pp · [DOI](https://doi.org/10.1145/365559.365617) · [PDF](https://harrymoreno.com/assets/greatPapersInCompSci/5.2_-_Solution_to_a_problem_in_concurrent_process_control-Edsger_W._Dijkstra.pdf). States the *n*-process mutual-exclusion problem and gives the first correct software solution (Dekker's, generalized) — the starting point for everything about locks.

8. **A New Solution of Dijkstra's Concurrent Programming Problem (the Bakery Algorithm)** — Leslie Lamport · CACM 1974 · 3pp · [DOI](https://doi.org/10.1145/361082.361093) · [PDF](https://lamport.azurewebsites.net/pubs/bakery.pdf). Mutual exclusion using only single-writer reads and writes, with no atomic read-modify-write — and robust to a process failing mid-protocol.

9. **Myths About the Mutual Exclusion Problem** — Gary L. Peterson · Information Processing Letters 1981 · 2pp · [DOI](https://doi.org/10.1016/0020-0190(81)90106-X) · [PDF](https://zoo.cs.yale.edu/classes/cs323/doc/Peterson.pdf). The two-line two-process algorithm now taught everywhere, showing the classic solutions were far more complicated than the problem required.

### Shared memory — what is correct, and what can you build?
*Now the hard case: many threads over one store. Before defining a memory model, fix what "correct" even means.*

10. **How to Make a Multiprocessor Computer That Correctly Executes Multiprocess Programs** — Leslie Lamport · IEEE ToC 1979 · 2pp · [DOI](https://doi.org/10.1109/TC.1979.1675439) · [PDF](https://lamport.azurewebsites.net/pubs/multi.pdf). Defines sequential consistency — the intuitive "as if the threads were interleaved in program order" model that every weaker model is measured against.

11. **Linearizability: A Correctness Condition for Concurrent Objects** — Herlihy, Wing · TOPLAS 1990 · 30pp · [DOI](https://doi.org/10.1145/78969.78972) · [PDF](https://cs.brown.edu/~mph/HerlihyW90/p463-herlihy.pdf). The standard correctness criterion for concurrent data structures: each operation appears to take effect atomically at some instant between its call and its return.

12. **Wait-Free Synchronization** — Maurice Herlihy · TOPLAS 1991 · 26pp · [DOI](https://doi.org/10.1145/114005.102808) · [PDF](https://cs.brown.edu/~mph/Herlihy91/p124-herlihy.pdf). The consensus hierarchy: ranks synchronization primitives by how many threads they can coordinate wait-free, explaining why compare-and-swap is universal.

13. **Weak Ordering — A New Definition** — Adve, Hill · ISCA 1990 · 13pp · [DOI](https://doi.org/10.1145/325164.325100) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-F03/handouts/papers/p363-adve.pdf). Recasts weak memory as a contract: the hardware promises sequential consistency exactly to programs that are data-race-free — the idea every language model below adopts.

### Building nonblocking structures — and reclaiming their memory
*With a correctness criterion and the wait-free hierarchy in hand, build real lock-free structures — where freeing memory becomes the hard part.*

14. **Simple, Fast, and Practical Non-Blocking and Blocking Concurrent Queue Algorithms** — Michael, Scott · PODC 1996 · 9pp · [DOI](https://doi.org/10.1145/248052.248106) · [PDF](https://www.cs.rochester.edu/~scott/papers/1996_PODC_queues.pdf). The Michael-Scott queue — the lock-free queue still shipped in standard libraries — and a clear encounter with the ABA problem that compare-and-swap invites.

15. **Hazard Pointers: Safe Memory Reclamation for Lock-Free Objects** — Maged M. Michael · IEEE TPDS 2004 · 14pp · [DOI](https://doi.org/10.1109/TPDS.2004.8) · [PDF](https://www.eecg.utoronto.ca/~amza/ece1747h/papers/hazard_pointers.pdf). Solves the central practical problem of lock-free code — when is it safe to free a node another thread may still touch — without a garbage collector, and kills ABA along the way.

16. **Read-Copy Update: Using Execution History to Solve Concurrency Problems** — McKenney, Slingwine · PDCS 1998 · 10pp · [PDF](http://www.rdrop.com/users/paulmck/RCU/rclockpdcsproof.pdf). RCU: make readers almost free by deferring reclamation until every pre-existing reader has passed a quiescent state — the synchronization workhorse of the Linux kernel.

### Putting the memory model in the language
*Programmers don't target hardware directly; the model has to live in C, C++, and Java — and it has to be sound for the compiler too.*

17. **Threads Cannot Be Implemented as a Library** — Hans-J. Boehm · PLDI 2005 · 10pp · [DOI](https://doi.org/10.1145/1065010.1065042) · [PDF](https://web.archive.org/web/2018/http://www.hpl.hp.com/techreports/2004/HPL-2004-209.pdf). Shows a thread library alone cannot give correct semantics — the compiler and language must know about concurrency — the argument that forced memory models into C and C++.

18. **Foundations of the C++ Concurrency Memory Model** — Boehm, Adve · PLDI 2008 · 11pp · [DOI](https://doi.org/10.1145/1375581.1375591) · [PDF](https://rsim.cs.illinois.edu/Pubs/08PLDI.pdf). The data-race-free foundation of the C++11/C11 model that standardized atomics and fences for mainstream systems languages.
    - **atomic&lt;&gt; Weapons: The C++ Memory Model and Modern Hardware** — Herb Sutter · [VIDEO](https://www.youtube.com/watch?v=A8eCGOqgvH4). A practitioner's walkthrough of what these rules mean when you actually write lock-free code.

19. **The Java Memory Model** — Manson, Pugh, Adve · POPL 2005 · 14pp · [DOI](https://doi.org/10.1145/1040305.1040336) · [PDF](http://rsim.cs.uiuc.edu/Pubs/popl05.pdf). The first rigorous language-level memory model, built on happens-before and data-race-freedom — and the source of the notorious out-of-thin-air problem.

20. **Mathematizing C++ Concurrency** — Batty, Owens, Sarkar, Sewell, Weber · POPL 2011 · 12pp · [DOI](https://doi.org/10.1145/1926385.1926394) · [PDF](https://www.cl.cam.ac.uk/~pes20/cpp/popl085ap-sewell.pdf). A fully formal, mechanized semantics for the C11/C++11 relaxed-atomics model, exposing defects in the standard's prose.

21. **Common Compiler Optimisations Are Invalid in the C11 Memory Model, and What We Can Do About It** — Vafeiadis, Balabonski, Chakraborty, Morisset, Zappa Nardelli · POPL 2015 · 12pp · [DOI](https://doi.org/10.1145/2676726.2676995) · [PDF](https://plv.mpi-sws.org/c11comp/popl15.pdf). Shows textbook optimizations are unsound under C11 as written — the compiler-facing half of the out-of-thin-air problem, with concrete fixes.

### Real hardware and the hard cases
*Actual machines are weaker than sequential consistency; the weakest need their own models, and relaxed atomics still resist a clean semantics.*

22. **x86-TSO: A Rigorous and Usable Programmer's Model for x86 Multiprocessors** — Sewell, Sarkar, Owens, Zappa Nardelli, Myreen · CACM 2010 · 9pp · [DOI](https://doi.org/10.1145/1785414.1785443) · [PDF](https://www.cl.cam.ac.uk/~pes20/weakmemory/cacm.pdf). A precise, tractable total-store-order model for real x86 hardware — what "relaxed" actually means on the machine most code runs on.
    - **Weak vs. Strong Memory Models** — Jeff Preshing · [WEB](https://preshing.com/20120930/weak-vs-strong-memory-models/). A clear, example-driven explainer of the hardware-reordering spectrum.

23. **Understanding POWER Multiprocessors** — Sarkar, Sewell, Alglave, Maranget, Williams · PLDI 2011 · 12pp · [DOI](https://doi.org/10.1145/1993498.1993520) · [PDF](https://www.cl.cam.ac.uk/~pes20/ppc-supplemental/pldi105-sarkar.pdf). An operational model for the very weak memory of POWER (and, by extension, ARM) — the counterpart to x86-TSO for the machines that reorder the most.

24. **Herding Cats: Modelling, Simulation, Testing, and Data Mining for Weak Memory** — Alglave, Maranget, Tautschnig · TOPLAS 2014 · 74pp · [DOI](https://doi.org/10.1145/2627752) · [PDF](http://www0.cs.ucl.ac.uk/staff/j.alglave/papers/toplas14.pdf). A general axiomatic framework (the `cat` language and `herd` tool) that captures x86, POWER, and ARM uniformly and tests them against real silicon.

25. **A Promising Semantics for Relaxed-Memory Concurrency** — Kang, Hur, Lahav, Vafeiadis, Dreyer · POPL 2017 · 19pp · [DOI](https://doi.org/10.1145/3009837.3009850) · [PDF](https://people.mpi-sws.org/~dreyer/papers/promising/paper.pdf). Solves the long-standing out-of-thin-air problem for relaxed atomics with a semantics of "promised" future writes.

### A different discipline — transactional memory
*Instead of locks and fences, make groups of accesses atomic and let the runtime referee.*

26. **Transactional Memory: Architectural Support for Lock-Free Data Structures** — Herlihy, Moss · ISCA 1993 · 12pp · [DOI](https://doi.org/10.1145/165123.165164) · [PDF](https://cs.brown.edu/~mph/HerlihyM93/herlihy93transactional.pdf). Proposes hardware transactions as an alternative to locks: commit a group of memory accesses atomically, or abort and retry.

27. **Software Transactional Memory** — Shavit, Touitou · PODC 1995 · 10pp · [DOI](https://doi.org/10.1145/224964.224987) · [PDF](https://groups.csail.mit.edu/tds/papers/Shavit/ShavitTouitou-podc95.pdf). Realizes transactional memory purely in software, launching the STM line of research.

<!--html-->
<div class="why">
<b>Two traditions, one goal.</b> The <em>message-passing</em> calculi (CSP, CCS, pi,
actors, session types) avoid shared state entirely and reason about processes by how they
communicate. The <em>shared-memory</em> line — from the mutual-exclusion algorithms and
sequential consistency, through linearizability and the nonblocking structures built on
it, up to the Java and C++ models, x86-TSO, the POWER/ARM models, and the promising
semantics — confronts the store head-on and asks what a read may return. They converge on
one contract, <em>data-race-freedom</em>, which lets weak hardware present a strong,
sequentially consistent face to well-behaved programs.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Communicating Sequential Processes** — C. A. R. Hoare · 1985 · 260pp · [PDF](https://web.archive.org/web/2019/http://www.usingcsp.com/cspbook.pdf). Hoare's own book-length development of CSP, kept free online.
- **FREE** **Is Parallel Programming Hard, And, If So, What Can You Do About It?** — Paul E. McKenney · 2023 · 662pp · [PDF](https://kernel.org/pub/linux/kernel/people/paulmck/perfbook/perfbook.2023.06.11a.pdf). The practitioner's companion — RCU, memory barriers, and lock-free technique from the person who put RCU in the kernel.
- **BUY** **The Art of Multiprocessor Programming** — Herlihy, Shavit · Rev. ed. 2012 · 536pp · [page](https://www.amazon.com/dp/0124159508). The standard text — linearizability, the wait-free hierarchy, and transactional memory in one place.
- **BUY** **A Primer on Memory Consistency and Cache Coherence** — Nagarajan, Sorin, Hill, Wood · 2nd ed. 2020 · 294pp · [page](https://link.springer.com/book/10.1007/978-3-031-01764-3). The bridge from language memory models down to what caches and hardware actually do.

## Key terms

- **happens-before** — a partial order on events; if it does not order two accesses, they may be observed in either order.
- **mutual exclusion** — the guarantee that at most one process is in its critical section at a time.
- **sequential consistency (SC)** — the model where the program behaves as *some* interleaving of each thread's operations, each in program order.
- **linearizability** — each concurrent operation appears to take effect atomically at a single point between its call and its return.
- **data-race-free (DRF)** — a program with no two conflicting accesses left unordered by synchronization; on a weak model such programs still get SC.
- **wait-free / lock-free** — progress guarantees: every thread finishes in a bounded number of steps (wait-free) / some thread always makes progress (lock-free).
- **compare-and-swap (CAS)** — an atomic read-modify-write that updates a location only if it still holds an expected value; the universal primitive of the wait-free hierarchy.
- **ABA problem** — a CAS succeeds because a value returned to its old bit pattern, hiding an intervening change; the hazard nonblocking reclamation schemes exist to prevent.
- **hazard pointer** — a per-thread published pointer marking a node still in use, so reclamation knows it must not free it yet.
- **RCU (read-copy-update)** — near-free reads plus deferred reclamation: free a node only after every reader active when it was unlinked has finished.
- **memory fence / barrier** — an instruction that constrains how memory operations may be reordered around it.
- **relaxed atomic** — an atomic access that permits reordering, trading ordering guarantees for speed.
- **out-of-thin-air** — a pathological relaxed-atomics outcome where a value appears with no write justifying it; the defect the promising semantics repairs.
- **TSO (total store order)** — the x86 model: stores are buffered and may be reordered after later loads, but all cores agree on the order of stores.
- **bisimulation** — the equivalence used in CCS and the pi-calculus: two processes that can match each other's moves step for step.
</content>
</invoke>
