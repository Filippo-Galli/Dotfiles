return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  },

  "zbirenbaum/copilot-cmp",
  config = function()
    require("copilot_cmp").setup()
  end,
}
