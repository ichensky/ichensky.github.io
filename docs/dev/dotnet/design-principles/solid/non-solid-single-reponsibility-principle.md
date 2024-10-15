# Non-SOLID Single Responsibility Principle (non-SRP)

The `non-SOLID` `Single Responsibility Principle (SRP)` is often confused with the `SOLID SRP`. While both principles sound similar, they have different meanings.
  
`non-SOLID SRP`:
> "The function should do one thing and only one thing." 

This principle is violated when a function becomes a "God" function and can perform many semanticaly unrelated tasks.

### Example
The `PrepareReport` function performs multiple tasks. It downloads `report.json` from the server, deserializes it, and creates a report with HTML text.

```csharp
void Main() {
    Console.WriteLine(PrepareReport());
}

async Task<string> PrepareReport() {
    // Initialize settings
    var uri = new Uri("https://.../report.json");
    HttpClient client = new ();

    // Download and deserialize json
    Info? info = await client.GetFromJsonAsync<Info>(uri) ?? throw new NullReferenceException("json is invalid");

    // Prepare report
    return $"""
        <h1>{info.Title}</h1>
        <p>{info.Content}</p>
        """;
}

record Info(string Title, string Content);
```
"God" functions are difficult to maintain and extend with new functionality. A small change to the code can potentially break subfunctions.

### Improvements 
To adhere to the non-SOLID SRP, the function should be divided into multiple functions.

```csharp
void Main()
{
    var settings = InitSettings();
    Console.WriteLine(PrepareReport(settings.Uri, settings.Client));
}

// Initialize settings
(HttpClient Client, Uri Uri) InitSettings()
{
    var uri = new Uri("https://.../report.json");
    HttpClient client = new();

    return (client, uri);
}

// Depending on Settings, prepare a report
async Task<string> PrepareReport(Uri uri, HttpClient client)
{
    Info info = await DownloadInfo(uri, client);

    var report = CreateReport(info);

    return report;
}

// Downloads Info DTO
async Task<Info> DownloadInfo(Uri uri, HttpClient client)
{
    ArgumentNullException.ThrowIfNull(uri, nameof(uri));
    ArgumentNullException.ThrowIfNull(client, nameof(client));

    var json = await client.GetFromJsonAsync<Info>(uri) ?? throw new NullReferenceException("json is invalid");

    return json;
}

// Creates HTML report from Info DTO
string CreateReport(Info info)
{
    ArgumentNullException.ThrowIfNull(info, nameof(info));

    return $"""
        <h1>{info.Title}</h1>
        <p>{info.Content}</p>
        """;
}

record Info(string Title, string Content);
```