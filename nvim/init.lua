-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd("set termguicolors")
vim.cmd("let g:gruvbox_transparent_bg = 1")
vim.cmd("autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE")

-- If using python, set tabstop, shiftwidth, and softtabstop to 4
vim.cmd("autocmd FileType python setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4")

-- If using c, set tabstop, shiftwidth, and softtabstop to 4
vim.cmd("autocmd FileType c, h, cpp,hpp setlocal tabstop=4 shiftwidth=4 expandtab")
