return {

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    -- main = 'nvim-treesitter.configs',
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      fold = { enable = true },
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'go',
        'gotmpl',
        'gomod',
        'gosum',
        'gowork',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'kdl',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'nix',
        'proto',
        'python',
        'regex',
        'rust',
        'sql',
        'terraform',
        'hcl',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
    },
  },
  {
    -- give context to cursor place in buffer via top-screen info
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 5, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = '^',
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
  },
}
