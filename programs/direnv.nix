{ config, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    
    # Configure shell integration
    enableZshIntegration = true;
  };
}
