{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.nushell = {
    enable = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";
      vpn_up = "sudo openconnect --background --protocol=anyconnect --user=figalli vpn-01-dc1.inria.fr";
      vpn_status = "pgrep -x openconnect | complete | if ($in.exit_code == 0) { 'VPN connected' } else { 'VPN disconnected' }";
      rcat = "cat";
      term = "kitty";
      "..." = "cd ../..";
    };

    extraConfig = ''
      def update [] {
        cd ~/Documents/Dotfiles/nixos
        sudo nix flake update
        sudo nixos-rebuild switch --upgrade
      }

      def vpn_down [] {
        sudo pkill -SIGINT openconnect
        if $env.LAST_EXIT_CODE != 0 { print "No openconnect process found" }
      }
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
    BRAVE_PASSWORD_STORE = "gnome-libsecret";
    SECRET_TOOL_BACKEND = "gnome";
  };

  # fzf still works with nushell
  programs.fzf.enable = true;
}
