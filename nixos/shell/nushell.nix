{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh.initContent = lib.mkOrder 9999 ''
    if [[ $- == *i* && -z "$__NU_LAUNCHED" ]] && command -v nu > /dev/null; then
        export __NU_LAUNCHED=1
        LOGIN_OPT=""
        if [ -n "$BASH_VERSION" ] && shopt -q login_shell; then
            LOGIN_OPT="--login"
        elif [ -n "$ZSH_VERSION" ] && [[ -o login ]]; then
            LOGIN_OPT="--login"
        fi
        exec nu $LOGIN_OPT
    fi
  '';

  programs.nushell = {
    enable = true;

    shellAliases = {
      test-build = "sudo nixos-rebuild test --flake ~/Documents/Dotfiles/nixos#nixos";
      rebuild = "sudo nixos-rebuild switch --flake ~/Documents/Dotfiles/nixos#nixos";
      vpn_up = "sudo openconnect --background --protocol=anyconnect --user=figalli vpn.inria.fr";
      rcat = "cat";
      term = "kitty";
      "..." = "cd ../..";
    };

    extraConfig = ''

      $env.config.show_banner = false

      def ll [] { ls -l }
      def la [] { ls -a }

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
