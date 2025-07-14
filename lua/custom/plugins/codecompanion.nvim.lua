return {
  'olimorris/codecompanion.nvim',
  -- version = 'v12.2.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
  },
  config = function()
    require('codecompanion').setup {
      opts = {
        log_level = 'WARN', -- TRACE|DEBUG|ERROR|INFO
        language = 'English',
      },

      -- set keymaps
      vim.keymap.set('n', '<Leader>a\\', '<cmd>CodeCompanionChat toggle<CR>', { noremap = true, silent = true, desc = '[a]i toggle chat' }),
      vim.keymap.set('n', '<Leader>aP', function()
        require('codecompanion').actions {}
      end, { noremap = true, silent = true, desc = '[a]i [P]alette...' }),
      vim.keymap.set('v', '<Leader>aE', function()
        require('codecompanion').prompt 'Explain'
      end, { noremap = true, silent = true, desc = '[a]i [E]xplain selected...' }),
      vim.keymap.set('v', '<Leader>aD', function()
        require('codecompanion').prompt 'Document'
      end, { noremap = true, silent = false, desc = '[a]i [D]ocument...' }),

      adapters = {
        openrouter = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'https://openrouter.ai/api',
              api_key = 'cmd:echo $OPENROUTER_API_KEY', -- name (openrouter) + _API_KEY
              chat_url = '/v1/chat/completions',
            },
            schema = {
              model = {
                default = 'anthropic/claude-sonnet-4',
              },
            },
          })
        end,
      },

      strategies = {
        chat = {
          adapter = 'openrouter',
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
          adapter = 'openrouter',
        },
      },

      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
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
          show_settings = true,
          start_in_insert_mode = false,
          show_token_count = true, -- Show the token count for each response?
          auto_scroll = false,
        },
        diff = {
          enabled = true,
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = 'vertical', -- vertical|horizontal split for default provider
          opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
          provider = 'mini_diff', -- default|mini_diff
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
                return '@insert_edit_into_file write documentation for the following code in the #buffer , do not include an example:\n\n```'
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
    }
  end,
}
