local M = {}

---@return string[]
M.get_modules_in_directory = function(opts)
  local files = vim.fn.globpath(opts.directory, "*", true, true)
  local modules = {}
  for _, file in ipairs(files) do
    -- check if any of the blacklisted files are in the path
    local skip = false
    for _, blacklisted in ipairs(opts.blacklist) do
      if file:match(blacklisted) then
        skip = true
        break
      end
    end
    if not skip then
      local module = file:match "/([^/]*)%.lua$"
      if module then
        modules[#modules + 1] = module
      end
    end
  end
  return modules
end

return M
