local M = { loaded = {} }

local function report(message, level)
    vim.schedule(function()
        vim.notify('lazypack: ' .. message, level or vim.log.levels.ERROR)
    end)
end

local function error_text(err)
    if type(err) == 'table' and err.message then
        return err.message
    end
    return tostring(err)
end

function M.load(name)
    if M.loaded[name] then
        return true
    end

    local ok, err = pcall(vim.cmd.packadd, name)
    if not ok then
        report(('failed to load %s: %s'):format(name, error_text(err)))
        return false
    end

    M.loaded[name] = true
    return true
end

function M.load_all(names)
    for _, name in ipairs(names) do
        if not M.load(name) then
            return false
        end
    end
    return true
end

function M.require(package, module)
    if not M.load(package) then
        return nil
    end

    local ok, result = pcall(require, module or package)
    if not ok then
        report(('failed to require %s: %s'):format(module or package, error_text(result)))
        return nil
    end
    return result
end

return M
