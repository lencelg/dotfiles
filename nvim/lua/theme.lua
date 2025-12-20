-- 主题加载 (在 VimEnter 时，避免启动闪烁)
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        vim.cmd('packadd catppuccin')
        vim.cmd('colorscheme catppuccin-mocha')
        -- 透明背景
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    end,
})
