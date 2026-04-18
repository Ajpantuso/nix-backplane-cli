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
        version = "0.8.0";

        sources = {
          x86_64-linux = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Linux_x86_64.tar.gz";
            sha256 = "sha256-CUuYpUGEpz7xvhF//6cCScb8R2KDOWJI78A5Izcq7tg=";
          };
          aarch64-linux = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Linux_arm64.tar.gz";
            sha256 = "sha256-fsQ8lZo5e1vtQqWNokfSOVVc8ggAP+NNkpM/WCgf2YQ=";
          };
          x86_64-darwin = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Darwin_x86_64.tar.gz";
            sha256 = "sha256-63Doz+5qpF8ytVOjLguQvtPWwVf2srL9YIJzsKPrHME=";
          };
          aarch64-darwin = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Darwin_arm64.tar.gz";
            sha256 = "sha256-Cb8YIsZZoGS+PaPQRoJdBWL6Zw+EYP5yB+3Rl3pmTH0=";
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
