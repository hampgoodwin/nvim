return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",   -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  opts = function()
    local tree = require('neo-tree')
    tree.setup({
      sort_case_insensitive = true,
    })
  end,
}
