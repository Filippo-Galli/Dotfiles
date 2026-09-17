{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.nixpkgs-master.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zotero
  ];
}
