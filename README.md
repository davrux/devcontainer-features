# Some Devcontainer Features

## Contents

This repository contains a _collection_ of Features. 

### buf

Installs buf:

```jsonc
{
    "features": {
        "ghcr.io/davrux/devcontainer-features/buf:1": {
            "version": "latest"
        }
    }
}
```

### earthly

Installs earthly:

```jsonc
{
    "features": {
        "ghcr.io/davrux/devcontainer-features/earthly:1": {
            "version": "latest"
        }
    }
}
```

### grpcui

Installs grpcui:

```jsonc
{
    "features": {
        "ghcr.io/davrux/devcontainer-features/grpcui:1": {
            "version": "latest"
        }
    }
}
```


## Tests

```sh
devcontainer features test
devcontainer features test --features buf
devcontainer features test --features earthly
devcontainer features test --features grpcui
```

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in a Feature's
`devcontainer-feature.json`. Features are versioned according to the semver
specification. More details can be found in [the dev container Feature
specification](https://containers.dev/implementors/features/#versioning).

