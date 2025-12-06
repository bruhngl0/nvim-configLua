return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
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
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
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

		-- Setup handlers for better error messages and hover windows
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
		})

		-- Diagnostic configuration
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				source = "if_many",
			},
			virtual_lines = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- Diagnostic signs
		local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Build enhanced capabilities with nvim-cmp support
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			cmp_nvim_lsp.default_capabilities()
		)

		-- Add folding capabilities
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		-- LSP keymaps on attach
		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, silent = true }

			-- Navigation
			vim.keymap.set(
				"n",
				"gd",
				vim.lsp.buf.definition,
				vim.tbl_extend("force", opts, { desc = "Go to definition" })
			)
			vim.keymap.set(
				"n",
				"gD",
				vim.lsp.buf.declaration,
				vim.tbl_extend("force", opts, { desc = "Go to declaration" })
			)
			vim.keymap.set(
				"n",
				"gi",
				vim.lsp.buf.implementation,
				vim.tbl_extend("force", opts, { desc = "Go to implementation" })
			)
			vim.keymap.set(
				"n",
				"gr",
				vim.lsp.buf.references,
				vim.tbl_extend("force", opts, { desc = "Show references" })
			)
			vim.keymap.set(
				"n",
				"gt",
				vim.lsp.buf.type_definition,
				vim.tbl_extend("force", opts, { desc = "Go to type definition" })
			)

			-- Hover and signature help
			vim.keymap.set(
				"n",
				"K",
				vim.lsp.buf.hover,
				vim.tbl_extend("force", opts, { desc = "Show hover documentation" })
			)
			vim.keymap.set(
				"n",
				"<C-k>",
				vim.lsp.buf.signature_help,
				vim.tbl_extend("force", opts, { desc = "Show signature help" })
			)

			-- Code actions
			vim.keymap.set(
				{ "n", "v" },
				"<leader>ca",
				vim.lsp.buf.code_action,
				vim.tbl_extend("force", opts, { desc = "Code action" })
			)
			vim.keymap.set(
				"n",
				"<leader>rn",
				vim.lsp.buf.rename,
				vim.tbl_extend("force", opts, { desc = "Rename symbol" })
			)

			-- Diagnostics
			vim.keymap.set(
				"n",
				"[d",
				vim.diagnostic.goto_prev,
				vim.tbl_extend("force", opts, { desc = "Previous diagnostic" })
			)
			vim.keymap.set(
				"n",
				"]d",
				vim.diagnostic.goto_next,
				vim.tbl_extend("force", opts, { desc = "Next diagnostic" })
			)
			vim.keymap.set(
				"n",
				"<leader>e",
				vim.diagnostic.open_float,
				vim.tbl_extend("force", opts, { desc = "Show diagnostic" })
			)
			vim.keymap.set(
				"n",
				"<leader>q",
				vim.diagnostic.setloclist,
				vim.tbl_extend("force", opts, { desc = "Diagnostic list" })
			)

			-- Workspace
			vim.keymap.set(
				"n",
				"<leader>wa",
				vim.lsp.buf.add_workspace_folder,
				vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
			)
			vim.keymap.set(
				"n",
				"<leader>wr",
				vim.lsp.buf.remove_workspace_folder,
				vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
			)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

			-- Formatting (if supported by server)
			if client.supports_method("textDocument/formatting") then
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, vim.tbl_extend("force", opts, { desc = "Format document" }))
			end

			-- Inlay hints (Neovim 0.10+)
			if client.supports_method("textDocument/inlayHint") then
				vim.keymap.set("n", "<leader>ih", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
				end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
			end

			-- Document highlight on cursor hold
			if client.supports_method("textDocument/documentHighlight") then
				local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
				vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = bufnr,
					group = group,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = bufnr,
					group = group,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end

		-- Server configurations
		local servers = {
			bashls = {},

			gopls = {
				manual_install = true,
				settings = {
					gopls = {
						gofumpt = true,
						codelenses = {
							gc_details = false,
							generate = true,
							regenerate_cgo = true,
							run_govulncheck = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
						},
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						analyses = {
							fieldalignment = true,
							nilness = true,
							unusedparams = true,
							unusedwrite = true,
							useany = true,
						},
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
						semanticTokens = true,
					},
				},
			},

			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
						},
						format = {
							enable = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
				server_capabilities = {
					semanticTokensProvider = vim.NIL,
				},
			},

			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							runBuildScripts = true,
						},
						checkOnSave = {
							allFeatures = true,
							command = "clippy",
							extraArgs = { "--no-deps" },
						},
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
					},
				},
			},

			svelte = {},
			templ = {},
			taplo = {},
			intelephense = {},

			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic",
						},
					},
				},
			},

			ruff = {
				manual_install = true,
			},

			biome = {},

			vtsls = {
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "all" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
					javascript = {
						inlayHints = {
							parameterNames = { enabled = "all" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
				server_capabilities = {
					documentFormattingProvider = false,
				},
			},

			jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
				server_capabilities = {
					documentFormattingProvider = false,
				},
			},

			yamlls = {
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
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
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					clangdFileStatus = true,
					usePlaceholders = true,
					completeUnimported = true,
					semanticHighlighting = true,
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
								[[class: "([^"]*)"]],
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
		require("mason").setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Setup Mason LSP config
		require("mason-lspconfig").setup({
			ensure_installed = vim.list_extend(
				{ "lua_ls" },
				vim.tbl_filter(function(server)
					return servers[server] and not (type(servers[server]) == "table" and servers[server].manual_install)
				end, servers_to_install)
			),
			automatic_installation = true,
		})

		-- Setup Mason tool installer
		local ensure_installed = {
			"stylua",
			"delve",
		}
		vim.list_extend(ensure_installed, servers_to_install)
		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
			auto_update = false,
			run_on_start = true,
		})

		-- Configure and setup each LSP server
		for name, config in pairs(servers) do
			-- Merge capabilities and on_attach into each server config
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
			config.on_attach = config.on_attach or on_attach

			lspconfig[name].setup(config)
		end

		-- Setup lsp_lines plugin (show diagnostics as virtual lines)
		require("lsp_lines").setup()

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
					virtual_text = {
						prefix = "●",
						source = "if_many",
					},
					virtual_lines = false,
				})
			end
		end, {
			desc = "Toggle LSP diagnostic display mode",
			silent = true,
		})
	end,
}
