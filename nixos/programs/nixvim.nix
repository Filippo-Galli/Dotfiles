{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    
    plugins = with pkgs.vimPlugins; [
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = ''
          require("catppuccin").setup()
          vim.cmd.colorscheme "catppuccin"
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup()
        '';
      }
    ];
    
    extraConfig = ''
      set number
      set relativenumber
      set shiftwidth=2
      
    '';
  };
}
