# UML diagrams, short notes

**Structure diagrams** represent the static aspects of the system. It emphasizes the things that must be present in the system being modeled.

**Behavior diagrams** represent the dynamic aspect of the system. It emphasizes what must happen in the system being modeled. Since behavior diagrams illustrate the behavior of a system, they are used extensively to describe the functionality of software systems. 

### Component diagram 
**Goal** Describes how a software system is split up into components and shows the dependencies among these components.
Splits app on components with `ports` and `interfaces`.

### Composite structure diagram
**Goal** This diagram can include internal parts, `ports` through which `the parts interact with each other` or through which `instances of the class interact` with the parts and `with the outside world`, and connectors between parts or ports. 

### Class diagram
**Goal** Describes the structure of a system by showing the system's classes, their attributes, operations (or methods), and the relationships among objects.

### Deployment diagram
**Goal** models the physical deployment of artifacts on nodes.
Device Node : physical computing resources
Execution Environment Node: software computing resource

### Profile diagram
**Goal** an extensibility mechanism that allows to extend and customize UML by adding new building blocks, creating new properties and specifying new semantics in order to make the language suitable to specific problem domain.

---

### Use Case diagram
**Goal** show Big Picture of project; graphical depiction of a user's possible interactions with a system.

*Actor*: user/system

*Use Case*: action/event
```xml
<<include>> sub_case is executed 100%.
<<extend>> sub_case may execute.
```

### Sequence diagram
**Goal** shows process interactions arranged in time sequence.
```
-------> send message
< - - -  receive response; result 
```

### Communication diagram
**Goal** models the interactions between objects or parts in terms of sequenced messages.
```
[:Chef] +-->switchOn()  ----> [:Oven] 
         \->switchOff() --/
```

Show much of the same information as `sequence diagrams`, but because of how the information is presented, some of it is easier to find in one diagram than the other.
`Communication diagrams` show which elements each one interacts with better, but `sequence diagrams` show the order in which the interactions take place more clearly.

### Timing diagram
**Goal** used to explore the behaviors of objects throughout a given period of time.
```
State Lifeline:
State1-----|
State2---------|
time-->----+---+-----
```
*Value Lifeline*: shows change of value through time

### Activity diagram
**Goal** graphical representations of workflows of stepwise activities and actions with support for choice, iteration, and `concurrency`. `Constructed from a limited number of shapes, connected with arrows.`

### Interaction Overview Diagram
**Goal** The `interaction overview diagram` is similar to the `activity diagram`, in that both visualize a sequence of activities. The difference is that, for an `interaction overview`, each `individual activity` is pictured as a frame which `can contain a nested interaction diagram`. This makes the interaction overview diagram useful to "`deconstruct a complex scenario` that would otherwise require multiple if-then-else paths to be illustrated as a single sequence diagram

### State diagram
**Goal** The concepts behind it are about `organizing` the way a device, `computer program`, or other (often technical) process works such that an `entity` or each of its sub-entities is always `in exactly one of a number of possible states` and `where there are well-defined conditional transitions between these states`.
state+transition

```
Transition: ----> 
State: [abc]
Entry Point: o--> 
```

```
                (close)          (lock) 
o-> [Opened] --------->[Closed] --------> [Locked]
           \   (open)  /      \   (unlock) /
             <--------/         <---------/  
```