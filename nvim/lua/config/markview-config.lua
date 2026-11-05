local lazypack = require('config/lazypack')
local treesitter = require('config/treesitter')

local M = {}
local ready = false

function M.ensure()
    if ready then
        return true
    end
    if not treesitter.ensure() then
        return false
    end
    if not lazypack.load('markview.nvim') then
        return false
    end

    local markview = lazypack.require('markview.nvim', 'markview')
    if not markview then
        return false
    end

    local ok, err = pcall(markview.setup, {
        preview = { enable = false },
    })
    if not ok then
        vim.schedule(function()
            vim.notify('Markview setup failed: ' .. tostring(err), vim.log.levels.ERROR)
        end)
        return false
    end

    ready = true
    return true
end

function M.toggle()
    if M.ensure() then
        vim.cmd('Markview Toggle')
    end
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = M.ensure,
})

return M
