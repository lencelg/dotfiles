-- 首次进入插入模式时加载补全
vim.api.nvim_create_autocmd('InsertEnter', {
    once = true,
    callback = function()
        vim.cmd('packadd LuaSnip')
        vim.cmd('packadd blink.cmp')
        require('blink.cmp').setup({
            keymap = { preset = 'super-tab' },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lsp = { name = 'LSP' },
                    snippets = { name = 'luasnip' },
                },
            },
            completion = { documentation = { auto_show = true } },
        })
    end,
})
