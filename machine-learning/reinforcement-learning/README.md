# Machine learning · Reinforcement learning

Reinforcement learning is the study of agents that learn from reward rather than
labels. This guide follows the field's own logic: start with the tabular ideas that
define its vocabulary — value functions, temporal-difference learning, off-policy
control — then the policy-gradient family that optimizes behavior directly, then the
deep-network era that scaled both to pixels and continuous control, then the
distributed systems, exploration methods, and offline algorithms that industrialized
it, then the planning-and-self-play line that mastered Go and chess, and finally RL
from human feedback, where the field now touches everyone through large language
models. Read top to bottom: each section assumes the one before it.

> **How to read this list.** The two foundational families are *value-based*
> (learn what states are worth, then act greedily) and *policy-gradient* (adjust the
> policy directly). Sections 1 and 2 give you each in its tabular, provable form; the
> deep-RL sections that follow are those same two ideas with neural-network function
> approximators and the engineering needed to make them stable. If you only read
> three papers, read Sutton's TD paper, DQN, and PPO.

## Reading order

### Foundations — tabular RL
*The ideas every later paper assumes: value functions, bootstrapping, and off-policy control, all provable in the tabular setting.*
1. **Learning to Predict by the Methods of Temporal Differences** — Richard Sutton · Machine Learning 1988 · 37pp · [DOI](https://doi.org/10.1007/BF00115009) · [PDF](http://incompleteideas.net/papers/sutton-88-with-erratum.pdf). Introduced TD learning, RL's foundational idea: bootstrap a prediction from later predictions instead of waiting for the final outcome.
   - **RL Course — Lecture 1: Introduction** — David Silver · [VIDEO](https://www.youtube.com/watch?v=2pWv7GOvuf0). The classic UCL lecture series; the clearest spoken introduction to everything in this section.
2. **Q-learning** — Chris Watkins, Peter Dayan · Machine Learning 1992 · 14pp · [DOI](https://doi.org/10.1007/BF00992698) · [PDF](http://www.gatsby.ucl.ac.uk/~dayan/papers/cjch.pdf). The canonical model-free, off-policy control algorithm, with a convergence proof — learn the optimal action-values while following any exploratory policy.
3. **On-line Q-learning using Connectionist Systems (SARSA)** — Gavin Rummery, Mahesan Niranjan · Cambridge tech report 1994 · 21pp · [PDF](http://mi.eng.cam.ac.uk/reports/svr-ftp/auto-pdf/rummery_tr166.pdf). The on-policy counterpart to Q-learning and the origin of the SARSA update; the contrast between the two defines on- vs off-policy learning.

### Policy gradients — optimize the policy directly
*Instead of learning values and acting greedily, adjust the policy's parameters up the reward gradient — the family that scales to continuous actions and underlies RLHF.*
4. **Simple Statistical Gradient-Following Algorithms (REINFORCE)** — Ronald Williams · Machine Learning 1992 · 27pp · [DOI](https://doi.org/10.1007/BF00992696) · [PDF](https://people.cs.umass.edu/~barto/courses/cs687/williams92simple.pdf). The REINFORCE family: unbiased policy-gradient estimates from sampled returns, the root of every method in this section.
   - **Deep Reinforcement Learning: Pong from Pixels** — Andrej Karpathy · [WEB](http://karpathy.github.io/2016/05/31/rl/). A hands-on walkthrough that makes the REINFORCE gradient concrete in about 130 lines of code.
5. **Policy Gradient Methods for RL with Function Approximation** — Sutton, McAllester, Singh, Mansour · NeurIPS 2000 · 7pp · [PDF](https://proceedings.neurips.cc/paper/1999/file/464d828b85b0bed98e80ade0a5c43b0f-Paper.pdf). Proves the policy-gradient theorem for function approximators and introduces the actor-critic template the deep methods below all follow.
   - **Policy Gradient Algorithms** — Lilian Weng · [WEB](https://lilianweng.github.io/posts/2018-04-08-policy-gradient/). A single well-organized derivation chain from REINFORCE through A3C, TRPO, PPO, DDPG, and SAC.
6. **A Natural Policy Gradient** — Sham Kakade · NeurIPS 2001 · 8pp · [PDF](https://proceedings.neurips.cc/paper/2001/file/4b86abe48d358ecf194c56c69108433e-Paper.pdf). Reshapes the gradient by the Fisher information metric so updates are invariant to how the policy is parameterized — the idea TRPO and PPO later make practical.
7. **Deterministic Policy Gradient Algorithms (DPG)** — Silver, Lever, Heess, Degris, Wierstra, Riedmiller · ICML 2014 · 9pp · [PDF](http://proceedings.mlr.press/v32/silver14.pdf). Shows a deterministic policy has a tractable gradient, setting up off-policy continuous control and DDPG.

### Deep value-based RL — the breakthrough
*Neural nets as value-function approximators, plus the engineering (replay, target networks, and their successive fixes) that made them stable.*
8. **Human-level Control through Deep Reinforcement Learning (DQN)** — Mnih et al. · Nature 2015 · 13pp · [DOI](https://doi.org/10.1038/nature14236) · [PDF](https://web.stanford.edu/class/psych209/Readings/MnihEtAlHassibis15NatureControlDeepRL.pdf). Learned to play Atari from pixels with experience replay and a target network; the paper that founded deep RL.
9. **Deep RL with Double Q-learning (Double DQN)** — van Hasselt, Guez, Silver · AAAI 2016 · 13pp · [DOI](https://doi.org/10.1609/aaai.v30i1.10295) · [PDF](https://arxiv.org/pdf/1509.06461). Diagnoses and corrects DQN's systematic overestimation of action values with a small, decisive change.
10. **Prioritized Experience Replay** — Schaul, Quan, Antonoglou, Silver · ICLR 2016 · 21pp · [arXiv](https://arxiv.org/abs/1511.05952) · [PDF](https://arxiv.org/pdf/1511.05952). Replays surprising transitions more often, sharply improving DQN's sample efficiency.
11. **Dueling Network Architectures for Deep RL** — Wang et al. · ICML 2016 · 15pp · [arXiv](https://arxiv.org/abs/1511.06581) · [PDF](https://arxiv.org/pdf/1511.06581). Splits the value function into state-value and advantage streams, learning which states matter without learning each action's effect.
12. **A Distributional Perspective on Reinforcement Learning (C51)** — Bellemare, Dabney, Munos · ICML 2017 · 19pp · [arXiv](https://arxiv.org/abs/1707.06887) · [PDF](https://arxiv.org/pdf/1707.06887). Learns the full distribution of returns instead of just their mean, a richer signal that became one of Rainbow's biggest ingredients.
13. **Rainbow: Combining Improvements in Deep RL** — Hessel et al. · AAAI 2018 · 14pp · [DOI](https://doi.org/10.1609/aaai.v32i1.11796) · [PDF](https://arxiv.org/pdf/1710.02298). Shows the DQN extensions above are complementary and combines six of them into one strong agent — the capstone of the value-based line.

### Deep policy-gradient & actor-critic
*Bring deep networks to the policy-gradient family; these are the methods that dominate continuous control and became the RLHF default.*
14. **Asynchronous Methods for Deep RL (A3C)** — Mnih et al. · ICML 2016 · 19pp · [arXiv](https://arxiv.org/abs/1602.01783) · [PDF](https://arxiv.org/pdf/1602.01783). Parallel actors decorrelate experience without a replay buffer — a simple, fast deep actor-critic.
15. **Trust Region Policy Optimization (TRPO)** — Schulman, Levine, Moritz, Jordan, Abbeel · ICML 2015 · 16pp · [arXiv](https://arxiv.org/abs/1502.05477) · [PDF](https://arxiv.org/pdf/1502.05477). Constrains each policy update to a trust region, giving monotonic-improvement guarantees and stable large-scale policy optimization.
16. **High-Dimensional Continuous Control Using Generalized Advantage Estimation (GAE)** — Schulman, Moritz, Levine, Jordan, Abbeel · ICLR 2016 · 14pp · [arXiv](https://arxiv.org/abs/1506.02438) · [PDF](https://arxiv.org/pdf/1506.02438). The bias-variance advantage estimator that the trust-region methods rely on in practice.
17. **Proximal Policy Optimization Algorithms (PPO)** — Schulman, Wolski, Dhariwal, Radford, Klimov · arXiv 2017 · 12pp · [arXiv](https://arxiv.org/abs/1707.06347) · [PDF](https://arxiv.org/pdf/1707.06347). Replaces TRPO's hard constraint with a clipped objective — the robust, simple policy-gradient method that became the RL and RLHF default.
    - **Spinning Up in Deep RL** — OpenAI · [WEB](https://spinningup.openai.com/en/latest/). An educational codebase and write-up with clean reference implementations of VPG, TRPO, PPO, DDPG, and SAC.
18. **Continuous Control with Deep RL (DDPG)** — Lillicrap et al. · ICLR 2016 · 14pp · [arXiv](https://arxiv.org/abs/1509.02971) · [PDF](https://arxiv.org/pdf/1509.02971). Extends deterministic policy gradients and DQN-style replay to continuous action spaces.
19. **Addressing Function Approximation Error in Actor-Critic Methods (TD3)** — Fujimoto, van Hoof, Meger · ICML 2018 · 15pp · [arXiv](https://arxiv.org/abs/1802.09477) · [PDF](https://arxiv.org/pdf/1802.09477). Brings Double-DQN's overestimation fix to continuous control with twin critics and delayed policy updates, turning DDPG into a reliable baseline.
20. **Soft Actor-Critic (SAC)** — Haarnoja, Zhou, Abbeel, Levine · ICML 2018 · 14pp · [arXiv](https://arxiv.org/abs/1801.01290) · [PDF](https://arxiv.org/pdf/1801.01290). Adds a maximum-entropy objective for exploration and stability — the strong off-policy continuous-control baseline today.

### Scaling up — distributed agents
*The same deep methods, re-engineered to run on hundreds of actors; this is how deep RL went from a single machine to industrial scale.*
21. **IMPALA: Scalable Distributed Deep-RL with Importance Weighted Actor-Learner Architectures** — Espeholt et al. · ICML 2018 · 22pp · [arXiv](https://arxiv.org/abs/1802.01561) · [PDF](https://arxiv.org/pdf/1802.01561). Decouples acting from learning across many machines and corrects the resulting off-policy lag with V-trace — the template for large-scale actor-critic.
22. **Distributed Prioritized Experience Replay (Ape-X)** — Horgan et al. · ICLR 2018 · 19pp · [arXiv](https://arxiv.org/abs/1803.00933) · [PDF](https://arxiv.org/pdf/1803.00933). Scales prioritized replay to hundreds of parallel actors feeding one learner, a large jump in both data and final performance for value-based agents.

### Exploration & offline RL
*Two hard problems the core methods sidestep: how to seek out reward when it is sparse, and how to learn from a fixed dataset with no environment to probe.*
23. **Exploration by Random Network Distillation (RND)** — Burda, Edwards, Storkey, Klimov · ICLR 2019 · 17pp · [arXiv](https://arxiv.org/abs/1810.12894) · [PDF](https://arxiv.org/pdf/1810.12894). A simple, robust curiosity bonus — reward the agent for states a random network predicts poorly — that finally cracked hard-exploration games like Montezuma's Revenge.
24. **Conservative Q-Learning for Offline RL (CQL)** — Kumar, Zhou, Tucker, Levine · NeurIPS 2020 · 31pp · [arXiv](https://arxiv.org/abs/2006.04779) · [PDF](https://arxiv.org/pdf/2006.04779). Learns entirely from a fixed dataset by lower-bounding action values, so the policy can't be fooled into overrating actions it never saw — the strong offline baseline.
   - **Offline Reinforcement Learning: Tutorial, Review, and Perspectives** — Levine, Kumar, Tucker, Fu · [PDF](https://arxiv.org/pdf/2005.01643). The survey that frames the whole offline problem and where CQL sits in it.
25. **Decision Transformer: Reinforcement Learning via Sequence Modeling** — Chen et al. · NeurIPS 2021 · 21pp · [arXiv](https://arxiv.org/abs/2106.01345) · [PDF](https://arxiv.org/pdf/2106.01345). Recasts offline RL as conditional sequence prediction — a Transformer that outputs actions given a target return — dropping value functions and bootstrapping entirely.

### Planning & self-play — model-based mastery
*Combine learned value/policy networks with search; the AlphaGo lineage that reached superhuman play and then learned its own model of the game.*
26. **Mastering the Game of Go with Deep Neural Networks and Tree Search (AlphaGo)** — Silver et al. · Nature 2016 · 20pp · [DOI](https://doi.org/10.1038/nature16961) · [PDF](https://storage.googleapis.com/deepmind-media/alphago/AlphaGoNaturePaper.pdf). Deep policy and value networks guiding Monte-Carlo tree search beat a top human at Go.
27. **Mastering Chess and Shogi by Self-Play (AlphaZero)** — Silver et al. · arXiv 2017 · 19pp · [arXiv](https://arxiv.org/abs/1712.01815) · [PDF](https://arxiv.org/pdf/1712.01815). Superhuman chess, shogi, and Go from self-play alone, with one general algorithm and no human games.
28. **Mastering Atari, Go, Chess and Shogi by Planning with a Learned Model (MuZero)** — Schrittwieser et al. · Nature 2020 · 21pp · [DOI](https://doi.org/10.1038/s41586-020-03051-4) · [PDF](https://arxiv.org/pdf/1911.08265). Matches AlphaZero without being given the rules, learning a model sufficient for planning.

### RL from human feedback — RL meets language models
*Where RL now touches everyone: learn a reward model from human preferences, then optimize a policy against it — the recipe behind aligned LLMs.*
29. **Deep Reinforcement Learning from Human Preferences** — Christiano, Leike, Brown, Martic, Legg, Amodei · NeurIPS 2017 · 17pp · [arXiv](https://arxiv.org/abs/1706.03741) · [PDF](https://arxiv.org/pdf/1706.03741). Learns a reward model from pairwise human comparisons, avoiding hand-designed rewards — the conceptual core of RLHF.
30. **Training Language Models to Follow Instructions with Human Feedback (InstructGPT)** — Ouyang et al. · NeurIPS 2022 · 68pp · [arXiv](https://arxiv.org/abs/2203.02155) · [PDF](https://arxiv.org/pdf/2203.02155). Applies preference-based RL (with PPO) to fine-tune GPT-3 into an instruction follower — the template for modern LLM alignment.

<!--html-->
<div class="why">
<b>Two families, one field.</b> Almost everything here is a variation on two ideas.
<em>Value-based</em> methods (Q-learning, DQN and its fixes) learn how good states and
actions are, then act greedily; they are sample-efficient and off-policy but awkward in
continuous action spaces. <em>Policy-gradient</em> methods (REINFORCE, TRPO, PPO, SAC)
adjust the policy directly; they handle continuous control and stochastic policies
naturally, at the cost of higher variance. The deep-RL and self-play breakthroughs are
these two families scaled up with neural networks and search — and RLHF is policy
gradients pointed at a reward model learned from people.
</div>
<!--/html-->

## Reference shelf — books

- **FREE** **Reinforcement Learning: An Introduction (2nd ed.)** — Richard Sutton, Andrew Barto · 2018 · 548pp · [PDF](http://incompleteideas.net/book/RLbook2020.pdf). The field's defining textbook and the framing every paper here inherits; read it alongside sections 1–2.
- **FREE** **Algorithms for Reinforcement Learning** — Csaba Szepesvári · 2010 · 98pp · [PDF](https://sites.ualberta.ca/~szepesva/papers/RLAlgsInMDPs.pdf). A concise, rigorous companion that states the convergence results behind TD, Q-learning, and policy gradients.

## Key terms

- **value function** — the expected return from a state (V) or a state-action pair (Q) under a policy.
- **temporal-difference (TD) learning** — updating a prediction toward a later, bootstrapped prediction rather than the final return.
- **on-policy vs off-policy** — learning about the policy you follow (SARSA) vs a different target policy while behaving exploratorily (Q-learning).
- **policy gradient** — the gradient of expected return with respect to the policy's parameters; the basis of REINFORCE and its descendants.
- **actor-critic** — a policy (actor) trained with a learned value estimate (critic) to reduce the variance of the policy gradient.
- **advantage** — how much better an action is than the state's average, A(s,a) = Q(s,a) − V(s); GAE estimates it with tunable bias and variance.
- **experience replay** — storing past transitions and sampling them to break temporal correlation and reuse data (DQN, DDPG).
- **natural gradient** — a policy update reshaped by the Fisher information metric so it is invariant to the policy's parameterization; the basis of TRPO and PPO.
- **distributional RL** — learning the whole distribution of returns rather than just its expectation (C51), a richer training signal.
- **trust region** — a bound on how far each policy update may move, keeping optimization stable (TRPO, PPO).
- **distributed RL** — decoupling many parallel actors from one learner to scale data collection (IMPALA, Ape-X).
- **exploration bonus** — an intrinsic reward added to encourage visiting novel states when extrinsic reward is sparse (RND).
- **offline (batch) RL** — learning a policy from a fixed dataset with no further interaction with the environment (CQL, Decision Transformer).
- **MCTS** — Monte-Carlo tree search; look-ahead search guided by learned networks in the AlphaGo lineage.
- **RLHF** — reinforcement learning from human feedback: optimizing a policy against a reward model learned from human preferences.
