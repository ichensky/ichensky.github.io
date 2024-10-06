# How to debug CoreCLR in 2024 with Visual Studio 2022 

This instruction covers questions: 
- How to build current version of `.NET runtime` (.net 10)
- How to create C# application with `.net`.
- How to debug `CoreCLR` with `Visual Studio 2022`

Current `main` branch contains `.net10.0` version.

Instruction is based on the [debugging-runtime](https://github.com/dotnet/runtime/blob/main/docs/workflow/debugging/coreclr/debugging-runtime.md#using-visual-studio) note.


### 1. Clone repository 
```sh
git clone https://github.com/dotnet/runtime
```

### 2. Build project
```cmd
./build.cmd
```

This command will build all components of the project and create a new directory named `artifacts` at the root level. This directory will contain the compiled DLLs, EXE files, and other runtime files necessary for the application.

```sh
 /c/proj/dotnet/runtime (main)
$ ls -la artifacts/
total 308
drwxr-xr-x 1 Ivan 197121 0 Oct  6 03:11 ./
drwxr-xr-x 1 Ivan 197121 0 Oct  6 02:47 ../
drwxr-xr-x 1 Ivan 197121 0 Oct  6 03:20 bin/
drwxr-xr-x 1 Ivan 197121 0 Oct  6 02:47 log/
drwxr-xr-x 1 Ivan 197121 0 Oct  6 02:47 mibc/
drwxr-xr-x 1 Ivan 197121 0 Oct  6 03:08 obj/
drwxr-xr-x 1 Ivan 197121 0 Oct  6 02:57 packages/
drwxr-xr-x 1 Ivan 197121 0 Oct  6 03:11 tests/
drwxr-xr-x 1 Ivan 197121 0 Oct  6 02:47 tmp/
drwxr-xr-x 1 Ivan 197121 0 Oct  6 02:56 toolset/
```

### 3. Create a `HelloWorld` application using the `.NET 10.0` runtime.

Create directory `src/samples/HelloWorld` with project files

```sh
mkdir src/samples/HelloWorld
```

`HelloWorld.csproj` 
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>$(NetCoreAppCurrent)</TargetFramework>
    <AllowUnsafeBlocks>true</AllowUnsafeBlocks>
    <Nullable>enable</Nullable>
    <TreatWarningsAsErrors>false</TreatWarningsAsErrors>
  </PropertyGroup>
</Project>
```
`Program.cs` 
```csharp
using System;

Console.WriteLine("Hello world");
Console.ReadLine();
```

If open project `HelloWorld.csproj` in `Visual Studio` it should have a reference to the `.net core 10` 
```txt
+HelloWorld
+-Dependencies
 +-Frameworks
  +-Microsoft.NETCore
```
In `Properties` `Microsoft.NETCore` will have `Path`: `...\runtime\artifacts\bin\microsoft.netcore.app.ref`

### 4. Build `HelloWorlds` application
After the applicaiton is built, executables will appear in directory:
`...\artifacts\bin\HelloWorld\Debug\net10.0`

### 5. Start Visual Studio project with CoreCLR
```
./build.cmd -vs coreclr.sln 
```

### 6. Right-click the `INSTALL` project and choose Set as `StartUp Project`.

### 7. Bring up the properties page for the `INSTALL` project.

### 8. Select `Configuration Properties -> Debugging` from the left side tree control.

#### Set `.NET Core runtime host` path
```sh
Command=$(SolutionDir)\..\..\..\..\bin\coreclr\windows.$(Platform).$(Configuration)\corerun.exe
```

### 9. Set application to debug
```sh
Command Arguments=C:\proj\dotnet\runtime\artifacts\bin\HelloWorld\Debug\net10.0\HelloWorld.dll
```

### 10. Set core libraries path
```sh
Environment=CORE_LIBRARIES=$(SolutionDir)\..\..\..\..\bin\runtime\net10.0-windows-$(Configuration)-$(Platform)
```

### 11. Right-click the `INSTALL` project and choose `Build`. This will load necessary information from CMake to Visual Studio.

### 12 Re-build CRL
```sh
./build.cmd +clr
```

### 13. Press `F11` to start debugging at wmain in corerun, or set a breakpoint in source and press `F5` to run to it. As an example, set a breakpoint for the `EEStartup()` function in ceemain.cpp to break into CoreCLR startup.