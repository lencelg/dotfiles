-- ~/.config/nvim/lua/cpp_builder.lua
-- :Com – compile only (C++23, output in ./output/)
-- :Cpprun – compile & run
-- Output window shows raw compiler/program output + timing/success info at the end

local M = {}

local output_buf = nil
local output_win = nil

local function get_output_window()
  if output_win and vim.api.nvim_win_is_valid(output_win) then
    vim.api.nvim_set_current_win(output_win)
    return output_win, output_buf
  end

  vim.cmd("below split")
  output_win = vim.api.nvim_get_current_win()

  if output_buf and vim.api.nvim_buf_is_valid(output_buf) then
    vim.api.nvim_win_set_buf(output_win, output_buf)
  else
    output_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(output_buf, "C++ Build Output")
  end
  vim.api.nvim_win_set_buf(output_win, output_buf)

  vim.api.nvim_buf_set_option(output_buf, 'modifiable', true)
  vim.api.nvim_buf_set_option(output_buf, 'readonly', false)
  vim.api.nvim_buf_set_option(output_buf, 'bufhidden', 'wipe')
  vim.api.nvim_win_set_height(output_win, 10)

  vim.api.nvim_buf_set_keymap(output_buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(output_buf, 'n', '<ESC>', ':close<CR>', { noremap = true, silent = true })

  vim.api.nvim_set_current_win(output_win)
  return output_win, output_buf
end

local function clear_output_buffer()
  if output_buf and vim.api.nvim_buf_is_valid(output_buf) then
    vim.api.nvim_buf_set_option(output_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, {})
    vim.api.nvim_buf_set_option(output_buf, 'modifiable', false)
  end
end

local function append_to_output(lines)
  if not output_buf or not vim.api.nvim_buf_is_valid(output_buf) then
    return
  end
  vim.api.nvim_buf_set_option(output_buf, 'modifiable', true)
  local line_count = vim.api.nvim_buf_line_count(output_buf)
  vim.api.nvim_buf_set_lines(output_buf, line_count, line_count, false, lines)
  if output_win and vim.api.nvim_win_is_valid(output_win) then
    vim.api.nvim_win_set_cursor(output_win, {line_count + #lines, 0})
  end
  vim.api.nvim_buf_set_option(output_buf, 'modifiable', false)
end

local function detect_compiler()
  local handle = io.popen("which g++ 2>/dev/null || which clang++ 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  return result:match("%S+")
end

local function get_output_path(filename)
  local src_dir = vim.fn.fnamemodify(filename, ":h")
  local output_dir = src_dir .. "/output"
  if vim.fn.isdirectory(output_dir) == 0 then
    vim.fn.mkdir(output_dir, "p")
  end
  local basename = vim.fn.fnamemodify(filename, ":t:r")
  local outfile = output_dir .. "/" .. basename
  if vim.fn.has("win32") == 1 then
    outfile = outfile .. ".exe"
  end
  return outfile
end

-- Run a command and capture stdout/stderr, then call on_complete(exit_code, elapsed_seconds)
local function run_command_with_timing(cmd, on_complete)
  local start_time = vim.loop.hrtime()
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data then
        local filtered = {}
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(filtered, line)
          end
        end
        if #filtered > 0 then
          vim.schedule(function()
            append_to_output(filtered)
          end)
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        local filtered = {}
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(filtered, line)
          end
        end
        if #filtered > 0 then
          vim.schedule(function()
            append_to_output(filtered)
          end)
        end
      end
    end,
    on_exit = function(_, code)
      local elapsed = (vim.loop.hrtime() - start_time) / 1e9
      vim.schedule(function()
        if on_complete then on_complete(code, elapsed) end
      end)
    end
  })
end

local function compile_and_run(run_after_build)
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buf)
  if filename == "" then
    vim.notify("Current buffer has no filename, please save first", vim.log.levels.ERROR)
    return
  end

  local ext = filename:match("%.([^%.]+)$")
  if ext ~= "cpp" and ext ~= "cc" and ext ~= "cxx" then
    vim.notify("Current file is not a C++ source file (.cpp/.cc/.cxx)", vim.log.levels.ERROR)
    return
  end

  if vim.bo[buf].modified then
    vim.cmd("write")
  end

  local compiler = detect_compiler()
  if not compiler then
    vim.notify("No C++ compiler found (g++ or clang++)", vim.log.levels.ERROR)
    return
  end

  local outfile = get_output_path(filename)
  local compile_cmd = string.format("%s -std=c++23 -o %s %s", compiler, outfile, filename)

  get_output_window()
  clear_output_buffer()

  -- Step 1: compile
  run_command_with_timing(compile_cmd, function(compile_code, elapsed)
    if compile_code == 0 then
      append_to_output({string.format("Compilation succeeded in %.3f seconds", elapsed)})
      if run_after_build then
        -- Step 2: run the program
        append_to_output({})
        local run_start = vim.loop.hrtime()
        vim.fn.jobstart(outfile, {
          on_stdout = function(_, data)
            if data then
              local filtered = {}
              for _, line in ipairs(data) do
                if line ~= "" then
                  table.insert(filtered, line)
                end
              end
              if #filtered > 0 then
                vim.schedule(function() append_to_output(filtered) end)
              end
            end
          end,
          on_stderr = function(_, data)
            if data then
              local filtered = {}
              for _, line in ipairs(data) do
                if line ~= "" then
                  table.insert(filtered, line)
                end
              end
              if #filtered > 0 then
                vim.schedule(function() append_to_output(filtered) end)
              end
            end
          end,
          on_exit = function(_, run_code)
            local run_elapsed = (vim.loop.hrtime() - run_start) / 1e9
            vim.schedule(function()
              append_to_output({string.format("Program exited with code %d, runtime %.3f seconds", run_code, run_elapsed)})
            end)
          end
        })
      end
    else
      append_to_output({string.format("Compilation failed in %.3f seconds", elapsed)})
    end
  end)
end

function M.compile()
  compile_and_run(false)
end

function M.compile_and_run()
  compile_and_run(true)
end

vim.api.nvim_create_user_command("Com", function()
  M.compile()
end, {})

vim.api.nvim_create_user_command("Cpprun", function()
  M.compile_and_run()
end, {})

return M
