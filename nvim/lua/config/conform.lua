vim.pack.add({
    'https://github.com/stevearc/conform.nvim',
})

require('conform').setup({
    formatters_by_ft = {
        markdown = { 'markdownlint-cli2' },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
    },
})
