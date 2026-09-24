# Kruskal's Minimum Spanning Tree (MST) Algorithm

Kruskal's algorithm is a `greedy algorithm` used to find the `Minimum Spanning Tree (MST)` of a `connected, undirected graph`. The MST is a subset of the edges that connects all vertices together without any cycles and with the minimum possible total edge weight.

## Steps of Kruskal's Algorithm
1. Sort all the edges in non-decreasing order of their weight.
2. Initialize an empty MST.
3. Iterate through the sorted edges and for each edge, check if adding it to the MST will form a cycle using a union-find data structure.
4. If it doesn't form a cycle, include it in the MST.
5. Repeat step 3 until the MST contains exactly \(V-1\) edges, where \(V\) is the number of vertices in the graph.

```csharp

//           [2]
//         /     \ 
//       1         2
//     /             \
//   /                 \
// [1]---1---[0]---2---[3]
//   \        |        /
//     \      3      /
//       6    |    3
//         \  |  /
//           [4]
//
//
// 0: vertex, 1: vertex, 2: weight, 3: isMst
int[][] edges = [[0,1,1,0],[1,2,1,0],[2,3,2,0],[0,3,2,0],[0,4,3,0],[3,4,3,0],[1,4,6,0]];
int nodes = 5;
var isMst = KruskalMST(nodes, edges);
if (isMst)
{
    Console.WriteLine("The graph has a minimum spanning tree.");
    Console.WriteLine("Edges in the minimum spanning tree:");
    foreach (var edge in edges)
    {
        if (edge[3] == 1)
        {
            Console.WriteLine($"[{edge[0]}]---{edge[2]}---[{edge[1]}]");
        }
    }
}
else
{
    Console.WriteLine("The graph is disconnected and does not have a minimum spanning tree.");
}

// The graph has a minimum spanning tree.
// Edges in the minimum spanning tree:
// [0]---1---[1]
// [1]---1---[2]
// [2]---2---[3]
// [0]---3---[4]

// MST: 
//           [2]
//         /     \ 
//       1         2
//     /             \
//   /                 \
// [1]---1---[0]       [3]
//            |        
//            3      
//            |    
//            |  
//           [4]
//



bool KruskalMST(int nodes, int[][] edges)
{
    Array.Sort(edges, (l, r) => l[2] - r[2]);

    var unions = new int[nodes];
    for (int i = 0; i < nodes; i++)
    {
        unions[i] = i;
    }
    var treeSize = 0;
    var edgesCount = 0;

    for (int i = 0; i < edges.Length; i++)
    {
        var u = edges[i][0];
        var v = edges[i][1];
        var w = edges[i][2];
        var root1 = FindRoot(unions, u);
        var root2 = FindRoot(unions, v);

        // if there is no cycle, connect the components
        if (root1 != root2)
        {
            unions[root1] = root2;
            treeSize += w;
            edgesCount++;
            edges[i][3] = 1;

            if (edgesCount == nodes - 1) { break; }
        }
    }

    // if graph is disconected
    return edgesCount == nodes - 1;
}

int FindRoot(int[] unions, int i)
{
    if (unions[i] == i)
    {
        return i;
    }
    unions[i] = FindRoot(unions, unions[i]);
    return unions[i];
}
```

## Example Usage

### Find Critical and Pseudo-Critical Edges in Minimum Spanning Tree

> Given a weighted undirected connected graph with n vertices numbered from `0` to `n - 1`, and an array edges where `edges[i] = [ai, bi, weighti]` represents a bidirectional and weighted edge between nodes ai and bi. A minimum spanning tree (MST) is a subset of the graph's edges that connects all vertices without cycles and with the minimum possible total edge weight.

> Find all the critical and pseudo-critical edges in the given graph's minimum spanning tree (MST). An MST edge whose deletion from the graph would cause the MST weight to increase is called a critical edge. On the other hand, a pseudo-critical edge is that which can appear in some MSTs but not all.

> Note that you can return the indices of the edges in any order.

**Input:** n = 5, edges = [[0,1,1],[1,2,1],[2,3,2],[0,3,2],[0,4,3],[3,4,3],[1,4,6]]

**Output:** [[0,1],[2,3,4,5]]

### Solution
1. `Apply Kruskal's algorithm` to find the minimum spanning tree (MST) of the graph.
2. `Identify the critical edges` by removing each edge one by one and checking if the MST weight increases. If it does, the edge is critical.
3. `Identify the pseudo-critical edges` by forcing each non-critical edge into the MST and checking if the MST weight remains the same. If it does, the edge is pseudo-critical.


#### C# Implementation

```csharp
public class Solution
{
    public IList<IList<int>> FindCriticalAndPseudoCriticalEdges(int n, int[][] edges)
    {
        var extEdges = new int[edges.Length][];
        for (int i = 0; i < edges.Length; i++)
        {
            extEdges[i] = [edges[i][0], edges[i][1], edges[i][2], i];
        }

        Array.Sort(extEdges, (l, r) => l[2] - r[2]);

        var size = KurscalMST(n, extEdges, -1);
        var criticalIndices = new HashSet<int>();

        for (int i = 0; i < extEdges.Length; i++)
        {
            var skip = KurscalMST(n, extEdges, i);
            if (skip > size)
            {
                criticalIndices.Add(extEdges[i][3]);
            }
        }

        var pseudoCriticalIndices = new List<int>();

        for (int i = 0; i < extEdges.Length; i++)
        {
            int origIdx = extEdges[i][3];
            if (criticalIndices.Contains(origIdx))
            {
                continue;
            }

            var forceWeight = KurscalMST(n, extEdges, -1, i);
            if (forceWeight == size)
            {
                pseudoCriticalIndices.Add(origIdx);
            }
        }

        return new List<IList<int>>() {
            criticalIndices.ToList(),
            pseudoCriticalIndices
        };
    }

    private int KurscalMST(int n, int[][] edges, int skip, int force = -1)
    {
        var unions = new int[n];
        for (int i = 0; i < n; i++)
        {
            unions[i] = i;
        }
        var treeSize = 0;
        var edgesCount = 0;

        if (force != -1)
        {
            unions[edges[force][0]] = edges[force][1];
            treeSize += edges[force][2];
            edgesCount++;
        }

        for (int i = 0; i < edges.Length; i++)
        {
            if (skip > -1 && skip == i)
            {
                continue;
            }

            var u = edges[i][0];
            var v = edges[i][1];
            var w = edges[i][2];
            var root1 = FindRoot(unions, u);
            var root2 = FindRoot(unions, v);

            if (root1 != root2)
            {
                unions[root1] = root2;
                treeSize += w;
                edgesCount++;

                if (edgesCount == n - 1) { break; }
            }
        }

        // if graph is disconected
        return edgesCount == n - 1 ? treeSize : int.MaxValue;
    }

    private int FindRoot(int[] unions, int i)
    {
        if (unions[i] == i)
        {
            return i;
        }
        unions[i] = FindRoot(unions, unions[i]);
        return unions[i];
    }
}
```