# Key Concepts in `JavaScript`

### `null` vs `undefined`
```js
let myVariable = null; // Intentionally set to null
let myOtherVariable; // Declared but not assigned, so it's undefined
```

### `var` vs. `let`

##### var
Variables declared with `var` are either `function-scoped` or `global-scoped`. `var` variable can be used before it is declared.

##### let
Variables declared with `let` is `block scoped` `{}`. 


```js
function myFunction() {
  var x = 10; // Function scope
  let y = 20; // Block scope

  if (true) {
    var z = 30; // Function scope
    let w = 40; // Block scope
  }

  console.log(x); // 10
  console.log(y); // 20
  console.log(z); // 30
  console.log(w); // ReferenceError: w is not defined
}
```

### `function` vs `class`

In `javascript` when keyword `function` is written,
it defines not just a [function](https://en.wikipedia.org/wiki/Function_(computer_programming)), but also a [class](https://en.wikipedia.org/wiki/Class_(computer_programming)) with a [constuctor](https://en.wikipedia.org/wiki/Constructor_(object-oriented_programming)) which has body of that `function`.

# [js](#tab/jsClass)
```js
// Define class `Foo`
function Foo(value){
    console.log(value);
}

// Define instance `foo1` of the class `Foo`
// and call `empty` constructor of the object
var foo1 = new Foo();

// Call `parameterized` constructor of the object
foo1.constructor(123); // 123
foo1.constructor(567); // 567

// Define instance `foo1` of the class `Foo`
// and call `parameterized` constructor of the object
var foo2 = new Foo(111); // 111

// Call `parameterized` constructor of the object
foo2.constructor(222); // 222
```

# [C#](#tab/csharpClass)
```csharp
public class Foo{
    public Foo() {}

    public Foo(int value) => Init(value);

    public void Init(int value) => Console.WriteLine(value);
}

Foo foo1 = new();
foo1.Init(123); // 123
foo1.Init(567); // 567

Foo foo2 = new(111); // 111
foo2.Init(222); // 222
```
> * In C# by default constructor can be called only once, when the instance of the class is defined. 
---

#### `prototype`

To define [functions](https://en.wikipedia.org/wiki/Function_(computer_programming) inside of `class` in `javascript` used keyword `prototype`.

This means, that method's of the `class` could be defined later at `"runtime"`, and behavior of the instance of that class could be changed. 

# [js](#tab/jsClassFunctions)
```js
function Foo(value){
    console.log(value);
}
// 
// here can be logic
// var foo = new Foo();
// foo.Bar() // Uncaught TypeError: foo.Bar is not a function
//

// Define `method` `Bar` inside of `class` `Foo` 
Foo.prototype.Bar = function(x, y){
    console.log(x + y);
}

var foo = new Foo();
foo.Bar(1, 2); // 3
```
Equivalent class `Foo` definition
```js
function Foo(value){
    // Define `method` `Bar` inside of `class` `Foo` 
    this.Bar = function(x, y){
        console.log(x + y);
    }

    console.log(value);
}

var foo = new Foo();
foo.Bar(1, 2); // 3
```

# [C#](#tab/ClassFunctions)
```csharp
public class Foo{
    public Foo() {}

    public Foo(int value) => Init(value);

    public void Init(int value) => Console.WriteLine(value);

    public void Bar(int x, int y) => Console.WriteLine(x + y);
}

Foo foo = new();
foo.Bar(1, 2); // 3
```
---

# [js](#tab/jsClassFields)
#### class fields
```js
function Foo(){
    // Define fields inside of class `Foo`
    this.id = 1;
    this.name  = "Bob";
}

// Define a method inside of Foo class
Foo.prototype.doSmth = function(){
    console.log("work");
}
var foo = new Foo();
console.log(foo.id); // 1
console.log(foo.name); // Bob
foo.doSmth(); // work
```

Equivalent class definition

```js
// Define instance `foo` of an anonymous class
var foo = {

    // Define fields inside of class `Foo`
    id: 1,

    name: "Bob",

    // Define a method inside of anonymous class
    doSmth() {
        console.log("work");
    }
};
console.log(foo.id); // 1
console.log(foo.name); // Bob
foo.doSmth(); // work
```

# [C#](#tab/csharpClassFields)
```csharp
public class Foo{
    public int id;
    public string name;

    public Foo() {
        this.id = 1;
        this.name = "Bob";        
    }

    public doSmth() => Console.WriteLine("work");
}

Foo foo = new();
Console.WriteLine(foo.id); // 1
Console.WriteLine(foo.name); // Bob
foo.doSmth(); // work
```
---


### `object` inheritance
#### `__proto__`
In `js` keyword `__proto__` is used for `object` [inheritance](https://en.wikipedia.org/wiki/Inheritance_(object-oriented_programming)).

Comparing to C#, js use `object`([prototype-based inheritance](https://en.wikipedia.org/wiki/Prototype-based_programming)), while C# use `class`([class-based inheritance](https://en.wikipedia.org/wiki/Class-based_programming))

In `js` object consists of fields and a `reference` to the type, which can be changed durring code execution and `object` will aquire new `methods`.
In `C#` object consists of fields, a `reference` to the type([virtual method table (VMT)](https://en.wikipedia.org/wiki/Virtual_method_table)) and `SyncBlockIndex`. 

```js
function Foo(){ }

Foo.prototype.doFooWork = function(){
    console.log("foo work");
}

function Bar(){ 
}

Bar.prototype.doBarWork = function(){
    console.log("bar work");
}

var bar = new Bar();

// Now bar has a reference to `VMT` of `Foo`
bar.__proto__ = Foo.prototype
// Other ways to change `reference` of `type` to another `type`:
// bar.__proto__ = Object.create(Foo.prototype);
// bar.__proto__ = new Foo().__proto__;
//
// Make class `Bar` itself be inherited from `Foo` class
// Object.setPrototypeOf(Bar.prototype, Foo.prototype);

bar.doFooWork(); // foo work
bar.doBarWork(); // TypeError: bar.doBarWork is not a function

```

Instance `__proto__` has same address as class `type` `prototype`. 
```js
function Foo(){ }

var foo = new Foo();

foo.__proto__ === Foo.prototype; // true
```

#### Inheritance in JS
```js
function Foo() { }

function Bar() { }

Object.setPrototypeOf(Bar.prototype, Foo.prototype);
```

with syntax sugar
```js
class Foo {} 

class Bar extends Foo {}
```

### class `Function` 
In `js` each class is inherited from `Function` class.<br> 
In `C#` each class is inherited from `Object` class.

`Function` has methods `call`, `bind`, `apply`.
Methods like `call()`, `apply()`, and `bind()` can refer `this` to any object.

#### `call()`
`call()` calls a method from another object.
```js
const person = {
  fullName: function() {
    return this.firstName + " " + this.lastName;
  }
}
const person1 = {
  firstName:"John",
  lastName: "Doe"
}

person.fullName.call(person1); // Jonh Doe
```

#### `apply()`
`apply()` calls a method from another object.
```js
const person = {
  fullName: function() {
    return this.firstName + " " + this.lastName;
  }
}

const person1 = {
  firstName: "Mary",
  lastName: "Doe"
}

person.fullName.apply(person1); // Mary Doe
```
##### `call()` vs `apply()`
The `call()` method takes `arguments separately`.<br>
The `apply()` method takes `arguments as an array`.

#### `bind()`
With the `bind()` method, an `object` can `borrow` a `method` to another object.
```js
const person = {
  firstName:"John",
  lastName: "Doe",
  fullName: function () {
    return this.firstName + " " + this.lastName;
  }
}

const member = {
  firstName:"Hege",
  lastName: "Nilsen",
}

let fullName = person.fullName.bind(member);
fullName(); // Hege Nilsen
```

### Closures
Inner functions have access to outer scope.

```js
function Foo(){
    // function-scoped
    let value = 0;

    // inner function
    function Bar(){
        value++;
        console.log(value);
    }

    Bar();
}

Foo(); // 1
Foo(); // 1

```

When the inner function is returned from the outer function, the local variable 'value' will exists durring the whole `foo` object life.

# [js](#tab/jsClosure)
```js
function Foo(){
    // function-scoped
    let value = 0;

    // inner function
    function Bar(){
        value++;
        console.log(value);
    }

    return Bar;
}

let foo = Foo();
foo(); // 1
foo(); // 2

```

# [C#](#tab/csharpClosure)
```csharp
var foo = Foo();
foo(); // 1
foo(); // 2


static Action Foo() {

    int value = 0;

    void Bar() { 
        value++;
        Console.WriteLine(value);
    }

    return Bar;
}
```
---


### Callback trick
```js
function Bar(value, callback){
    console.log("Bar enter.. " + value);

    setTimeout(() => {
        value++;
        console.log("Bar: Long running job...");

        callback(value);
    }, "1000");

    console.log("Bar exit.. " + value);
}

function Foo(){
    function CallBack(value){
        console.log("CallBack: " + value);
    }

    let value = 10; 
    let callBack = CallBack;

    console.log("Foo: before `Bar` " + value);
    Bar(value, callBack);
    console.log("Foo: after `Bar` " + value);
}

Foo();
// Foo: before `Bar` 10
// Bar enter.. 10
// Bar exit.. 10
// Foo: after `Bar` 10
// ..
// Bar: Long running job...
// CallBack: 11

```

### The event loop
To execute `functions` js runtime use [Queue](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)). 
Js runtime puts `function's` into the `queue` and executes them `one by one`. 
As a result, `the next function` in the `queue` does not start until the `current one` finishes executing. 
```js
function Bar() {
    console.log("Bar: ...");
}
function Foo(){
    console.log("Foo: stat..");
    let bar = Bar;

    // Timeout: 0ms
    setTimeout(bar, 0)

    // Intensive work
    for(let i = 0; i < 10000; i++) { }

    console.log("Foo: end..");
}

Foo();
// Foo: stat..
// Foo: end..
// Bar: ...

```