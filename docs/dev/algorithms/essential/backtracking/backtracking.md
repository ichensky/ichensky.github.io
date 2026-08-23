# Backtracking

## Find all permutations of an array 
1. **Explore** all possible arrangements of the array elements.
    (Use recursion)

2. During the exploration

    - 2.1. **Filter out** the arrangements that are not valid permutations.(like duplicates)
    (Use i=start to avoid duplicates)

    - 2.3. **Backtrack** to explore other arrangements.
    (Swap the elements back to their original position after the recursive call)

3. **Store** the valid permutations in a list and return it.
    (The last node of the recursion tree is the base case, where we add the current arrangement to the list of permutations.)

```text
                      123
         ______________|______________
        /              |              \
    [1]23            2[1]3            32[1]
     / \              / \              / \
1[2]3   13[2]    2[1]3   23[1]    3[2]1   31[2]      

```

```csharp
var arr = new int[]{1, 2, 3};
IList<IList<int>> permutations = []; 

Permutations(arr, permutations, 0);

for (int i = 0; i < permutations.Count; i++)
{
    Console.WriteLine(string.Join(',', permutations[i]));
}

static void Permutations(int[] arr, IList<IList<int>> permutations, int start)
{
    if (start == arr.Length)
    {
        permutations.Add([.. arr]); 
        return;
    }

    for (int i = start; i < arr.Length; i++)
    {
        (arr[start], arr[i]) = (arr[i], arr[start]);
        
        Permutations(arr, permutations, start + 1);
        
        (arr[start], arr[i]) = (arr[i], arr[start]);
    }
}

// 1,2,3
// 1,3,2
// 2,1,3
// 2,3,1
// 3,2,1
// 3,1,2
```
