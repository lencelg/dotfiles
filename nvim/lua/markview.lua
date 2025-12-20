vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.cmd("packadd markview.nvim")
        local ok, markview = pcall(require, "markview")
        if ok and type(markview) == "table" and markview.setup then
            require("markview").setup({ preview = { enable = false } })
            vim.cmd("Markview diableAll")
        end
    end,
})
