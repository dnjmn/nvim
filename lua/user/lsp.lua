local M = {
  "neovim/nvim-lspconfig",
  commit = "649137cbc53a044bffde36294ce3160cb18f32c7",
  lazy = false,
  event = { BufReadPre },
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
      commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
    },
  },
}

function M.config()
  local cmp_nvim_lsp = require "cmp_nvim_lsp"
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

  local opt = function(bufnr, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    return { buffer = bufnr, remap = false }
  end
  local lspconfig = require "lspconfig"
  local function lsp_keymaps(bufnr)
    local builtin = require "telescope.builtin"
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.keymap.set("n", "gI", builtin.lsp_implementations, opt(bufnr, "[G]oto [I]mplementation"))
    vim.keymap.set("n", "gr", builtin.lsp_references, opt(bufnr, "[G]oto [R]eferences"))
    keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
    keymap(bufnr, "n", "<leader>lI", "<cmd>Mason<cr>", opts)
    keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
    keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
    keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  end

  local formatAndSave = function(client, bufnr)
    local params = vim.lsp.util.make_formatting_params {}
    local handler = function(_, result)
      if not result then
        return
      end
      vim.lsp.util.apply_text_edits(result, bufnr, client.offset_encoding)
      vim.cmd "write"
    end

    client.request("textDocument/formatting", params, handler, bufnr)
  end

  local on_attach = function(client, bufnr)
    -- Add the following code to your init.lua or init.nvim file

    local serve = { "tsserver", "sumneko_lua", "gopls" }
    for _, s in ipairs(serve) do
      if client.name == s then
        client.server_capabilities.documentFormattingProvider = false
      end
    end
    lsp_keymaps(bufnr)
    vim.keymap.set("n", "<leader>w", function()
      formatAndSave(client, bufnr)
    end, { buffer = bufnr })
    require("illuminate").on_attach(client)
  end

  for _, server in pairs(require("utils").servers) do
    Opts = { on_attach = on_attach, capabilities = capabilities }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "settings." .. server)
    if require_ok then
      Opts = vim.tbl_deep_extend("force", conf_opts, Opts)
    end

    lspconfig[server].setup(Opts)
  end

  -- lsp DiagnosticSigns
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      suffix = "",
    },
  }

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

return M
