vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		--FormatDisable will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			'<leader>f',
        		function()
				require('conform').format { async = true, lsp_fallback = true }
        		end,
        		mode = '',
        		desc = '[F]ormat buffer',
		},
	},
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			go = { "gofumpt" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			nix = { "nixfmt" },
			lua = { "stylua" },
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			local disable_filetypes = { c = true, cpp = true }
			return {
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				async = false,
				timeout_ms = 1000,
			}
		end,
	},
}
