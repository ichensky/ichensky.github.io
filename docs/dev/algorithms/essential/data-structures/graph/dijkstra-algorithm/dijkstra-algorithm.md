# Dijkstra's Algorithm

Finds the shortest path from a **source vertex** to **all reachable vertices** in a weighted graph.

### Prerequisites & Constraints

* **Graph Type:** Directed or undirected.
* **Edge Weights:** Must be **non-negative** ($w \ge 0$). Negative weights break the greedy choice property and require algorithms like Bellman-Ford.

### Core Idea

Uses a **greedy approach**, always processing the unvisited vertex with the smallest tentative distance:

1. **Initialize:** Set the source vertex distance to `0` and all other vertices to `Infinity`.
2. **Select:** Pop the unvisited vertex with the smallest known distance from the priority queue.
3. **Relax:** For each unvisited neighbor, calculate the tentative distance through the current vertex. If this new distance is smaller than the known distance, update it.
4. **Repeat:** Continue steps 2 and 3 until the priority queue is empty.

### Key Data Structures

* **Priority Queue (Min-Heap):** Efficiently retrieves the next unvisited vertex with the minimum distance in $O(\log V)$ time.
* **Distance Table / Array:** Stores the current shortest known distance from the source to each vertex.
* **Predecessor Map (Optional):** Maps each vertex to its previous node to reconstruct the actual path.

```csharp
var graph = new Graph<string>
{
    { "Paris", [( "London", 450 ), ( "Berlin", 1050 )] },
    { "London", [( "Paris", 450 ), ( "New York", 5567 ), ("Tokyo", 9567)]  },
    { "Kyiv", [( "Berlin", 1200 ), ( "London", 2300 )] },
    { "Berlin", [( "Paris", 1050 ), ("Kyiv", 1200)] },
    { "New York", [( "London", 5567 ), ( "Los Angeles", 3940 )] },
    { "Los Angeles", [( "New York", 3940 ), ( "Tokyo", 5470 )] },
    { "Tokyo", [( "London", 9567 ), ( "Los Angeles", 5470 )] },
    { "Moscow", []}
};

var sourceVertexId = "London";
Dijkstra<string> dijkstra = new (graph);

var distanceTable = dijkstra.CalculateDistanceTable(sourceVertexId);

new PrintDijkstraDistanceTable<string>(
    graph,
     sourceVertexId,
      distanceTable)
    .Print();
    


// Distance table from source vertex 'London':
//       Vertex |     Distance |     Previous
// ------------------------------------------
//        Paris |          450 |       London
//       London |            0 |             
//         Kyiv |         2700 |       Berlin
//       Berlin |         1500 |        Paris
//     New York |         5567 |       London
//  Los Angeles |         9507 |     New York
//        Tokyo |         9567 |       London
//       Moscow |  Unreachable |            -





// Representation of a graph as an adjacency list
public class Graph<TVertexId> : Dictionary<TVertexId, IList<(TVertexId vertexId, uint weight)>> where TVertexId : notnull { }

// Previous vertex Id is optional. It is used to reconstruct the shortest path from the source vertex to a given vertex.
public class DistanceTable<TVertexId> : Dictionary<TVertexId, (uint Distance, TVertexId? PreviousVertexId)> where TVertexId : notnull { }

public class Dijkstra<TVertexId>(Graph<TVertexId> graph) where TVertexId : notnull
{
    public DistanceTable<TVertexId> CalculateDistanceTable(TVertexId sourceVertexId)
    {
        if (!graph.ContainsKey(sourceVertexId))
        {
            throw new ArgumentException($"Source vertex {sourceVertexId} does not exist in the graph.");
        }

        var distanceTable = new DistanceTable<TVertexId>();

        // Value: Distance from source vertex
        var queue = new PriorityQueue<TVertexId, uint>();

        // Put source vertex in the distance table and the queue
        distanceTable[sourceVertexId] = (0, default);
        queue.Enqueue(sourceVertexId, 0);

        // While queue is not empty, process the vertex with the smallest distance
        while (queue.TryDequeue(out var vertexId, out var priority))
        {
            // Multiple entries for the same vertex can be in the queue, 
            //  | [REMARK]: C# PriorityQueue does not support updating the priority of an existing entry.
            if (!distanceTable.TryGetValue(vertexId, out var currentDistance) 
                || priority > currentDistance.Distance)
            {
                continue;
            }

            if (!graph.TryGetValue(vertexId, out var neighbours))
            {
                continue;
            }

            foreach (var (neighbourId, weight) in neighbours)
            {
                var newDistanceToNeighbour = currentDistance.Distance + weight;

                // Update the distance table and queue if current path is shorter than previously known path
                if (!distanceTable.TryGetValue(neighbourId, out var distanceToNeighbour) 
                    || newDistanceToNeighbour < distanceToNeighbour.Distance)
                {
                    distanceTable[neighbourId] = (newDistanceToNeighbour, vertexId);

                    queue.Enqueue(neighbourId, newDistanceToNeighbour);
                }
            }
        }

        return distanceTable;
    }
}

public class PrintDijkstraDistanceTable<TVertexId>(Graph<TVertexId> graph,
    TVertexId sourceVertexId,
    DistanceTable<TVertexId> distanceTable) where TVertexId : notnull
{
    public void Print()
    {
        var format = "{0,12} | {1,12} | {2,12}";
        Console.WriteLine($"Distance table from source vertex '{sourceVertexId}':");

        var header = string.Format(format, "Vertex", "Distance", "Previous");
        Console.WriteLine(header);
        Console.WriteLine(new string('-', header.Length));

        foreach (var vertexId in graph.Keys)
        {
            if (distanceTable.TryGetValue(vertexId, out var distanceTuple))
            {
                Console.WriteLine(format, vertexId, distanceTuple.Distance, distanceTuple.PreviousVertexId);
            }
            else
            {
                Console.WriteLine(format, vertexId, "Unreachable", "-");
            }
        }
    }
}
```