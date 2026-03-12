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
      test-build = "sudo nixos-rebuild test --flake ~/Documents/Dotfiles/nixos#nixos";
      rebuild = "sudo nixos-rebuild switch --flake ~/Documents/Dotfiles/nixos#nixos";
      vpn_up = "sudo openconnect --background --protocol=anyconnect --user=figalli vpn-01-dc1.inria.fr";
      rcat = "cat";
      term = "kitty";
      "..." = "cd ../..";
    };

    extraConfig = ''
      $env.config.show_banner = false
      $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default []) ++ [{
        once: true
        code: { print $"Nushell startup time: ($nu.startup-time)" }
      }]


      def update [] {
        pushd ~/Documents/Dotfiles/nixos
        sudo nix flake update
        sudo nixos-rebuild switch --upgrade
        popd
      }

      def vpn_down [] {
        sudo pkill -SIGINT openconnect
        if $env.LAST_EXIT_CODE != 0 { print "No openconnect process found" }
      }

      def vpn_status [] {
        if (pgrep -x openconnect | length) > 0 { 'VPN connected' } else { 'VPN disconnected' }
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
