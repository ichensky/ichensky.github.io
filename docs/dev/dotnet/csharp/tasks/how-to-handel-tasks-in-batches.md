# How to Handle Tasks in Batches

There are scenarios where it is necessary to handle multiple tasks concurrently in batches. 

## Task
Process 100 URLs in batches of 10 concurrently. Once one task in a batch completes, the next task starts.

### Modern Approach with `Parallel.ForEachAsync`

```csharp
static async Task Net6AndNewer(IList<string> urls, CancellationToken token = default)
{
    var options = new ParallelOptions { MaxDegreeOfParallelism = 10, CancellationToken = token };
    await Parallel.ForEachAsync(urls, options, async (url, ct) =>
    {
        try
        {
            await ProcessUrlAsync(url, ct);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed: {url} - Error: {ex.Message}");
        }
    });
}
```

### Before .NET 6

```csharp
static async Task BeforeNet6(IList<string> urls, CancellationToken token = default)
{
    using SemaphoreSlim semaphore = new(10, 10);
    List<Task> tasks = [];

    foreach (var url in urls)
    {
        await semaphore.WaitAsync();

        tasks.Add(Task.Run(async () =>
        {
            try
            {
                try
                {
                    await ProcessUrlAsync(url, token);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Failed: {url} - Error: {ex.Message}");
                }
            }
            finally
            {
                semaphore.Release();
            }
        }));
    }

    await Task.WhenAll(tasks);
}
```

### Example Usage
```csharp
List<string> urls = [];
for (int i = 1; i <= 100; i++)
{
    urls.Add($"https://example.com?val={i}");
}
//await Net6AndNewer(urls);
//await BeforeNet6(urls);

Console.WriteLine("All 100 URLs have been processed.");


static async Task ProcessUrlAsync(string url, CancellationToken token = default)
{
    Console.WriteLine($"Starting: {url}");

    token.ThrowIfCancellationRequested();
  
    // Simulate network delay
    await Task.Delay(1000, token); 

    Console.WriteLine($"Finished: {url}");
}

```