
# Development Container Features

<table style="width: 100%; border-style: none;"><tr>
<td style="width: 140px; text-align: center;"><a href="https://github.com/devcontainers"><img width="128px" src="https://raw.githubusercontent.com/microsoft/fluentui-system-icons/78c9587b995299d5bfc007a0077773556ecb0994/assets/Cube/SVG/ic_fluent_cube_32_filled.svg" alt="devcontainers organization logo"/></a></td>
<td>
<strong>Development Container 'Features'</strong><br />
<i>A set of simple and reusable Features. Quickly add a language/tool/CLI to a development container.
</td>
</tr></table>

'Features' are self-contained units of installation code and development container configuration. Features are designed
to install atop a wide-range of base container images (**this repo focuses on `debian` based images**).

> This repo follows the [dev container feature distribution specification](https://containers.dev/implementors/features-distribution/).

**List of features:**

- [MsQuic](src/msquic/README.md): Install the MsQuic library, a [Microsoft implementation](https://github.com/microsoft/msquic) of the IETF QUIC protocol into your Devcontainer. This library is a requirement for [using HTTP/3 with ASP.NET Core Kestrel web server](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel/http3?view=aspnetcore-7.0).

## Usage

To reference a feature from this repository, add the desired features to a `devcontainer.json`. Each feature has a README.md that shows how to reference the feature and which options are available for that feature.

The example below installs the `MsQuic` feature declared in the `./src` directory of this repository.

> See the relevant feature's README for supported options.

```jsonc
{
    "name": "my-project-devcontainer",
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",  // Any generic, debian-based image.
    "features": {
        "ghcr.io/tlc-sundown/devcontainers-features/msquic": {
            "version": "1.9.1"
        }
    }
}
```

The `:latest` version annotation is added implicitly if omitted. To pin to a specific package version
([example](https://github.com/tlc-sundown/devcontainers-features/pkgs/container/features/msquic/versions)), append it to the end of the
Feature. Features follow semantic versioning conventions, so you can pin to a major version `:1`, minor version `:1.0`, or patch version `:1.0.0` by specifying the appropriate label.

```jsonc
"features": {
    "ghcr.io/tlc-sundown/devcontainers-features/msquic:1.0.0": {
        "version": "1.9.1"
    }
}
```
