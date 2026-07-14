-- 首次进入文件时加载 Treesitter
vim.api.nvim_create_autocmd('BufReadPre', {
    once = true,
    callback = function()
        vim.cmd('packadd nvim-treesitter')
        require('nvim-treesitter').setup({
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = { 'lua', 'vim', 'vimdoc', 'markdown', 'bash', 'python', 'c', 'rust' },
            auto_install = true,
        })

        -- Treesitter-based folding
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
        vim.opt.foldlevel = 99
    end,
})
