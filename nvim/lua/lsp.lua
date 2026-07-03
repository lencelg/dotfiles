-- 懒加载 LSP 相关插件 (首次读取或新建文件时加载)
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    once = true,
    callback = function()
        vim.cmd('packadd mason.nvim')
        vim.cmd('packadd nvim-lspconfig')
        vim.cmd('packadd mason-lspconfig.nvim')

        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = { 'lua_ls', 'pyright', 'clangd'},
            automatic_installation = true,
        })

        -- LSP 服务器配置 (Neovim 0.12+ API)
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('', true),
                        checkThirdParty = false,
                    },
                    format = { enable = true },
                },
            },
        })
        vim.lsp.config('pyright', {})
        vim.lsp.config('clangd', {})
        vim.lsp.enable({ 'lua_ls', 'pyright', 'clangd' })

        vim.diagnostic.config({ virtual_text = true })
    end,
})

vim.lsp.config["tinymist"] = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    settings = {
        -- ...
    }
}
