-- Inspired by:
-- https://github.com/johmsalas/text-case.nvim

local function untrim_str(str, trim_info)
  return trim_info.start_trim .. str .. trim_info.end_trim
end

local function trim_str(str, _trimmable_chars)
  local chars = vim.split(str, "")
  local startCount = 0
  local endCount = 0
  local trimmable_chars = _trimmable_chars or { " ", "'", '"', "{", "}", "," }
  local trimmable_chars_by_char = {}

  for i = 1, #trimmable_chars, 1 do
    local trim_char = trimmable_chars[i]
    trimmable_chars_by_char[trim_char] = trim_char
  end

  local isTrimmable = function(char)
    return trimmable_chars_by_char[char]
  end

  for i = 1, #chars, 1 do
    local char = chars[i]
    if isTrimmable(char) then
      startCount = startCount + 1
    else
      break
    end
  end

  for i = #str, startCount + 1, -1 do
    local char = chars[i]
    if isTrimmable(char) then
      endCount = endCount + 1
    else
      break
    end
  end

  local trim_info = {
    start_trim = string.sub(str, 1, startCount),
    end_trim = string.sub(str, #chars - endCount + 1),
  }

  local trimmed_str = string.sub(str, startCount + 1, #chars - endCount) or ""

  return trim_info, trimmed_str
end
local function map(tbl, f)
  local t = {}

  for k, v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

local M = {}

local is_upper = function(char)
  if vim.fn.toupper(char) == vim.fn.tolower(char) then
    return false
  end

  return vim.fn.toupper(char) == char
end

local function split_string_into_chars(str)
  local chars = {}
  if str == "" or str == nil then
    return chars
  end

  for uchar in str:gmatch "([%z\1-\127\194-\244][\128-\191]*)" do
    table.insert(chars, uchar)
  end
  return chars
end

local function has_lower(str)
  local chars = split_string_into_chars(str)

  for _, char in ipairs(chars) do
    if vim.fn.tolower(char) == char and vim.fn.toupper(char) ~= vim.fn.tolower(char) then
      return true
    end
  end
end

local is_special = function(char)
  local b = char:byte(1)
  return b <= 0x2F or (b >= 0x3A and b <= 0x3F) or (b >= 0x5B and b <= 0x60) or (b >= 0x7B and b <= 0x7F)
end

local toTitle = function(str)
  if str == nil or str == "" then
    return ""
  end

  local chars = split_string_into_chars(str)
  local first_char = chars[1]
  local rest_chars = { unpack(chars, 2) }
  local rest_str = table.concat(rest_chars, "")

  return vim.fn.toupper(first_char) .. vim.fn.tolower(rest_str)
end

function M.to_parts(str)
  local parts = {}
  local new_part = true
  for _, char in ipairs(split_string_into_chars(str)) do
    if is_special(char) then
      new_part = true
    else
      if is_upper(char) and has_lower(str) then
        new_part = true
      end

      if new_part then
        table.insert(parts, "")
        new_part = false
      end

      parts[#parts] = parts[#parts] .. char
    end
  end

  return parts
end

function M.to_pascal_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  return table.concat(map(parts, toTitle), "")
end

function M.to_camel_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  if #parts == 1 then
    return vim.fn.tolower(parts[1])
  end
  if #parts > 1 then
    return vim.fn.tolower(parts[1]) .. table.concat(map({ unpack(parts, 2) }, toTitle), "")
  end

  return ""
end

function M.to_upper_phrase_case(str)
  return vim.fn.toupper(M.to_kebab_case(str)):gsub("-", " ")
end

function M.to_lower_phrase_case(str)
  return vim.fn.tolower(M.to_kebab_case(str)):gsub("-", " ")
end

function M.to_phrase_case(str)
  local lower = vim.fn.tolower(M.to_kebab_case(str))
  lower = lower:gsub("-", " ")
  return vim.fn.toupper(lower:sub(1, 1)) .. lower:sub(2, #lower)
end

function M.to_lower_case(str)
  return vim.fn.tolower(str)
end

function M.to_upper_case(str)
  return vim.fn.toupper(str)
end

function M.to_title_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  return table.concat(map(parts, toTitle), " ")
end

function M.to_snake_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  return table.concat(parts, "_")
end

function M.to_dot_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  return table.concat(parts, ".")
end

function M.to_comma_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  return table.concat(parts, ",")
end

function M.to_path_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  return table.concat(parts, "/")
end

function M.to_macro_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  return table.concat(map(parts, vim.fn.toupper), "_")
end

function M.to_title_dash_case(str)
  local parts = vim.split(M.to_kebab_case(str), "-")
  return table.concat(map(parts, toTitle), "-")
end

function M.to_kebab_case(str)
  local trim_info, s = trim_str(str)

  local parts = M.to_parts(s)
  local result = table.concat(map(parts, vim.fn.tolower), "-")

  return untrim_str(result, trim_info)
end

---@param str string
---@param case_type "snake_case" | "camelCase" | "PascalCase" | "kebab-case" | "MACRO_CASE"
function M.convert(str, case_type)
  local case_funcs = {
    snake_case = M.to_snake_case,
    camelCase = M.to_camel_case,
    PascalCase = M.to_pascal_case,
    ["kebab-case"] = M.to_kebab_case,
    MACRO_CASE = M.to_macro_case,
  }

  local func = case_funcs[case_type]
  if func == nil then
    error("Invalid case type: " .. tostring(case_type))
  end

  return func(str)
end

return M
