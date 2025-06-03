{
  pkgs,
  ...
}:{  
  home.packages = [pkgs.gh];
  
  programs.git = {
    enable = true;
    userName = "Filippo-Galli";
    userEmail = "filippo.galli.cr@gmail.com";
  };
}

