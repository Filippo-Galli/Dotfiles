{
  description = "NixOS configuration for multiple hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.51.1";
    flake-utils.url = "github:numtide/flake-utils";
    ghgrab.url = "github:abhixdd/ghgrab";

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      stateVersion = "25.11";
      username = "filippo";
      system = "x86_64-linux";

      shared-modules = [
        (
          { config, pkgs, ... }:
          {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  system = final.stdenv.hostPlatform.system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
        )

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit username stateVersion inputs; };
        }
      ];
    in
    {
      nixosConfigurations = {

        # --- Lenovo Yoga Slim 7 Pro 14IAH7  ---
        escanor = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username stateVersion inputs; };
          modules = shared-modules ++ [
            ./hosts/escanor/configuration.nix
            {
              home-manager.users.${username} = import ./hosts/escanor/home.nix;
            }
          ];
        };

        # --- Dell Pro Max 14 MC14250 ---
        gyomei = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username stateVersion inputs; };
          modules = shared-modules ++ [
            inputs.disko.nixosModules.disko
            inputs.lanzaboote.nixosModules.lanzaboote
            ./hosts/gyomei/configuration.nix
            {
              home-manager.users.${username} = import ./hosts/gyomei/home.nix;
            }
          ];
        };

        # --- Oxide Server ---
        oxide_server = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username stateVersion inputs; };
          modules = shared-modules ++ [
            ./hosts/oxide_server/configuration.nix
            {
              home-manager.users.${username} = import ./hosts/oxide_server/home.nix;
            }
          ];
        };
      };
    };
}
