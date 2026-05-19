-- 仅对 Rust 文件类型加载
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rust',
    callback = function()
        vim.cmd('packadd rustaceanvim')
        vim.g.rustaceanvim = {
            tools = { enable_clippy = true },
            server = { on_attach = function(client, bufnr) end },
        }
    end,
})
