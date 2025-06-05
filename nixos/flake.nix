{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland.url = "github:hyprwm/Hyprland/v0.49.0";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { username = "filippo"; };
      
      modules = [
        ./configuration.nix
        
        # Add unstable overlay to be specified for each package
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [ 
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = final.system;
                config.allowUnfree = true;
              };
            })
          ];
        })
        
        # Home Manager configuration
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            users.filippo = import ./home.nix;
          };
        }
      ];
    };
  };
}