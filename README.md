# nix-backplane-cli

A Nix flake for the [OpenShift backplane CLI](https://github.com/openshift/backplane-cli), distributed as `ocm-backplane`.

This package can be automatically updated when upstream releases a new version.

## Installation

### Quick Run

Try `ocm-backplane` without installing:

```bash
nix run github:Ajpantuso/nix-backplane-cli -- version
```

### Install in Current Shell

```bash
nix shell github:Ajpantuso/nix-backplane-cli
ocm-backplane version
```

### Add to a Flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-backplane-cli.url = "github:Ajpantuso/nix-backplane-cli";
  };

  outputs = { self, nixpkgs, nix-backplane-cli, ... }: {
    # Use nix-backplane-cli.packages.${system}.ocm-backplane
  };
}
```

### Install to User Profile

```bash
nix profile install github:Ajpantuso/nix-backplane-cli
```

## Development

### Build Locally

```bash
nix build .#ocm-backplane
./result/bin/ocm-backplane version
```

### Validate Flake

```bash
nix flake check
```

### Run Tests

```bash
./scripts/test-package.sh
```

## Manual Updates

1. Compute hashes for a new release:

   ```bash
   ./scripts/compute-hashes.sh v0.8.0
   ```

2. Update `flake.nix` with the new version and hashes.
3. Regenerate `flake.lock`:

   ```bash
   nix flake lock
   ```

4. Validate and test:

   ```bash
   nix flake check
   ./scripts/test-package.sh
   ```

## Auto-Update Workflow

The update workflow:

- runs daily at 2 AM UTC
- can be manually triggered
- checks for new `openshift/backplane-cli` releases
- computes hashes for all supported platforms
- validates the flake and package
- creates a pull request with updates

Supported platforms:

- x86_64-linux
- aarch64-linux
- x86_64-darwin
- aarch64-darwin

## License

This repository is released into the public domain under the [UNLICENSE](UNLICENSE).
