{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
    ];

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      lualine-nvim
      telescope-nvim
      neo-tree-nvim
      bufferline-nvim
      telescope-fzf-native-nvim
      lazygit-nvim
      which-key-nvim
      plenary-nvim
      nvim-web-devicons
      nui-nvim
    ];

    initLua = ''
      require("catppuccin").setup()
      vim.cmd.colorscheme "catppuccin"

      require('lualine').setup()

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
      vim.keymap.set('n', '<leader>pp', require('telescope.builtin').find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>pb', require('telescope.builtin').buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help tags' })

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
          follow_current_file = { enabled = true },
        },
      })
      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })

      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          offsets = {{
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true
          }},
        },
      })
      vim.keymap.set('n', '<leader>,', ':BufferLineCyclePrev<CR>', { desc = 'Previous Buffer' })
      vim.keymap.set('n', '<leader>.', ':BufferLineCycleNext<CR>', { desc = 'Next Buffer' })

      require('telescope').load_extension('fzf')

      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })

      local wk = require("which-key")
      wk.setup({
        defaults = {
          window = {
            border = "single",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 2, 2, 2, 2 },
          },
          layout = {
            height = { min = 4, max = 25 },
            width = { min = 20, max = 50 },
            spacing = 3,
            align = "left",
          },
        },
      })
      wk.add({
        { "<leader>p",  group = "Project" },
        { "<leader>pp", desc = "Find files" },
        { "<leader>pb", desc = "Find buffers" },
        { "<leader>f",  group = "Find" },
        { "<leader>fg", desc = "Live grep" },
        { "<leader>fh", desc = "Help tags" },
        { "<leader>e",  desc = "Toggle file explorer" },
        { "<leader>g",  group = "Git" },
        { "<leader>gg", desc = "LazyGit" },
        { "<leader>c",  group = "Code" },
        { "<leader>ca", desc = "Code actions" },
        { "<leader>cr", desc = "Rename" },
        { "<leader> ",  desc = "Which-key (all)" },
        { "<leader>b",  group = "Buffers" },
        { "<leader>,",  desc = "Prev Buffer" },
        { "<leader>.",  desc = "Next Buffer" },
      })
    '';

    extraConfig = ''
      set number
      set relativenumber
      set shiftwidth=2
      let mapleader = " "
      set clipboard=unnamedplus
      set ignorecase
      set smartcase
      set hlsearch
      set incsearch
    '';
  };
}
