# Cwalina K. Framework Design Guidelines. Conventions,Idioms,and Patterns 3ed 2020

## Review
The book offers quotes and advice from various experts on selecting the optimal code structures for developing libraries and .NET frameworks.<br>
It contains many historical backward explanations of why certain things were chosen and the resulting consequences.<br>
I especially liked the story about exposing `abstract class` vs `interfaces` and what is best to choose. It explains a lot why modern `C# interfaces` can have logic within them. 

## Notes

### 4.2 class vs struct 

- (de)allocation an array of value types is immediat, while array of reference types - not

- Value types get boxed when they are cast to a reference type or one of the interfaces they implement. They get unboxed when they are cast back to the value type.

- Assignments of large reference types are cheaper than assignments of large value types.

- Reference types are passed by reference, whereas value types default to being passed by value

**CONSIDER** defining a struct instead of a class if instances of the type are small and commonly short-lived or are commonly embedded in other objects, especially arrays.

**AVOID** defining a struct unless the type has all of the following characteristics:
- It logically represents a single value, similar to primitive
- types (int, double, etc.).
- It has an instance size less than 24 bytes.
- It is immutable.
- It will not have to be boxed frequently.


### 4.3 class vs interface

**DO** favor defining classes over interfaces.<br>
Class-based APIs can be evolved with much greater ease than interface-based APIs because it is possible to add members to a class without breaking existing code.

**DO** use abstract classes instead of interfaces to decouple the contract from implementations.

**DO** define an interface if you need to provide a polymorphic hierarchy of value types.<br>
Value types cannot inherit from other types, but they can implement interfaces.

**CONSIDER** defining interfaces to achieve a similar effect to that of multiple inheritance.


### 4.4 abstract class

**DO NOT** define public or protected internal constructors in abstract types

**DO** define a protected or an internal constructor in abstract classes.

**DO** provide at least one concrete type that inherits from each abstract class that you ship.


### 4.5 static class

Static classes are a compromise between pure object-oriented design and simplicity. They are commonly used to provide shortcuts to other operations (such as System.IO.File), holders of extension methods, or functionality for which a full object-oriented wrapper is unwarranted

**DO** use static classes sparingly.
(Static classes should be used only as supporting classes for the object-oriented core of the framework.)

**DO NOT** treat static classes as a miscellaneous bucket.

**DO NOT** declare or override instance members in static classes.
(This is enforced by the C# compiler. abstract sealed)

**DO** declare static classes as sealed, abstract, and add a private instance constructor if your programming language does not have built-in support for static classes.


### 4.6 interface

**DO** define an interface if you need some common API to be supported by a set of types that includes value types.

**CONSIDER** defining an interface if you need to support its functionality on types that already inherit from some other type.

**AVOID** using marker interfaces (interfaces with no members).<br>
*Avoid*: ```interface IImutable {}  class Key : IImutable```<br>
*Consider*: ```[Immutable] class Key {}```<br>
Methods can be implemented to reject parameters that are not marked with a specific attribute)

**DO** provide at least one type that is an implementation of an interface.<br>
Doing this helps to validate the design of the interface.

**DO** provide at least one API that consumes each interface you define (a method taking the interface as a parameter or a property typed as the interface).
<br>
Doing this helps to validate the interface design.

**DO NOT** add members to an interface that has previously shipped.<br>
Doing so would break implementations of the interface. You should create a new interface to avoid versioning problems.<br>
In general, choose classes rather than interfaces in designing managed code reusable libraries.

> `IClonable` - some implement it as `shadow copy`, some as `deep copy`. You never
know what you’re going to get. This makes the interface useless

### 4.7 struct

**DO NOT** provide a default constructor for a struct.

**DO NOT** define mutable value types.<br> 
when a property getter returns a value type, the caller receives a copy. Because the copy is created implicitly, developers might not be aware that they are mutating the copy, not the original value.

**DO** declare immutable value types with the `readonly` modifier.<br>
Newer compiler understand the readonly modifier on a value type and avoid making extra
value copies on operations such as invoking a method on a field declared with the readonly modifier.
```public readonly struct ZipCode {...}```

```csharp
class .. { 
    private readonly ZipCode _zipCode;

    .. {
        // ToString() method call does not involve a defensive copy
        string zip = _zipCode.ToString();
    }
}
```

**DO** declare nonmutating methods on mutable value types with the `readonly` modifier.<br>
`readonly` modifier on a method allows the compiler to skip copying the value before invoking the method.
```csharp
// Any methods also need the readonly modifier (if they don't mutate)
public override readonly string ToString() {}
```

**DO** ensure that a state where all instance data is set to zero, false, or null (as appropriate) is valid.<br>
This prevents accidental creation of invalid instances when an array of the structs is created.

**DO NOT** define `ref-like` value types (ref struct types), other than for specialized low-level purposes where performance is critical.<br>
`ref struct` type are allowed to exist only on the stack, and can never be boxed into the heap. Consequently, a ref struct type cannot be used as the type for a field in another type, except for other ref struct types, and cannot be used in asynchronous methods generated with the async keyword.

**DO** implement `IEquatable<T>` on value types.<br>
The `Object.Equals` method on value types causes boxing, and its default implementation is not very efficient, because it uses reflection.


### 4.8 enum

**DO** use an enum to strongly type parameters, properties, and return values that represent sets of values.

**DO** favor using an enum instead of static constants.
(you will get some additional compiler and reflection
support if you define an enum versus manually defining a structure with
static constants.)

**DO NOT** use an enum for open sets (such as the operating system version, names of your friends, etc.).

**DO NOT** provide reserved enum values that are intended for future use.
(You can always simply add values to the existing enum at a later stage.
Reserved values just pollute the set of real values and tend to lead to user errors.)

**DO** provide a value of zero on simple enums.
`(enum ..{ None=0,GZip,Deflate}`
> `class` and `struct` fields are initialized to their zero-value by default.

**CONSIDER** using `Int32`<br>
A smaller underlying type would result in substantial savings in space.
The size savings might be significant if:
- You expect the enum to be used as a field in a very frequently instantiated structure or class.
- You expect users to create large arrays or collections of the enum instances.

> For in-memory usage, be aware that managed objects are always `DWORD`-aligned.

**DO** name flag enums with plural nouns or noun phrases and simple enums with singular nouns or noun phrases.


#### 4.8.1 enum flags

**DO** apply the System.FlagsAttribute to flag enums.<br>
Do not apply this attribute to simple enums.`[Flag] enum ..`

**DO** use powers of 2 for the flag enum values so they can be freely combined using the bitwise OR operation.
```csharp
[Flags]
public enum WatcherChangeTypes {
    None = ʘ,
    Created = ʘxʘʘʘ2,
    Deleted = ʘxʘʘʘ4,
    Changed = ʘxʘʘʘ8,
    Renamed = ʘxʘʘ1ʘ,
}
```

**AVOID** creating flag enums where certain combinations of values are invalid.

**DO** name the zero value of flag enums `None`.

**CONSIDER** adding values to enums, despite a small compatibility risk.<br>
If you have real data about application incompatibilities caused by additions to an enum, consider adding a new API that returns the new and old values, and deprecate the old API

### 4.9 nested type

A nested type is a type defined within the scope of another type, which is called the enclosing type. A nested type has access to all members of its enclosing type.

> *Nested types are very tightly coupled with their enclosing types*, and as such are not suited to be general-purpose types.

Nested types are best suited for modeling implementation details of their enclosing types.
The end user should rarely have to declare variables of a nested type, and should almost never have to explicitly instantiate nested types.  For example, the enumerator of a collection can be a nested type of that collection.

**DO** use nested types when the relationship between the nested type and its outer type is such that member-accessibility semantics are desirable.

**DO NOT** use nested types if the type is likely to be referenced outside of the containing type.
(For example, an enum passed to a method defined on a class should not be defined as a nested type in the class.)

**DO NOT** use nested types if they need to be instantiated by client code.


### 5.3 ctor

.net execute the static constructor precisely on the first static field
access.


### 5.4 events

There are two groups of events: events raised `before a state of the system changes`, called `pre-events`, and events raised `after a state changes`, called `post-events`. An example of a pre-event would be `Form.Closing`, which is raised before a form is closed. An example of a post-event would be `Form.Closed`, which is raised after a form isclosed.


### 5.8 parameter design
**DO** use the least derived parameter type that provides the functionality required by the member.<br>
`void WriteItemsToConsole(IEnumerable<object> items) {...)`


#### 5.8.1 enum vs bool
**DO** use enums if a member would otherwise have two or more Boolean parameters.<br>
```csharp
Stream stream = File.Open("foo.txt", true, false);
```
```csharp
Stream stream = File.Open("foo.txt", CasingOptions.CaseSensitive, FileMode.Open);
```


#### 5.8.2 Validating Arguments

**DO** validate arguments passed to public, protected, or explicitly implemented members. `Throw System.ArgumentException`, or one of its subclasses, if the validation fails.

**DO** `throw ArgumentNullException` if a null argument is passed and the member does not support null arguments.

**DO** `validate enum parameters`. Do not assume enum arguments will be in the range defined by the enum. The CLR allowscasting any integer value into an enum value even if the value is not defined in the enum.

**DO** be aware that `mutable arguments might have changed` after they were validated. 


#### 5.8.3 Parameter Passing

**AVOID** using `out` or `ref` parameters except when implementing patterns that require them, such as the Try pattern

**DO NOT** pass reference types by reference (`ref` or `in`)<br>
There are some limited exceptions to the rule, such as when a method can be used to swap references.

```csharp
public static class Reference {
    public void Swap<T>(ref T obj1, ref T obj2){
            T temp = obj1;
            obj1 = obj2;
            obj2 = temp;
        }
    }
```

**DO NOT** pass value types by read-only reference `in`.<br>
> struct should be small by design


### 6.1.4 Virtual Members

**DO NOT** make members `virtual` unless you have a good reason to do so and you are aware of all the costs related to designing, testing, and maintaining virtual members.<br>
Virtual members are less forgiving in terms of changes that can be made to them without breaking compatibility. Also, they are `slower than nonvirtual members`, mostly because calls to virtual members are not inlined.


### 6.3 SEALING

**CONSIDER** sealing members that you override.
```csharp
protected sealed override void OnValueChanged())
```


### 7.3 Exception types

**DO** throw an InvalidOperationException if the object is in an inappropriate state.<br>
The `System.InvalidOperationException` exception should be thrown if a property set or a method call is not appropriate given the object’s current state.<br>
The difference between `InvalidOperationException` and `ArgumentException` is that `ArgumentException` does not rely on the state of any other object besides the argument itself to determine whether it needs to be thrown.


### 8.3 Collections

**DO NOT** use weakly typed collections in `public APIs`.<br>
A collection storing Components should not have a public Add method that takes an object or a public indexer returning IComponent.

```csharp
// bad design
public class ComponentDesigner {
    public IList Components { get { } }
}
// good design
public class ComponentDesigner {
    public Collection<Component> Components { get { } }
}

```

**DO NOT** use `ArrayList` or `List<T>` in public APIs.<br>
These types are data structures designed to be used in internal implementation, not in public APIs.<br> `List<T>` is optimized for performance and power at the cost of cleanness of the APIs and flexibility. For example, if you return `List<T>`, you will never be able to receive notifications when client code modifies the collection. Also, `List<T>` `exposes many members`, such as `BinarySearch`, that are `not` useful or `applicable in many scenarios`.
Instead of using these concrete types, consider `Collection<T>`, `IEnumerable<T>`, `IList<T>`, `IReadOnlyList<T>`, or other collection abstractions.


**DO NOT** use `Hashtable` or `Dictionary<TKey,TValue>` in public APIs.
These types are data structures designed to be used in internal implementation. Public APIs should use `IDictionary`, `IDictionary <TKey, TValue>`, or a custom type implementing one or both of the interfaces.

**DO NOT** use `IEnumerator<T>`, `IEnumerator`, or any other type that implements either of these interfaces, except as the return type of a GetEnumerator method.

**DO NOT** implement both `IEnumerator<T>` and `IEnumerable<T>` on the same type. The same applies to the non-generic interfaces IEnumerator and IEnumerable. In other words, a `type should be either a collection or an enumerator`, but not both.


### 8.3.1 collection paramaters

**DO** use the least-specialized type possible as a parameter type. Most members taking collections as parameters use the `IEnumerable<T>` interface.
```csharp
ppublic void PrintNames(IEnumerable<string> names)
```

**AVOID** using `ICollection<T>` or `ICollection` as a parameter just to access the `Count` property.
```csharp
    public List(IEnumerable<T> collection){
    // check if it implements ICollection
    if (collection is ICollection<T> col) {
        this.Capacity = collection.Count;
    }
    foreach(T item in collection){
        Add(item);
    }
}
```


**DO NOT** return null values from collection properties or from methods returning collections.<br>  
`Return an empty collection` or an empty array instead.

**AVOID** implementing collection interfaces on types with complex APIs unrelated to the concept of a collection.<br>
Collection should be a simple type used to store, access, and manipulate items, and not much more.

#### 8.6 ICloneable

**DO NOT** use ICloneable in public APIs.

**CONSIDER** defining the Clone method on types that need a cloning mechanism.


### 8.6 ICOMPARABLE<T> AND IEQUATABLE<T>

`IComparable<T>` specifies ordering (less than, equals, greater than) and is used mainly for sorting.
`IEquatable<T>` specifies equality and is used mainly for look-ups.

**DO** implement `IEquatable<T>` on value types.
The `Object.Equals` method on value types causes boxing, and its default implementation is not very efficient because it uses reflection.

**DO** override Object.Equals whenever implementing `IEquatable<T>`

**CONSIDER** overloading `operator==` and `operator!=` whenever implementing `IEquatable<T>`

**DO** implement `IEquatable<T>` any time you implement `IComparable<T>`


### 8.8 NULLABLE<T>

```csharp
int? x = null; // alias for Nullable<int>
```

**DO NOT** use `Nullable<T>` to represent optional parameters.
```csharp
// good design
public class Foo {
    public Foo(string name, int id);
    public Foo(string name);
}
```

**AVOID** using Nullable<bool> to represent a general three-state value.<br>
`Nullable<bool>` should only be used to represent truly optional Boolean values: true, false, and not available. If you simply want to represent three states (e.g., yes, no, cancel), `consider` using an `enum`.


### 8.9 OBJECT

The default implementation of `Object.Equals` on `value types` returns true if all fields of the values being compared compare themselves as equal. We call such equality “value equality.” The implementation `uses reflection to access the fields`; in consequence, it is often unacceptably inefficient and `should be overridden`.

The default implementation of `Object.Equals` on `reference types` returns true if the `two references being compared point to the same object`. We call such equality “reference equality.” Some reference types override the default implementation to provide value equality semantics. For example, the value of a `string` is based on the characters of the string, so the `Equals method of the String` class returns true for any `two string instances that contain exactly the same characters in the same order`.

**DO** override `GetHashCode` whenever you override Equals.

**DO NOT** implement value equality on `mutable reference types`.<br>
Reference types that implement value equality (e.g., System.String) should be immutable.


#### 8.9.2 Object.GetHashCode

**DO** override `GetHashCode` if you override `Object.Equals`.<br>
This guarantees that two objects considered equal have the same hash code. The following guidelines provide more information.

**DO** make every effort to ensure that `GetHashCode` generates a uniform distribution of numbers for all objects of a type.<br>
This will minimize hashtable collisions, which degrade performance.


#### 8.9.3 Object.ToString

The `Object.ToString` method is intended to be used for general display and `debugging purposes`. The `default implementation` simply provides the object type name. The default implementation is not very useful, and it is `recommended that the method be overridden`.


#### 8.11 URI

**DO** use `System.Uri` to represent URI and URL data.<br>
`System.Uri` is a much safer and richer way of representing URIs. Extensive manipulation of URI-related data using plain strings has been shown to cause many security and correctness problems.


### 9.1 AGGREGATE COMPONENTS

Many feature areas might benefit from one or more façade types that act as simplified views over more complex but also more powerful APIs.
An aggregate component ties multiple lower- level factored types into a higher-level component to support common scenarios, and is `the entry point for developers exploring its namespace`.
Aggregate components, as high-level APIs, should be implemented so they magically work without the user being aware of the sometimes complicated things happening underneath. We often refer to this concept as `It-Just-Works`.
Users of aggregate components should not be required to implement any interfaces, modify any configuration files, and so on.
(string[] lines = File.ReadAllLines("foo.txt");)
In other words, framework designers should provide `full end-to-end solutions`, `not just the APIs`.

### 9.1.1 Component-Oriented Design
Component-oriented design is a design in which APIs are exposed as types, with constructors, properties, methods, and events.<br>
**Create–Set–Call pattern**
```csharp
var foo = new Foo();
foo.P1 = v1;
foo.P2 = v2;
foo.P2.Body = new Body();
// Call methods and optionally change options between calls
foo.M1();
// foo.P3 = v3;
foo.M2();
```
It is very important that `all aggregate components` `support this pattern`.<br>
One `problem` with component-oriented design is that it sometimes `results in types` that `can have modes` and `invalid states`.<br>
The `Create–Set–Call` pattern is something that users of aggregate components expect and for which tools such as `IntelliSense` and `designers` are `optimized`.<br>
For example, a `default constructor` `allows` users to `instantiate` a MessageQueue `component` `without providing a valid path`. Also, `properties`, which `can be set optionally` and independently, sometimes `cannot enforce consistent and atomic changes to the state of the object`.<br>

The `benefits` of component-oriented design often outweigh these drawbacks for mainline scenario APIs, such as aggregate components, where `usability is the top priority`.

> When users call `methods` that are `not valid in the current state ofthe object`, an `InvalidOperationException` `should be thrown`. The exception’s message should clearly explain what properties need to be changed to get the object into a valid state.

**Constructors** An aggregate component should provide a simple constructor.<br>
**Constructors** All constructor parameters correspond to and initialize properties.<br>
**Properties** Most properties have getters and setters.<br>
**Properties** All properties have sensible defaults.<br>
**Methods** Methods do not take parameters if the parameters specify options that stay constant across method calls (in main scenarios). Such options should be specified using properties.<br>
**Events** Methods do not take delegates as parameters. All callbacks are exposed as events.


### 9.1.2 Factored Types

`Factored types` should `not have modes` and should `have very clear lifetimes`. An aggregate component `might provide` access to its internal factored types `through some properties or methods`. Users would access the internal factored types in advanced scenarios or in scenarios where integration with different parts of the system is required.
```csharp
var port = new SerialPort("COM1");
port.Open();
GZipStream compressed;
compressed = new GZipStream(port.BaseStream, CompressionMode.Compress);
compressed.Write(data, ʘ, data.Length);
port.Close();
```
> Since `factored types have an explicit lifetime`, it probably makes good sense to implement the `IDisposable interface` so that developers can make use of the using statement.

### 9.1.3 Aggregate Component Guidelines

**CONSIDER** providing aggregate components for commonly used feature areas.<br>
Aggregate components `provide high-level functionality` and `are starting points for exploring given technology`. They `should provide shortcuts` for common operations and add significant value over what is already provided by factored types.<br>  
They `should not simply duplicate the functionality`. Many main scenario code samples should start with an instantiation of an aggregate component.<br>
> An `easy trick to increase the visibility` of an aggregate component is `to choose the most “attractive” name for the component` and less attractive names for the corresponding factored types. For example, a name representing a well-known system entity like File will attract more attention than StreamReader.

**DO** model `high-level concepts (physical objects)` rather than system-level tasks with aggregate components.<br>  
For example, the components should model files, directories, and drives, rather than streams, formatters, and comparers.

**DO** increase the visibility of aggregate components by `giving them names that correspond to well-known entities of the system`, such as MessageQueue, Process, or EventLog.

**DO** design aggregate components so they `can be used after very simple initialization`.<br>
If some initialization is necessary, the exception resulting from not having the component initialized should clearly explain what needs to be done.

**DO NOT** require the users of aggregate components to explicitly instantiate multiple objects in a single scenario.<br>
Simple tasks should be done with just one object. The next best thing is to start with one object that in turn creates other supporting objects.
```csharp
var queue = new MessageQueue();
queue.Path = ...;
queue.Send("Hello World");
```

**DO** make sure aggregate components `support the Create–Set–Call` usage pattern, where developers expect to be able to implement most scenarios by instantiating the component, setting its properties, and calling simple methods.

**DO** provide a default or a very simple constructor for all aggregate components.

**DO** provide properties with getters and setters corresponding to all parameters of aggregate component constructors.<br>
It should always be possible to use the default constructor and then set some properties instead of calling a parameterized constructor.

**DO** use events instead of delegate-based APIs in aggregate components.

**DO** use events in aggregate components instead of virtual members that need to be overridden.

**DO NOT** require users of aggregate components to inherit, override methods, or implement any interfaces in common scenarios.<br>  
Components should mostly rely on properties and composition as the means of modifying their behavior.

**DO NOT** require users of aggregate components to do anything besides writing code
in common scenarios. For example, users shouldnot have to configure components in the configuration file, generate any resource files, and so on.

**DO NOT** design factored types that have modes.<br>
Factored types should have a well-defined life span scoped to a single mode. For example, instances of Stream can either read or write, and an instantiated stream is already opened.

**CONSIDER** separating aggregate components and factored types into different assemblies.

**CONSIDER** exposing access to internal factored types of an aggregate component.<br>
Factored types are ideal for integrating different feature areas. For example, the SerialPort component exposes access to its stream, thus allowing integration with reusable APIs, such as compression APIs that operate on streams.


### 9.2.3 Async Method Return Types

**CONSIDER** returning `ValueTask<TResult>`
from an asynchronous method when the method commonly `completes synchronously`.<br>
Analysis of the behavior of `System.IO.Stream` shows that in many cases there is already data available when the `ReadAsync` method is called, due to buffering; thus, the method often returns synchronously. Since the synchronous Read method returns an `Int32`, it can usually avoid having any memory impact when data is already available, but the `ReadAsync` method needs to produce a `Task<int>` to report the number of bytes read. The resulting small memory impact can become noticeable when done in a loop.
```csharp
// The newer, .NET Standard 2.1 version 
public virtual ValueTask<int> ReadAsync( Memory<byte> buffer, CancellationToken cancellationToken = default);
```
)

> `ValueTask<TResult>` `doesn’t always provide better performance` than `Task<TResult>`. When a `ValueTask<TResult>` is returned by a method that is built with the async keyword, and `the method did not complete synchronously`, `a new Task<TResult> instance` is created to track the remainder of the operation. **For operations that regularly complete asynchronously, returning a `ValueTask<TResult>` leads to a usability loss and a minor performance penalty for the caller**, with no significant gain.

**DO** throw an `OperationCanceledException` when aborting work due to a `CancellationToken`.
(
```csharp
// Good: this causes the canceled message for our caller
if (cancellationToken.IsCancellationRequested)
{
throw new OperationCanceledException(cancellationToken);
}
// Good: this causes the canceled message for our caller 
cancellationToken.ThrowIfCancellationRequested();
```
)

**DO** use `await task.ConfigureAwait(false)` when awaiting an Async operation, except in application models that depend on the synchronization context.<br>
By default, .NET uses SynchronizationContext.Current to determine how to continue processing the Task. 
In a `console application`, the default SynchronizationContext sends Tasks to be executed on `background threads` with no special handling. 
`Win-Forms or WPF—the` default SynchronizationContext dispatches all Task completion callbacks to the UI thread to make it easier to interact with UI elements.


### 9.2.5.3 Avoiding Deadlock

**DO NOT** invoke `Task.Wait()` or read the `Task.Result` property in an Async method; instead, `use await`.<br>
The await keyword causes the Task to yield, which allows other Tasks to continue. The `Task.Wait()` method—and the `Task.Result` property—instead do a blocking synchronous wait, which is inefficient and can lead to deadlock in some situations.

**DO** `call asynchronous method variants`, `instead of synchronous` method variants, in the implementation of Async methods.


### 9.2.5.5 Exceptions from Async Methods

**DO** throw usage error exceptions directly from the Async method, to aid in debuggability.
```csharp
// Wrong: The exception is thrown inside the Task;
// the call stack will be less clear
public async Task SaveAsync(string filename) {
if (filename == null)
    throw new ArgumentNullException(nameof(filename));
...
}

// Right: The exception is thrown instead of a Task being returned.
public Task SaveAsync(string filename) {
if (filename == null)
    throw new ArgumentNullException(nameof(filename));
return SaveAsyncCore(uri);
}
private async Task SaveAsyncCore(string filename) { ... }
```


### 9.2.10 IAsyncEnumerable<T>
**DO** add the `[EnumeratorCancellation]` attribute to the CancellationToken parameter of an IAsyncEnumerable<T> method using yield return.<br>
When the `attribute is not specified`, `the CancellationToken value` from `GetAsyncEnumerator` `is ignored` for compiler-generated implementations.
```csharp
// correct
public static async IAsyncEnumerable<int> ValueGenerator( int start, int count, [EnumeratorCancellation] CancellationToken cancellationToken = default) 
{
    int end = start + count;
    for (int i = start; i < end; i++) {
        await Task.Delay(i, cancellationToken).ConfigureAwait(false);
        yield return i;
    }
}
```

**DO** use the `WithCancellation` modifier when using `await foreach` on an IAsyncEnumerable<T> parameter for the purpose of using your `CancellationToken` with the enumerator.
```csharp
async foreach (int value in source.WithCancellation(cancellationToken).ConfigureAwait(false)
```


### 9.4 DISPOSE PATTERN

`Managed memory` is just one of many types of system resources. Resources other than managed memory still need to be released explicitly.

`System.Object` declares a `virtual method Finalize` (also called the finalizer) that is `called` by the `GC` `before` the object’s `memory is reclaimed` by the GC; this method can be overridden to release unmanaged resources. Types that override the finalizer are referred to as finalizable types.


> `Finalizers` are effective in some cleanup scenarios, they have two `significant drawbacks`:

* The finalizer is called when the GC detects that an object is eligible for collection. This happens at some `undetermined period` of time after the resource is no longer needed. The `delay` between when the developer could or would like to release the resource and the time when the resource is actually released by the finalizer might be unacceptable in programs that acquire `many scarce resources` (resources that can be easily exhausted) or in cases in which resources are `costly to keep in use` (e.g., large unmanaged memory buffers).

*  When the CLR needs to call a finalizer, it must postpone collection of the object’s memory until the next round of garbage collection (`the finalizers run between collections`).  
As a result, the object’s memory (and all objects it refers to) will not be released for a longer period of time.

.NET provides the `System.IDisposable` interface that should be implemented to provide the developer with a manual way to release unmanaged resources as soon as they are no longer needed. It also provides the `GC.SuppressFinalize` method, which can tell the GC that an object was manually disposed of and no longer needs to be finalized, in which case the object’s memory can be reclaimed earlier.

**CONSIDER** implementing the `Basic Dispose Pattern on classes` that themselves `don’t hold unmanaged resources` or disposable objects, but are `likely to have subtypes that do`.<br>
A great example of this is the `System.IO.Stream` class. Although it is an abstract base class that doesn’t hold any resources, most of its subclasses do.)

**DO** throw an `ObjectDisposedException` from any member that cannot be used after the object has been disposed of.

**CONSIDER** providing a `Close()` method, in addition to the `Dispose()` method, if “close” is standard terminology in the area.


### 9.4.3 Scoped Operations

**CONSIDER** returning a disposable value instead of making callers manually pair “begin” and “end” methods.


### 9.4.4 IAsyncDisposable
The `IAsyncDisposable` interface permits the same resource cleanup and operation termination as IDisposable, but allows for the implementation to use asynchronous methods when the work from Dispose() involves I/O or other blocking operations.

```csharp
public partial class SomeType : IDisposable, IAsyncDisposable {
public void Dispose() {
    Dispose(true);
    GC.SuppressFinalize(this);
}
protected virtual void Dispose(bool disposing) { ... }
public async ValueTask DisposeAsync() {
    await DisposeAsyncCore();
    Dispose(false);
    GC.SuppressFinalize(this);
}
protected virtual ValueTask DisposeAsyncCore() { ... }
}
```


### 9.5 FACTORIES

A factory is an operation or collection of operations that abstract the object creation process for the users, allowing for specialized semantics and finer granularity of control over an object’s instantiation. Simply put, a factory’s primary purpose is to generate and provide instances of objects to callers.

There are two main groups of factories: `factory methods` and `factory types` (also called abstract factories).

**DO** `prefer constructors to factories`, because they are generally more usable, consistent, and convenient than specialized construction mechanisms.

**CONSIDER** `naming factory methods` by `concatenating` `Create` and the `name of the type` being created, when the factory method is declared on a disctinct factory type.<br>  
For example, consider naming a factory method that creates buttons `CreateButton`. In some cases, a domain-specific name can be used, as in `File.Open`.

**CONSIDER** naming factory types by concatenating the `name of the type being created` and `Factory`.<br> 
For example, consider naming a factory type that creates Control objects `ControlFactory`.


### 9.6.1 Overview of LINQ

* Representation of a delay-compiled delegate, the `Expression<...>` family of types.


### 9.6.3 Supporting LINQ through IEnumerable<T>

**DO** implement `IEnumerable<T>` to enable basic LINQ support.
(
```csharp
public class RangeOfInt32s : IEnumerable<int> {
public IEnumerator<int> GetEnumerator() {...}
IEnumerator IEnumerable.GetEnumerator() {...}
}

...
var a = new RangeOfInt32s();
var b = a.Where(x => x>1ʘ);
```
)

**CONSIDER** implementing `ICollection<T>` to improve the performance of query operators.


**DO** place query extensions methods in a “Linq” subnamespace of the main namespace.  For example, extension methods for `System.Data` features reside in `System.Data.Linq` namespace.


### 9.9 TEMPLATE METHOD

The Template Method Pattern allows subclasses to retain the algorithm’s structure while permitting redefinition of certain steps of the algorithm.

The goal of the pattern is to control extensibility.  In the preceding example, the extensibility iscentralized to a single method (a common mistake is to make more than one overload virtual).

The nonvirtual public methods can ensure that certain code executes before or after the calls to virtual members and that the virtual members execute in a fixed order.

**AVOID** making `public` members `virtual`.

**CONSIDER** using the `Template Method Pattern` to `provide more controlled extensibility`.

**CONSIDER** naming `protected virtual` members that `provide extensibility points` for nonvirtual members by suffixing the `nonvirtual member name` with `“Core.”`.
```csharp
public void SetBounds(...){
    ...
    SetBoundsCore (...);
}
protected virtual void SetBoundsCore(...){ ... }
```

**DO** perform `argument and state validation` in the `nonvirtual member` of the Template Method Pattern `before calling the virtual member`.


### 9.10 TIMEOUTS

The user often specifies the timeout time. For example, it might take a form of a
parameter to a method call.
```csharp
server.PerformOperation(timeout);
```
An alternative approach is to `use a property`.
```csharp
server.Timeout = timeout;
server.PerformOperation();
```

**DO** `prefer` `method parameters` as the mechanism for users `to provide timeout time`.

**DO** prefer using `TimeSpan` to `represent timeout time`.

**DO** throw `System.TimeoutException` when a `timeout elapses`.

**DO NOT** return error codes to indicate timeout expiration.


### 9.12 OPERATING ON BUFFERS

The `Span<T>` type represents contiguous memory from a managed array, from a stackalloc array, a pointer and length, or a string. The Span<T> type also supports O(1) slicing operations, through the Slice methods.

`Span<T>` is a `ref-like value type (ref struct)`, which means `it cannot be a field in a class or (non-ref) struct`. Operations that need to store a buffer can use the `System.Memory<T>` type, which essentially `functions as a Span<T>` holder.
The `Memory<T>` type can represent a range within an array or be associated with a `MemoryManager<T>` object for more complicated uses (including pointer-based memory), making it more versatile than the `ArraySegment<T>` type.


**CONSIDER** using Spans as a representation of buffers.

**DO** use `ReadOnlySpan<T>` instead of `Span<T>` where possible.

**AVOID** returning a Span<T> or ReadOnlySpan<T> unless the lifetime of the returned Span is very clear.<br>
Because `Span` types can represent unmanaged memory, it is hard for a caller to understand the lifetime associated with the returned Span. Even with managed memory, it is entirely possible that the Span represents part of `an array that can get repurposed for some other operation.`

**DO** provide `very clear documentation` for the ownership rules `on a Span that you return` that `did not come from the caller`.


**CONSIDER** returning a `ReadOnlySpan<T>` from a get-only property or parameter-less method to represent fixed data, `when T is an immutable type`.


**CONSIDER** returning `System.Range` representing the bounds of a Span parameter, rather than a slice of the parameter.<br>
You `can convert` a `Span<T>` value to a `ReadOnlySpan<T>` when you need to, but you `can’t convert` a `ReadOnlySpan<T>` back to a `Span<T>`. So, if you call a method that accepts a ReadOnlySpan<T> and returns a slice of the parameter, you can’t easily determine the equivalent slice of your writable Span.

**DO** use `ReadOnlyMemory<T>` in place of `ReadOnlySpan<T>` in asynchronous methods.

**DO** use `Memory<T>` in place of `Span<T>` in asynchronous methods.<br>
Asynchronous methods largely represent the idea of “doing work later.” Since the Span types can’t generally be stored as part of the state of pending work, the appropriate Memory type should be used instead.

**DO** use `ReadOnlyMemory<T>` in place of `ReadOnlySpan<T>` for parameters when the purpose of the constructor or method is to store a reference to the buffer.

**DO** use `Memory<T>` in place of `Span<T>` for parameters when the purpose of the constructor or method is to save a reference to the buffer.

**AVOID** overloading a method across `Span<T>` and `ReadOnlySpan<T>`, or `Memory<T>` and `ReadOnlyMemory<T>`.<br>
If one method operates on a buffer in a read-only manner and another operates on it in a read- write manner, those methods should have different names to facilitate caller understanding on why the two methods behave differently.

**DO** prefer the `name` `“source”` for the `input buffer` parameter of methods that accept anoutput buffer and a single input buffer.
**DO** prefer the `name` `“destination”` for the `output buffer` parameter of methods that write to a single buffer.


### A.2 NAMING CONVENTIONS

**DO** use a prefix `“_”` (underscore) for private and internal instance fields, `“s_”` for private and internal static fields, and `“t_”` for private and internal thread-static fields.<br>
These prefixes are very valuable to a code reviewer.
