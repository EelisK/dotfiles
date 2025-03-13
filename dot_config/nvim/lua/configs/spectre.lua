local M = {}

M.replace_engine = {
  ["sed"] = {
    cmd = "sed",
    args = {
      "-i",
      "",
      "-E",
    },
  },
}

return M
