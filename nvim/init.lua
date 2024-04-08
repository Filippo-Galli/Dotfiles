-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd("set termguicolors")
vim.cmd("let g:gruvbox_transparent_bg = 1")
vim.cmd("autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE")
