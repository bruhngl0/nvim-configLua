return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
					{ path = "/usr/share/awesome/lib/", words = { "awesome" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true },
		"williamboman/mason.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
		{ "elixir-tools/elixir-tools.nvim" },
		"stevearc/conform.nvim",
		"b0o/SchemaStore.nvim",
	},
	config = function()
		-- Early return if in obsidian mode
		if vim.g.obsidian then
			return
		end

		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Build enhanced capabilities with nvim-cmp support
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			cmp_nvim_lsp.default_capabilities()
		)

		-- Server configurations
		local servers = {
			bashls = {},

			gopls = {
				manual_install = true,
				settings = {
					gopls = {
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},

			lua_ls = {
				server_capabilities = {
					semanticTokensProvider = vim.NIL,
				},
			},

			rust_analyzer = {},
			svelte = {},
			templ = {},
			taplo = {},
			intelephense = {},
			pyright = {},

			ruff = {
				manual_install = true,
			},

			biome = {},

			vtsls = {
				server_capabilities = {
					documentFormattingProvider = false,
				},
			},

			jsonls = {
				server_capabilities = {
					documentFormattingProvider = false,
				},
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},

			yamlls = {
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							url = "",
						},
					},
				},
			},

			ols = {},

			racket_langserver = {
				manual_install = true,
			},

			roc_ls = {
				manual_install = true,
			},

			gleam = {
				manual_install = true,
			},

			lexical = {
				cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/lexical"), "server" },
				root_dir = lspconfig.util.root_pattern({ "mix.exs" }),
				server_capabilities = {
					completionProvider = vim.NIL,
					definitionProvider = true,
				},
			},

			clangd = {
				init_options = {
					clangdFileStatus = true,
				},
				filetypes = { "c" },
			},

			tailwindcss = {
				init_options = {
					userLanguages = {
						elixir = "phoenix-heex",
						eruby = "erb",
						heex = "phoenix-heex",
					},
				},
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								[[class: "([^"]*)]],
								[[className="([^"]*)"]],
							},
						},
					},
				},
			},
		}

		-- Filter servers that should be auto-installed via Mason
		local servers_to_install = vim.tbl_filter(function(key)
			local config = servers[key]
			if type(config) == "table" then
				return not config.manual_install
			end
			return true
		end, vim.tbl_keys(servers))

		-- Setup Mason
		require("mason").setup()

		-- Setup Mason tool installer
		local ensure_installed = {
			"stylua",
			"lua_ls",
			"delve",
		}
		vim.list_extend(ensure_installed, servers_to_install)
		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
		})

		-- Configure and setup each LSP server
		for name, config in pairs(servers) do
			-- Merge capabilities into each server config
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
			lspconfig[name].setup(config)
		end

		-- Setup lsp_lines plugin
		require("lsp_lines").setup()

		-- Configure diagnostics display (start with virtual_text)
		vim.diagnostic.config({
			virtual_text = true,
			virtual_lines = false,
		})

		-- Keymap to toggle between virtual_text and virtual_lines
		vim.keymap.set("n", "<leader>l", function()
			local config = vim.diagnostic.config()
			if config and config.virtual_text then
				vim.diagnostic.config({
					virtual_text = false,
					virtual_lines = true,
				})
			else
				vim.diagnostic.config({
					virtual_text = true,
					virtual_lines = false,
				})
			end
		end, {
			desc = "Toggle LSP diagnostic display mode",
			silent = true,
		})
	end,
}
