-- mini 快捷键
local mini = require('mini')

vim.keymap.set('n', '<leader>e', function() mini.load('files') end, { desc = 'Open mini.files' })
vim.keymap.set('n', '<leader>f', function() mini.load('pick'); require('mini.pick').builtin.files() end, { desc = 'Pick files' })
vim.keymap.set('n', '<leader>g', function() mini.load('pick'); require('mini.pick').builtin.grep_live() end, { desc = 'Grep live' })
vim.keymap.set('n', '<leader>b', function() mini.load('pick'); require('mini.pick').builtin.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>h', function() mini.load('pick'); require('mini.pick').builtin.help() end, { desc = 'Help tags' })

-- 系统剪贴板
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { desc = 'Cut to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from clipboard' })

-- 撤销
-- vim.keymap.set({ 'n', 'v', 'i' }, '<C-z>', '<ESC>u<CR>', { desc = 'Undo' })

-- 窗口管理
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Focus next window' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move right' })
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase height' })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease height' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase width' })

-- 行移动
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-1<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- 保存文件
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<ESC>:write<CR>', { desc = 'Save file' })

-- 缓冲区
vim.keymap.set('n', '<leader>n', ':bn<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>p', ':bp<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'Delete buffer' })

-- 终端
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { desc = 'Open terminal' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- LSP 快捷键（依赖 lsp 模块，但定义在此处，实际调用 vim.lsp.buf.* 在 lsp 加载后可用）
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '<leader>ma', ':Mason<CR>', { desc = 'Open Mason' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ wrap = true, count = -1 }) end, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ wrap = true, count = 1 }) end, { desc = 'Next diagnostic' })

-- Markview
vim.keymap.set('n', '<leader>ms', '<CMD>Markview Toggle<CR>', { desc = 'Toggle markview' })
