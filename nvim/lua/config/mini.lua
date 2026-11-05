local lazypack = require('config/lazypack')

local M = {}
local base_ready = false
local module_ready = {}

local function ensure_base()
    if base_ready then
        return true
    end
    if not lazypack.load('mini.nvim') then
        return false
    end

    require('mini.pairs').setup()
    require('mini.tabline').setup()
    require('mini.icons').setup()
    base_ready = true
    return true
end

local setups = {
    files = function()
        require('mini.files').setup({
            mappings = {
                synchronize = 's',
            },
        })
    end,
    jump = function()
        require('mini.jump').setup()
    end,
}

function M.load(module)
    if not ensure_base() then
        return false
    end

    local setup = setups[module]
    if not setup then
        vim.notify('Unknown mini module: ' .. tostring(module), vim.log.levels.WARN)
        return false
    end

    if not module_ready[module] then
        setup()
        module_ready[module] = true
    end

    if module == 'files' then
        require('mini.files').open()
    end
    return true
end

vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = ensure_base,
})

return M
