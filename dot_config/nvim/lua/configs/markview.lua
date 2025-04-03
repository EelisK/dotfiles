return {
  -- Highlight groups to use
  -- "dynamic" | "light" | "dark"
  highlight_groups = "dark",
  -- Modes where hybrid mode is enabled
  hybrid_modes = nil,
  preview = {
    -- Modes where preview is shown
    modes = { "n", "no", "c" },
    -- Lines from the cursor to draw when the
    -- file is too big
    draw_range = 100,
    -- Max file size that is rendered entirely
    max_buf_lines = 1000,
    -- Filetypes where the plugin is enabled
    filetypes = { "markdown", "quarto", "rmd" },
    -- Window configuration for split view
    splitview_winopts = {},
    -- Delay, in milliseconds
    -- to wait before a redraw occurs(after an event is triggered)
    debounce = 50,
    -- Render configs
    headings = {},
    horizontal_rules = {},
    list_items = {},
    callbacks = {},
    tables = {},
    -- Initial plugin state,
    -- true = show preview
    -- falss = don't show preview
    initial_state = true,
    -- Buffer types to ignore
    ignore_buftypes = { "nofile" },
  },

  -- Rendering related configuration
  block_quotes = {},
  checkboxes = {},
  code_blocks = {},
  escaped = {},
  footnotes = {},
  html = {},
  inline_codes = {},
  latex = {},
  links = {},
}
