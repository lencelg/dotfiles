local added, add_err = pcall(vim.cmd.packadd, 'image.nvim')

local ok, image = false, nil
if added then
  ok, image = pcall(require, 'image')
end

if not (added and ok) then
  vim.notify(
    'image.nvim 未能加载: ' .. tostring(add_err or 'require 失败') .. '',
    vim.log.levels.WARN
  )
  return
end

image.setup({
  backend = 'kitty',

  processor = 'magick_cli',

  integrations = {
    markdown = { enabled = true },
    typst = { enabled = true },
  },

  max_width = 100,
  max_height = 12,
  max_height_window_percentage = 50,

  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'blink-cmp-menu', '' },

  editor_only_render_when_focused = false,
  tmux_show_only_in_active_window = false,

  hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
})
