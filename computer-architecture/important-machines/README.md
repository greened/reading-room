# Computer architecture · Important machines & ISAs

Landmark computers and instruction sets, told through their system-description and
retrospective papers — the machines that fixed the vocabulary and the ISAs that
endured. The path below is *conceptual*, not chronological: start with what an
architecture even *is* (System/360), then watch the two abstractions every later
machine leans on — virtual memory and in-CPU parallelism — get invented; then follow
the great ISA debates (stack vs. vector, mini vs. mainframe, RISC vs. CISC) down to
the microprocessors that won, and out to the open, compiler-scheduled, and free ISAs
that argue over what comes next. Techniques these machines pioneered are treated in
depth in the mechanism subtopics; here the focus is the machine as a whole.

> **How to read this list.** Keep one distinction in mind throughout: the
> *architecture* (the instruction set a programmer sees) versus the
> *microarchitecture* (how a particular chip implements it). System/360 made that line
> explicit; the RISC papers argue about where to draw it; and the x86 chapters show a
> single architecture outliving a dozen wildly different implementations.

### 1 · What an architecture is — the durable contract
*Start here: an instruction set is a contract you keep across many implementations, fast and slow.*

1. **Architecture of the IBM System/360** — Amdahl, Blaauw, Brooks · IBM J. R&D 1964 · 15pp · [DOI](https://doi.org/10.1147/rd.82.0087) · [PDF](https://people.eecs.berkeley.edu/~culler/courses/cs252-s05/papers/amdahl.pdf). ISA-as-durable-contract: one architecture spanning a whole line of models, from cheap to fast. The founding statement of the idea.

2. **Design Objectives for the IBM Stretch Computer** — S. W. Dunwell · Eastern JCC 1957 · 3pp · [DOI](https://doi.org/10.1145/1455533.1455540). The ambitious 7030 whose overreach and lessons — pipelining, instruction lookahead, interrupts, the 8-bit byte — fed directly into System/360.
   - **The Engineering Design of the Stretch Computer** — Erich Bloch · [PDF](https://www.bitsavers.org/pdf/ibm/7030/Bloch_EngrDesOfStretch_1959.pdf). 11pp. The companion engineering account of how Stretch was actually built.

### 2 · Making memory an abstraction
*Next, the two tricks that let every later machine pretend it has more memory than it does — and faster memory than it has.*

3. **One-Level Storage System** — Kilburn, Edwards, Lanigan, Sumner · IRE Trans. Electronic Computers 1962 · 13pp · [DOI](https://doi.org/10.1109/TEC.1962.5219356) · [PDF](https://www.cs.princeton.edu/courses/archive/fall09/cos375/Kilburn.pdf). The Manchester Atlas paging scheme — the first practical virtual memory, and the origin of the term.

4. **Structural Aspects of the System/360 Model 85, II: The Cache** — J. S. Liptay · IBM Systems J. 1968 · 7pp · [DOI](https://doi.org/10.1147/sj.71.0015) · [PDF](https://www.andrew.cmu.edu/course/15-440/assets/READINGS/liptay1968.pdf). The first commercial machine with a cache — the other memory illusion, making a large slow store look small and fast, invisibly to software.

### 3 · Parallelism inside one processor
*How a single CPU overlaps instructions: the scoreboard, then Tomasulo's dynamic scheduling.*

5. **Parallel Operation in the Control Data 6600** — J. E. Thornton · AFIPS FJCC 1964 · 8pp · [DOI](https://doi.org/10.1145/1464039.1464045) · [PDF](https://cs.uwaterloo.ca/~mashti/cs850-f18/papers/cdc6600.pdf). The first scoreboarded out-of-order supercomputer and an archetypal load/store design — Seymour Cray's breakthrough machine.

6. **The IBM System/360 Model 91: Machine Philosophy and Instruction-Handling** — Anderson, Sparacio, Tomasulo · IBM J. R&D 1967 · 17pp · [DOI](https://doi.org/10.1147/rd.111.0008) · [PDF](http://bitsavers.org/pdf/ibm/IBM_Journal_of_Research_and_Development/111/ibmrd1101C.pdf). The original description of Tomasulo's algorithm — reservation stations and register renaming — running in a real machine.
   - **The IBM System/360 Model 91: Floating-Point Execution Unit** — S. F. Anderson et al · [PDF](http://bitsavers.org/pdf/ibm/IBM_Journal_of_Research_and_Development/111/ibmrd1101E.pdf). 20pp. The other half of the Model 91 story: the pipelined arithmetic that Tomasulo's scheduler kept fed.

### 4 · Two bold answers to "what should instructions be?"
*Same era, opposite philosophies: a stack machine built for a high-level language, and a machine built for vectors.*

7. **A New Approach to the Functional Design of a Digital Computer** — R. S. Barton · Western JCC 1961 · 4pp · [DOI](https://doi.org/10.1145/1460690.1460736) · [PDF](https://refs.devinmcgloin.com/worrydream/Barton%20-%20A%20New%20Approach%20to%20the%20Functional%20Design%20of%20a%20New%20Computer.pdf). The design manifesto behind the Burroughs B5000: a stack architecture shaped by ALGOL rather than by the hardware.

8. **The CRAY-1 Computer System** — R. M. Russell · CACM 1978 · 10pp · [DOI](https://doi.org/10.1145/359327.359336) · [PDF](https://cray-history.net/wp-content/uploads/2021/07/cray1_PaperbyRussell.pdf). The canonical description of the defining vector supercomputer — registers, chaining, and raw numerical throughput.

### 5 · Architecture for the masses — the minicomputer
*A cheaper class of machine, with a clean ISA that grew from 16 to 32 bits and set up the RISC/CISC fight.*

9. **A New Architecture for Minicomputers — The DEC PDP-11** — Bell, Cady, McFarland, Delagi, O'Loughlin, Noonan, Wulf · AFIPS SJCC 1970 · 19pp · [DOI](https://doi.org/10.1145/1476936.1477037) · [PDF](https://archive.computerhistory.org/resources/text/DEC/pdp-11/dec.pdp-11.a_new_architecture_for_mini-computers-the_dec_pdp-11.1970.102630380.pdf). The elegant, orthogonal minicomputer ISA — the Unibus and general-register design that a generation learned on.

10. **VAX-11/780: A Virtual Address Extension to the DEC PDP-11 Family** — W. D. Strecker · AFIPS NCC 1978 · 14pp · [DOI](https://doi.org/10.1016/B978-0-932376-00-8.50026-8) · [PDF](https://tcm.computerhistory.org/ComputerTimeline/Chap42_vax11-780_CS2.pdf). The quintessential 32-bit CISC minicomputer — and, a few years on, the foil the RISC camp measured against.
    - **What Have We Learned from the PDP-11?** — Strecker & Bell (retrospective) · [PDF](https://gordonbell.azurewebsites.net/Digital/Strecker%20Bell%20PDP-11%20VAX%20Alpha%20Retrospective.pdf). 5pp. The architects looking back across the PDP-11, VAX, and Alpha lineage.

### 6 · The RISC revolution
*The reaction to CISC complexity: small instruction sets, deep pipelines, and work pushed onto the compiler — from research prototype to commercial big iron to a free, open ISA.*

11. **The 801 Minicomputer** — G. Radin · ASPLOS-I 1982 · 9pp · [DOI](https://doi.org/10.1145/960120.801824) · [PDF](https://courses.grainger.illinois.edu/ece511/fa2005/papers/Radin.1982.ASPLOS.pdf). IBM's 801 — the progenitor of RISC and of compiler-driven load/store design.

12. **A VLSI RISC (Berkeley RISC-I)** — Patterson, Séquin · IEEE Computer 1982 · 14pp · [DOI](https://doi.org/10.1109/MC.1982.1654133). Reduced instruction set, register windows, and the single-chip VLSI economics that made it pay.
    - **RISC I: A Reduced Instruction Set VLSI Computer** — Patterson, Séquin · ISCA 1981 · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-F00/handouts/papers/p216-patterson.pdf). 15pp. The original architecture paper, openly available.

13. **MIPS: A Microprocessor Architecture** — Hennessy, Jouppi, Przybylski, Rowen, Gross, Baskett, Gill · MICRO-15 1982 · 6pp · [DOI](https://doi.org/10.1145/1014194.800930) · [PDF](http://people.duke.edu/~bcl15/teachdir/ece252_fall11/Hennessy.pdf). A deeply pipelined RISC that pushed hazard handling out of the hardware and into the compiler — the "interlocks" MIPS deliberately lacked.

14. **The MIPS R4000 Processor** — Mirapuri, Woodacre, Vasseghi · IEEE Micro 1992 · 13pp · [DOI](https://doi.org/10.1109/40.127580) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-S07/handouts/papers/R4000.pdf). The RISC idea in volume production: a 64-bit, deeply super-pipelined MIPS with on-chip caches — the machine that carried the ISA into workstations and, later, game consoles.

15. **The Scalable Processor Architecture (SPARC)** — Garner, Agrawal, Briggs, Brown, Hough, Joy, Kleiman, Muchnick, Namjoo, Patterson, Pendleton, Tuck · COMPCON 1988 · 6pp · [DOI](https://doi.org/10.1109/CMPCON.1988.4874). Sun's open RISC ISA — register windows taken commercial, and designed as a licensable standard rather than one company's chip.
    - **The SPARC Architecture Manual, Version 8** — SPARC International · [PDF](https://courses.grainger.illinois.edu/cs423/sp2011/lectures/sim_public/sparcv8.pdf). 295pp. The canonical, freely published ISA reference — a model of what "architecture as contract" looks like on paper.

16. **Precision Architecture (PA-RISC)** — Ruby B. Lee · IEEE Computer 1989 · 14pp · [DOI](https://doi.org/10.1109/2.19825). HP's commercial RISC, built to span an entire product line from minicomputers to mainframe-class systems — RISC as a durable corporate contract in the System/360 mold.
    - **PA-RISC Computer Architecture** — OpenPA · [WEB](https://www.openpa.net/pa-risc_architecture.html). A clear, modern overview of the ISA and its implementations for readers without the paywalled paper.

17. **IBM RISC System/6000 Processor Architecture** — R. R. Oehler, R. D. Groves · IBM J. R&D 1990 · 14pp · [DOI](https://doi.org/10.1147/rd.341.0023) · [PDF](http://bitsavers.org/pdf/ibm/IBM_Journal_of_Research_and_Development/341/ibmrd3401E.pdf). POWER: the 801 idea grown into a multiple-issue commercial workstation CPU, and the direct ancestor of the PowerPC and today's POWER line.
    - **The Evolution of RISC Technology at IBM** — Cocke, Markstein · IBM J. R&D 1990 · [PDF](http://bitsavers.org/pdf/ibm/IBM_Journal_of_Research_and_Development/341/ibmrd3401C.pdf). 8pp. John Cocke's own account of the line from the 801 research machine to RS/6000.

18. **The Acorn RISC Machine — An Architectural View** — S. B. Furber, A. R. Wilson · Electronics & Power 1987 · 4pp · [DOI](https://doi.org/10.1049/ep.1987.0249). The original ARM: a tiny British RISC built for a low-cost PC, whose descendants now ship in the tens of billions.
    - **ARM Inventor: Sophie Wilson** — [VIDEO](https://www.youtube.com/watch?v=jhwwrSaHdh8). The co-designer on how the first ARM was specified and brought up on shoestring resources.

19. **Instruction Sets Should Be Free: The Case for RISC-V** — Asanović, Patterson · UC Berkeley EECS TR 2014 · 7pp · [PDF](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2014/EECS-2014-146.pdf). The RISC argument taken to its conclusion: an open, royalty-free, modular ISA that anyone can implement — the "architecture as contract" idea, made a public good.

### 7 · Microprocessors take over — x86 and the RISC high-water mark
*From the first single-chip CPU to the ISAs that won the desktop and server, plus the clean-slate 64-bit bet that lost — and where single-thread performance peaked.*

20. **The History of the 4004** — Faggin, Hoff, Mazor, Shima · IEEE Micro 1996 · 11pp · [DOI](https://doi.org/10.1109/40.546561) · [PDF](https://baltazarstudios.com/webshare/A-Z80/Library/The%20History%20of%204004.pdf). The designers' own account of the Intel 4004 — the first commercial single-chip microprocessor, and the seed of everything in this section.

21. **The Intel 8086: A 16-bit Evolution of the 8080** — Morse, Pohlman, Ravenel · IEEE Computer 1978 · 10pp · [DOI](https://doi.org/10.1109/C-M.1978.218219). The origin of the x86 instruction set — still, decades later, the dominant desktop and server ISA.
    - **Intel Microprocessors: 8008 to 8086** — Stephen Morse et al · [PDF](https://stevemorse.org/8086history/8086history.pdf). 47pp. The lead designer's own detailed history of how the 8086 came to be.

22. **Tuning the Pentium Pro Microarchitecture (P6)** — David B. Papworth · IEEE Micro 1996 · 8pp · [DOI](https://doi.org/10.1109/40.491458). The x86 turning point: a CISC ISA run as a high-performance out-of-order core by decoding instructions into RISC-like μops.
    - **Inside the P6** — Mark Smotherman (course notes) · [WEB](https://people.computing.clemson.edu/~mark/330/colwell/case_p6.html). A concise walkthrough of the P6 pipeline and the μop idea.

23. **The AMD Opteron Processor for Multiprocessor Servers** — Keltcher, McGrath, Ahmed, Conway · IEEE Micro 2003 · 11pp · [DOI](https://doi.org/10.1109/MM.2003.1196116) · [PDF](https://cse.ucdenver.edu/~gita/csprojects/CSC5593/Organization/Papers/keltcher-opteron.pdf). AMD64: the 64-bit extension that x86 actually kept, plus an on-chip memory controller and HyperTransport.

24. **Introducing the IA-64 Architecture** — Huck, Morris, Ross, Knies, Mulder, Zahir · IEEE Micro 2000 · 12pp · [DOI](https://doi.org/10.1109/40.877947) · [PDF](https://pages.cs.wisc.edu/~markhill/restricted/ieeemicro2000_ia64isa.pdf). The other 64-bit answer — a clean-slate HP/Intel ISA (Itanium) that bet on the compiler to expose parallelism explicitly (EPIC), predication, and speculation. The great counterexample: technically bold, commercially eclipsed by evolutionary AMD64.
    - **Understanding EPIC Architectures and Implementations** — Mark Smotherman · [PDF](https://people.computing.clemson.edu/~mark/464/acmse_epic.pdf). 8pp. A clear survey of what EPIC/VLIW promised and why in-order, compiler-scheduled parallelism struggled against out-of-order hardware.

25. **A 200-MHz 64-b Dual-Issue CMOS Microprocessor (Alpha 21064)** — Dobberpuhl, Witek, et al · IEEE JSSC 1992 · 13pp · [DOI](https://doi.org/10.1109/4.165353) · [PDF](https://www.cs.tufts.edu/~soha/paperArchive/1992%20A%20200-MHz%2064-b%20dual-issue%20CMOS%20microprocessor.pdf). The first Alpha: a clean 64-bit RISC clocked far past its contemporaries — the machine that reset the clock-speed race.

26. **The Alpha 21264 Microprocessor** — R. E. Kessler · IEEE Micro 1999 · 13pp · [DOI](https://doi.org/10.1109/40.755465) · [PDF](https://people.eecs.berkeley.edu/~kubitron/courses/cs252-S10/handouts/papers/alpha-ieee.pdf). An aggressive out-of-order superscalar RISC — a high-water mark for single-thread performance and a canonical microarchitecture case study.

27. **A 160-MHz, 32-b, 0.5-W CMOS RISC Microprocessor (StrongARM SA-110)** — Montanaro, Witek, et al · IEEE JSSC 1996 · 12pp · [DOI](https://doi.org/10.1109/JSSC.1996.542315) · [PDF](https://bioee.ee.columbia.edu/courses/ee6321/papers/00542315.pdf). The implementation that made ARM viable for high performance at very low power — the bridge from the RISC papers to the mobile world.

<!--html-->
<div class="why">
<b>Architecture outlives implementation.</b> The through-line of this list is the split
System/360 made explicit: an <em>instruction set</em> is a promise to software, while a
<em>microarchitecture</em> is one hardware team's way of keeping it. Virtual memory
(Atlas), caches (Model 85), and dynamic scheduling (6600, Model 91) are
microarchitectural tricks hidden behind that promise. The RISC papers argue about how
<em>simple</em> the promise should be so the hardware can go fast — and how <em>open</em>
it should be, from Sun's licensable SPARC to the free RISC-V. IA-64 pushed the promise
the other way, asking the compiler to schedule the parallelism explicitly, and lost to
an evolutionary AMD64. The x86 chapters (4004 → 8086 → P6 → Opteron) show a deliberately
un-simple promise surviving fifty years precisely because it was never tied to one
implementation.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Planning a Computer System: Project Stretch** — Werner Buchholz (ed.) · 1962 · 347pp · [PDF](https://www.bitsavers.org/pdf/ibm/7030/Planning_A_Computer_System.pdf). The book-length design record behind the 7030 — the fullest picture of the machine the Dunwell paper only sketches.
- **FREE** **Computer Engineering: A DEC View of Hardware Systems Design** — Bell, Mudge, McNamara · 1978 · 609pp · [PDF](https://bitsavers.org/pdf/dec/_Books/Bell-ComputerEngineering.pdf). The DEC minicomputers end-to-end, including the PDP-8 (the machine that made the minicomputer a category) alongside the PDP-11 and VAX.
- **BUY** **Computer Architecture: A Quantitative Approach** — Hennessy & Patterson · 6th ed. 2017 · 936pp · [page](https://shop.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1). The modern reference these machines seeded; the running examples trace straight back to the 6600, VAX, MIPS, and Alpha.
- **BUY** **Computer Architecture: Concepts and Evolution** — Blaauw & Brooks · 1997 · 1213pp · [page](https://www.pearson.com/en-us/subject-catalog/p/computer-architecture-concepts-and-evolution/P200000003491). A taxonomy of ISA design by two of the System/360 architects — the theory of the contract, from the people who invented it.

## Key terms

- **instruction set architecture (ISA)** — the programmer-visible interface (registers, instructions, memory model) a machine promises to implement.
- **microarchitecture** — how a particular chip realizes an ISA (pipeline depth, caches, execution units); invisible to correct software.
- **load/store architecture** — an ISA where only explicit load and store instructions touch memory; all arithmetic works on registers.
- **virtual memory / paging** — presenting programs a large address space backed automatically by a smaller physical store, introduced by Atlas.
- **cache** — a small fast memory holding recently used data, making a large slow main store look fast; first shipped in the System/360 Model 85.
- **pipelining** — overlapping the stages of successive instructions so several are in flight at once.
- **superscalar** — issuing more than one instruction per cycle from a single instruction stream (RS/6000, P6, Alpha 21264).
- **out-of-order execution** — issuing instructions as their operands become ready rather than in program order, to hide latency.
- **scoreboard** — the CDC 6600's hardware bookkeeping that tracks operand availability and hazards to schedule instructions.
- **register renaming / reservation stations** — Tomasulo's mechanism (Model 91) that removes false dependences by mapping architectural registers onto more physical ones.
- **RISC vs. CISC** — reduced vs. complex instruction sets: few simple fixed-length instructions the compiler schedules, versus rich variable-length instructions done in hardware/microcode.
- **micro-operations (μops)** — the internal RISC-like steps a CISC instruction is decoded into, as in the Pentium Pro.
- **register windows** — the RISC-I/SPARC scheme that gives each procedure call a fresh overlapping bank of registers to speed argument passing.
- **vector processor** — a machine (CRAY-1) with instructions that operate on whole arrays of data at once.
- **VLIW / EPIC** — encoding independent operations into wide instructions the compiler packs, shifting scheduling from hardware to the compiler; IA-64's central bet.
- **predication** — turning a branch into conditionally-executed instructions guarded by a boolean, to avoid mispredicting it; a defining IA-64 feature.
- **open ISA** — an instruction set anyone may implement without a license fee, from SPARC's published standard to the fully free RISC-V.
</content>
