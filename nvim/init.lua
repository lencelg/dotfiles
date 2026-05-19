-- ============================================================================
-- Neovim 0.12 配置 (vim.pack 规范重写版)
-- ============================================================================

-- 基础选项
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = 'yes'
vim.opt.winborder = 'rounded'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
vim.opt.inccommand = 'split'
vim.g.mapleader = ' '

-- 系统剪贴板支持
vim.opt.clipboard = 'unnamedplus'

-- ============================================================================
-- 插件声明 (vim.pack)
-- ============================================================================
vim.pack.add({
    -- 主题 (只保留 catppuccin)
    { src = 'https://github.com/catppuccin/nvim', type = 'opt' },

    -- LSP 相关
    { src = 'https://github.com/mason-org/mason.nvim', type = 'opt' },
    { src = 'https://github.com/neovim/nvim-lspconfig', type = 'opt' },
    { src = 'https://github.com/williamboman/mason-lspconfig.nvim', type = 'opt' },

    -- 补全 (blink.cmp + 依赖)
    { src = 'https://github.com/saghen/blink.cmp', type = 'opt' },
    { src = 'https://github.com/L3MON4D3/LuaSnip', type = 'opt' }, -- snippets 引擎

    -- Treesitter
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', type = 'opt' },

    -- mini.nvim 系列 (全部懒加载)
    { src = 'https://github.com/nvim-mini/mini.nvim', type = 'opt' }, -- 提供所有 mini 模块
    -- 状态栏
    { src = 'https://github.com/nvim-lualine/lualine.nvim', type = 'opt' },

    -- Markdown 预览
    { src = 'https://github.com/OXY2DEV/markview.nvim', type = 'opt' },

    -- Rust 支持 (可选)
    { src = 'https://github.com/mrcjkb/rustaceanvim', type = 'opt', ft = 'rust' },
})

-- ============================================================================
-- 懒加载与插件配置
-- ============================================================================

-- 辅助函数: 加载 opt 插件并执行配置
local function lazy_load(plugin_name, config_fn)
    vim.cmd('packadd ' .. plugin_name)
    if config_fn then config_fn() end
end

-- 1. 颜色主题 (启动后立即加载)
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        lazy_load('catppuccin', function()
            vim.cmd('colorscheme catppuccin-mocha')
            -- 透明背景
            vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
        end)
    end,
})

-- 2. Treesitter (首次进入文件时加载)
vim.api.nvim_create_autocmd('BufReadPre', {
    once = true,
    callback = function()
        lazy_load('nvim-treesitter', function()
            require('nvim-treesitter').setup({
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = { 'lua', 'vim', 'vimdoc', 'markdown', 'bash', 'python', 'c', 'rust' },
                auto_install = true,
            })
        end)
    end,
})

-- 3. LSP + Mason (首次打开文件时加载)
vim.api.nvim_create_autocmd('BufReadPre', {
    once = true,
    callback = function()
        -- 加载 LSP 核心插件
        vim.cmd('packadd mason.nvim')
        vim.cmd('packadd nvim-lspconfig')
        vim.cmd('packadd mason-lspconfig.nvim')

        -- Mason 配置
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = { 'lua_ls', 'pyright', 'clangd', 'bash-language-server', 'harper-ls' },
            automatic_installation = true,
        })

        -- LSP 服务器配置 (Neovim 0.12+ API)
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
                    format = { enable = true },
                },
            },
        })
        vim.lsp.config('pyright', {})
        vim.lsp.config('clangd', {})
        vim.lsp.config('bash-language-server', {})
        vim.lsp.config('harper-ls', {})
        vim.lsp.enable({ 'lua_ls', 'pyright', 'clangd', 'bash-language-server', 'harper-ls' })

        -- 诊断显示
        vim.diagnostic.config({ virtual_text = true })
    end,
})

-- 4. blink.cmp (首次进入插入模式时加载)
vim.api.nvim_create_autocmd('InsertEnter', {
    once = true,
    callback = function()
        vim.cmd('packadd LuaSnip')
        vim.cmd('packadd blink.cmp')
        require('blink.cmp').setup({
            keymap = { preset = 'super-tab' },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lsp = { name = 'LSP' },
                    snippets = { name = 'luasnip' },
                },
            },
            completion = { documentation = { auto_show = true } },
        })
    end,
})

-- 5. mini.nvim 模块 (按需通过快捷键激活)
-- 不自动预加载，仅在首次调用快捷键时加载对应模块
local function ensure_mini_module(module)
    return function()
        vim.cmd('packadd mini.nvim')
        require('mini.pick').setup({})
        require('mini.files').setup({})
        require('mini.files').open({})
        require('mini.pairs').setup({})
        require('mini.icons').setup({})
        require('mini.jump').setup({})
    end
end

-- 6. lualine 状态栏 (在 VimEnter 后加载)
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        vim.cmd('packadd lualine.nvim')
        require('lualine').setup({
            options = { theme = 'catppuccin-mocha', section_separators = '', component_separators = '' },
            sections = {
                lualine_a = { 'mode' },
                lualine_x = { function() return 'lencelg' end },
            },
        })
    end,
})

-- 7. markview (Markdown 增强，按需加载)
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        vim.cmd('packadd markview.nvim')
        require('markview').setup({
            preview = { enable = false },
            latex = { enable = true },
        })
    end,
})

-- 8. rustaceanvim (仅 Rust 文件)
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

-- ============================================================================
-- 快捷键映射
-- ============================================================================

-- 系统剪贴板
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { desc = 'Cut to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from clipboard' })

-- 撤销
vim.keymap.set({ 'n', 'v', 'i' }, '<C-z>', '<ESC>u<CR>', { desc = 'Undo' })

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
vim.keymap.set('n', '<A-j>', ':m .+7<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- 保存文件
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<ESC>:write<CR>', { desc = 'Save file' })

-- mini 系列快捷键 (首次使用时自动加载)
vim.keymap.set('n', '<leader>e', function()
    vim.cmd('packadd mini.nvim')
    require('mini.files').setup()
    require('mini.files').open()
end, { desc = 'Open mini.files' })

vim.keymap.set('n', '<leader>f', function()
    vim.cmd('packadd mini.nvim')
    require('mini.pick').setup()
    require('mini.pick').builtin.files()
end, { desc = 'Pick files' })

vim.keymap.set('n', '<leader>g', function()
    vim.cmd('packadd mini.nvim')
    require('mini.pick').setup()
    require('mini.pick').builtin.grep_live()
end, { desc = 'Grep live' })

vim.keymap.set('n', '<leader>b', function()
    vim.cmd('packadd mini.nvim')
    require('mini.pick').setup()
    require('mini.pick').builtin.buffers()
end, { desc = 'List buffers' })

vim.keymap.set('n', '<leader>h', function()
    vim.cmd('packadd mini.nvim')
    require('mini.pick').setup()
    require('mini.pick').builtin.help()
end, { desc = 'Help tags' })

-- 缓冲区管理
vim.keymap.set('n', '<leader>n', ':bn<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>p', ':bp<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Delete buffer' })

-- 终端
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { desc = 'Open terminal' })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, desc = 'Exit terminal mode' })

-- LSP 快捷键 (依赖已加载)
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

-- Markview 切换
vim.keymap.set('n', '<leader>ms', '<CMD>Markview splitToggle<CR>', { desc = 'Toggle markview split' })

-- ============================================================================
-- 其他增强
-- ============================================================================

-- 复制高亮
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.highlight.on_yank({ timeout = 500 }) end,
})
