return {
  {

    -- for lsp features in code cells / embedded code
    "jmbuhr/otter.nvim",
    dev = false,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
      },
    },
    opts = {
      buffers = {
        set_filetype = true,
        write_to_disk = false,
      },
      handle_leading_whitespace = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { -- nice loading notifications
        -- PERF: but can slow down startup
        "j-hui/fidget.nvim",
        enabled = false,
        opts = {},
      },
      { "folke/neodev.nvim", opts = {}, enabled = true },
      { "folke/neoconf.nvim", opts = {}, enabled = false },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })
      require("mason-tool-installer").setup({
        ensure_installed = {
          "black",
          "stylua",
          "shfmt",
          "isort",
          "tree-sitter-cli",
        },
      })

      local lsp_flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- also needs:
      -- $home/.config/marksman/config.toml :
      -- [core]
      -- markdown.file_extensions = ["md", "markdown", "qmd"]
      lspconfig.marksman.setup({
        capabilities = capabilities,
        filetypes = { "markdown", "quarto" },
        root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
      })

      lspconfig.r_language_server.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          r = {
            lsp = {
              rich_documentation = false,
            },
          },
        },
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
      })

      lspconfig.html.setup({
        capabilities = capabilities,
        flags = lsp_flags,
      })

      lspconfig.emmet_language_server.setup({
        capabilities = capabilities,
        flags = lsp_flags,
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = "",
            },
          },
        },
      })

      lspconfig.dotls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
      })

      lspconfig.tsserver.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        filetypes = { "js", "javascript", "typescript", "ojs" },
      })

      local function get_quarto_resource_path()
        local function strsplit(s, delimiter)
          local result = {}
          for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
            table.insert(result, match)
          end
          return result
        end

        local f = assert(io.popen("quarto --paths", "r"))
        local s = assert(f:read("*a"))
        f:close()
        return strsplit(s, "\n")[2]
      end

      local lua_library_files = vim.api.nvim_get_runtime_file("", true)
      local lua_plugin_paths = {}
      local resource_path = get_quarto_resource_path()
      if resource_path == nil then
        vim.notify_once("quarto not found, lua library files not loaded")
      else
        table.insert(lua_library_files, resource_path .. "/lua-types")
        table.insert(lua_plugin_paths, resource_path .. "/lua-plugin/plugin.lua")
      end

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            runtime = {
              version = "LuaJIT",
              plugin = lua_plugin_paths,
            },
            diagnostics = {
              globals = { "vim", "quarto", "pandoc", "io", "string", "print", "require", "table" },
              disable = { "trailing-space" },
            },
            workspace = {
              library = lua_library_files,
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      lspconfig.julials.setup({
        capabilities = capabilities,
        flags = lsp_flags,
      })

      lspconfig.bashls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        filetypes = { "sh", "bash" },
      })

      -- Add additional languages here.
      -- See `:h lspconfig-all` for the configuration.
      -- Like e.g. Haskell:
      -- lspconfig.hls.setup {
      --   capabilities = capabilities,
      --   flags = lsp_flags
      -- }

      -- lspconfig.clangd.setup {
      --   capabilities = capabilities,
      --   flags = lsp_flags,
      -- }

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = true,
            },
          },
        },
      })

      -- See https://github.com/neovim/neovim/issues/23291
      -- disable lsp watcher.
      -- Too lags on linux for python projects
      -- because pyright and nvim both create too many watchers otherwise
      if capabilities.workspace == nil then
        capabilities.workspace = {}
        capabilities.workspace.didChangeWatchedFiles = {}
      end
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      lspconfig.pyright.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              disgnosticServerOverrides = {
                reportUnusedExpression = "none",
              },
            },
          },
        },
        root_dir = function(fname)
          return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname)
            or vim.fs.dirname(fname)
        end,
      })
    end,
  },
}
