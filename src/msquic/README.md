
# msquic (msquic)

A feature to install the MsQuic library

## Example Usage

```json
"features": {
    "ghcr.io/tlc-sundown/devcontainers-features/msquic:1": {
        "version": "latest"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter an MsQuic library version | string | latest |
| verbose | Enable verbose mode during install | boolean | false |

## References

- HTTP/3 with ASP.NET Core - see requirements for [Kestrel web server](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel/http3?view=aspnetcore-7.0).
- QUIC protocol implementation - see [MsQuic on github](https://github.com/microsoft/msquic)
- configuring the Microsoft repository on a Linux system - see [Linux Software Repository for Microsoft Products](https://learn.microsoft.com/en-us/windows-server/administration/linux-package-repository-for-microsoft-software)


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/tlc-sundown/devcontainers-features/blob/main/src/msquic/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
