-- Requires Neovim >= 0.12

-- Options -------------------------------------------------------------------
vim.g.mapleader = ' '

local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = 'a'
o.clipboard = 'unnamedplus'
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.signcolumn = 'yes'
o.splitright = true
o.splitbelow = true
o.scrolloff = 8
o.updatetime = 250
o.completeopt = { 'menuone', 'noselect', 'popup' }
o.autocomplete = true
o.complete = '.,w,b,u,o'
o.termguicolors = false -- use the terminal's own background and 16-color palette

-- Keymaps -------------------------------------------------------------------
local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>w', '<cmd>write<CR>')
map('n', '<leader>e', vim.diagnostic.open_float)
map('t', '<Esc><Esc>', [[<C-\><C-n>]])

-- Small conveniences --------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})

-- VimTeX --------------------------------------------------------------------
-- Must be set before VimTeX is loaded
vim.g.vimtex_view_method = vim.fn.has('mac') == 1 and 'skim' or 'zathura'
vim.g.vimtex_compiler_latexmk_engines = { _ = '-xelatex' } -- metropolis (Fira fonts), xeCJK

-- Plugins (built-in vim.pack) -----------------------------------------------
vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/R-nvim/R.nvim',
  'https://github.com/lervag/vimtex',
})

-- R.nvim --------------------------------------------------------------------
vim.g.r_indent_align_args = 0
require('r').setup({
  hook = {
    on_filetype = function()
      vim.keymap.set('n', '<Enter>', '<Plug>RDSendLine', { buffer = true })
      vim.keymap.set('x', '<Enter>', '<Plug>RSendSelection', { buffer = true })
    end,
  },
})

-- Treesitter ----------------------------------------------------------------
-- Parsers required by R.nvim; Python and Lua added for this computer.
-- Not started for tex: VimTeX relies on its own syntax.
require('nvim-treesitter').install({
  'r', 'rnoweb', 'latex', 'yaml', 'csv', 'markdown', 'markdown_inline',
  'python', 'lua',
})
vim.treesitter.language.register('markdown', { 'rmd', 'quarto' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'r', 'rmd', 'quarto', 'rnoweb', 'markdown', 'yaml', 'python', 'lua' },
  callback = function() pcall(vim.treesitter.start) end,
})

-- LSP (built-in) ------------------------------------------------------------
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = { library = { vim.env.VIMRUNTIME } }, -- recognize the `vim` global
    },
  },
})

-- No R server here: R.nvim ships its own
vim.lsp.enable({ 'lua_ls', 'pyright', 'texlab' })

vim.diagnostic.config({ virtual_text = true })

-- Completion (built-in) -----------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
