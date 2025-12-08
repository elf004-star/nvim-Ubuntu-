-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      -- 删除 LazyVim 的拼写检查自动命令组
      pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")
    end)
  end,
  once = true,
})

-- 确保 Markdown 文件不启用拼写检查
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
