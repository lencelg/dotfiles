-- 使用 vim.pack 声明所有插件
-- 注意：type = 'opt' 表示懒加载，需要手动 packadd

vim.pack.add({
    -- 主题
    { src = 'https://github.com/catppuccin/nvim', type = 'opt' },

    -- LSP 核心
    { src = 'https://github.com/mason-org/mason.nvim', type = 'opt' },
    { src = 'https://github.com/neovim/nvim-lspconfig', type = 'opt' },
    { src = 'https://github.com/williamboman/mason-lspconfig.nvim', type = 'opt' },

    -- 补全
    { src = 'https://github.com/saghen/blink.cmp', type = 'opt' },
    { src = 'https://github.com/saghen/blink.lib' },
    -- { src = 'https://github.com/L3MON4D3/LuaSnip', type = 'opt' },

    -- Treesitter
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', type = 'opt' },

    -- mini.nvim 套件
    { src = 'https://github.com/nvim-mini/mini.nvim', type = 'opt' },

    -- 状态栏
    { src = 'https://github.com/nvim-lualine/lualine.nvim', type = 'opt' },

    -- Markdown
    { src = 'https://github.com/OXY2DEV/markview.nvim', type = 'opt'},

    -- Rust
    { src = 'https://github.com/mrcjkb/rustaceanvim', type = 'opt' },

    --typst preview
    { src = 'https://github.com/chomosuke/typst-preview.nvim', type = 'opt'}
})
