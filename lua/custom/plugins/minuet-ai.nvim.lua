return {
  'milanglacier/minuet-ai.nvim',
  opts = {
    provider = 'openai_fim_compatible',
    n_completions = 1,
    context_window = 1024,
    provider_options = {
      openai_fim_compatible = {
        api_key = 'TERM',
        name = 'Ollama',
        end_point = 'http://hamp:11434/api/generate',
        model = 'qwen2.5-coder:32b',
        optional = {
          max_tokens = 256,
          top_p = 0.9,
        },
      },
    },
    notify = 'debug',
  },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'Saghen/blink.cmp' },
  },
}
