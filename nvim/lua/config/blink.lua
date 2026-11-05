local lazypack = require('config/lazypack')

local ready = false

local function setup()
    if ready then
        return
    end
    if not lazypack.load_all({ 'blink.lib', 'blink.cmp' }) then
        return
    end

    local cmp = lazypack.require('blink.cmp', 'blink.cmp')
    if not cmp then
        return
    end

    cmp.build():pwait()
    cmp.setup({
        keymap = { preset = 'super-tab' },
        sources = {
            default = { 'lsp', 'path', 'buffer' },
            providers = {
                lsp = { name = 'LSP' },
            },
        },
        completion = { documentation = { auto_show = true } },
    })
    ready = true
end

vim.api.nvim_create_autocmd('InsertEnter', {
    callback = setup,
})
