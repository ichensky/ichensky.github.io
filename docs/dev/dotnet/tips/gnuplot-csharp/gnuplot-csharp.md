# `gnuplot` C# example of using

```csharp
using System.Diagnostics;

// Start first gnuplot window
var window0 = new GnuPlotWrapper();
window0.Start();

await window0.ExecuteAsync(@" plot sin(x) ".AsMemory());

// Start second gnuplot window 
var window1 = new GnuPlotWrapper();
window1.Start();

await window1.ExecuteAsync(@"plot '-' with lines ".AsMemory());
await window1.ExecuteAsync("0 0".AsMemory());
await window1.ExecuteAsync("1 1".AsMemory());
await window1.ExecuteAsync("2 0".AsMemory());
await window1.ExecuteAsync("e".AsMemory());

// Keep windows open for 10 seconds
await Task.Delay(10_000);

window0.Close();
window1.Close();


public class GnuPlotWrapper : IDisposable 
{
    private const string GnuPlotExecutable = "gnuplot";

    private bool disposed = false;

    private Process? process;

    public void Start()
    {
        var processStartInfo = CreateProcessStartInfo();
        process = StartProcess(processStartInfo);
    }

    public async Task ExecuteAsync(ReadOnlyMemory<char> script, CancellationToken cancellationToken = default)
    {
        await process!.StandardInput.WriteLineAsync(script, cancellationToken).ConfigureAwait(false);
        await process.StandardInput.FlushAsync(cancellationToken: cancellationToken).ConfigureAwait(false);
    }

    private static Process StartProcess(ProcessStartInfo startInfo)
    {
        var process = new Process
        {
            StartInfo = startInfo
        };

        process.Start();
        process.StandardInput.AutoFlush = false;

        return process;
    }

    private static ProcessStartInfo CreateProcessStartInfo()
    {
        return new ProcessStartInfo
        {
            FileName = GnuPlotExecutable,
            Arguments = "-",
            RedirectStandardInput = true,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            UseShellExecute = false,
            CreateNoWindow = true
        };
    }

    public Task WaitForExitAsync(CancellationToken cancellationToken = default) => process?.WaitForExitAsync(cancellationToken) ?? Task.CompletedTask;

    public void Close() => Dispose();

    public void Dispose()
    {
        Dispose(true);

        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (disposed)
        {
            return;
        }

        if (disposing)
        {
            // Dispose managed state (managed objects).
            process?.Dispose();
        }

        // Free unmanaged resources.

        disposed = true;
    }
}


```