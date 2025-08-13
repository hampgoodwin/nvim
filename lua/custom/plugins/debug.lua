return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    -- {
    --   'theHamsta/nvim-dap-virtual-text',
    --   opts = {},
    -- },

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go', -- go, so ez -- I wonder if I even need this anymore..?
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dap.set_log_level 'TRACE'

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    -- vim.keymap.set('n', '<leader>da', function()
    --   dap.continue { before = get_args }
    -- end, { desc = '[d]debug with [a]rgs' })
    vim.keymap.set('n', '<F6>', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<F9>', dap.run_last, { desc = 'Debug: Run Last' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[d]ebug: toggle [b]reakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = '[d]ebug set [B]reakpoint' })
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸️',
          play = '▶',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '',
          disconnect = '',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    --
    --CUSTOM
    --

    -- configure go dap
    require('dap-go').setup {
      dap_configurations = {
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

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug',
        args = { '${port}' },
      },
      options = {
        initialize_timeout_sec = 10,
      },
    }

    for _, l in ipairs { 'typescript', 'javascript' } do
      dap.configurations[l] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node)',
          cwd = vim.fn.getcwd(),
          program = '${file}', -- Use program instead of args
          sourceMaps = true,
          protocol = 'inspector',
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Test Current File (pwa-node with jest)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
          runtimeExecutable = 'node',
          args = { '${file}', '--coverage', 'false' },
          rootPath = '${workspaceFolder}',
          sourceMaps = true,
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
      }
    end
  end,
}
