-- vim.pack.add({ 'https://github.com/saghen/blink.lib', 'https://github.com/saghen/blink.cmp' })
-- 首次进入插入模式时加载补全
vim.api.nvim_create_autocmd('InsertEnter', {
    once = true,
    callback = function()
        -- vim.cmd('packadd LuaSnip')
        vim.cmd('packadd blink.cmp')
        local cmp = require('blink.cmp')
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
    end,
})
