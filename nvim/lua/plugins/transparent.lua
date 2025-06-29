return {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup({
      enable = true, -- boolean: enable transparent
      extra_groups = { -- table/string: additional groups that should be cleared
        "NormalFloat",
        "FloatBorder",
        "TelescopeBorder",
        "NvimTreeNormal",
        "NvimTreeWinSeparator",
      },
      exclude = {}, -- table: groups you don't want to clear
    })

    require("transparent").clear_prefix('NeoTree')
  end,
}
