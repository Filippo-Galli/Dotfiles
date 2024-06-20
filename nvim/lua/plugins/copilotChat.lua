return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },

    -- default prompts
    prompts = {
      Explain = {
        prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
      },
      Review = {
        prompt = "/COPILOT_REVIEW Review the selected code.",
        callback = function(response, source)
          local ns = vim.api.nvim_create_namespace("copilot_review")
          local diagnostics = {}
          for line in response:gmatch("[^\r\n]+") do
            if line:find("^line=") then
              local start_line = nil
              local end_line = nil
              local message = nil
              local single_match, message_match = line:match("^line=(%d+): (.*)$")
              if not single_match then
                local start_match, end_match, m_message_match = line:match("^line=(%d+)-(%d+): (.*)$")
                if start_match and end_match then
                  start_line = tonumber(start_match)
                  end_line = tonumber(end_match)
                  message = m_message_match
                end
              else
                start_line = tonumber(single_match)
                end_line = start_line
                message = message_match
              end

              if start_line and end_line then
                table.insert(diagnostics, {
                  lnum = start_line - 1,
                  end_lnum = end_line - 1,
                  col = 0,
                  message = message,
                  severity = vim.diagnostic.severity.WARN,
                  source = "Copilot Review",
                })
              end
            end
          end
          vim.diagnostic.set(ns, source.bufnr, diagnostics)
        end,
      },
      Fix = {
        prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
      },
      Optimize = {
        prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readablilty.",
      },
      Docs = {
        prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
      },
      Tests = {
        prompt = "/COPILOT_GENERATE Please generate tests for my code.",
      },
    },

    -- default window options
    window = {
      layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
      width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
      height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
      -- Options below only apply to floating windows
      relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
      border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
      row = nil, -- row position of the window, default is centered
      col = nil, -- column position of the window, default is centered
      title = "Copilot Chat", -- title of chat window
      footer = nil, -- footer of chat window
      zindex = 1, -- determines if window is on top or below other floating windows
    },

    -- default mappings (in tables first is normal mode, second is insert mode)
    mappings = {
      complete = {
        detail = "Use @<Tab> or /<Tab> for options.",
        insert = "<Tab>",
      },
      close = {
        normal = "q",
        insert = "<C-c>",
      },
      reset = {
        normal = "<C-l>",
        insert = "<C-l>",
      },
      submit_prompt = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      accept_diff = {
        normal = "<C-y>",
        insert = "<C-y>",
      },
      yank_diff = {
        normal = "gy",
      },
      show_diff = {
        normal = "gd",
      },
      show_system_prompt = {
        normal = "gp",
      },
      show_user_selection = {
        normal = "gs",
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
