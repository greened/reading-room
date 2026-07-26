# Computer architecture · Warehouse-scale computing

The datacenter is the computer: a warehouse of commodity parts, wired together and
programmed as one machine. This guide follows that idea from the ground up — first the
abstraction and its cost model, then the storage that holds the data, the frameworks
that compute over it, the software that schedules the fleet, the network that carries
the bytes, the power and latency limits that bound the whole thing, and finally where
the machine is being decomposed again into disaggregated and serverless resources.

> **How to read this list.** Read the two framing papers first — they give you the WSC
> abstraction and the energy argument that motivates everything after. Then the storage
> and compute layers (GFS through Spark) show how a pile of unreliable machines becomes
> a reliable data platform. The scheduling and network sections are the "operating
> system" and "bus" of the warehouse. Close with the power/tail-latency limits and the
> disaggregation papers, which are the frontier. The book in the reference shelf is the
> single best companion to the whole path.

## Reading order

### The warehouse as the machine
*Start here: the vocabulary, the reliability stance, and the cost model that every later paper assumes.*

1. **Web Search for a Planet: The Google Cluster Architecture** — Barroso, Dean, Hölzle · IEEE Micro 2003 · 7pp · [DOI](https://doi.org/10.1109/MM.2003.1196112) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//archive/googlecluster-ieee.pdf). Reliable planet-scale search built on unreliable commodity hardware — the paper that reframed the datacenter as the unit of design.

2. **The Case for Energy-Proportional Computing** — Barroso, Hölzle · IEEE Computer 2007 · 5pp · [DOI](https://doi.org/10.1109/MC.2007.443) · [PDF](https://www.barroso.org/publications/ieee_computer07.pdf). Servers are most efficient at full load but spend life half-idle; the case that energy use should track utilization. Shapes a decade of WSC hardware and scheduling.

### Storing the data
*A warehouse is first a place to keep data durably on parts that fail constantly; these are the storage substrates.*

3. **The Google File System** — Ghemawat, Gobioff, Leung · SOSP 2003 · 15pp · [DOI](https://doi.org/10.1145/945445.945450) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//archive/gfs-sosp2003.pdf). A scalable, fault-tolerant distributed file system whose design assumes failure is the common case — the storage floor the rest of the stack stands on.

4. **Bigtable: A Distributed Storage System for Structured Data** — Chang et al. · OSDI 2006 · 14pp · [DOI](https://doi.org/10.1145/1365815.1365816) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//archive/bigtable-osdi06.pdf). The sparse, sorted, distributed map over GFS that made petabyte-scale structured storage routine.
   - **Companion — Finding a Needle in Haystack (Facebook photo storage)** — [PDF](https://www.usenix.org/legacy/event/osdi10/tech/full_papers/Beaver.pdf) · 14pp. A contrasting production object store, tuned for one huge read-mostly BLOB workload.

5. **Dynamo: Amazon's Highly Available Key-value Store** — DeCandia et al. · SOSP 2007 · 16pp · [DOI](https://doi.org/10.1145/1294261.1294281) · [PDF](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf). Chooses availability over strong consistency for the shopping cart — the eventual-consistency design that seeded a generation of NoSQL stores.

6. **Spanner: Google's Globally-Distributed Database** — Corbett et al. · OSDI 2012 · 14pp · [DOI](https://doi.org/10.1145/2491245) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//archive/spanner-osdi2012.pdf). Swings back the other way: externally-consistent transactions across continents, using TrueTime and synchronized clocks to bound uncertainty.

7. **The Case for RAMCloud** — Ousterhout et al. · CACM 2011 · 14pp · [DOI](https://doi.org/10.1145/1965724.1965751) · [PDF](https://web.stanford.edu/~ouster/cgi-bin/papers/ramcloud.pdf). Keep all data in DRAM across the whole datacenter for microsecond access — the argument that memory, not disk, should be the warehouse's storage tier.

### Programming the warehouse
*Once the data is stored, the question is how thousands of machines compute over it without the programmer thinking about any one of them.*

8. **MapReduce: Simplified Data Processing on Large Clusters** — Dean, Ghemawat · OSDI 2004 (CACM 2008) · 13pp · [DOI](https://doi.org/10.1145/1327452.1327492) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//archive/mapreduce-osdi04.pdf). Two functions and a runtime that hides fault tolerance, data movement, and parallelism — the programming model that made large-scale batch processing ordinary.

9. **Resilient Distributed Datasets (Spark)** — Zaharia et al. · NSDI 2012 · 14pp · [PDF](https://www.usenix.org/system/files/conference/nsdi12/nsdi12-final138.pdf). In-memory, lineage-based fault tolerance that made iterative and interactive cluster computing fast — MapReduce's successor for the analytics workload.

### Coordinating and scheduling the fleet
*Turning a pile of machines into one managed system: agreement, resource sharing, and placement.*

10. **The Chubby Lock Service for Loosely-coupled Distributed Systems** — Burrows · OSDI 2006 · 16pp · [PDF](https://static.googleusercontent.com/media/research.google.com/en//archive/chubby-osdi06.pdf). Coarse-grained locking and small-file storage backed by Paxos — the coordination primitive under GFS, Bigtable, and cluster election.

11. **Mesos: A Platform for Fine-Grained Resource Sharing in the Data Center** — Hindman et al. · NSDI 2011 · 14pp · [PDF](https://www.usenix.org/legacy/event/nsdi11/tech/full_papers/Hindman.pdf). Resource offers that let many frameworks share one cluster — the two-level scheduling model behind much of the open-source stack.

12. **Omega: Flexible, Scalable Schedulers for Large Compute Clusters** — Schwarzkopf et al. · EuroSys 2013 · 14pp · [DOI](https://doi.org/10.1145/2465351.2465386) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/41684.pdf). Shared-state, optimistic-concurrency scheduling — the argument that monolithic and two-level schedulers both hit a wall at scale.

13. **Large-scale Cluster Management at Google with Borg** — Verma et al. · EuroSys 2015 · 18pp · [DOI](https://doi.org/10.1145/2741948.2741964) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43438.pdf). The production cluster manager that runs Google, and the direct ancestor of Kubernetes.

14. **Borg, Omega, and Kubernetes** — Burns, Grant, Oppenheimer, Brewer, Wilkes · ACM Queue 2016 · 24pp · [DOI](https://doi.org/10.1145/2898442.2898444) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/44843.pdf). A decade of lessons across three schedulers — the retrospective that explains why Kubernetes looks the way it does.

### The datacenter network
*Bandwidth between servers is the scarce resource; these papers build the fabric and then run it like software.*

15. **A Scalable, Commodity Data Center Network Architecture** — Al-Fares, Loukissas, Vahdat · SIGCOMM 2008 · 12pp · [DOI](https://doi.org/10.1145/1402958.1402967) · [PDF](https://cseweb.ucsd.edu/~vahdat/papers/sigcomm08.pdf). The fat-tree/Clos design that delivers full-bisection bandwidth from cheap commodity switches — the topology the rest of the section builds on.

16. **VL2: A Scalable and Flexible Data Center Network** — Greenberg et al. · SIGCOMM 2009 · 12pp · [DOI](https://doi.org/10.1145/1592568.1592576) · [PDF](https://people.eecs.berkeley.edu/~sylvia/cs268-2019/papers/vl2.pdf). Valiant load balancing and a flat address space that give any server full rate to any other — the agility case for WSC networks.

17. **B4: Experience with a Globally-Deployed Software Defined WAN** — Jain et al. · SIGCOMM 2013 · 12pp · [DOI](https://doi.org/10.1145/2486001.2486019) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/41761.pdf). SDN and centralized traffic engineering driving Google's inter-datacenter WAN to near-100% link utilization.

18. **Jupiter Rising: A Decade of Clos Topologies and Centralized Control in Google's Datacenter Network** — Singh et al. · SIGCOMM 2015 · 15pp · [DOI](https://doi.org/10.1145/2785956.2787508) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43837.pdf). Five generations of intra-datacenter Clos fabrics with SDN control — how the fat-tree idea was industrialized.
   - **Companion — Maglev: A Fast and Reliable Software Network Load Balancer** — [PDF](https://www.usenix.org/system/files/conference/nsdi16/nsdi16-paper-eisenbud.pdf) · 14pp. The commodity-server load balancer that sits at the edge of that fabric.

### Power, latency, and the physical limits
*The fabric and the scheduler can only do so much; power delivery and tail latency are the hard physical bounds on a warehouse.*

19. **Power Provisioning for a Warehouse-sized Computer** — Fan, Weber, Barroso · ISCA 2007 · 11pp · [DOI](https://doi.org/10.1145/1273440.1250665) · [PDF](https://www.barroso.org/publications/power_provisioning.pdf). Measured power across thousands of servers reveals headroom to safely oversubscribe the power budget — money that would otherwise be stranded.

20. **The Tail at Scale** — Dean, Barroso · CACM 2013 · 7pp · [DOI](https://doi.org/10.1145/2408776.2408794) · [PDF](https://www.barroso.org/publications/TheTailAtScale.pdf). Names and tames latency variability in large fan-out services, where the slowest component dictates the user-visible response time.
   - **Companion — Heracles: Improving Resource Efficiency at Scale** — [DOI](https://doi.org/10.1145/2749469.2749475) · [PDF](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43792.pdf) · 13pp. Safely co-locating batch work with a latency-critical service to reclaim the idle headroom the tail forces you to leave.

21. **Attack of the Killer Microseconds** — Barroso, Marty, Patterson, Ranganathan · CACM 2017 · 7pp · [DOI](https://doi.org/10.1145/3015146) · [PDF](https://www.barroso.org/publications/AttackoftheKillerMicroseconds.pdf). New I/O devices land in an awkward microsecond regime that neither interrupts nor polling handle well — a call to rethink the systems stack for it.

### Beyond the server: disaggregation and serverless
*The frontier: decomposing the machine itself, and hiding the warehouse entirely behind functions.*

22. **Network Requirements for Resource Disaggregation** — Gao et al. · OSDI 2016 · 17pp · [PDF](https://www.usenix.org/system/files/conference/osdi16/osdi16-gao.pdf). Quantifies the network latency and bandwidth needed before you can break the server into pooled CPU, memory, and storage — the feasibility study for disaggregation.

23. **LegoOS: A Disseminated, Distributed OS for Hardware Resource Disaggregation** — Shan, Huang, Chen, Zhang · OSDI 2018 · 20pp · [PDF](https://www.usenix.org/system/files/osdi18-shan.pdf). An operating system built for disaggregated hardware, splitting the kernel across independent compute, memory, and storage components.

24. **Cloud Programming Simplified: A Berkeley View on Serverless Computing** — Jonas et al. · UC Berkeley 2019 · 33pp · [PDF](https://arxiv.org/pdf/1902.03383). The synthesis of where the WSC abstraction is going for developers: functions, not servers — plus a clear-eyed account of what serverless still can't do.
   - **Companion — Occupy the Cloud: Distributed Computing for the 99% (PyWren)** — [DOI](https://doi.org/10.1145/3127479.3128601) · [PDF](https://arxiv.org/pdf/1702.04024) · 8pp. The small, concrete demonstration that stateless functions can do real distributed computing.

## Reference shelf — books

- **FREE** **The Datacenter as a Computer: Designing Warehouse-Scale Machines (3rd ed.)** — Barroso, Hölzle, Ranganathan · 2018 · 209pp · [PDF](https://pages.cs.wisc.edu/~shivaram/cs744-readings/dc-computer-v3.pdf). The canonical text that named the field; read chapters 1–2 before anything else here, and use the rest as the reference for every topic above.
- **BUY** **Designing Data-Intensive Applications** — Martin Kleppmann · 2017 · 616pp · [page](https://dataintensive.net/). Ties the storage, replication, consistency, and batch/stream-processing papers together for the practitioner building on top of a WSC.

## Key terms

- **warehouse-scale computer (WSC)** — a datacenter designed and programmed as a single large machine, not a room of independent servers.
- **energy-proportional** — hardware whose power draw scales down with utilization, so a half-idle machine costs roughly half the energy.
- **tail latency** — the high-percentile (p99, p999) response time; in a fan-out service the slowest of many parallel calls sets the user-visible latency.
- **bisection bandwidth** — the bandwidth across the worst-case cut of the network; full bisection means any server can talk to any other at full rate.
- **Clos / fat-tree** — a multi-stage switching topology that builds high-bandwidth fabrics from many small commodity switches.
- **external consistency** — transactions appear to commit in an order consistent with real (wall-clock) time; Spanner's guarantee, backed by TrueTime.
- **eventual consistency** — replicas may diverge briefly but converge if writes stop; Dynamo's trade for high availability.
- **disaggregation** — pooling CPU, memory, and storage as independent network-attached resources rather than fixing their ratio inside one server.
- **serverless / FaaS** — an execution model where the provider runs short-lived stateless functions and hides all server and capacity management.
- **two-level scheduling** — a resource manager (e.g. Mesos) offers resources to independent framework schedulers that decide what to run.
