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

-- ============================================
-- Ctrl+] 跳出括号
-- ============================================
-- 在插入模式下按 Ctrl+] 跳到下一个闭合括号/引号之后
local function jump_out_of_bracket()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 转为1-indexed
  local brackets = { ")", "]", "}", ">", '"', "'", "`" }

  -- 在当前光标之后查找最近的闭合括号
  local nearest_pos = nil
  for i = col, #line do
    local char = line:sub(i, i)
    for _, b in ipairs(brackets) do
      if char == b then
        nearest_pos = i
        break
      end
    end
    if nearest_pos then
      break
    end
  end

  if nearest_pos then
    -- 移动光标到括号之后
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], nearest_pos })
  end
end

vim.keymap.set("i", "<C-]>", jump_out_of_bracket, { noremap = true, silent = true, desc = "Jump out of bracket" })

-- 在插入模式下使用 Ctrl+Z 撤销
vim.keymap.set("i", "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })
-- 在插入模式下使用 Ctrl+Y 重做
vim.keymap.set("i", "<C-m>", "<cmd>redo<cr>", { desc = "Redo" })
