local lazypack = require('config/lazypack')

local M = {}
local ready = false

function M.ensure()
    if ready then
        return true
    end
    if not lazypack.load('nvim-treesitter') then
        return false
    end

    local ok, err = pcall(function()
        require('nvim-treesitter').setup({
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = { 'lua', 'vim', 'vimdoc', 'markdown', 'bash', 'python', 'c', 'rust' },
            auto_install = true,
        })

        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.opt.foldlevel = 99
    end)
    if not ok then
        vim.schedule(function()
            vim.notify('Treesitter setup failed: ' .. tostring(err), vim.log.levels.ERROR)
        end)
        return false
    end

    ready = true
    return true
end

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    callback = M.ensure,
})

return M
