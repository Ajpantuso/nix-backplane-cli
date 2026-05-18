{
  description = "Backplane CLI (ocm-backplane) packaged as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "0.10.0";

        sources = {
          x86_64-linux = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Linux_x86_64.tar.gz";
            sha256 = "sha256-Y5NyJ5AErvMJ162fYGLHGpQ/haF4fYyfn5wZDretFUM=";
          };
          aarch64-linux = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Linux_arm64.tar.gz";
            sha256 = "sha256-0H1UFnfY/pJSWw80K8W570XPKNJIhtMMKNOSPIvz7NA=";
          };
          x86_64-darwin = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Darwin_x86_64.tar.gz";
            sha256 = "sha256-A7TlLzLqh5zlDozlEd/UkJ93j+TV7/7AHpfO2boCZAk=";
          };
          aarch64-darwin = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Darwin_arm64.tar.gz";
            sha256 = "sha256-lfz06Jt0cjRDVag3nk2eGIoTSuMQDzBg84jMbj3rrbw=";
          };
        };

        source = sources.${system} or (throw "Unsupported system: ${system}");

        ocm-backplane = pkgs.stdenv.mkDerivation {
          pname = "ocm-backplane";
          inherit version;

          src = pkgs.fetchurl {
            inherit (source) url sha256;
          };

          sourceRoot = ".";

          installPhase = ''
            runHook preInstall
            install -D -m755 ocm-backplane $out/bin/ocm-backplane
            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "OpenShift Backplane CLI";
            homepage = "https://github.com/openshift/backplane-cli";
            license = licenses.asl20;
            maintainers = [ ];
            platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
            mainProgram = "ocm-backplane";
          };
        };
      in
      {
        packages = {
          default = ocm-backplane;
          ocm-backplane = ocm-backplane;
        };

        apps = {
          default = {
            type = "app";
            program = "${ocm-backplane}/bin/ocm-backplane";
          };
        };
      }
    );
}
