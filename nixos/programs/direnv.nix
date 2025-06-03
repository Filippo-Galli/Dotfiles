
# Add this to your home.nix file
{ config, pkgs, ... }:

{
  # Your existing configuration...

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    
    # Configure shell integration
    enableZshIntegration = true;   # if you use Zsh
  };
}
