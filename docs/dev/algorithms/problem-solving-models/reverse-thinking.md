# Reverse thinking

`Reverse thinking`, aka `inversion`, is a way to solve problems by looking at them `backward`. Instead of asking "How to succeed?", you ask "How to fail?". By figuring out what would make a situation `worse`, you learn what `mistakes to avoid`.

### Example
Instead of asking "How can I be healthy?", you ask "What makes me unhealthy?".

Answers like "junk food," "no exercise," or "poor sleep" immediately show you what to cut out. Avoiding those bad habits is often the fastest way to get healthy.

## Pros 
- Helps identify potential edge cases and mistakes before the algorithm is even implemented.
- Encourages creative problem-solving by considering alternative perspectives.
- Complex problems are simplified by focusing on what to avoid rather than looking for a single perfect solution, as clear guardrails are created to rule out bad choices.


In the book 'Decisive' by Chip and Dan Heath, the first pillar of making better choices is 'Widen your options' and 'looking for the opposite' is a prime way to do that.

## Cons
- Too many alternatives can lead to analysis paralysis, making it difficult to make a decision.

## Code solving example
Reverse thinking works well in algorithm design, especially for finding alternative ways to solve complex problems and handling edge cases.

## Example - Longest Consecutive Sequence

> Given an unsorted array of integers nums, return the length of the longest consecutive elements sequence.
> You must write an algorithm that runs in O(n) time.

> **Example 1:**<br>
> Input: nums = [100,4,200,1,3,2]<br>
> Output: 4<br>
> Explanation: The longest consecutive elements sequence is [1, 2, 3, 4]. Therefore its length is 4.

> **Example 2:**<br>
> Input: nums = [0,3,7,2,5,8,4,6,0,1]<br>
> Output: 9

> **Example 3:**<br>
> Input: nums = [1,0,1,2]<br>
> Output: 3
 
> **Constraints:**<br>
> 0 <= nums.length <= $10^5$<br>
> -$10^9$ <= nums[i] <= $10^9$


### Forward-thinking approach
Using a standard `forward-thinking` approach, we typically:

1. Brute-force familiar patterns—like queues, stacks, BFS/DFS, or sorting and try to mentally apply them.
2. Realize the most straightforward option is to `sort the array and iterate through` it to find the longest consecutive sequence. However, sorting takes $O(n \log n)$ time.

<details>
<summary>Solution Array.Sort(...)</summary>

```csharp
public class Solution
{
    public int LongestConsecutive(int[] nums)
    {
        if (nums == null || nums.Length == 0)
        {
            return 0;
        }

        Array.Sort(nums);

        int max = 1;
        int count = 1;

        for (int i = 1; i < nums.Length; i++)
        {
            if (nums[i] == nums[i - 1] + 1)
            {
                count++;
                max = Math.Max(max, count);

                continue;
            }
            else if (nums[i] == nums[i - 1])
            {
                continue;
            }

            count = 1;
        }

        return max;
    }
}
```
</details>


### Reverse-thinking approach

Instead of asking, *"How do I find the longest consecutive sequence?"*, flip the perspective: *"How do I find numbers that are **NOT** part of the longest sequence?"*

Now, let's address this question: **Which numbers are NOT part of the longest consecutive sequence?**
* Any number that belongs to a shorter sequence.
 
**Can a number exist outside of any sequence?**
* No, because every number belongs to some consecutive sequence—even if its length is only $1$.
 
**How do we find these shorter consecutive sequences?**
* **Option 1 (Sorting):** Use `Array.Sort()` and iterate through the array to find all sequences.
* **Option 2 (Brute-force):** Check every possible range repeatedly.
* **Option 3 (Elimination via Dictionary):** Put all numbers into a `Dictionary<int, bool>` initialized to `true`. Iterate through the dictionary, expanding both left ($x - 1$) and right ($x + 1$) to find each number's full sequence:
* If `flag == true`, the number belongs to the **current** sequence. Count it and set its flag to `false` so it isn't reprocessed.
* If `flag == false`, the number was already processed in a **previous** sequence, so stop expanding in that direction.
 
At this point, before writing a single line of code, reverse thinking has already helped us map out `3 distinct solution paths`.
Let's implement the `Dictionary<int, bool>` approach.


<details>
<summary>Solution Dictionary<int,bool>(...)</summary>

```csharp
public class Solution {
    public int LongestConsecutive(int[] nums) {
        var dict = new Dictionary<int,bool>();
        
        for(int i=0;i<nums.Length;i++){
            if(!dict.TryGetValue(nums[i],out var value)){
                dict.Add(nums[i], true);
            }
        }

        int max = 0;

        foreach(var item in dict){
            if(!item.Value) 
            { 
                continue;
            }

            dict[item.Key] = false;

            //search left
            int left=0;
            var next = item.Key-1;

            while(dict.ContainsKey(next) && dict[next]){
                dict[next]=false;
                next--;
                left++;
            }

            //search right
            int right=0;
            next = item.Key+1;

            while(dict.ContainsKey(next) && dict[next]){
                dict[next]=false;
                next++;
                right++;
            }

            max = Math.Max(max, left+right+1);
        }
        
        return max;
    }
}
```

</details>

**Step 3 (Refining, Optimizing):** 

Currently, the code uses `two while loops` to expand left and right. Is there a way to combine them into a single loop?

This can be achieved by finding the start or end of the sequence first, and then expanding in only one direction.

To check if a number is the start of a sequence, we can simply check whether $num - 1$ exists in the set.

If we iterate through the set in only one direction, we no longer need to track flags for processed numbers, because we will always start from the beginning of a sequence.

As a result, the dictionary can be simplified to a `HashSet<int>` that stores unique numbers.

<details>
<summary>Solution HashSet<int>(...)</summary>

```csharp
public class Solution {
    public int LongestConsecutive(int[] nums) {
        var set = new HashSet<int>(nums);
        int max = 0;

        foreach (int num in set) {
            // if it is first el in sequence
            if (!set.Contains(num - 1)) {
                int next = num + 1;
                int count = 1;

                while (set.Contains(next)) {
                    next++;
                    count++;
                }

                max = Math.Max(max, count);
            }
        }

        return max;
    }
}
```

</details>

### Conclusion
By starting with a `reverse-thinking` approach, we explored `multiple solution paths`, refined our state management, and ultimately arrived at an optimal $O(n)$ `HashSet<int>` solution.