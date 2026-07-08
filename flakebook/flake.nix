{
  description = "Flake wrapper around ../basic's classic NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    {
      # `nixos-rebuild switch --flake /path/to/flakebook#gobook`
      # (basic/hardware-configuration.nix must exist -- generate it with
      # `nixos-generate-config` on the target machine, same as before.)
      nixosConfigurations.gobook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ../basic/configuration.nix
        ];
      };
    };
}
