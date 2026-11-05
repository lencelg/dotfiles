require('config/options')   -- 基础选项
require('config/plugins')   -- 插件声明

require('config/keymaps')   -- 快捷键
require('config/autocmds')  -- 自动命令

require('config/mini')      -- mini.nvim 基础模块（VimEnter）
require('config/theme')     -- 主题（VimEnter）
require('config/lualine-config')  -- 状态栏（VimEnter）

require('config/treesitter') -- 首次读取文件时加载
require('config/lsp')        -- 首次打开支持的文件类型时加载
require('config/blink')      -- 首次进入插入模式时加载

require('config/markview-config')   -- Markdown 增强（按文件类型）
require('config/images')     -- 图片渲染（按文件类型/扩展名）
require('config/rust')       -- Rust 支持（按扩展名）
require('config/cd-navigator')
require('config/telescope')
