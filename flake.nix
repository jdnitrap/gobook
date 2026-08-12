{
  description = "gobook - NixOS configurations (NixQubes and Basic)";

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
        # Development shell for working with the configs
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            nixfmt-rfc-style
          ];

          shellHook = ''
            echo "gobook development environment"
            echo "Projects:"
            echo "  - nixqubes/  (Qubes-like container security)"
            echo "  - basic/     (modular NixOS configuration)"
          '';
        };
      }
    );
}
