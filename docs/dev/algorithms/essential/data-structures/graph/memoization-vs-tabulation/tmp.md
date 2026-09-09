Longest Common Subsequence (LCS) dynamic programming solutions can be understood through the lens of graph theory, where the problem forms a Directed Acyclic Graph (DAG) of overlapping subproblems.

## Graph Representation of LCS States

The state space of an LCS problem between two strings $A$ of length $m$ and $B$ of length $n$ is represented as a grid or DAG with $(m + 1) \times (n + 1)$ nodes.

* **Nodes:** Each node corresponds to a state $(i, j)$, representing the prefixes $A[0 \dots i-1]$ and $B[0 \dots j-1]$.
* **Directed Edges:** Transitions flow from state $(i, j)$ based on character matching:
* If $A[i-1] == B[j-1]$: A diagonal edge leads from $(i, j)$ to $(i-1, j-1)$, representing a match.
* Otherwise: Two branching edges lead from $(i, j)$ to $(i-1, j)$ and $(i, j-1)$, representing deletions from either string.



---

## Top-Down Memorization (Lazy DAG Traversal)

Memorization approaches the graph from the target state $(m, n)$ back down to the base cases $(0, 0)$ using recursive Depth-First Search (DFS) with a cache.

* **Graph Traversal Strategy:** It performs a lazy, demand-driven traversal. It only visits nodes and subproblems that are strictly reachable from the initial call $lcs(m, n)$.
* **Memory and Overhead:** Allocates a memoization table (or hash map) of size $(m + 1) \times (n + 1)$. It incurs recursion call stack overhead ($O(m + n)$ depth) and conditional lookup checks.
* **Advantage:** If the optimal substructure only requires a fraction of the states (though in standard LCS, most states are visited, sparse variations or early exits can benefit), unnecessary states are skipped.

---

## Bottom-Up Tabulation (Eager Topological Evaluation)

Tabulation approaches the graph iteratively, filling the grid from the base cases $(0, 0)$ up to $(m, n)$ in topological order.

* **Graph Traversal Strategy:** It evaluates every single node in the $M \times N$ grid systematically, regardless of whether a specific subproblem is strictly necessary for the final path.
* **Memory and Overhead:** Eliminates recursion stack overhead entirely. It relies on nested loops with contiguous memory access, yielding superior CPU cache locality. The space complexity can be easily optimized from $O(m \times n)$ down to $O(\min(m, n))$ by keeping only the current and previous rows (or columns).
* **Advantage:** Predictable performance, zero stack overflow risk, and minimal memory footprint via rolling-array optimization.

---

| Feature | Memorization (Top-Down) | Tabulation (Bottom-Up) |
| --- | --- | --- |
| **Graph Traversal** | DFS (Lazy, Demand-driven) | Iterative Topological Sort (Eager) |
| **State Coverage** | Only visits reachable subproblems | Evaluates all $O(m \cdot n)$ states in the grid |
| **Call Stack** | $O(m + n)$ recursive stack frames | $O(1)$ stack overhead |
| **Space Optimization** | Harder to optimize space beyond memo table | Easy to reduce space to $O(\min(m, n))$ |
| **Cache Locality** | Variable (depends on recursion pattern) | Excellent (sequential memory access) |