return {
  -- 禁用 Markdown LSP 服务器（如果不需要的话）
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 禁用 marksman（Markdown LSP）
        marksman = {
          enabled = false,
        },
        -- 禁用 markdown_oxide（另一个 Markdown LSP）
        markdown_oxide = {
          enabled = false,
        },
      },
    },
  },

  -- Markdown 预览插件
  {
    "OXY2DEV/markview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("markview").setup({
        -- 默认配置
        auto_close = true, -- 自动关闭其他 markdown 预览窗口
        width = 80, -- 预览窗口宽度
        height = 20, -- 预览窗口高度
        border = "rounded", -- 窗口边框样式
        update_interval = 200, -- 更新间隔（毫秒）
        use_gh_theme = true, -- 使用 GitHub 主题
        -- 自定义高亮组
        highlights = {
          title = "Title",
          list = "Special",
          code = "String",
          quote = "Comment",
          link = "Underlined",
        },
      })

      -- 设置快捷键
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkviewOpen<CR>", { desc = "Toggle Markdown Preview" })
      vim.keymap.set("n", "<leader>mc", "<cmd>MarkviewClose<CR>", { desc = "Close Markdown Preview" })
    end,
  },
}
