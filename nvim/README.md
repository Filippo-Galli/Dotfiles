# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Installation
- Do a backup of your nvim dotfiles using: 
```Bash
mv .config/nvim .config/nvim.bak
```

- Clone this repo wherever you want
- link local repo to your config: 
```Bash
cd; cd .config; ln -s path/where/you/cloned/this/repo/nvim .
```

## Theme

### catpuccin.lua

It's a plugin to use the catpuccino theme. I use the `dark_catppuccino` theme.

### cyberdream.lua
It's a plugin to use the cyberdream theme. I use the `dark_cyberdream` theme.
Refer to the [documentation](https://github.com/scottmckendry/cyberdream.nvim)

### gruvbox.lua

It's a plugin to use the gruvbox theme. I use the `dark` theme.

## Functionalities

### cmp.lua

It's a plugin for autocompletion, it's very fast and easy to use. You can use it with LSP, snippets and more.
The configuration is the default one.

### copilot.lua

It's the plugin to use Copilot. In this way you have the suggestion made by Copilot directly in your editor.

### dashboard.lua

It is a plugin to have a dashboard when you open your editor. You can see the recent files, the projects and more.

### lazygit.lua

It's a plugin to use lazygit directly in your editor. You can open it with `:LazyGit`.
Refer to the [Lazygit](https://github.com/jesseduffield/lazygit) and to the plugin as [Plugin Page](https://github.com/kdheepak/lazygit.nvim)
### mason.lua

It's a plugin to use Mason directly in your editor. You can open it with `:Mason`.

### neo-tree.lua
Neo-tree is a file explorer. You can open it with `:NvimTreeToggle`. I set the option to always show hidden files. 

### telescope.lua

It's a plugin to use Telescope. It's a fuzzy finder, you can search for files, buffers, git files and more.

## Useful keybindings

<leader> is the leader key, by default is the space key.

- e: open the file explorer
- <space> or ff: find files
- ,: switch between open buffers (tabs)
- /: search in files (cwd)
- gg: open lazygit
- st: search TODOs
 

