# Computer architecture · Weird / unconventional architectures

The roads less taken: machines shaped to a language, dataflow processors that
abandon the program counter, VLIW/EPIC designs that hand parallelism to the
compiler, decoupled and systolic pipelines, massively-parallel SIMD and
multithreaded machines, and the tiled, spatial, and reconfigurable revival. The
path below starts with the gentlest departure from von Neumann — hardware bent
to fit a programming model — then removes the program counter entirely, then
walks outward through the compiler, the pipeline, space, threads, and finally
the instruction set itself, until the datapath is all that is left to program.

> **How to read this list.** Each section names one thing the designers gave up
> from the conventional stored-program machine. Read top to bottom and the
> departures compound: first the ISA follows a language, then execution follows
> data instead of a counter, then the compiler (not the hardware) finds the
> parallelism, then the pipeline splits apart, then the datapath multiplies in
> space and in threads, and at the end there is no fixed instruction set at all.

## Reading order

### Machines shaped by a language
*Begin where hardware bends to fit a programming model — the smallest step off the von Neumann path.*

1. **A New Approach to the Functional Design of a Digital Computer (Burroughs B5000)** — Robert S. Barton · Western Joint IRE-AIEE-ACM 1961 · 5pp · [DOI](https://doi.org/10.1145/1460690.1460736) · [PDF](http://people.eecs.berkeley.edu/~kubitron/courses/cs252-S11/handouts/papers/barton.pdf). The stack machine whose control structure was derived from ALGOL 60 — the ur-example of a language-directed architecture.

2. **Design of a LISP-based microprocessor** — Guy L. Steele, Gerald J. Sussman · CACM 1980 · 18pp · [DOI](https://doi.org/10.1145/359024.359031) · [PDF](http://bitsavers.org/pdf/mit/ai/aim/AIM-514.pdf). Lisp as the instruction set, garbage collection in silicon — "LAMBDA: the ultimate opcode." (PDF is the fuller MIT AI Memo 514.)

### Abandon the program counter — dataflow
*The most radical idea in the set: let the availability of data, not a sequential PC, drive execution.*

3. **A Preliminary Architecture for a Basic Data-Flow Processor** — Jack Dennis, David Misunas · ISCA 1974 · 7pp · [DOI](https://doi.org/10.1145/642089.642111) · [PDF](https://web.archive.org/web/20070128024415id_/http://courses.ece.uiuc.edu/ece512/Papers/Dennis.1975.ISCA.pdf). The seminal static dataflow processor; start here for the model itself.

4. **Executing a Program on the MIT Tagged-Token Dataflow Architecture** — Arvind, Rishiyur Nikhil · IEEE TC 1990 · 19pp · [DOI](https://doi.org/10.1109/12.48862) · [PDF](https://csg.csail.mit.edu/pubs/memos/Memo-271/Memo-271.pdf). Dynamic (tagged-token) dataflow: tags let many instances of a loop body run at once. (PDF is the extended CSAIL memo.)

5. **The Manchester Prototype Dataflow Computer** — John Gurd, Chris Kirkham, Ian Watson · CACM 1985 · 19pp · [DOI](https://doi.org/10.1145/2465.2468) · [PDF](https://web.archive.org/web/20150114024834id_/http://www.ece.cmu.edu/~ece447/s14/lib/exe/fetch.php?media=p34-gurd.pdf). The most complete built-and-measured tagged-token machine — what dataflow actually cost in hardware.

6. **Monsoon: An Explicit Token-Store Architecture** — Greg Papadopoulos, David Culler · ISCA 1990 · 10pp · [DOI](https://doi.org/10.1145/325164.325117) · [PDF](https://people.eecs.berkeley.edu/~culler/courses/cs252-s05/papers/p398-papadopoulos.pdf). The explicit token store that fixed dataflow's associative-matching bottleneck and made dynamic dataflow buildable.
   - **VIDEO** **Dataflow (Part II) and Systolic Arrays** — Onur Mutlu · [lecture](https://www.youtube.com/watch?v=cEA47rnkVLQ). A clear walk through static vs. tagged-token dataflow and the pivot to systolic arrays; good before or after the four papers above.

### Hand parallelism to the compiler — VLIW / EPIC
*Keep the program counter, but expose all the parallelism statically so the hardware can stay simple.*

7. **Very Long Instruction Word Architectures and the ELI-512** — Joseph A. Fisher · ISCA 1983 · 11pp · [DOI](https://doi.org/10.1145/800046.801649) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-S09/handouts/papers/p263-fisher.pdf). The founding VLIW paper, and the argument that trace scheduling can fill very wide instructions.

8. **EPIC: Explicitly Parallel Instruction Computing** — Michael Schlansker, B. Ramakrishna Rau · IEEE Computer 2000 · 9pp · [DOI](https://doi.org/10.1109/2.820037). VLIW reborn with predication and speculation as the philosophy behind Itanium — where handing everything to the compiler met its limits.
   - **Understanding EPIC Architectures and Implementations** — Mark Smotherman · [PDF](https://people.computing.clemson.edu/~mark/464/acmse_epic.pdf). A compact survey that situates EPIC/Itanium against classic VLIW; the open companion to the paywalled paper above.

### Decouple and stream the pipeline
*Instead of one tightly-coupled pipeline, split the machine into cooperating engines and let operands flow as streams.*

9. **Decoupled Access/Execute Computer Architectures** — James E. Smith · ISCA 1982 · 8pp · [DOI](https://doi.org/10.1145/1067649.801719) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-F00/handouts/papers/p231-smith.pdf). Split memory access from execution into two queue-coupled processors so memory latency overlaps compute — the ancestor of modern access/execute decoupling.

10. **The Effectiveness of Decoupling** — Peter L. Bird, Alasdair Rawsthorne, Nigel P. Topham · ICS 1993 · 20pp · [PDF](https://homepages.inf.ed.ac.uk/npt/pubs/ics-93.pdf). The ACRI-1 machine’s *control decoupling*: a third instruction stream runs ahead issuing work to separate access and execute units — extending Smith’s access/execute split to three cooperating processors.

11. **The WM Computer Architecture** — Wm. A. Wulf · SIGARCH CAN 1988 · 15pp · [DOI](https://doi.org/10.1145/44571.44577). Takes decoupling further: operand streams are first-class, and the ISA reads and writes queues rather than registers.

12. **MOVE: A Framework for High-Performance Processor Design** — Henk Corporaal, Hans Mulder · Supercomputing 1991 · 10pp · [DOI](https://doi.org/10.1145/125826.126159). Transport-triggered architectures — the program schedules data *movement* over buses, and computation is a side effect of moving operands to a function unit.

13. **Why Systolic Architectures?** — H. T. Kung · IEEE Computer 1982 · 10pp · [DOI](https://doi.org/10.1109/MC.1982.1653825) · [PDF](https://www.eecs.harvard.edu/~htk/publication/1982-kung-why-systolic-architecture.pdf). Arrays of simple cells rhythmically pumping data through each other — the paradigm behind today's ML matrix engines.

### Parallelism in space and in threads
*Multiply the datapath: one instruction over thousands of elements, or thousands of live threads to hide latency.*

14. **The ILLIAC IV System** — W. Bouknight, S. Denenberg, D. McIntyre, J. Randall, A. Sameh, Daniel Slotnick · Proc. IEEE 1972 · 20pp · [PDF](https://www.cs.auckland.ac.nz/courses/compsci703s1c/resources/Bouknight-ILIAC-IV.pdf). The original large-scale SIMD array (256 lock-step PEs) — the machine every later data-parallel design answers to.

15. **Data Parallel Algorithms** — Danny Hillis, Guy L. Steele · CACM 1986 · 14pp · [DOI](https://doi.org/10.1145/7902.7903) · [PDF](http://cva.stanford.edu/classes/cs99s/papers/hillis-steele-data-parallel-algorithms.pdf). The Connection Machine article that crystallized massively-parallel SIMD as a *programming* model, not just hardware.

16. **The Tera Computer System** — Robert Alverson, David Callahan, Daniel Cummings, Brian Koblenz, Allan Porterfield, Burton Smith · ICS 1990 · 6pp · [DOI](https://doi.org/10.1145/77726.255132) · [PDF](http://www.ai.mit.edu/projects/aries/course/notes/tera.pdf). Hide memory latency with massive fine-grained multithreading and no data cache — the MTA, the other way to keep a datapath busy.

17. **The Transputer** — Colin Whitby-Strevens · ISCA 1985 · 9pp · [DOI](https://doi.org/10.1145/327070.327269). INMOS's message-passing processor with on-chip serial links and an ISA co-designed with occam/CSP — parallelism as composition of communicating processes.

### The spatial / tiled revival
*Dataflow and streaming ideas return as tiled, software-exposed chips built to beat the wire-delay wall.*

18. **Baring It All to Software: Raw Machines** — Elliot Waingold, Michael Taylor, et al. · IEEE Computer 1997 · 8pp · [DOI](https://doi.org/10.1109/2.612254) · [PDF](https://groups.csail.mit.edu/cag/raw/documents/Waingold-Computer-1997.pdf). A tiled array with a software-exposed, statically-scheduled on-chip network — the template for modern spatial accelerators.

19. **Scaling to the End of Silicon with EDGE Architectures (TRIPS)** — Doug Burger, Steve Keckler, et al. · IEEE Computer 2004 · 12pp · [DOI](https://doi.org/10.1109/MC.2004.65) · [PDF](https://www.cs.utexas.edu/~mckinley/papers/trips-computer-2004.pdf). Explicit Data Graph Execution: map dataflow graphs of instructions onto a grid of ALUs — dataflow's ideas inside a modern tiled core.

20. **WaveScalar** — Steven Swanson, Ken Michelson, Andrew Schwerin, Mark Oskin · MICRO 2003 · 12pp · [PDF](https://cseweb.ucsd.edu/~swanson/papers/Micro2003WaveScalar.pdf). A dataflow ISA that supports imperative memory ordering ("wave-ordered memory") on a tiled substrate — dataflow made compatible with C.

### Dissolve the ISA — reconfigurable fabric
*The end of the road: no fixed instruction set at all; the datapath itself is what you program.*

21. **Garp: A MIPS Processor with a Reconfigurable Coprocessor** — John Hauser, John Wawrzynek · FCCM 1997 · 10pp · [DOI](https://doi.org/10.1109/fpga.1997.624600) · [PDF](http://www.cs.ucr.edu/~kmiller/references/hauser97garp.pdf). Bolt an FPGA-like reconfigurable array onto a standard CPU as a first-class functional unit — the pragmatic route to hardware-as-instruction.

22. **PipeRench: A Reconfigurable Architecture and Compiler** — Seth Goldstein, Herman Schmit, et al. · IEEE Computer 2000 · 8pp · [DOI](https://doi.org/10.1109/2.839324) · [PDF](http://www.cs.cmu.edu/~seth/papers/goldstein-ieee00.pdf). Pipeline reconfiguration: virtualize a large hardware pipeline onto a small physical fabric, streaming configurations in as the computation runs.

<!--html-->
<div class="why">
<b>One idea per section, and the costs compound.</b> Each family here trades away a
guarantee that conventional CPUs quietly provide. Language-directed and stack machines
give up a general-purpose ISA. Dataflow gives up the program counter — and pays in
associative token matching. VLIW/EPIC give up dynamic scheduling and lean entirely on the
compiler. Decoupled, streaming, and systolic designs give up the single monolithic
pipeline. SIMD and multithreaded machines give up per-element control flow or per-thread
latency guarantees. Tiled/EDGE machines give up a global register file and a fast global
wire. Reconfigurable fabrics give up a fixed instruction set entirely. Read in order, the
list is a tour of what you can remove from a computer and still compute.
</div>
<!--/html-->

## Reference shelf — books

- **BUY** **The Connection Machine** — Danny Hillis · MIT Press 1986 · 190pp · [page](https://mitpress.mit.edu/9780262580977/the-connection-machine/). The vision behind massively-parallel SIMD, from the machine's own architect; the long-form companion to the Hillis–Steele paper.
- **BUY** **Computer System Organization: The B5700/B6700 Series** — Elliott Organick · Academic Press 1973 · 132pp · [book](https://archive.org/details/computersystemor0000orga). The definitive account of the Burroughs stack architecture and its ALGOL-directed, descriptor-based design.

## Key terms

- **dataflow** — an execution model where an instruction fires as soon as its operands are available, with no program counter sequencing the code.
- **static vs. dynamic (tagged-token) dataflow** — static allows one token per arc at a time; dynamic tags tokens so multiple activations (e.g. loop iterations) coexist.
- **token store / explicit token store** — the memory that holds operands waiting to be matched; making it explicit (Monsoon) removed the associative-matching bottleneck.
- **VLIW** — very long instruction word: one instruction encodes many independent operations the *compiler* has proven parallel, so the hardware issues them in lock step.
- **EPIC** — VLIW plus predication and control/data speculation, letting the compiler expose parallelism across branches and memory; the Itanium philosophy.
- **trace scheduling** — a compiler technique that schedules the likely path through a program as a single long block, then patches up the off-path cases.
- **decoupled access/execute** — splitting a processor into a memory-access engine and a compute engine connected by queues, so long memory latencies overlap useful work.
- **transport-triggered** — the program specifies data *moves* between function units; an operation happens as a side effect of transporting operands to a unit's input.
- **systolic array** — a grid of simple processing elements that rhythmically pass data to their neighbors, reusing each datum across many cells.
- **SIMD** — single instruction, multiple data: one control unit broadcasts each instruction to many datapaths operating in lock step.
- **fine-grained multithreading** — interleaving many hardware threads cycle-by-cycle to hide memory and pipeline latency instead of caching around it (the MTA approach).
- **EDGE** — explicit data graph execution: the ISA encodes dataflow dependences directly and maps instruction graphs onto an array of ALUs.
- **reconfigurable computing** — implementing the datapath itself in a programmable fabric (FPGA-like), so "instructions" become hardware configurations.
