-- 依赖检查
local function check_deps()
    local ok, minipick = pcall(require, 'mini.pick')
    if not ok then
        vim.notify('mini.pick not found', vim.log.levels.ERROR)
        return nil
    end
    if vim.fn.executable('fd') == 0 then
        vim.notify('fd not found', vim.log.levels.ERROR)
        return nil
    end
    return minipick
end

-- 通用选择器：仅执行 :cd，不打开任何文件浏览器
local function pick_and_cd(fd_cmd, prompt, is_local, base_dir)
    local minipick = check_deps()
    if not minipick then return end

    local handle = io.popen(fd_cmd)
    local result = handle:read('*a')
    handle:close()

    local items = {}
    local path_map = {}

    for line in result:gmatch('[^\n]+') do
        line = line:gsub('%s+$', '')
        if line ~= '' then
            local display
            if is_local and base_dir then
                -- 相对路径基于 base_dir（当前 buffer 目录）
                display = line:gsub('^' .. base_dir .. '/?', '')
                if display == '' then display = '.' end
            else
                display = line
            end
            table.insert(items, display)
            path_map[display] = line
        end
    end

    if #items == 0 then
        vim.notify('No directories found', vim.log.levels.WARN)
        return
    end

    minipick.start({
        source = {
            items = items,
            name = prompt,
        },
        -- ... 前面的 check_deps, pick_and_cd 等保持不变，只修改 choose 部分
        choose = function(item)
            local target = path_map[item]
            if target then
                vim.cmd.cd(target)
                vim.cmd('doautocmd DirChanged')   -- 额外触发事件，确保所有插件同步
                vim.notify('cd to: ' .. target, vim.log.levels.INFO)
            end
        end,
    })
end

-- 本地模式：基于当前 buffer 的目录，排除隐藏目录，深度 4
local function cd_local()
    -- 获取当前 buffer 的文件路径
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == '' then
        vim.notify('No file in current buffer', vim.log.levels.WARN)
        return
    end
    local base_dir = vim.fn.fnamemodify(bufname, ':h')  -- 文件所在目录
    if base_dir == '' then base_dir = '.' end

    local cmd = string.format(
        'fd --type directory --max-depth 4 --absolute-path --exclude .git --exclude node_modules . "%s"',
        base_dir
    )
    pick_and_cd(cmd, '📁 Local (relative to current file)', true, base_dir)
end

-- 全局模式：从根扫描，包含隐藏目录，深度 4
local function cd_global()
    local cmd = [[
        fd --type directory --max-depth 4 --absolute-path --hidden \
           --exclude .git --exclude node_modules --exclude proc --exclude sys --exclude dev --exclude tmp --exclude run \
           . /
    ]]
    pick_and_cd(cmd, '🌍 Global (absolute paths)', false, nil)
end

-- 创建命令
vim.api.nvim_create_user_command('CdLocal', cd_local, {})
vim.api.nvim_create_user_command('CdGlobal', cd_global, {})

-- 快捷键
vim.keymap.set('n', '<leader>cdl', '<cmd>CdLocal<CR>', { desc = 'Cd Local (relative to current file)' })
vim.keymap.set('n', '<leader>cdg', '<cmd>CdGlobal<CR>', { desc = 'Cd Global (absolute paths)' })
