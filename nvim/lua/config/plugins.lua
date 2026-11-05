
-- 只安装和登记，不加入 runtimepath；实际加载由 lazypack 在触发事件时执行
vim.pack.add({
    -- 主题（包名由仓库名推断为 nvim）
    { src = 'https://github.com/catppuccin/nvim'},

    -- LSP 核心
    { src = 'https://github.com/mason-org/mason.nvim'},
    { src = 'https://github.com/neovim/nvim-lspconfig'},
    { src = 'https://github.com/williamboman/mason-lspconfig.nvim'},

    -- 补全
    { src = 'https://github.com/saghen/blink.cmp'},
    { src = 'https://github.com/saghen/blink.lib' },
    -- { src = 'https://github.com/L3MON4D3/LuaSnip'},

    -- Treesitter
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter'},

    -- mini.nvim 套件
    { src = 'https://github.com/nvim-mini/mini.nvim'},

    -- 状态栏
    { src = 'https://github.com/nvim-lualine/lualine.nvim'},

    -- Markdown
    { src = 'https://github.com/OXY2DEV/markview.nvim'},
    
    -- image render
    { src = 'https://github.com/3rd/image.nvim'},

    -- Rust
    { src = 'https://github.com/mrcjkb/rustaceanvim'},

    --typst preview
    -- { src = 'https://github.com/chomosuke/typst-preview.nvim'}

    -- nvim.lint
    { src = 'https://github.com/mfussenegger/nvim-lint'},
    { src = 'https://github.com/rshkarin/mason-nvim-lint'},
}, { load = function() end })
