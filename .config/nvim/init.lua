vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Enable line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Display a welcome message on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.api.nvim_echo({
      {'Welcome to Neovim, enjoy your coding!', 'Normal'}
    }, true, {})
  end,
})

-- Transparent Background
-- Set Neovim's background transparency using Lua
vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi VertSplit guibg=NONE ctermbg=NONE
]])

-- Set tab width and expand tabs to spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

require('lspconfig').cssls.setup {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  settings = {
    css = {
      validate = true,
    },
    scss = {
      validate = true,
    },
    less = {
      validate = true,
    },
  },
}