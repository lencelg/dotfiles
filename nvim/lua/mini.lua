-- lua/mini.lua
-- mini.nvim 模块按需加载器

local M = {}

require('mini.pairs').setup()
function M.load(module)
    vim.cmd('packadd mini.nvim')
    require('mini.tabline').setup()
    require('mini.icons').setup()
    if module == 'files' then
        require('mini.files').setup()
        require('mini.files').open()
    elseif module == 'pick' then
        require('mini.pick').setup()
    elseif module == 'jump' then
        require('mini.jump').setup()
    end
end

return M
