{pkgs, config, ...}:

{
  imports = [
    ./vscode.nix
    ./obsidian.nix
    ./brave.nix
    ./direnv.nix
    ./nvim.nix
    ./nextcloud-client.nix
    ./kwallet.nix 
    ./onlyoffice.nix
    ./zotero.nix
    ./firefox.nix
  ];
}
