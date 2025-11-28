-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 在注释的行按回车，不会自动再出现注释
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NoCommentOnEnter", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "r", "o" })
  end,
})