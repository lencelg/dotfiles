-- 仅对 markdown 文件类型加载
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        vim.cmd('packadd markview.nvim')
        require('markview').setup({
            preview = { enable = false },
            latex = { enable = true },
        })
    end,
})
