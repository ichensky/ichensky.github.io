# Interface Segregation Principle 

Martin, Robert C. 
> Clients should not be forced to depend upon interfaces that they do not use.

`Client` refers to a `class` or `object` that uses these methods to interact with the class that implements the interface. `Client` is a caller of the interface.

An `interface` is a contract that defines a set of methods that a class must implement.<br>
Different languages refer to interfaces as "abstract classes", “interfaces”, “protocols” or “signatures”. 

The ISP principle suggests dividing large interfaces into smaller ones, each containing only the methods relevant to a specific client.

Overly large interfaces can lead to several issues:
* **Increased coupling**<br>
When an interface has many methods, classes that implement the interface become tightly coupled to its methods. This makes it harder to change these classes independently.<br>
If a class only needs a subset of the methods in an interface, it is forced to implement all of the interface methods, leading to unnecessary complexity.

* **Reduced reusability**<br>
Large interfaces make it harder to reuse classes in different contexts. If a class is tightly coupled to a large interface, it makes it more complicated to use it in a system that doesn't need all of the methods.

## Example
Imagine a `use case` for creating a library that can download `HTML` files and remove all `b` and optionally `span` tags. 

Requirements can be satisfied by implementing `Template Method` pattern with two classes `HtmlClient` and derived `HtmlCleaner`.<br> 
Class `HtmlClient` provides method for downloading `HTML` file. And inherited `HtmlCleaner` class, methods for removing `b` and `span` tags.
```csharp
public abstract class HtmlClient(HttpClient client)
{
    protected string? html;

    public async Task DownloadHtml(string url)
    {
        this.html = await client.GetStringAsync(url);

        PostDownloadHtmlProcessor();
    }

    protected abstract void PostDownloadHtmlProcessor();
}

public class HtmlCleaner(HttpClient client) : HtmlClient(client)
{
    protected string? cleanedHtml;

    public string GetHtml()
    {
        return this.cleanedHtml!;
    }

    public void SetHtml(string html)
    {
        this.cleanedHtml = html ?? string.Empty;
    }

    public void RemoveSpanTags()
    {
        this.cleanedHtml = RemoveSpanTags(this.cleanedHtml!);
    }

    protected override void PostDownloadHtmlProcessor()
    {
        this.cleanedHtml = RemoveBoldTags(html ?? string.Empty);
    }

    private static string RemoveBoldTags(string html)
        => Regex.Replace(html, @"<b>(.*?)</b>", string.Empty);

    private static string RemoveSpanTags(string html)
        => Regex.Replace(html, @"<span>(.*?)</span>", string.Empty);
}
```

The client can used this classes like: 

```csharp
var client = new HttpClient();
var htmlCleaner = new HtmlCleaner(client);
var url = "https://../file.html";

await htmlCleaner.DownloadHtml(url);

// optionally
htmlCleaner.RemoveSpanTags();

Console.WriteLine(htmlCleaner.GetHtml());
```

Problems with this code that 

**1.** Every time it is needed to create another class based on `HtmlClient` or `HtmlCleaner`, it requies to implement all their methods.<br>
In this example, `PostDownloadHtmlProcessor()` method has been incorporated solely for the benefit of one of its subclasses. 

To create a class, that, just downloads html file, without any post-processing , it is needed to implement all methods from the base `HtmlClient` class. <br>

```csharp
var client = new HttpClient();
var htmlSimple = new HtmlSimple(client);
var url = "https://../file.html";

// Just downloads html
await htmlCleaner.DownloadHtml(url);

```

```csharp
public class HtmlSimple(HttpClient client) : HtmlClient(client)
{
    protected override void PostDownloadHtmlProcessor()
    {
        // This method is doing nothing
    }
}
```

To create a class that does some HTML processing, it is again necessary to implement methods from `HtmlClient` and `HtmlCleaner`.
```csharp
public class HtmlBuilder(HttpClient client) : HtmlCleaner(client)
{
    protected override void PostDownloadHtmlProcessor() 
    { 
        base.PostDownloadHtmlProcessor();

        ...
    }

    ...
}

```


**2.** If a client wants to remove only tags from the existing `HTML`, they may be needed to `create extra instances` of classes, call extra methods. Methods, which can be tightly integrated with base class methods. Clients are coupled with other clients.

```csharp
// Extra instance of `HttpClient`
var client = new HttpClient();

var htmlCleaner = new HtmlCleaner(client);
var html = "Html<span> to process</span>.";

htmlCleaner.SetHtml(html);
htmlCleaner.RemoveSpanTags();
```

## `Adapter` pattern to follow ISP

The code presented above can be reworked by cleaning up the `HtmlCleaner` so that it implements only methods for cleaning `HTML`.<br>
Next, break unwanted coupling between `clients`, either by implementing `adapter` pattern for the `HtmlClient` and `HtmlCleaner` classes, through the `multiple inheritance` (which is not supported in `C#`) or `object delegation`.

```csharp
public class HtmlClient(HttpClient client)
{
    private string? html;

    public async Task DownloadHtml(string url)
    {
        this.html = await client.GetStringAsync(url);
    }

    protected internal string GetHtml()
    {
        return this.html!;
    }
}

public class HtmlCleaner(){
    private string? html;

    public string GetHtml()
    {
        return this.html!;
    }

    public void SetHtml(string html)
    {
        this.html = html ?? string.Empty;
    }

    public void RemoveSpanTags()
    {
        this.html = RemoveSpanTags(this.html!);
    }

    protected internal void RemoveBoldTags()
    {
        this.html = RemoveBoldTags(this.html!);
    }

    private static string RemoveBoldTags(string html)
        => Regex.Replace(html, @"<b>(.*?)</b>", string.Empty);

    private static string RemoveSpanTags(string html)
        => Regex.Replace(html, @"<span>(.*?)</span>", string.Empty);
}

public class HtmlCleanerClientAdapter(HtmlClient htmlClient, HtmlCleaner htmlCleaner)
{
    public async Task DownloadHtml(string url)
    {
        await htmlClient.DownloadHtml(url);

        PostDownloadHtmlProcessor();

        htmlCleaner.SetHtml(htmlClient.GetHtml());
    }

    public string GetHtml() => htmlCleaner.GetHtml();

    public void SetHtml(string html) => htmlCleaner.SetHtml(html);

    public void RemoveSpanTags()
    {
        htmlCleaner.RemoveSpanTags();
    }

    private void PostDownloadHtmlProcessor() => htmlCleaner.RemoveBoldTags();
}
```

Classes can be used like 
```csharp
var client = new HttpClient();
var htmlClient = new HtmlClient(client);
var htmlCleaner = new HtmlCleaner();
var url = "https://../file.html";
var htmlCleanerClientAdapter = new HtmlCleanerClientAdapter(htmlClient, htmlCleaner);

await htmlCleanerClientAdapter.DownloadHtml(url);

// optionally
htmlCleaner.RemoveSpanTags();

Console.WriteLine(htmlCleaner.GetHtml());
```

or download html

```csharp
var client = new HttpClient();
var htmlClient = new HtmlClient(client);
var url = "https://../file.html";

await htmlClient.DownloadHtml(url);

Console.WriteLine(htmlClient.GetHtml());
```

or clean up html
```csharp
var htmlCleaner = new HtmlCleaner();
var html = "Html<span> to process</span>.";

await htmlCleaner.SetHtml(url);
htmlCleaner.RemoveSpanTags();

Console.WriteLine(htmlCleaner.GetHtml());
```