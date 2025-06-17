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
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require('telescope').setup({
            defaults = {
              mappings = {
                i = {
                  ["<C-u>"] = false,
                  ["<C-d>"] = false,
                },
              },
            },
          })
          
          -- Telescope keymaps
          vim.keymap.set('n', '<leader>pp', require('telescope.builtin').find_files, { desc = 'Find files' })
          vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Live grep' })
          vim.keymap.set('n', '<leader>pb', require('telescope.builtin').buffers, { desc = 'Find buffers' })
          vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help tags' })
        '';
      }
      {
        plugin = neo-tree-nvim;
        type = "lua";
        config = ''
          require("neo-tree").setup({
            close_if_last_window = false,
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            filesystem = {
              filtered_items = {
                visible = false,
                hide_dotfiles = true,
                hide_gitignored = true,
              },
              follow_current_file = {
                enabled = true,
              },
            },
          })
          
          -- Neo-tree keymap
          vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
        '';
      }
      {
        plugin = telescope-fzf-native-nvim;
        type = "lua";
        config = ''
          require('telescope').load_extension('fzf')
        '';
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          require("which-key").setup({
            -- Modern which-key configuration
          })
          
          -- Register key mappings with descriptions using the new API
          require("which-key").add({
            { "<leader>p", group = "Project" },
            { "<leader>pp", desc = "Find files" },
            { "<leader>pb", desc = "Find buffers" },
            { "<leader>f", group = "Find" },
            { "<leader>fg", desc = "Live grep" },
            { "<leader>fh", desc = "Help tags" },
            { "<leader>e", desc = "Toggle file explorer" },
          })
        '';
      }
      
      # Dependencies for the plugins
      plenary-nvim  # Required by telescope
      nvim-web-devicons  # Icons for neo-tree and telescope
      nui-nvim  # UI components for neo-tree
    ];
    
    extraConfig = ''
      set number
      set relativenumber
      set shiftwidth=2
      
      " Set leader key
      let mapleader = " "
      
      " Enable system clipboard
      set clipboard=unnamedplus
      
      " Additional useful settings
      set ignorecase
      set smartcase
      set hlsearch
      set incsearch
    '';
  };
}