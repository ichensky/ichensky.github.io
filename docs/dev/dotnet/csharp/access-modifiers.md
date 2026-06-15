# Access modifiers C#

Access modifiers are keywords used to specify the accessibility of types and type members. 

- `public`: The type or member is accessible from any other code.
- `private`: The type or member is accessible only within its own class or struct.
- `protected`: The type or member is accessible within its own class and by derived class instances.
- `internal`: The type or member is accessible within the same assembly, but not from another assembly.
- `protected internal`: The type or member is accessible within its own assembly or from derived classes in another assembly. (*union* of `protected` and `internal`)
- `private protected`: The type or member is accessible within its own class and by derived class instances that are in the same assembly.(*intersection* of `protected` and `internal`)
- `file`: The type or member is accessible only `within the same source file`.