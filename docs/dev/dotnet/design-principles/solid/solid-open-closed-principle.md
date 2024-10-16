# Open-Closed Principle

The open-closed principle was introduced by Bertrand Meyer in booke "Object-Oriented Software Construction".
> Software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification. 

A `module` is considered `open` if it can be extended with new functionality, fields, data structures.

A `module` is considered to be `closed` if it is available for use by other modules. Module is assumed to be stable, tested, with well-defined documentation.<br>
Closing a module simply means compiling it into a `library` or `package` format (e.g., NuGet, npm), obtaining management approval, or merging the code into the `main` branch of the repository. 

With traditional methods it is imposible to make module open and closed.<br>
A module can be `open`, meaning `it's not yet available for others to use`<br>
Or, a `module` can be `closed`, and any changes, such as hotfixes, can lead to `cascading effects` and painful changes in `other modules`.

### Example of an issue with traditional methods

Class `Foo` is distributed and closed. Two other clients `Client1`, `Client2` started using it. 
```csharp
public class Foo
{
    public string GetApiEndpoint(int x)
    {
        return "https://.../file.json";
    }
}

public class Client1 
{
    public void Method1(Foo foo, int x)
    {
        string endpoint = foo.GetApiEndpoint(x);
    }
}

public class Client2 
{
    public void Method2(Foo foo) { ... }
}
```

Publishing new functionality can be made, either

**1.** By adding a new changes to class `Foo`.
```csharp
public class Foo
{
    public string GetApiEndpoint(int x)
    {
        // new changes
        if(x < 0)
        {
            throw new ArgumentException("x < 0");   
        }

        return "https://.../file.json";
    }
}
```
And then clients update their modules:
```csharp
public class Client1 
{
    public void Method1(Foo foo, int x)
    {
        // adopting new `Foo` class
        if (x < 0)
        {
            x = 100_000 - x;   
        }
        string endpoint = foo.GetApiEndpoint(x);
    }
}
```

**2.** Or by renaming class `Foo` to new name, for ex. `FooV2`. 
```csharp
[Obsolute("Use class FooV2")]
public class Foo
{
    public string GetApiEndpoint(int x)
    {
        return "https://.../file.json";
    }
}

// Creating a new version of class with another name
public class FooV2
{
    public string GetApiEndpointV2(int x)
    {
        // and new changes
        if(x < 0)
        {
            throw new ArgumentException("x < 0");   
        }

        return "https://.../file.json";
    }
}
```

And then clients update their modules:
```csharp
public class Client1 
{
    public void Method1(FooV2 foo, int x)
    {
        // Clients adopting new class `FooV2`
        if (x < 0)
        {
            x = 100_000 - x;   
        }
        string endpoint = foo.GetApiEndpointV2(x);
    }
}
```

In the `first scenario`, `client's modules` might experience `compatibility issues`, and `stop working at all`, due to the module introducing new API endpoints.

In the `second scenario`, outdated `client modules` might encounter `security vulnerabilities` or `developers` may be `unsure` which class version to use.<br>
The issue could escalate further if clinet's modules also used by other modules and prolonged deployment process.

### How module can be open and closed? 
Object-oriented languages can offer inheritance to make code more easily adaptable for developers of client modules.

A new class `FooV2` inherits from class `Foo`, overrides method `GetApiEndpoint` and additionaly provides a new method with new functionality `GetApiEndpointV2`.
```csharp
public class Foo
{
    public virtual string GetApiEndpoint(int x)
    {
        return "https://.../file.json";
    }
}

// New class 
public class FooV2 : Foo
{
    // override base method
    public override string GetApiEndpoint(int x)
    {
        if(x < 0)
        {
            x = 100_000 - x;   
        }

        return GetApiEndpointV2(x);
    }

    // and introduce a new functionality
    public string GetApiEndpointV2(int x)
    {
        if(x < 0)
        {
            throw new ArgumentException("x < 0");   
        }

        return "https://.../file.json";
    }
}
```

Now clients can more easily adopt changes by simply renaming the object's type name.
```csharp
public class Client1 
{
    public void Method1(FooV2 foo, int x)
    {
        if (x < 0)
        {
            ...
        }
        string endpoint = foo.GetApiEndpoint(x);
    }
}
```

## Update 2014 
[ocp 2014 by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2014/05/12/TheOpenClosedPrinciple.html)

> You should be able to extend the behavior of a system without having to modify that system. 

The goal is to design modules in a manner that future changes can be implemented without `modifying any old code`.<br>

It can be achived by implementing plugin system. 

### Example of plugin system

Class `Logger` implements plugin system. It has one plugin `MyConsoleLoggerWritter` which writes logs to the console.

```csharp
public interface ILogger
{
    void LogInformation(string msg);
}

public interface ILoggerWritter : ILogger {}

// Class logger implement plugin system
public class Logger : ILogger
{
    IList<ILoggerWritter> loggerWritter;

    public Logger(IList<ILoggerWritter> loggerWritters)
    {
        this.loggerWritter = loggerWritter;
    }

    public LogInformation(string msg)
    {
        foreach(var loggerWritter in loggerWritter)
        {
            loggerWritter.LogInforamtion(msg);
        }
    }
}

public class MyConsoleLoggerWritter : ILoggerWritter
{
    void LogInformation(string msg)
    {
        Console.WriteLine($"Info: {msg}");
    }
}



```

After `Logger` class is `closed` and deployed, client's modules can use it.
```csharp
public class Client1
{
    void Method()
    {
        var logger = new Logger([
            new MyConsoleLoggerWritter()
        ]);

        logger.LogInformation("Method is executed.");
    }
}
```

Later, can be introduced and deployed a new `plugin` `MyFileLoggerWritter`, that writes logs to the file.

```csharp
public class MyFileLoggerWritter : ILoggerWritter
{
    private string path;

    public MyFileLogger(string path)
    {
        this.path = path;
    }

    void LogInformation(string msg)
    {
        File.WriteAllLines(path, [$"Info: {msg}"]);
    }
}
```

Now a new `plugin` can be downloaded and easily re-used by client's module without adopting or changing `Logger` class as it was not modified.
```csharp
public class Client1
{
    void Method()
    {
        var logger = new Logger([
            new MyConsoleLoggerWritter(),
            new MyFileLoggerWritter()
        ]);

        logger.LogInformation("Method is executed.");
    }
}
```

## Questions and Answers

**Q**: Can existing code be modified, re-written with introducing a new feature or fixing an issue `without` `inheritance` or new `plugin`? 

**A**: Yes, if the original software can be rewritten to accommodate various client needs without additional complexity.<br> 
If a module is faulty, it should be corrected directly, rather than implementing a workaround through a derived module or plugin. Except in situations where modifications to the flawed existing software are restricted.

Bertrand Meyer 
> The Open-Closed principle and associated techniques are intended for the adaptation of healthy modules.

**Q** Can all code be closed for modifications?

**A** No, Open-Closed principle is strategic, code can not be for 100% closed to modifications. There are always a code which can be abstracted more and more. There are often situations where new requirements or changes necessitate modifications to existing code.