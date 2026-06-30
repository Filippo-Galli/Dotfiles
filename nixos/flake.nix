{
  description = "NixOS configuration for multiple hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sunsetr.url = "github:psi4j/sunsetr/v0.12.2";
    nirimon.url = "github:stepbrobd/nirimon";
    brave-origin.url = "github:Daniel-42-z/brave-origin-flake";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.55.2";
    flake-utils.url = "github:numtide/flake-utils";
    ghgrab.url = "github:abhixdd/ghgrab";

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      username = "filippo";
      system = "x86_64-linux";
      stateVersion = "26.05";

      shared-modules = [
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs {
                system = final.stdenv.hostPlatform.system;
                config.allowUnfree = true;
              };
            })
            inputs.niri.overlays.niri
          ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit username inputs stateVersion; };
        }
      ];
    in
    {
      nixosConfigurations = {

        # --- Lenovo Yoga Slim 7 Pro 14IAH7  ---
        escanor = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username inputs stateVersion; };
          modules = shared-modules ++ [
            inputs.niri.nixosModules.niri
            ./hosts/escanor/configuration.nix
            {
              home-manager.users.${username} = import ./hosts/escanor/home.nix;
            }
          ];
        };

        # --- Dell Pro Max 14 MC14250 ---
        gyomei = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username inputs stateVersion; };
          modules = shared-modules ++ [
            inputs.niri.nixosModules.niri
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
          specialArgs = { inherit username inputs stateVersion; };
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
