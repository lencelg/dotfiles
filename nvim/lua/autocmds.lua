-- 复制高亮
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.hl.hl_op({ timeout = 500 }) end,
})

-- disable chinese when learving the insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.fn.jobstart({ "fcitx5-remote", "-c" }, {
      stdout_buffered = false,
      stderr_buffered = false,
    })
  end,
})
