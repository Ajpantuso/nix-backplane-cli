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
        version = "0.10.2";

        sources = {
          x86_64-linux = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Linux_x86_64.tar.gz";
            sha256 = "sha256-T1FzYTJAlWRoKRuHvjALjPT3xTrftzTkL9cbr162pBI=";
          };
          aarch64-linux = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Linux_arm64.tar.gz";
            sha256 = "sha256-QYOzm1BYKBRktNbvOgwWftQiWguVZQv5eQJ4uRXX3Gw=";
          };
          x86_64-darwin = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Darwin_x86_64.tar.gz";
            sha256 = "sha256-ETu3HiCpH4qUvuUGiUF3DidDAbATQupgRoNgiVByi7E=";
          };
          aarch64-darwin = {
            url = "https://github.com/openshift/backplane-cli/releases/download/v${version}/ocm-backplane_${version}_Darwin_arm64.tar.gz";
            sha256 = "sha256-s5AmkOBX8dK/PLMnQCrXcgAv12kthwJdP9KpVVO/ROk=";
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
