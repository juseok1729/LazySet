return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        hl.CursorLine = {
          bg = "NONE",
          underline = true,
          blend = 100,
        }
        hl.CursorLineNr = { fg = "#ffffff", bold = true }
        hl.Visual = { bg = c.bg_highlight, fg = c.fg, reverse = true }
      end,
    },
  },
}