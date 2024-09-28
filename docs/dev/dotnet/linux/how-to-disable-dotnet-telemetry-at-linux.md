# How to opt out .NET SDK and .NET CLI [telemetry](https://learn.microsoft.com/en-us/dotnet/core/tools/telemetry) at linux

1. Add variable to `/etc/environment` file
```
DOTNET_CLI_TELEMETRY_OPTOUT=1
```

2. Log Out