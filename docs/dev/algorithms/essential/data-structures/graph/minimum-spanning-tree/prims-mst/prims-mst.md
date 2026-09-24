# Prim's Minimum Spanning Tree (MST) Algorithm

1. Select `any node`, mark it as `visited`.
2. Select the `edge` with the `minimum weight` that connects a visited node to an unvisited node.
3. Mark the newly connected node as `visited`.
4. Repeat steps 2 and 3 until all nodes are `visited`.

* Time Complexity: O(N^2), where N is the number of points.
* Space Complexity: O(N).

## Prim's vs Kruskal's Algorithm

`Prim's` is better suited for `dense graphs`, as it grows the MST one vertex at a time, always choosing the minimum weight edge that connects a visited node to an unvisited node. 

`Kruskal's` , on the other hand, is often preferred for `sparse graphs`, as it sorts all edges and adds them to the MST in order of increasing weight, avoiding cycles.

* `Dense graph` it is a graph with a `large number of edges`. Each node is connected to many other nodes.


## Example Usage 
### Min Cost to Connect All Points
> You are given an array points representing integer coordinates of some points on a 2D-plane, where points[i] = [xi, yi].

> The cost of connecting two points [xi, yi] and [xj, yj] is the manhattan distance between them: |xi - xj| + |yi - yj|, where |val| denotes the absolute value of val.

> Return the minimum cost to make all points connected. All points are connected if there is exactly one simple path between any two points.

**Input:** points = [[0,0],[2,2],[3,10],[5,2],[7,0]]

**Output:** 20

**Input:** points = [[3,12],[-2,5],[-4,1]]
**Output:** 18


```csharp
public class Solution {
    public int MinCostConnectPoints(int[][] points) {
        int len = points.Length;
        var visited = new bool[len];
        var minDist = new int[len];
        
        Array.Fill(minDist, int.MaxValue);
        minDist[0] = 0; 
        int totalCost = 0;

        for (int step = 0; step < len; step++) {
            int curr = -1;
            int minVal = int.MaxValue;

            // find next node to visit
            for (int i = 0; i < len; i++) {
                if (!visited[i] && minDist[i] < minVal) {
                    minVal = minDist[i];
                    curr = i;
                }
            }

            visited[curr] = true;
            totalCost += minVal;

            // update path from it to all other
            for (int i = 0; i < len; i++) {
                if (!visited[i]) {
                    int dist = Math.Abs(points[curr][0] - points[i][0]) 
                             + Math.Abs(points[curr][1] - points[i][1]);
                    
                    if (dist < minDist[i]) {
                        minDist[i] = dist;
                    }
                }
            }
        }

        return totalCost;
    }
}
```