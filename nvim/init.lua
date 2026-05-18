-- 通用 Neovim 设置 --
----------------------
vim.opt.number = true                           -- 显示行号
vim.opt.relativenumber = true                   -- 显示相对行号
vim.opt.cursorline = true                       -- 高亮光标所在行
vim.opt.expandtab = true                        -- 使用空格代替 Tab
vim.opt.tabstop = 4                             -- Tab 键宽度为 4
vim.opt.shiftwidth = 4                          -- 缩进宽度为 4
vim.opt.wrap = true                             -- 自动换行
vim.opt.scrolloff = 5                           -- 上下保留 5 行作为缓冲
vim.opt.signcolumn = 'yes'                      -- 永远显示 sign column（诊断标记）
vim.opt.winborder = 'rounded'                   -- 窗口边框样式
vim.opt.ignorecase = true                       -- 搜索忽略大小写
vim.opt.smartcase = true                        -- 当包含大写字母时，搜索区分大小写
vim.opt.hlsearch = true                         -- 搜索匹配高亮
vim.opt.incsearch = true                        -- 增量搜索
vim.opt.foldmethod = 'expr'                     -- 折叠方式使用表达式
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()' -- 使用 Treesitter 表达式折叠
vim.opt.foldlevel = 99                          -- 打开文件时默认不折叠
vim.opt.inccommand = 'split'                    -- 替换分栏
vim.g.mapleader = " "

----------------------
-- 插件管理（vim.pack） --
----------------------
vim.pack.add({
    { src = 'https://github.com/catppuccin/nvim' },                       -- catppuccin
    { src = 'https://github.com/mason-org/mason.nvim' },                  -- LSP 安装管理器
    { src = 'https://github.com/neovim/nvim-lspconfig' },                 -- LSP 配置
    { src = 'https://github.com/nvim-mini/mini.pick' },                   -- 文件/缓冲区选择器
    { src = 'https://github.com/nvim-mini/mini.files' },                  -- 文件浏览器
    { src = 'https://github.com/nvim-mini/mini.pairs' },                  -- 括号补全
    { src = 'https://github.com/nvim-mini/mini.icons' },                  -- 图标
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },             -- 状态栏
    { src = 'https://github.com/nvim-mini/mini.jump' },                   -- mini.jump
    { src = 'https://github.com/mrcjkb/rustaceanvim', ft = 'rust'},       -- rust
    { src = 'https://github.com/nvim-mini/mini.nvim'},                    -- if you use the mini.nvim suite
})

-- Treesitter安装并懒加载
vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' } -- 语法高亮和折叠
}, {
    load = function(plug_data)
        -- Treesitter 配置
        vim.api.nvim_create_autocmd("BufReadPre", {
            once = true,
            callback = function()
                vim.opt.runtimepath:append(plug_data.path)
                ---@diagnostic disable-next-line: missing-fields
                require('nvim-treesitter').setup({
                    highlight = { enable = true }, -- 语法高亮
                    indent = { enable = true },    -- 缩进
                })
            end,
        })
    end
})

-- blink.cmp
vim.pack.add({
    { src = 'https://github.com/saghen/blink.cmp' },
}, {
    load = function(plug_data)
        vim.api.nvim_create_autocmd("InsertEnter", {
            once = true,
            callback = function()
                vim.opt.runtimepath:append(plug_data.path)
                require('blink.cmp').setup({
                    keymap = { preset = 'super-tab' },
                    sources = {
                    },
                })
            end,
        })
    end
})

-- theme
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.cmd("colorscheme catppuccin-mocha")
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    end,
})

-- lualine
local function lencelg()
    return [[lencelg]]
end

require('lualine').setup{
    options = { 
        theme = 'palenight',
        section_separators = '',
        component_separators = '',
    },
    sections = {
        lualine_a = {'mode'},
        lualine_x = {lencelg},
     },
}

----------------------
-- 插件配置 --
----------------------
-- 插件延迟加载（在读取文件或创建新文件时加载）
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    callback = function()
        -- Mason
        require('mason').setup()
        -- mini.pick 配置
        require('mini.pick').setup({})
        -- mini.pari 配置
        require('mini.pairs').setup()
        require('mini.icons').setup()
        require('mini.tabline').setup()
        require('mini.jump').setup({})


        -- mini.files 文件浏览器配置
        require('mini.files').setup({
            content = {
                filter = nil,
                highlight = nil,
                prefix = nil,
                sort = nil,
            },

            mappings = {
                close       = 'q',
                go_in       = 'l',
                go_in_plus  = 'L',
                go_out      = 'h',
                go_out_plus = 'H',
                mark_goto   = "'",
                mark_set    = 'm',
                reset       = '<BS>',
                reveal_cwd  = '@',
                show_help   = 'g?',
                synchronize = 'n',
                trim_left   = '<',
                trim_right  = '>',
            },

            options = {
                permanent_delete = true,
                use_as_default_explorer = true,
            },

            windows = {
                max_number = math.huge,
                preview = false,
                width_focus = 50,
                width_nofocus = 15,
                width_preview = 25,
            }
        })
    end,
})
-- lsp config
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
            diagnostics = { globals = { 'vim' } },                                 
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            format = { enable = true }, -- 启用格式化
        },
    },
})
vim.lsp.config('bash-language-server', {})
vim.lsp.config('harper-ls', {})
vim.lsp.config('pyright', {})
vim.lsp.config('clangd', {})
vim.lsp.config('codebook', {})

-- 启用 LSP
vim.lsp.enable({ 'lua_ls', 'pyright', 'clangd', 'bash-language-server', 'harper-ls' , 'codebook'})
vim.diagnostic.config({ virtual_text = true }) -- 行内文本提示
-- vim.diagnostic.config({ virtual_lines = true }) -- 虚拟行提示（可选）

-- shortcut
-- 系统剪贴板
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>x', '"+d', { desc = 'cut to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'paste to system clipboard' })

-- 撤销
vim.keymap.set({ 'n', 'v', 'i' }, '<C-z>', '<ESC>u<CR>', { desc = 'undo' })

-- 窗口切换
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'focus windows' })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- 行移动
vim.keymap.set('n', '<A-j>', ':m .+7<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- 调整窗口大小
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- 保存文件
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<ESC>:write<CR>', { desc = 'save file' })

-- 文件/插件快捷键
vim.keymap.set('n', '<leader>e', function()
    if not pcall(require, 'mini.files') then
        vim.cmd('MiniFiles')
    else
        require('mini.files').open()
    end
end, { desc = 'open file explorer' })

vim.keymap.set('n', '<leader>f', ':Pick files<CR>', { desc = 'open file picker' })
vim.keymap.set('n', '<leader>h', ':Pick help<CR>', { desc = 'open help picker' })
vim.keymap.set('n', '<leader>g', ':Pick grep live<CR>', { desc = 'open grep live picker' })
vim.keymap.set('n', '<leader>b', function()
    if not pcall(require, 'mini.pick') then
        vim.cmd('PackAdd-mini.nvim')
    end
    require('mini.pick').builtin.buffers()
end, { desc = 'open buffer picker' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'diagnostic messages' })

-- LSP 快捷键
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP code action' })
vim.keymap.set('n', '<leader>ma', ':Mason<CR>', { desc = 'open Mason' })
vim.keymap.set('n', '<leader>n', ':bn<CR>', { desc = 'move to next buffer' })
vim.keymap.set('n', '<leader>p', ':bp<CR>', { desc = 'move to previous buffer' })
vim.keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'delete current buffer' })
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { desc = 'open a terminal as a buffer' })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- 诊断跳转
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ wrap = true, count = -1 }) end, { desc = 'prev diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ wrap = true, count = 1 }) end, { desc = 'next diagnostic' })

-- markdown key
vim.api.nvim_set_keymap("n", "<leader>ms", "<CMD>Markview splitToggle<CR>", { desc = "Toggles `splitview` for current buffer." });

-- 复制高亮
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'highlight copying text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.highlight.on_yank({ timeout = 500 }) end,
})
