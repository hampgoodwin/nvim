-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    {
      'nvim-neotest/nvim-nio',
    },
    {
      'nvim-neotest/neotest',
      dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-neotest/neotest-go',
        'nvim-neotest/neotest-jest',
      },
      config = function()
        -- get neotest namespace (api call creates or returns namespace)
        local neotest_ns = vim.api.nvim_create_namespace 'neotest'
        vim.diagnostic.config({
          virtual_text = {
            format = function(diagnostic)
              local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
              return message
            end,
          },
        }, neotest_ns)
        ---
        ---@diagnostic disable-next-line: missing-fields
        require('neotest').setup {
          -- your neotest config here
          adapters = {
            -- require 'neotest-plenary',
            require 'neotest-go' {
              recursive_run = true,
              experimental = {
                test_table = true,
              },
              args = { '-count=1' },
            },
            require 'neotest-jest' {
              jestCommand = 'npm test --',
              jestConfigFile = 'custom.jest.config.ts',
              env = { CI = true },
              cwd = function(path)
                return vim.fn.getcwd()
              end,
            },
          },
        }
      end,
    },

    -- Add your own debuggers here
    'leoluz/nvim-dap-go', -- go, so ez
    { -- js, not so ez ;(
      'mxsdev/nvim-dap-vscode-js',
      enabled = true,
      dependencies = {
        {
          'microsoft/vscode-js-debug',
          opt = true,
          build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
          -- build = 'npm i && npm run compile vsDebugServerBundle && mv dist out',
        },
      },
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F6>', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<F9>', dap.run_last, { desc = 'Debug: Run Last' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- sign definitions
    local sign = vim.fn.sign_define
    sign('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
    sign('DapBreakpointCondition', { text = '●', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
    sign('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    --
    --CUSTOM
    --

    -- configure go dap
    require('dap-go').setup {
      dap_configurations = {
        -- {
        --   type = 'go',
        --   name = 'Debug Test with args as Environment Variables',
        --   program = require('dap-go').get_arguments() .. ' ${file}',
        --   mode = 'remote',
        --   request = 'attach',
        -- },
        {
          type = 'go',
          name = 'Debug (Build Flags & Arguments)',
          request = 'launch',
          program = '${file}',
          args = require('dap-go').get_arguments,
          buildFlags = require('dap-go').get_build_flags,
        },
      },
      delve = {
        initialize_timeout_sec = 20,
      },
      tests = {
        verbose = true,
      },
    }

    -- configure javascript and typescript dap
    require('dap-vscode-js').setup {
      debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
      adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' },
    }
    local js_based_languages = { 'typescript', 'javascript', 'typescriptreact' }
    for _, language in ipairs(js_based_languages) do
      require('dap').configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Start Chrome with "localhost"',
          url = 'http://localhost:3000',
          webRoot = '${workspaceFolder}',
          userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests',
          -- trace = true, -- include debugger info
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/jest/bin/jest.js',
            '--runInBand',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
      }
    end
  end,
}
