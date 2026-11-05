local lazypack = require('config.lazypack')

local M = {}
local ready = false

local function setup()
    if not lazypack.load_all({ 'mason.nvim', 'nvim-lint', 'mason-nvim-lint' }) then
        return false
    end

    local ok, err = pcall(function()
        local mason = require('mason')
        if not mason.has_setup then
            mason.setup()
        end

        local lint = require('lint')
        lint.linters_by_ft = {
            markdown = { 'markdownlint-cli2' },
        }

        require('mason-nvim-lint').setup({
            automatic_installation = true,
        })
    end)
    if not ok then
        vim.schedule(function()
            vim.notify('Lint setup failed: ' .. tostring(err), vim.log.levels.ERROR)
        end)
        return false
    end

    ready = true
    return true
end

function M.lint()
    if not ready and not setup() then
        return
    end
    if vim.bo.modifiable then
        require('lint').try_lint(nil, { ignore_errors = true })
    end
end

vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('UserLint', { clear = true }),
    pattern = { '*.md', '*.markdown' },
    callback = M.lint,
})

return M
