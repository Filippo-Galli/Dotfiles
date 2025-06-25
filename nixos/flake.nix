{
  description = "NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland.url = "github:hyprwm/Hyprland/v0.49.0";

    # Add for better flake management
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
  let 
    stateVersion = "25.05";
    username = "filippo";
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit username stateVersion;
      };
      
      modules = [
        ./configuration.nix
        
        # Add unstable overlay
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
            users.${username} = import ./home.nix;
            extraSpecialArgs = { 
              inherit username;
              inherit stateVersion; 
            };
          };
        }
      ];
    };
  };
}