# How to disable `dotnet` telemetry at linux

### Note about how to opt out .NET SDK and .NET CLI [telemetry](https://learn.microsoft.com/en-us/dotnet/core/tools/telemetry)

1. Add variable to `/etc/environment` file
```
DOTNET_CLI_TELEMETRY_OPTOUT=1
```

2. Log Out