-- ==========================================
-- 1. 剪贴板显式绑定（针对 SSH 远程到 Ubuntu 的精准适配）
-- ==========================================
-- 使用 which lemonade 查出来的绝对路径
local lemonade_path = "/home/elf004/go/bin/lemonade"

vim.g.clipboard = {
    name = "lemonade",
    copy = {
        -- 强制将复制内容发往 127.0.0.1（即 SSH 反向隧道入口）
        ["+"] = lemonade_path .. " --host=127.0.0.1 copy",
        ["*"] = lemonade_path .. " --host=127.0.0.1 copy",
    },
    paste = {
        -- 强制从 127.0.0.1（经由 SSH 隧道从你本地电脑）获取剪贴板
        ["+"] = lemonade_path .. " --host=127.0.0.1 paste",
        ["*"] = lemonade_path .. " --host=127.0.0.1 paste",
    },
    cache_enabled = 0,
}

-- ==========================================
-- 2. 加载插件管理器与基础设置
-- ==========================================
require("config.lazy")

-- 延迟设置 clipboard，防止被 LazyVim 的 VeryLazy 回调覆盖（SSH 环境下 LazyVim 会清空 clipboard）
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.o.clipboard = "unnamedplus"
    end,
})
