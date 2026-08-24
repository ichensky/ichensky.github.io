# Z-algorithm

The Z-algorithm is a linear time string matching algorithm that finds all occurrences of a pattern in a text. 

It computes the **Z-array**, *which contains the lengths of the longest substrings starting from each position in the string that match the prefix of the string*.

For the string `text = "aabxaayaab"`, the Z-array is computed as follows:

```text
index:      0 1 2 3 4 5 6 7 8 9

text:       a a b x a a y a a b
Z-array:    0 1 0 0 2 1 0 3 1 0
            |_      |
               \____|
                    ^ starting from index 4, the substring "aa" matches the prefix "aa", so Z[4] = 2.
```

#### After building the Z-array, we can answer on questions like
- How many times does a prefix, for example `'aa'`, occur in the text?
- Does the prefix `'aab'` occur in the text? If yes, at which indices?

#### Naive Approach to compute the Z-array (two loops $O(n^2)$ time complexity)
This approach give an idea of how the Z-array is computed, but it is not efficient for large strings.

```csharp
var text = "aabxaayaab";

var zArray = Zarray(text);

Console.WriteLine("Word: " + string.Join(',', text.ToCharArray()));
Console.WriteLine("Zarray:  " + string.Join(',', zArray));

// Word: a,a,b,x,a,a,y,a,a,b
// Zarray:  0,1,0,0,2,1,0,3,1,0

static int[] Zarray(string str)
{
    var zArray = new int[str.Length];

    for (int i = 1; i < str.Length; i++)
    {
        int j = i;

        while(j < str.Length && str[j] == str[j-i])
        {
            zArray[i]++;
            j++;
        }
    }

    return zArray;
}

```

### How to search any pattern in a text using the Z-algorithm
To search pattern `abc` in text `xabcabcabc`:

1. Concatenate the pattern, a special character (not present in either the pattern or text), and the text: 
```
abc$xabcabcabc
```

2. Compute the Z-array for the concatenated string.
```text
abc.Length = 3

index:      0 1 2 3 4 5 6 7 8 9 10 11 12 13 
text:       a b c $ x a b c a b  c  a  b  c  
Z-array:    0 0 0 0 0 3 0 0 3 0  0  3  0  0
```
3. Search abc.Length in the Z-array. 



## Optimized approach to compute the Z-array (one loop $O(n)$ time complexity)
The optimized approach uses a window (or Z-box) with a matching window $[L, R]$ to skip redundant comparisons.

```text
Word:    a,a,b,x, a,a,b,x, c, a,a,b,x, a,a,b,x, a,y
Zarray:  0,1,0,0, 4, ... 
                 |________|
                L     ^    R
                      + z-box: Length of the substring starting from index 4 that matches the prefix of the string is 4, so Z[4] = 4. 
                        Z-box length = R - L + 1 = 7 - 4 + 1 = 4

Word:    a,a,b,x, a,a,b,x, c, a,a,b,x,a,a,b,x, a,y
Zarray:  0,1,0,0, 4,1,0,0, 
           |____|   |___|
              |_______^ 
                      instead of comparing characters from the beginning,
                        just copy the previously computed Z-values to skip comparisons.     

Word:    a,a,b,x, a,a,b,x, c, a,a,b,x,a,a,b,x, a,y
Zarray:  0,1,0,0, 4,1,0,0, 0, 8 ...
                             |________________|
                             L                 R

[! Caveat]:
index:   0 1 2 3  4 5 6 7  8  9 10 11 12 13 14 15 16  17 18
Word:    a,a,b,x, a,a,b,x, c, a, a, b, x, a, a, b, x,  a, y
Zarray:  0,1,0,0, 4,1,0,0, 0, 8, 1, 0, 0,[4+]
           |_____________|    |____________________| 
                |____________L___________^          R
                       copying Z-values from the previous Z-box to skip comparisons.
                       However, Z[4] + Z[4] = 4 + 4 = 8 > Window_R, so we need to compare characters starting from index 13+4 = 17 to find the new Z-value for index 13.

index:   0 1 2 3  4 5 6 7  8  9 10 11 12 13 14 15 16  17 18
Word:    a,a,b,x, a,a,b,x, c, a, a, b, x, a, a, b, x,  a, y
Zarray:  0,1,0,0, 4,1,0,0, 0, 8, 1, 0, 0, 5
           |______|                      |______________|
               |                        L       ^        R
               +--------------------------------+

[! Caveat]:
Word:    a,a,b,x, a,a,b,x, c, a, a, b, x, a, a, b, x,  a, y
Zarray:  0,1,0,0, 4,1,0,0, 0, 8, 1, 0, 0, 5, 1, 0, 0   
           |______|                      |______________|
                                                       ^ 
                                                       4+4>Window_R

Word:    a,a,b,x, a,a,b,x, c, a, a, b, x, a, a, b, x,  a, y
Zarray:  0,1,0,0, 4,1,0,0, 0, 8, 1, 0, 0, 5, 1, 0, 0,  1, 0
```


```csharp

var text = "aabxaayaab";

var zArray = Zarray(text);

Console.WriteLine("Word: " + string.Join(',', text.ToCharArray()));
Console.WriteLine("Zarray:  " + string.Join(',', zArray));

// Word: a,a,b,x,a,a,y,a,a,b
// Zarray:  0,1,0,0,2,1,0,3,1,0

static int[] Zarray(string str)
{
    var zArray = new int[str.Length];
    var left = 0;
    var right = 0;
    for (int i = 1; i < str.Length; i++)
    {
        // Try Expand R side of the window/z-box
        if (i > right)
        {
            left = right = i;

            while (right < str.Length && str[right] == str[right - left])
            {
                right++;
            }

            zArray[i] = right - left;
            right--;
        }
        // We are inside of the window/z-box
        else
        {
            var j = i - left;
            // Values are not stretch out of the window
            if (zArray[j] < right - i + 1)
            {
                zArray[i] = zArray[j];
            }
            else
            {
                left = i;

                // Expanding window, starting from `right` bound
                while (right < str.Length && str[right] == str[right - left])
                {
                    right++;
                }

                zArray[i] = right - left;
                right--;
            }
        }
    }

    return zArray;
}
```

## Example of using the Z-algorithm to solve a problem:

**Sum of Scores of Built Strings**

You are building a string `s` of length `n` one character at a time, prepending each new character to the front of the string. The strings are labeled from `1` to `n`, where the string with length `i` is labeled `si`.

For example, for s = "abaca", s1 == "a", s2 == "ca", s3 == "aca", etc.
The score of `si` is the length of the longest common prefix between `si` and `sn` (Note that `s` == `sn`).

Given the final string `s`, return the sum of the score of every `si`.


**Example 1**:
```text
Input: s = "babab"
Output: 9
Explanation:
For s1 == "b", the longest common prefix is "b" which has a score of 1.
For s2 == "ab", there is no common prefix so the score is 0.
For s3 == "bab", the longest common prefix is "bab" which has a score of 3.
For s4 == "abab", there is no common prefix so the score is 0.
For s5 == "babab", the longest common prefix is "babab" which has a score of 5.
The sum of the scores is 1 + 0 + 3 + 0 + 5 = 9, so we return 9.
```

**Example 2**:

```text
Input: s = "azbazbzaz"
Output: 14
Explanation: 
For s2 == "az", the longest common prefix is "az" which has a score of 2.
For s6 == "azbzaz", the longest common prefix is "azb" which has a score of 3.
For s9 == "azbazbzaz", the longest common prefix is "azbazbzaz" which has a score of 9.
For all other si, the score is 0.
The sum of the scores is 2 + 3 + 9 = 14, so we return 14.
```

**Constraints**:

1 <= s.length <= $10^5$
s consists of lowercase English letters.

**Solution:**
<details>
<summary>Solution</summary>

1. Compute the Z-array for the string s.
2. The sum of the scores is the sum of all values in the Z-array plus the length of the string `s`.


```csharp
public class Solution
{
    public long SumScores(string s)
    {
        var zArray = Zarray(s);

        long sum = s.Length;

        foreach (int z in zArray)
        {
            sum += z;
        }

        return sum;
    }

    static int[] Zarray(string str)
    {
        var zArray = new int[str.Length];
        var left = 0;
        var right = 0;
        for (int i = 1; i < str.Length; i++)
        {
            // Try Expand R side of the window/z-box
            if (i > right)
            {
                left = right = i;

                while (right < str.Length && str[right] == str[right - left])
                {
                    right++;
                }

                zArray[i] = right - left;
                right--;
            }
            // We are inside of the window/z-box
            else
            {
                var j = i - left;
                // Values are not stretch out of the window
                if (zArray[j] < right - i + 1)
                {
                    zArray[i] = zArray[j];
                }
                else
                {
                    left = i;

                    // Expanding window, starting from `right` bound
                    while (right < str.Length && str[right] == str[right - left])
                    {
                        right++;
                    }

                    zArray[i] = right - left;
                    right--;
                }
            }
        }

        return zArray;
    }

}
```
</details>