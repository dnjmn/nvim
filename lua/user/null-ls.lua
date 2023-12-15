local M = {
  "jose-elias-alvarez/null-ls.nvim",
}

-- null_ls.config({
-- 	diagnostics_format = "#{s} [#{c}] [#{m}]",
-- })

function M.config()
  local null_ls = require "null-ls"
	local completion = null_ls.builtins.completion
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup {
    debug = false,
    diagnostics_format = "[#{s}] #{m}",
    sources = {
      -- formatting.blue,
      -- formatting.google_java_format,

		-- GOLANG
      formatting.gofmt,
      -- formatting.gofumpt,
      diagnostics.golangci_lint,
      -- formatting.goimports_reviser,
      -- formatting.golines,

      formatting.stylua,
      -- formatting.prettier,
      -- formatting.prettier.with {
      -- extra_filetypes = { "toml" },
      -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      -- },
      -- null_ls.builtins.diagnostics.eslint,
      null_ls.builtins.completion.spell,

      diagnostics.flake8,
      formatting.black,
      formatting.pylint,
      diagnostics.flake8,
    },
  }
end

return M
