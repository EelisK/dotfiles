---
--- https://biomejs.dev
---
--- Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
---

--- Appends `new_names` to `root_files` if `field` is found in any such file in any ancestor of `fname`.
---
--- NOTE: this does a "breadth-first" search, so is broken for multi-project workspaces:
--- https://github.com/neovim/nvim-lspconfig/issues/3818#issuecomment-2848836794
---
--- @param root_files string[] List of root-marker files to append to.
--- @param new_names string[] Potential root-marker filenames (e.g. `{ 'package.json', 'package.json5' }`) to inspect for the given `field`.
--- @param field string Field to search for in the given `new_names` files.
--- @param fname string Full path of the current buffer name to start searching upwards from.
local function root_markers_with_field(root_files, new_names, field, fname)
  local path = vim.fn.fnamemodify(fname, ":h")
  local found = vim.fs.find(new_names, { path = path, upward = true })

  for _, f in ipairs(found or {}) do
    -- Match the given `field`.
    for line in io.lines(f) do
      if line:find(field) then
        root_files[#root_files + 1] = vim.fs.basename(f)
        break
      end
    end
  end

  return root_files
end

local function insert_package_json(root_files, field, fname)
  return root_markers_with_field(root_files, { "package.json", "package.json5" }, field, fname)
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = "biome"
    local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/biome"
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
  end,
  filetypes = {
    "astro",
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "svelte",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "vue",
  },
  workspace_required = true,
  root_dir = function(_, on_dir)
    -- To support monorepos, biome recommends starting the search for the root from cwd
    -- https://biomejs.dev/guides/big-projects/#use-multiple-configuration-files
    local cwd = vim.fn.getcwd()
    local root_files = { "biome.json", "biome.jsonc" }
    root_files = insert_package_json(root_files, "biome", cwd)
    local root_dir = vim.fs.dirname(vim.fs.find(root_files, { path = cwd, upward = true })[1])
    on_dir(root_dir)
  end,
}
