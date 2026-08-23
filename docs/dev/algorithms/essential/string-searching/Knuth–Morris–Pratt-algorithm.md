# Knuth–Morris–Pratt algorithm

The Knuth–Morris–Pratt algorithm (or KMP algorithm) is a string-searching algorithm that searches for occurrences of a "word" W within a main "text string" S.

The LPS Array: Before searching word in the text, KMP builds a table for word called the **Longest Prefix Suffix (LPS)** array.

## Observation
```text
Word: a,b,a,b,c,a,b,a,b
LPS:  0,0,1,2,0,1,2,3,4
```

If compare `word` with `text` and mismatch occurs, the LPS array is used to avoid unnecessary comparisons.

```text
text: b_abab_ababcababcabab
word:   abab_cabab
             ^
             c is not equal to a
            Therefore, using LPS[4 - 1] == 2, 
            comparing the first 2 characters of the word with the text can be avoided.
            We can start comparing directly from the 3rd character (word[2]) of the word with the text.

            text: b_abab_ababcababcabab
            word:     ab_abcabab
```
            

```csharp
var text = "bababababcababcabab";
var word = "ababcabab";

var lps = Lps(word);

Console.WriteLine("Word: " + string.Join(',', word.ToCharArray()));
Console.WriteLine("LPS:  " + string.Join(',', lps));

int j = 0; 
int i = 0;

while (i < text.Length)
{
    if (text[i] == word[j])
    {
        i++;
        j++;
        
        if (j == word.Length)
        {
            Console.WriteLine($"Word found at index {i - j}");
            j = lps[j - 1]; 
        }
    }
    // Mismatch occurred
    else 
    {
        if (j != 0)
        {
            j = lps[j - 1];
        }
        else
        {
            i++;
        }
    }
}


// Word: a,b,a,b,c,a,b,a,b
// LPS:  0,0,1,2,0,1,2,3,4
// Word found at index 5
// Word found at index 10


static int[] Lps(string str)
{
    var lps = new int[str.Length];
    var j = 0;
    var i = 1;

    while (i < lps.Length)
    {
        if (str[i] == str[j])
        {
            j++;
            lps[i] = j;
            i++;
        }
        else
        {
            if (j != 0)
            {
                j = lps[j - 1];
            }
            else
            {
                lps[i] = 0;
                i++;
            }
        }
    }
    return lps;
}

```
