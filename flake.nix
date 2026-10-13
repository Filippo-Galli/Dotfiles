{
  description = "NixOS configuration for multiple hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    nirimon = {
      url = "github:stepbrobd/nirimon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.56.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
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
            inputs.disko.nixosModules.disko
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

        # --- Appa Server ---
        appa = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username inputs stateVersion; };
          modules = shared-modules ++ [
            inputs.disko.nixosModules.disko
            ./hosts/appa/disko.nix
            ./hosts/appa/configuration.nix
            {
              home-manager.users.${username} = import ./hosts/appa/home.nix;
            }
          ];
        };

        # --- Vaultwarden LXC ---
        service-vaultwarden = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username inputs stateVersion; };
          modules = [
            ./hosts/service-vaultwarden/configuration.nix
          ];
        };
      };
    };
}
