local lazypack = require('config/lazypack')
local lsp = require('config/lsp')
local treesitter = require('config/treesitter')

local ready = false

local function ensure()
    if ready then
        return true
    end
    if not lsp.ensure() then
        return false
    end
    if not treesitter.ensure() then
        return false
    end
    if not lazypack.load('rustaceanvim') then
        return false
    end

    ready = true
    return true
end

vim.g.rustaceanvim = {
    tools = { enable_clippy = true },
    server = { on_attach = function(client, bufnr) end },
}

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    pattern = '*.rs',
    callback = ensure,
})
