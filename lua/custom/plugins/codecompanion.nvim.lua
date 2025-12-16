return {
  'olimorris/codecompanion.nvim',
  version = 'v18.1.1',
  -- lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    opts = {
      log_level = 'WARN', -- TRACE|DEBUG|ERROR|INFO
      language = 'English',
    },

    strategies = {
      chat = {
        adapter = 'gemini',
        model = 'gemini-2.5-pro',
        slash_commands = {
          ['file'] = { opts = { provider = 'snacks' } },
        },
        tools = {
          opts = {
            auto_submit_errors = true,
            auto_submit_success = true,
          },
          ['buffer'] = {
            opts = {
              default_params = 'watch',
            },
          },
          ['cmd_runner'] = {
            opts = {
              provider = 'snacks',
              requires_approval = true,
            },
          },
        },
      },
      inline = {
        adapter = 'gemini',
        model = 'gemini-2.5-flash',
      },
    },
    display = {
      action_palette = { provider = 'snacks' }, -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
      chat = {
        intro_message = '✨CodeCompanion✨ ? for Opts',
        icons = {
          pinned_buffer = ' ',
          watched_buffer = '👀 ',
        },
        show_header_separator = false,
        show_settings = false,
        start_in_insert_mode = false,
        show_token_count = true, -- Show the token count for each response?
        auto_scroll = false,
      },
    },
    prompt_library = {
      ['Document'] = {
        strategy = 'chat',
        description = 'Document visual block of code',
        opts = {
          mapping = '<LocalLeader>aD',
          modes = { 'v' },
          short_name = 'Document',
          auto_submit = true,
          stop_context_insertion = false,
        },
        prompts = {
          {
            role = 'system',
            content = function(context)
              return 'You are an experienced '
                .. context.filetype
                .. ' engineer. You have experience on writing documentation and will be asked to write documentation.'
            end,
          },
          {
            role = 'user',
            content = function(context)
              local visual = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
              return '@{insert_edit_into_file} write documentation for the following code in the #{buffer} , do not include an example:\n\n```'
                .. context.filetype
                .. '\n'
                .. visual
                .. '\n```\n'
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ['Explain'] = {
        strategy = 'chat',
        description = 'Explain the code in the file type',
        opts = {
          mapping = '<LocalLeader>aE',
          modes = { 'v' },
          short_name = 'Explain',
          auto_submit = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = 'system',
            content = function(context)
              return 'You are an experienced '
                .. context.filetype
                .. ' engineer. I will ask you specific question and I want you to return concise explanations, codeblock examples, and excerpts from source documentation.'
            end,
          },
          {
            role = 'user',
            content = function(context)
              local visual = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
              return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. visual .. '\n```\n\n'
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
    },
  },
  keys = {
    { '<C-a>', '<cmd>CodeCompanionActions<CR>', desc = 'c[a]i action' },
    { '<leader>a\\', '<cmd>CodeCompanionChat toggle<CR>', desc = '[a]i toggle chat' },
    { '<leader>aa', '<cmd>CodeCompanionChat Add<CR>', desc = '[a]i [a]dd chat' },
    { '<leader>aP', '<cmd>CodeCompanionActions<CR>', desc = '[a]i [P]alette...' },
    {
      '<leader>aE',
      function()
        require('codecompanion').prompt 'Explain'
      end,
      mode = 'v',
      desc = '[a]i [E]xplain selected...',
    },
    {
      '<leader>aD',
      function()
        require('codecompanion').prompt 'Document'
      end,
      mode = 'v',
      desc = '[a]i [D]ocument...',
    },
  },
}
