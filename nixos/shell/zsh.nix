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
      rebuild = "sudo nixos-rebuild switch";
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
    ";
    
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
          sha256 = "1b4pksrc573aklk71dn2zikiymsvq19bgvamrdffpf7azpq6kxl2";
        };
      }

    ];
  };

}
