{pkgs, config, nixvim, ...}:

{
  imports = [
    ./vscode.nix
    ./obsidian.nix
    ./brave.nix
    ./direnv.nix
    ./nixvim.nix
    ./nextcloud-client.nix
    ./kwallet.nix 
    ./onlyoffice.nix
  ];
}
