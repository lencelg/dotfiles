local lazypack = require('config.lazypack')

-- vim.pack 以仓库名 nvim 作为 catppuccin/nvim 的包名
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        if not lazypack.require('nvim', 'catppuccin') then
            return
        end

        vim.cmd.colorscheme('catppuccin-mocha')
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    end,
})
