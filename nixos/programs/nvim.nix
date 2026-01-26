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
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require("bufferline").setup({
            options = {
              mode = "buffers",
              separator_style = "slant",
              show_buffer_close_icons = false,
              show_close_icon = false,
              always_show_bufferline = true,
              offsets = {
                {
                  filetype = "neo-tree",
                  text = "File Explorer",
                  text_align = "center",
                  separator = true
                }
              },
            },
          })

          -- Buffer navigation
          vim.keymap.set('n', '<leader>,', ':BufferLineCyclePrev<CR>', { desc = 'Previous Buffer' })
          vim.keymap.set('n', '<leader>.', ':BufferLineCycleNext<CR>', { desc = 'Next Buffer' })
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
        plugin = lazygit-nvim;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
        '';
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          local wk = require("which-key")

          wk.setup({
            -- Modern LazyVim-style configuration
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

          -- Complete LazyVim-style keymap registration
          wk.add({
            -- ═══════════════════════════════════════════════════════════
            -- Project
            { "<leader>p",  group = "Project" },
            { "<leader>pp", desc = "Find files",                                        },
            { "<leader>pb", desc = "Find buffers",                                      },
            { "<leader>pf", desc = "Find files (cwd)",                                  },
            { "<leader>pF", desc = "Find files (root)",                                 },

            -- ═══════════════════════════════════════════════════════════
            -- Find
            { "<leader>f",  group = "Find" },
            { "<leader>fg", desc = "Live grep",                                         },
            { "<leader>fh", desc = "Help tags",                                         },
            { "<leader>fr", desc = "Resume search",                                     },
            { "<leader>fR", desc = "Recent files",                                      },

            -- ═══════════════════════════════════════════════════════════
            -- Explorer
            { "<leader>e",  desc = "Toggle file explorer",                              },

            -- ═══════════════════════════════════════════════════════════
            -- Git
            { "<leader>g",  group = "Git" },
            { "<leader>gg", desc = "LazyGit",                                           },
            { "<leader>gc", desc = "Commit",                                            },
            { "<leader>gp", desc = "Preview hunk",                                      },
            { "<leader>gs", desc = "Status",                                            },

            -- ═══════════════════════════════════════════════════════════
            -- Code/LSP
            { "<leader>c",  group = "Code" },
            { "<leader>ca", desc = "Code actions",                                      },
            { "<leader>cr", desc = "Rename",                                            },
            { "<leader>cd", desc = "Diagnostics",                                       },

            -- ═══════════════════════════════════════════════════════════
            -- Telescope/Which-key
            { "<leader> ",  desc = "Which-key (all)",                                   },
            
            -- ═══════════════════════════════════════════════════════════
            -- Buffers/Tabs
            { "<leader>b",  group = "Buffers" },
            { "<leader>bb", desc = "Buffer picker",                                     },
            { "<leader>bd", desc = "Delete buffer",                                     },
            { "<leader>,",  desc = "Prev Buffer",                                       },
            { "<leader>.",  desc = "Next Buffer",                                       },
          })
        '';
      }

      # Dependencies for the plugins
      plenary-nvim # Required by telescope
      nvim-web-devicons # Icons for neo-tree and telescope
      nui-nvim # UI components for neo-tree
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
