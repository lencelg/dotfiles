local lazypack = require('config.lazypack')

vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        local lualine = lazypack.require('lualine.nvim', 'lualine')
        if not lualine then
            return
        end

        lualine.setup({
            options = {
                theme = 'palenight',
                section_separators = '',
                component_separators = '',
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_x = { function() return 'lencelg' end },
            },
        })
    end,
})
