# Neovim DAP 调试器问题排查指南

本文档介绍如何诊断和修复 Neovim 中 nvim-dap 调试器的常见问题。

## 目录

- [常见问题](#常见问题)
- [诊断步骤](#诊断步骤)
- [解决方案](#解决方案)
- [调试器安装](#调试器安装)

---

## 常见问题

### 1. 插件加载失败

**错误信息：**
```
attempt to index field 'pack' (a nil value)
```

**原因：** 插件文件格式不正确，使用了不存在的 API（如 `vim.pack.add`）。

**解决方案：** 确保 `lua/plugins/*.lua` 文件使用 lazy.nvim 格式：

```lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { ... },
    config = function()
      require("config.debugging")
    end,
  },
}
```

### 2. 断点不生效

**现象：** 程序启动成功，但不会在断点处停止。

**可能原因：**
1. 编译时未包含调试符号（`-g` 参数）
2. 文件类型没有对应的 DAP 配置
3. 调试适配器未安装或路径错误

---

## 诊断步骤

### 步骤 1：检查调试器是否安装

```bash
# 检查 gdb
which gdb
gdb --version

# 检查 codelldb (可选)
which codelldb

# 检查 OpenDebugAD7 / cppdbg (可选)
which OpenDebugAD7
```

### 步骤 2：检查可执行文件是否包含调试符号

```bash
# 使用 file 命令检查
file ./your_executable
# 应显示 "with debug_info" 或 "not stripped"

# 或使用 readelf
readelf --debug-dump=info ./your_executable | head -20
```

### 步骤 3：检查 DAP 配置是否包含当前文件类型

在 Neovim 中执行：
```vim
:lua print(vim.bo.filetype)
:lua print(vim.inspect(require('dap').configurations))
```

确保你的文件类型（如 `c`、`cpp`、`python`）有对应的配置。

---

## 解决方案

### 问题：C 语言文件无法调试

**原因：** 只配置了 `cpp`，没有配置 `c`。

**修复：** 在 `lua/config/debugging.lua` 中添加：

```lua
-- C 语言使用与 C++ 相同的配置
dap.configurations.c = dap.configurations.cpp
```

### 问题：codelldb/cppdbg 不可用

**原因：** macOS 和 Linux 的调试适配器安装方式不同。

**修复：** 使用系统自带的 gdb，添加 gdb 适配器配置：

```lua
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}
```

并在 configurations 中添加使用 gdb 的配置：

```lua
{
  name = "Launch (gdb)",
  type = "gdb",
  request = "launch",
  program = function()
    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
  end,
  cwd = "${workspaceFolder}",
  stopOnEntry = false,
},
```

### 问题：编译时缺少调试符号

**修复：** 确保编译命令包含 `-g` 参数：

```bash
# C 语言
gcc -g -o output source.c

# C++
g++ -g -o output source.cpp

# 使用 Makefile 时
CFLAGS += -g
CXXFLAGS += -g
```

---

## 调试器安装

### Ubuntu/Debian

```bash
# 安装 gdb（推荐）
sudo apt install gdb

# 安装 codelldb（可选，通过 Mason）
:MasonInstall codelldb
```

### macOS

```bash
# 安装 lldb（系统自带）或通过 Homebrew
brew install llvm

# 安装 codelldb（推荐）
:MasonInstall codelldb
```

---

## 快速检查清单

- [ ] 调试器已安装（`gdb`、`codelldb` 等）
- [ ] 可执行文件包含调试符号（`-g` 编译）
- [ ] 文件类型有对应的 DAP 配置
- [ ] 适配器路径正确
- [ ] 重启 Neovim 使配置生效

