return {
  'milanglacier/minuet-ai.nvim',
  opts = {
    provider = 'openai_fim_compatible',
    n_completions = 1,
    context_window = 1024,
    provider_options = {
      openai_fim_compatible = {
        api_key = '',
        name = 'Ollama',
        end_point = 'http://hamp:11434/v1/completions',
        model = 'deepseek-coder-v2:16b',
        optional = {
          max_tokens = 256,
          top_p = 0.9,
        },
      },
    },
  },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'Saghen/blink.cmp',
      opts = {
        -- keymap = { ['<A-y>'] = require('minuet').make_blink_map() },
        sources = {
          -- Enable minuet for autocomplete
          default = { 'lsp', 'path', 'buffer', 'snippets', 'minuet' },
          -- For manual completion only, remove 'minuet' from default
          providers = {
            minuet = {
              name = 'minuet',
              module = 'minuet.blink',
              score_offset = 8, -- Gives minuet higher priority among suggestions
            },
          },
        },
        completion = { trigger = { prefetch_on_insert = false } },
      },
    },
  },
}
