-- 复制高亮
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.highlight.on_yank({ timeout = 500 }) end,
})

-- 为 Java 文件加载 nvim-java
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'java',
--     callback = function()
--         -- 利用 pcall 安全地加载，避免因插件未安装而报错
--         local ok, java = pcall(require, 'java')
--         if ok and java and java.setup then
--             java.setup()
--         else
--             vim.notify('nvim-java not found, please run :Pack sync', vim.log.levels.WARN)
--         end
--     end,
-- })
