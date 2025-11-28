return {
  -- vim-surround 插件，用于快速添加、删除、修改包围符号
  {
    "tpope/vim-surround",
    -- 这个插件不需要特殊配置，安装后即可使用
    -- 主要功能：
    -- 1. 在可视模式下，使用 S 键 + 符号（如 S{）来包围选中的文本
    -- 2. 在普通模式下，使用 cs<old><new> 来改变包围符号
    -- 3. 使用 ds<symbol> 来删除包围符号
    -- 4. 使用 ysiw<symbol> 来包围一个单词
    -- 5. 使用 yss<symbol> 来包围整行
    -- 注意：S 键的映射在 lua/config/keymaps.lua 中配置，以覆盖 flash 的映射
  },
}
