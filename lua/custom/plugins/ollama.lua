return {
	"nomnivore/ollama.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	-- All the user commands added by the plugin
	cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

	-- Sample keybind for prompting. Note that the <c-u> is important for selections to work properly.
	keys = {
		{
			"<leader>oo",
			":<c-u>lua require('ollama').prompt()<cr>",
			desc = "ollama prompt",
			mode = { "n", "v" },
		},
	},

	---@type Ollama.Config
	opts = {
		model = "zephyr",
		url = "http://192.168.0.172:11434",
		serve = {
			on_start = false,
			command = "ollama",
			args = { "serve" },
			stop_command = "pkill",
			stop_args = { "-SIGTERM", "ollama" },
		},
		-- View the actual default prompts in ./lua/ollama/prompts.lua
		prompts = {
			Sample_Prompt = {
				prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
				input_label = "> ",
				model = "mistral",
				action = "display",
			}
		}
	}
}
