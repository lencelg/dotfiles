vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.cmd("packadd markview.nvim")
    end,
})
