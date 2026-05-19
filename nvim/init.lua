require('plugins')   -- 插件声明
require('options')   -- 基础选项
require('keymaps')   -- 快捷键
require('autocmds')  -- 自动命令（包含懒加载触发器）
require('lsp')       -- LSP 配置
require('theme')     -- 主题（在 VimEnter 时加载）
require('treesitter')-- Treesitter 懒加载设置
require('blink')     -- 补全懒加载
require('mini')      -- mini.nvim 系列快捷键与配置
require('lualine-config')   -- 状态栏
require('markview')  -- Markdown 增强
require('rust')      -- Rust 支持（可选）
