return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                html = { "prettier" },
                json = { "prettier" }, -- or { "jq" }
                jsonc = { "prettier" },
            },
        },
    },
}
