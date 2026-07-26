# Machine learning · Agentic AI — the LLM-agent line

An *agent* is a language model put in a loop: it reasons about a goal, takes an
action in some environment, observes the result, and repeats until it is done. The
papers below trace how that loop was built up, one capability at a time — first
teaching a model to *reason* in steps, then to *act* through tools, then to *ground*
itself in retrieved knowledge, then to *reflect* and *remember*, and finally to
*coordinate* with other agents — closing with the benchmarks that measure whether any
of it works. Read them in that order: each capability assumes the ones before it.

> **How to read this list.** The path is capability-first, not chronological. Start
> with reasoning (Chain-of-Thought → Tree of Thoughts): everything else is a
> loop wrapped around a model that can reason. Then read ReAct, which is the hinge of
> the whole field — it fuses reasoning with acting, and the rest of the tool-use,
> memory, and multi-agent work elaborates on it. If you read only three, read
> Chain-of-Thought, ReAct, and Reflexion. For a bird's-eye view first, Lilian Weng's
> essay below is the single best map of the territory.

- **Read-first companion** — Lilian Weng, [LLM-Powered Autonomous Agents](https://lilianweng.github.io/posts/2023-06-23-agent/). The canonical overview: planning, memory, and tool use as the three pillars of an agent. Read it before the papers for the map, and again after for the connections.
- **Read-first companion** — Anthropic, [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents). The practitioner's counterpoint: when a simple workflow beats an autonomous agent, and the handful of patterns that actually pay off.

## Reading order

### Reasoning — the substrate
*Everything else is a loop around a model that can reason in steps, so start here.*

1. **Show Your Work: Scratchpads for Intermediate Computation** — Nye, Andreassen, Gur-Ari, Michalewski, Austin, Bosma, Dohan, Jiang, Cai, Terry, Le, Sutton · 2021 · 16pp · [PDF](https://arxiv.org/pdf/2112.00114). The seed idea: let the model write its intermediate steps into a "scratchpad" and its multi-step accuracy jumps. Chain-of-Thought is this idea, generalized.

2. **Chain-of-Thought Prompting Elicits Reasoning in Large Language Models** — Wei, Wang, Schuurmans, Bosma, Ichter, Xia, Chi, Le, Zhou · NeurIPS 2022 · 43pp · [PDF](https://arxiv.org/pdf/2201.11903). The founding result: prompting a model to "think step by step" unlocks reasoning that only emerges at scale. The bedrock every later method builds on.

3. **Self-Consistency Improves Chain-of-Thought Reasoning** — Wang, Wei, Schuurmans, Le, Chi, Narang, Chowdhery, Zhou · ICLR 2023 · 24pp · [PDF](https://arxiv.org/pdf/2203.11171). Sample many reasoning chains and take the majority answer. The first hint that *search over reasoning* beats a single greedy chain.

4. **Tree of Thoughts: Deliberate Problem Solving with LLMs** — Yao, Yu, Zhao, Shafran, Griffiths, Cao, Narasimhan · NeurIPS 2023 · 14pp · [PDF](https://arxiv.org/pdf/2305.10601). Generalizes a chain into a search tree with lookahead and backtracking. Reasoning becomes deliberate search, not a single forward pass.

### Acting — reasoning that reaches into the world
*A reasoner that can only talk is not an agent; here it starts calling tools and observing results. ReAct is the hinge of the whole field.*

5. **ReAct: Synergizing Reasoning and Acting in Language Models** — Yao, Zhao, Yu, Du, Shafran, Narasimhan, Cao · ICLR 2023 · 33pp · [PDF](https://arxiv.org/pdf/2210.03629). The pivotal paper: interleave *reasoning* traces with *actions* (tool calls) and observations. This thought→act→observe loop is the template nearly every later agent uses.
   - **Companion** — Lilian Weng's [agent essay](https://lilianweng.github.io/posts/2023-06-23-agent/) diagrams the ReAct loop against the planning/memory/tools pillars.

6. **MRKL Systems** — Karpas, Abend, Belinkov, Lenz, Lieber, Ratner, Shoham, Bata, Levine, Leyton-Brown, Muhlgay, Rozen, Schwartz, Shachaf, Shalev-Shwartz, Shashua, Tenenholtz · 2022 · 19pp · [PDF](https://arxiv.org/pdf/2205.00445). Modular Reasoning, Knowledge and Language: route each subquery to an expert module or symbolic tool. The blueprint behind "the model decides which tool to call".

7. **PAL: Program-aided Language Models** — Gao, Madaan, Zhou, Alon, Liu, Yang, Callan, Neubig · ICML 2023 · 34pp · [PDF](https://arxiv.org/pdf/2211.10435). Offload the *computation* to a Python interpreter: the model writes a program, the runtime executes it. Tool use as a cure for arithmetic and logic errors.

8. **Toolformer: Language Models Can Teach Themselves to Use Tools** — Schick, Dwivedi-Yu, Dessì, Raileanu, Lomeli, Zettlemoyer, Cancedda, Scialom · NeurIPS 2023 · 17pp · [PDF](https://arxiv.org/pdf/2302.04761). The model learns *when and how* to call APIs (calculator, search, translation) by self-annotating its own training data — tool use baked into the weights rather than the prompt.
   - **Companion** — OpenAI, [Function calling guide](https://platform.openai.com/docs/guides/function-calling). How this became a first-class API primitive: the model emits a structured call the runtime executes.
   - **Companion** — Anthropic, [Model Context Protocol](https://modelcontextprotocol.io/) ([announcement](https://www.anthropic.com/news/model-context-protocol), [spec](https://modelcontextprotocol.io/specification/2025-06-18)). The open standard that turns ad-hoc tool integrations into a common client/server protocol for tools, resources, and prompts.

9. **WebGPT: Browser-assisted Question-answering with Human Feedback** — Nakano, Hilton, Balaji, Wu, Ouyang, Kim, Hesse, Jain, Kosaraju, Saunders, Jiang, Cobbe, Eloundou, Krueger, Button, Knight, Chess, Schulman · 2021 · 32pp · [PDF](https://arxiv.org/pdf/2112.09332). An early, influential demonstration of an LLM *acting* in a live tool — a web browser — with citations, trained from human feedback.

10. **Gorilla: LLMs Connected with Massive APIs** — Patil, Zhang, Wang, Gonzalez · 2023 · 18pp · [PDF](https://arxiv.org/pdf/2305.15334). Teaches a model to emit correct calls across thousands of real APIs and cut hallucinated calls — tool use at the scale of a whole API ecosystem.

### Retrieval augmentation — grounding the reasoner in facts
*An agent that reasons and acts still confabulates; retrieval grounds it in an external corpus. Read this before memory — memory is retrieval over the agent's own history.*

11. **REALM: Retrieval-Augmented Language Model Pre-Training** — Guu, Lee, Tung, Pasupat, Chang · ICML 2020 · 12pp · [PDF](https://arxiv.org/pdf/2002.08909). Learns a neural retriever *jointly* with the language model, so retrieval is trained end-to-end rather than bolted on.

12. **Retrieval-Augmented Generation for Knowledge-Intensive NLP (RAG)** — Lewis, Perez, Piktus, Petroni, Karpukhin, Goyal, Küttler, Lewis, Yih, Rocktäschel, Riedel, Kiela · NeurIPS 2020 · 19pp · [PDF](https://arxiv.org/pdf/2005.11401). The paper that named RAG: retrieve passages, condition generation on them. The dominant pattern for giving agents fresh, checkable knowledge.

13. **Leveraging Passage Retrieval with Generative Models (Fusion-in-Decoder)** — Izacard, Grave · EACL 2021 · 6pp · [DOI](https://doi.org/10.18653/v1/2021.eacl-main.74) · [PDF](https://arxiv.org/pdf/2007.01282). Retrieve many passages and fuse them in the decoder, scaling how much evidence a model can read at once.

14. **Self-RAG: Learning to Retrieve, Generate, and Critique** — Asai, Wu, Wang, Sil, Hajishirzi · ICLR 2024 · 30pp · [PDF](https://arxiv.org/pdf/2310.11511). The model decides *when* to retrieve and critiques its own output with "reflection tokens" — retrieval that is itself an agentic decision.

### Reflection & memory — learning within and across episodes
*Now the loop learns from its own mistakes and carries state forward. Reflection needs a reasoner (§1) and grounding (§3); memory is retrieval turned inward.*

15. **Self-Refine: Iterative Refinement with Self-Feedback** — Madaan, Tandon, Gupta, Hallinan, Gao, Wiegreffe, Alon, Dziri, Prabhumoye, Yang, Gupta, Majumder, Hermann, Welleck, Yazdanbakhsh, Clark · NeurIPS 2023 · 54pp · [PDF](https://arxiv.org/pdf/2303.17651). One model generates, critiques, and revises its own output in a loop — the simplest form of reflection, no extra training.

16. **Reflexion: Language Agents with Verbal Reinforcement Learning** — Shinn, Cassano, Berman, Gopinath, Narasimhan, Yao · NeurIPS 2023 · 19pp · [PDF](https://arxiv.org/pdf/2303.11366). After a failed attempt the agent writes a natural-language "lesson" into memory and retries — learning across episodes without gradient updates. The reflection paper to read.

17. **Generative Agents: Interactive Simulacra of Human Behavior** — Park, O'Brien, Cai, Morris, Liang, Bernstein · UIST 2023 · 22pp · [DOI](https://doi.org/10.1145/3586183.3606763) · [PDF](https://arxiv.org/pdf/2304.03442). Twenty-five agents in a sandbox town, each with a memory stream, reflection, and planning — the influential blueprint for long-lived agent memory.

18. **Voyager: An Open-Ended Embodied Agent with LLMs** — Wang, Xie, Jiang, Mandlekar, Xiao, Zhu, Fan, Anandkumar · 2023 · 42pp · [PDF](https://arxiv.org/pdf/2305.16291). An agent in Minecraft that writes, tests, and stores reusable *skills* as code — a growing library of competence, i.e. procedural memory.

19. **MemGPT: LLMs as Operating Systems** — Packer, Wooders, Lin, Fang, Patil, Stoica, Gonzalez · 2023 · 13pp · [PDF](https://arxiv.org/pdf/2310.08560). Treats the context window like RAM and external storage like disk, paging memories in and out — how an agent transcends a fixed context length.

### Planning & multi-agent — many agents, coordinated
*A single agent hits limits; here agents plan, argue, and divide labor. This assumes the whole single-agent stack above.*

20. **Improving Factuality and Reasoning via Multiagent Debate** — Du, Li, Torralba, Tenenbaum, Mordatch · 2023 · 27pp · [PDF](https://arxiv.org/pdf/2305.14325). Several model instances debate and converge, improving factuality — the "society of minds" idea made concrete.

21. **CAMEL: Communicative Agents for "Mind" Exploration** — Li, Hammoud, Itani, Khizbullin, Ghanem · NeurIPS 2023 · 77pp · [PDF](https://arxiv.org/pdf/2303.17760). Role-playing agents (a "user" and an "assistant") cooperate through structured dialogue to complete a task autonomously — a foundational multi-agent framework.

22. **AutoGen: Multi-Agent Conversation Framework** — Wu, Bansal, Zhang, Wu, Li, Zhu, Jiang, Zhang, Zhang, Liu, Awadallah, White, Burger, Wang · 2023 · 43pp · [PDF](https://arxiv.org/pdf/2308.08155). A general framework for building applications as conversations among configurable agents (including tool-using and human-in-the-loop ones) — the engineering substrate under many agent systems.
    - **Companion** — [AutoGPT](https://github.com/Significant-Gravitas/AutoGPT) and [BabyAGI](https://github.com/yoheinakajima/babyagi). The 2023 open-source projects that popularized the autonomous "goal → plan → execute → repeat" loop and put "agent" in everyone's vocabulary.

### Evaluation & surveys — does any of it actually work?
*Capabilities are worth only what they measure; end here to calibrate the claims above and see the field whole.*

23. **AgentBench: Evaluating LLMs as Agents** — Liu, Yu, Zhang, Xu, Lei, Lai, Gu, Ding, Men, Yang, Zhang, Deng, Zeng, Du, Zhang, Wang, Shan, Jiang, Tang, Dong · ICLR 2024 · 58pp · [PDF](https://arxiv.org/pdf/2308.03688). A multi-environment benchmark (OS, DB, web, games) that exposed how far open models trail closed ones at *acting*, not just answering.

24. **GAIA: A Benchmark for General AI Assistants** — Mialon, Fourrier, Swift, Wolf, LeCun, Scialom · ICLR 2024 · 24pp · [PDF](https://arxiv.org/pdf/2311.12983). Questions that are easy for humans but require tool use and multi-step reasoning for models — a deliberately hard bar for "general assistant" claims.

25. **SWE-bench: Can LMs Resolve Real-World GitHub Issues?** — Jimenez, Yang, Wettig, Yao, Pei, Press, Narasimhan · ICLR 2024 · 52pp · [PDF](https://arxiv.org/pdf/2310.06770). Real issues from real repositories, scored by the project's own test suite — the benchmark that now defines agentic *coding* and drives much of the current frontier.

26. **A Survey on Large Language Model based Autonomous Agents** — Wang, Ma, Feng, Zhang, Yang, Zhang, Chen, Tang, Chen, Lin, Zhao, Wei, Wen · 2023 · 42pp · [PDF](https://arxiv.org/pdf/2308.11432). Organizes the field into construction, application, and evaluation — the map to read once the papers above have given you the terrain.
    - **Companion** — Xi et al., [The Rise and Potential of LLM Based Agents: A Survey](https://arxiv.org/pdf/2309.07864) (86pp). A second, complementary survey built around the brain / perception / action decomposition.

<!--html-->
<div class="why">
<b>An agent is a loop, not a model.</b> Strip the field to its skeleton and every system
here is the same cycle: <em>reason</em> about the goal (§1), <em>act</em> through a tool and
read the result (§2), stay <em>grounded</em> in retrieved facts (§3), <em>reflect</em> on
failures and <em>remember</em> what worked (§4), and where one agent isn't enough,
<em>coordinate</em> with others (§5). The benchmarks (§6) exist because that loop is easy to
demo and hard to make reliable — which is the open problem of the whole area.
</div>
<!--/html-->

## Reference shelf — books & further reading

- **FREE** **Speech and Language Processing (3rd ed. draft)** — Dan Jurafsky & James H. Martin · ongoing · 600+pp · [PDF](https://web.stanford.edu/~jurafsky/slp3/). The standard NLP text; its later chapters cover prompting, RAG, and chain-of-thought reasoning from the ground up.
- **FREE** **Prompt Engineering Guide** — DAIR.ai · living · [page](https://www.promptingguide.ai/). A maintained, example-heavy reference for CoT, ReAct, self-consistency, RAG, and the other prompting patterns the papers introduce.
- **BUY** **AI Engineering** — Chip Huyen · O'Reilly 2024 · 500+pp · [page](https://huyenchip.com/books/). Building applications on foundation models, with substantial, practical treatment of RAG and agents.
- **BUY** **AI Agents in Action** — Micheal Lanham · Manning 2025 · 400+pp · [page](https://www.manning.com/books/ai-agents-in-action). A hands-on tour of planning, memory, tool use, and multi-agent orchestration in code.

## Key terms

- **agent** — a language model run in a loop that reasons about a goal, takes actions in an environment, observes the results, and repeats until done.
- **tool** — an external function or service (calculator, search, code interpreter, API) the model can invoke to act or fetch information beyond its weights.
- **ReAct loop** — the interleaving of *reasoning* traces with *actions* and *observations* — thought → act → observe, repeated — the template most agents follow.
- **chain-of-thought** — prompting the model to emit intermediate reasoning steps before its answer, which raises multi-step accuracy at scale.
- **RAG** — retrieval-augmented generation: fetch relevant passages from an external corpus and condition the model's output on them, to ground it in checkable facts.
- **reflection** — an agent critiquing its own output or a failed attempt and revising, often writing a natural-language lesson into memory for the next try.
- **planning** — decomposing a goal into an ordered set of subgoals or actions before (or while) executing them.
- **memory** — state an agent carries beyond a single turn: a context window (short-term) plus external storage it retrieves from (long-term).
- **function calling** — the model emitting a structured, machine-readable tool invocation that the surrounding runtime parses and executes.
- **MCP (Model Context Protocol)** — an open client/server standard for connecting agents to tools, data sources, and prompts through a common interface.
- **grounding** — tying a model's output to an external source of truth (retrieved documents, tool results) so claims can be checked rather than confabulated.
- **scaffolding** — the surrounding harness (prompts, control flow, memory, tool wiring) that turns a bare model into an agent.
