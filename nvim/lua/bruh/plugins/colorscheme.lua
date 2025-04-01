return {
	{
		lazy = false,
		priority = 1000,
		"tjdevries/colorbuddy.nvim",
		config = function()
			vim.cmd.colorscheme("default")
		end,
	},
	"rktjmp/lush.nvim",
	"tckmn/hotdog.vim",
	"dundargoc/fakedonalds.nvim",
	"craftzdog/solarized-osaka.nvim",
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		config = function()
			require("rose-pine").setup({
				variant = "dawn", -- light theme
			})
		end,
	},
	"eldritch-theme/eldritch.nvim",
	"jesseleite/nvim-noirbuddy",
	"miikanissi/modus-themes.nvim",
	"rebelot/kanagawa.nvim",
	"gremble0/yellowbeans.nvim",
	"rockyzhang24/arctic.nvim",
	"folke/tokyonight.nvim",
	"Shatur/neovim-ayu",
	"RRethy/base16-nvim",
	"xero/miasma.nvim",
	"cocopon/iceberg.vim",
	"kepano/flexoki-neovim",
	"ntk148v/komau.vim",
	{ "catppuccin/nvim", name = "catppuccin" },
	"uloco/bluloco.nvim",
	"LuRsT/austere.vim",
	"ricardoraposo/gruvbox-minor.nvim",
	"NTBBloodbath/sweetie.nvim",
	"vim-scripts/MountainDew.vim",
	"NLKNguyen/papercolor-theme", -- ← fixed here
	{
		"maxmx03/fluoromachine.nvim",
		-- config = function()
		--   local fm = require "fluoromachine"
		--   fm.setup { glow = true, theme = "fluoromachine" }
		-- end,
	},
}
