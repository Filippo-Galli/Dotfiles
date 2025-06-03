{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # Make sure nixvim uses the same nixpkgs version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.49.0";
  };

  outputs = inputs@{self, nixpkgs, home-manager, hyprland, ... }: {
    nixosConfigurations = {
     nixos = let
        username = "filippo";
        specialArgs = {
          inherit username;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
	      home-manager.backupFileExtension = "bak";

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./home.nix;
            }
          ];
        };
    };
  };
}
