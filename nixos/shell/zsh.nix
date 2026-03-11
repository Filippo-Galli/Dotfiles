{config, lib, pkgs, ...}:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    
    shellAliases = {
      ls = "eza -lha";
      update = "cd ~/Documents/Dotfiles/nixos; sudo nix flake update && sudo nixos-rebuild switch --upgrade";
      rebuild = "sudo nixos-rebuild switch --flake ~/Documents/Dotfiles/nixos#nixos";
      vpn_up = "sudo openconnect --background --protocol=anyconnect --user=figalli vpn-01-dc1.inria.fr";
      vpn_status = "pgrep -x openconnect >/dev/null && echo 'VPN connected' || echo 'VPN disconnected'";
      vpn_down = "sudo pkill -SIGINT openconnect 2>/dev/null || echo 'No openconnect process found'";

      rcat = "cat";
      ".." = "cd ..";
      "..." = "cd ../..";
      term = "kitty";
    };

    initContent = "
      # Keybindings
      bindkey '^[[A' history-beginning-search-backward # Up arrow
      bindkey '^[[B' history-beginning-search-forward  # Down arrow
      
      # Completion styling
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

      # fzf 
      eval \"$(fzf --zsh)\"

      # Enable nushell as the default shell within zsh
      exec nu --login
    ";
  };

}
