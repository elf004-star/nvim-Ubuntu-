-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- ============================================
-- Ctrl+C 和 Ctrl+V 复制粘贴快捷键
-- ============================================
-- 注意：只在普通模式和可视模式下映射，不影响终端模式和插入模式
-- 这样终端中的 Ctrl+C 仍然可以用来终止程序

-- 可视模式下：Ctrl+C 复制到系统剪贴板
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })

-- 普通模式下：Ctrl+V 从系统剪贴板粘贴
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- 可视模式下：Ctrl+V 从系统剪贴板粘贴（替换选中内容）
vim.keymap.set("v", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- 插入模式下：Ctrl+V 从系统剪贴板粘贴
-- 使用 <C-r>+ 可以在插入模式下粘贴，并且保持缩进
vim.keymap.set("i", "<C-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- ============================================
-- vim-surround: 在可视模式下使用 S 键包围选中文本
-- ============================================
-- 禁用 flash 的 S 键映射，确保 vim-surround 的 S 键可以正常工作
vim.keymap.set("v", "S", "<Plug>VSurround", { desc = "Surround selection", remap = true, silent = true })

-- jk绑定ESC
vim.keymap.set("i", "jk", "<Esc>", { desc = "jk to ESC", remap = true, silent = true })
