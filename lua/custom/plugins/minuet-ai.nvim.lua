return {
  'milanglacier/minuet-ai.nvim',
  opts = {
    provider = 'openai_compatible',
    -- notify = 'debug',
    n_completions = 1,
    context_window = 512,
    request_timeout = 2.5,
    throttle = 1500,
    debouce = 600,
    provider_options = {
      openai_compatible = {
        -- model = 'qwen/qwen-2.5-coder-32b-instruct',
        model = 'anthropic/claude-3.7-sonnet',
        -- system = 'see [Prompt] section for the default value',
        -- few_shots = 'see [Prompt] section for the default value',
        -- chat_input = 'See [Prompt Section for default value]',
        end_point = 'https://openrouter.ai/api/v1/chat/completions',
        api_key = 'OPENROUTER_API_KEY',
        name = 'Openrouter',
        optional = {
          max_tokens = 256,
          top_p = 0.9,
          provider = {
            -- Prioritize throughput for faster completion
            sort = 'throughput',
          },
        },
      },
      openai_fim_compatible = {
        api_key = 'TERM',
        name = 'Ollama',
        end_point = 'http://hamp:11434/v1/completions',
        model = 'qwen2.5-coder:14b',
        optional = {
          max_tokens = 256,
          top_p = 0.9,
        },
      },
    },
    virtualtext = {
      auto_trigger_ft = {},
      auto_trigger_ignore_ft = {},
      keymap = {
        -- accept whole completion
        accept = '<A-A>',
        -- accept one line
        accept_line = '<A-a>',
        -- accept n lines (prompts for number)
        accept_n_lines = '<A-z>',
        -- Cycle to prev completion item, or manually invoke completion
        prev = '<A-[>',
        -- Cycle to next completion item, or manually invoke completion
        next = '<A-]>',
        dismiss = '<A-e>',
      },
      show_on_completion_menu = true,
    },
  },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    -- { 'saghen/blink.cmp' }, -- set up in separate plugin file
  },
}
