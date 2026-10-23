{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      mkHost = { hostname, system ? "x86_64-linux", username }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname username; };
          modules = [
            ./modules/common.nix
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs hostname username; };
              home-manager.users.${username} = import ./home/${username}.nix;
            }
          ];
        };
    in {
      nixosConfigurations = {
        laptop = mkHost { hostname = "laptop"; username = "eostendarp"; };
        # server = mkHost { hostname = "server"; system = "aarch64-linux"; username = "eostendarp"; };
      };
    };
}
