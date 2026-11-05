local lazypack = require('config/lazypack')

local M = {}
local ready = false

local function setup()
    if not lazypack.load_all({ 'mason.nvim', 'nvim-lspconfig', 'mason-lspconfig.nvim' }) then
        return false
    end

    local ok, err = pcall(function()
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = { 'lua_ls', 'pyright', 'clangd' },
            -- 由下方显式 enable，避免 mason 抢在自定义配置前启动默认配置
            automatic_enable = false,
        })

        vim.lsp.config('lua_ls', {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } }
            }
          }
        })
        vim.lsp.config('pyright', {})
        vim.lsp.config('clangd', {})
        vim.lsp.enable({ 'lua_ls', 'pyright', 'clangd' })

        vim.diagnostic.config({ virtual_text = true })
    end)
    if not ok then
        vim.schedule(function()
            vim.notify('LSP setup failed: ' .. tostring(err), vim.log.levels.ERROR)
        end)
        return false
    end

    return true
end

function M.ensure()
    if ready then
        return true
    end
    ready = setup()
    return ready
end

function M.open_mason()
    if M.ensure() then
        vim.cmd('Mason')
    end
end

vim.lsp.config['tinymist'] = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    settings = {
        exportPdf = 'onSave',
    },
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua', 'python', 'c', 'cpp', 'rust' },
    callback = M.ensure,
})

local reclaim_group = vim.api.nvim_create_augroup('lsp-reclaim', { clear = true })

-- 最后一个关联 buffer 关闭后延迟停止，避免切换 buffer 时反复启停
vim.api.nvim_create_autocmd('LspDetach', {
    group = reclaim_group,
    callback = function()
        vim.defer_fn(function()
            for _, client in ipairs(vim.lsp.get_clients()) do
                if not client:is_stopped() and next(client.attached_buffers) == nil then
                    -- 优雅退出最多等 5s，卡住则强制结束
                    client:stop(5000)
                end
            end
        end, 1500)
    end,
})

return M
