-- lua/mini.lua
-- mini.nvim 模块按需加载器

local M = {}

-- 首次加载 mini.nvim 并初始化基础模块
local function ensure_mini()
    vim.cmd('packadd mini.nvim')
    require('mini.pairs').setup()
    require('mini.tabline').setup()
    require('mini.icons').setup()
end

function M.load(module)
    ensure_mini()
    if module == 'files' then
        require('mini.files').setup({
            mappings = {
                synchronize = 's',
            },
        })
        require('mini.files').open()
    elseif module == 'pick' then
        require('mini.pick').setup()
    elseif module == 'jump' then
        require('mini.jump').setup()
    end
end

-- 在 VimEnter 时自动加载基础模块（pairs/tabline/icons）
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = ensure_mini,
})

return M
