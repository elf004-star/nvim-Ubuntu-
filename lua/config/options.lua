-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 缩进设置：4个空格
vim.opt.shiftwidth = 4  -- 自动缩进使用的空格数
vim.opt.tabstop = 4     -- Tab 键显示的宽度
vim.opt.expandtab = true -- 将 Tab 转换为空格

-- 全局禁用拼写检查
vim.opt.spell = false

-- 禁用诊断的虚拟文本和下划线（波浪线），但保留其他 LSP 功能
vim.diagnostic.config({
  virtual_text = false, -- 禁用虚拟文本（行尾的错误提示）
  signs = true, -- 保留侧边栏的符号（可以看到哪行有问题）
  underline = false, -- 禁用下划线/波浪线
  update_in_insert = false, -- 插入模式下不更新诊断
  severity_sort = true, -- 按严重程度排序
})

-- 在注释的行按回车，不会自动再出现注释
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NoCommentOnEnter", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "r", "o" })
  end,
})

