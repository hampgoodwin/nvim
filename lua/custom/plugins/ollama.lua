return {
	"David-Kunz/gen.nvim",
	lazy = false,
	keys = {
		{
			"<leader>o",
			":Gen<CR>",
			desc = "gen.nvim",
			mode = { "n", "v" }
		},
	},
	opts = {
		model = "deepseek-coder:6.7b", -- The default model to use.
		host = "localhost", -- The host running the Ollama service.
		port = "11434",  -- The port on which the Ollama service is listening.
		display_mode = "split", -- The display mode. Can be "float" or "split".
		show_prompt = true, -- Shows the Prompt submitted to Ollama.
		show_model = true, -- Displays which model you are using at the beginning of your chat session.
		no_auto_close = true, -- Never closes the window automatically.
		init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
		-- Function to initialize Ollama
		command = function(options)
			return "curl --silent --no-buffer -X POST http://" ..
			    options.host .. ":" .. options.port .. "/api/chat -d $body"
		end,
		-- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
		-- This can also be a command string.
		-- The executed command must return a JSON object with { response, context }
		-- (context property is optional).
		-- list_models = '<omitted lua function>', -- Retrieves a list of model names
		debug = false, -- Prints errors and the command which is run.
		prompts = {
			Generate = { prompt = "$input", replace = true },
			Chat = { prompt = "$input" },
			Summarize = { prompt = "Summarize the following:\n\n$text" },
			["Ask about"] = { prompt = "Regarding this:\n\n```\n$text```\n\n$input" },
			Review_Code = {
				prompt =
				"Review the following code and make concise suggestions:\n```$filetype\n$text\n```",
			},
			["Ask about code"] = {
				prompt =
				"Given this snippet of code:\n\n```$filetype\n$text\n```\n\n$input",
				replace = false,
			}
		},
	},
	-- config = function()
	-- 	local gen = require('gen')
	-- 	gen.prompts = {}
	-- 	gen.prompts["test"] = {
	-- 		prompt = "what is a react component?",
	-- 		replace = false
	-- 	}
	-- 	gen.prompts["Given this snippet of code:\\n\\n$text\\n\\nwhich is of filetype $filetype\\n\\n$input"] = {
	-- 		prompt = "Given this snippet of code:\n\n$text\n\nwhich is of filetype $filetype\n\n$input",
	-- 		replace = false,
	-- 	}
	-- end
}
