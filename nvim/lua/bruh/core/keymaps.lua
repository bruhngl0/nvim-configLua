vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

-- ============================================================================
-- INSERT MODE
-- ============================================================================

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- ============================================================================
-- NORMAL MODE
-- ============================================================================

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows with arrows
keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Toggle split maximize" })

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Buffer navigation
keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
keymap.set("n", "<leader>bn", ":enew<CR>", { desc = "New buffer" })

-- Move text up and down
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Better page navigation (keep cursor centered)
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page (centered)" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page (centered)" })
keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Better indenting
keymap.set("n", "<", "<<", { desc = "Indent left" })
keymap.set("n", ">", ">>", { desc = "Indent right" })

-- Join lines and keep cursor position
keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- Quick save and quit
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all without saving" })

-- Source current file
keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file" })

-- Replace word under cursor
keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

-- Make file executable
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Quickfix list navigation
keymap.set("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix list" })
keymap.set("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })

-- Location list navigation
keymap.set("n", "<leader>lo", "<cmd>lopen<CR>", { desc = "Open location list" })
keymap.set("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "Close location list" })
keymap.set("n", "[l", "<cmd>lprev<CR>", { desc = "Previous location item" })
keymap.set("n", "]l", "<cmd>lnext<CR>", { desc = "Next location item" })

-- LSP keymaps (your existing ones)
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Additional LSP keymaps
keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", { desc = "List all diagnostics" })

-- Diagnostic navigation with severity
keymap.set("n", "[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })
keymap.set("n", "]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

keymap.set("n", "[w", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Previous warning" })
keymap.set("n", "]w", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Next warning" })

-- ============================================================================
-- VISUAL MODE
-- ============================================================================

-- Stay in indent mode
keymap.set("v", "<", "<gv", { desc = "Indent left" })
keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste without yanking replaced text
keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Better search in visual mode
keymap.set("v", "//", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search selection" })

-- ============================================================================
-- VISUAL BLOCK MODE
-- ============================================================================

-- Move text up and down
keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up" })
keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up" })

-- ============================================================================
-- COMMAND MODE
-- ============================================================================

-- Navigate command history
keymap.set("c", "<C-j>", "<Down>", { desc = "Next command" })
keymap.set("c", "<C-k>", "<Up>", { desc = "Previous command" })

-- ============================================================================
-- TERMINAL MODE
-- ============================================================================

-- Better terminal navigation
keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move to left window" })
keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move to bottom window" })
keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move to top window" })
keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move to right window" })
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================================================
-- CLIPBOARD
-- ============================================================================

-- Copy to system clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

-- Paste from system clipboard
keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- Delete to black hole register
keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to black hole register" })

-- ============================================================================
-- PLUGIN-SPECIFIC KEYMAPS (Optional - add if you have these plugins)
-- ============================================================================

-- Neo-tree
keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
keymap.set("n", "<leader>o", "<cmd>Neotree focus<CR>", { desc = "Focus file explorer" })

-- Telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Find word under cursor" })
keymap.set("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Resume last search" })

-- Git signs
keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })
keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Git blame line" })
keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous git hunk" })
keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next git hunk" })

-- Trouble
keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Toggle trouble" })
keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Workspace diagnostics" })
keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Document diagnostics" })

-- Harpoon
keymap.set("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<CR>", { desc = "Harpoon add file" })
keymap.set("n", "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { desc = "Harpoon menu" })
keymap.set("n", "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", { desc = "Harpoon file 1" })
keymap.set("n", "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", { desc = "Harpoon file 2" })
keymap.set("n", "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", { desc = "Harpoon file 3" })
keymap.set("n", "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", { desc = "Harpoon file 4" })

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Toggle line numbers
keymap.set("n", "<leader>un", function()
	vim.opt.number = not vim.opt.number:get()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle line numbers" })

-- Toggle wrap
keymap.set("n", "<leader>uw", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle line wrap" })

-- Toggle spell check
keymap.set("n", "<leader>us", function()
	vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spell check" })

-- Toggle conceallevel
keymap.set("n", "<leader>uc", function()
	if vim.opt.conceallevel:get() > 0 then
		vim.opt.conceallevel = 0
	else
		vim.opt.conceallevel = 2
	end
end, { desc = "Toggle conceal" })

-- Change directory to current file
keymap.set("n", "<leader>cd", "<cmd>cd %:p:h<CR>:pwd<CR>", { desc = "Change directory to current file" })
