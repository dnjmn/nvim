local util = require "lspconfig/util"

return {
  cmd = { "gopls", "serve" },
  filetypes = { "go", "gomod" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      staticcheck = true,
      -- Enable or disable specific features of gopls
      analyses = {
        unusedParams = true,
        unusedResults = true,
      },
    },
  },
}
