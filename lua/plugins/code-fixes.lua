local function apply_quickfix()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1

  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "quickfix" },
      diagnostics = vim.diagnostic.get(0, { lnum = line }),
    },
  })
end

local function golangci_lint_fix()
  if vim.bo.filetype ~= "go" then
    vim.notify("golangci-lint --fix is only configured for Go buffers", vim.log.levels.WARN)
    return
  end

  local root = (LazyVim.root and LazyVim.root()) or vim.fs.root(0, { "go.mod", ".git" }) or vim.uv.cwd()

  vim.cmd.write()
  vim.fn.jobstart({ "golangci-lint", "run", "--fix" }, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code)
      vim.schedule(function()
        vim.cmd.checktime()

        if code == 0 then
          vim.notify("golangci-lint --fix completed", vim.log.levels.INFO)
        else
          vim.notify("golangci-lint --fix finished with issues", vim.log.levels.WARN)
        end
      end)
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>cf",
        apply_quickfix,
        desc = "Apply Quick Fix",
      },
      {
        "<leader>cF",
        golangci_lint_fix,
        desc = "Lint Fix Project",
      },
    },
  },
}
