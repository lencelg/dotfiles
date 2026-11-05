local lazypack = require('config/lazypack')
local treesitter = require('config/treesitter')

local M = {}
local ready = false

local function setup()
    if not treesitter.ensure() then
        return false
    end
    if not lazypack.load('image.nvim') then
        return false
    end

    local image = lazypack.require('image.nvim', 'image')
    if not image then
        return false
    end

    local ok, err = pcall(image.setup, {
        backend = 'kitty',
        processor = 'magick_cli',

        integrations = {
            markdown = { enabled = true },
            typst = { enabled = true },
        },

        max_width = 100,
        max_height = 12,
        max_height_window_percentage = 50,

        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'blink-cmp-menu', '' },

        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = false,

        hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    })
    if not ok then
        vim.schedule(function()
            vim.notify('image.nvim setup failed: ' .. tostring(err), vim.log.levels.ERROR)
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

local document_patterns = {
    '*.md',
    '*.markdown',
    '*.mdx',
    '*.wiki',
    '*.typ',
    '*.png',
    '*.jpg',
    '*.jpeg',
    '*.gif',
    '*.webp',
    '*.avif',
}

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    pattern = document_patterns,
    callback = M.ensure,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'vimwiki', 'typst' },
    callback = M.ensure,
})

return M
