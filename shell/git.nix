{ pkgs, ...}:
{  
  home.packages = [pkgs.gh];
  
  programs.git = {
    settings.user = {
      name = "Filippo-Galli";
      email = "filippo.galli.cr@gmail.com";
    };
    enable = true;
    lfs.enable = true;
  };

  

  programs.gh = {
    enable = true; 
    gitCredentialHelper = {
      enable = true;
    };
  };
}

