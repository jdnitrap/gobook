{
  description = "gobook - NixOS configurations and tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # AINIX package
        packages.ainix = pkgs.callPackage ./ainix/ainix-package.nix { };

        # Default package
        packages.default = self.packages.${system}.ainix;

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            python3.pkgs.pip
            git
          ];

          shellHook = ''
            echo "🚀 gobook development environment"
            echo "Available commands:"
            echo "  - python3 ainix/ainix.py 'query'      (run AINIX)"
            echo "  - python3 ainix/tests/test_*.py       (run tests)"
          '';
        };

        # Apps for easy running
        apps.ainix = {
          type = "app";
          program = "${self.packages.${system}.ainix}/bin/ainix";
        };

        apps.default = self.apps.${system}.ainix;
      }
    ) // {
      # NixOS modules
      nixosModules.ainix = import ./ainix/ainix-nixos-module.nix;
      nixosModules.default = self.nixosModules.ainix;

      # Home-manager module (optional)
      homeManagerModules.ainix = { config, lib, pkgs, ... }: {
        options.programs.ainix = {
          enable = lib.mkEnableOption "AINIX - AI-Native NixOS Integration";
          package = lib.mkOption {
            type = lib.types.package;
            default = self.packages.${pkgs.system}.ainix;
            description = "AINIX package to use";
          };
        };

        config = lib.mkIf config.programs.ainix.enable {
          home.packages = [ config.programs.ainix.package ];

          home.shellAliases = {
            ainix = "${config.programs.ainix.package}/bin/ainix";
          };
        };
      };
    };
}
