local highlight = {
  "CursorColumn",
  "Whitespace",
}

return {
  indent = { highlight = highlight, char = "│" },
  whitespace = {
    highlight = highlight,
    remove_blankline_trail = false,
  },
  scope = { enabled = false },
}
