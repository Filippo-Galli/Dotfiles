{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName  = "Filippo-Galli";
    userEmail = "filippo.galli.cr@gmail.com";
    lfs.enable = true;
  };

  programs.gh = {
    enable = true; 
    gitCredentialHelper = {
      enable = true;
    };
  };
}
