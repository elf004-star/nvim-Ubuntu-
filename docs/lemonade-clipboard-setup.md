# Lemonade 剪贴板配置总结

## 场景

SSH 远程开发时，将远程 Neovim/Vim 的复制操作同步到本地剪贴板。

## 架构

```
本地电脑                         远程服务器
┌──────────────┐               ┌──────────────────────┐
│ lemonade     │ ◄── SSH ──── │ lemonade client      │
│ server       │    -R 2489   │ (neovim/vim 调用)    │
│ :2489        │               │                       │
└──────────────┘               │ clipboard=unnamedplus │
                               │ g:clipboard={lemonade}│
                               └──────────────────────┘
```

- 本地运行 `lemonade server`
- SSH 带 `-R 2489:127.0.0.1:2489` 反向隧道
- 远程的 lemonade client 通过 127.0.0.1:2489 经隧道连回本地

## SSH 连接命令

```bash
ssh -R 2489:127.0.0.1:2489 user@host -p port
```

## Neovim 配置

**位置**: `~/.config/nvim/init.lua`

```lua
local lemonade_path = "/home/elf004/go/bin/lemonade"

vim.g.clipboard = {
    name = "lemonade",
    copy = {
        ["+"] = lemonade_path .. " --host=127.0.0.1 copy",
        ["*"] = lemonade_path .. " --host=127.0.0.1 copy",
    },
    paste = {
        ["+"] = lemonade_path .. " --host=127.0.0.1 paste",
        ["*"] = lemonade_path .. " --host=127.0.0.1 paste",
    },
    cache_enabled = 0,
}

-- 注意：必须放在 VeryLazy 事件中，否则会被 LazyVim 覆盖
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.o.clipboard = "unnamedplus"
    end,
})
```

## Vim 配置

**前提**: Vim 需编译了 `+clipboard`（安装 `vim-gtk3` 可获得）

```bash
sudo apt install vim-gtk3
```

**注意**: 不是所有 Vim 版本都支持 `g:clipboard` 自定义剪贴板提供者。
Debian 的 `vim-gtk3`（9.1, patches 1-16, 647, 678, 697）就不支持
（`has("clipboard_plus") == 0`）。因此改用 `TextYankPost` 自动命令实现。

**位置**: `~/.vimrc`

```vim
" ==================================================
" 剪贴板 - lemonade（SSH 远程复制到本地剪贴板）
" ==================================================

" lemonade 可执行文件路径
let s:lemonade = '/home/elf004/go/bin/lemonade --host=127.0.0.1'

" 任意 yank 操作后自动复制到 lemonade
function! s:LemonadeTextYank() abort
    if v:event.operator ==# 'y'
        let l:yanked = getreg('')
        if l:yanked !=# ''
            call system(s:lemonade .. ' copy', l:yanked)
        endif
    endif
endfunction

augroup lemonade_clipboard
    autocmd!
    autocmd TextYankPost * call s:LemonadeTextYank()
augroup END

" 可视模式 Ctrl+C 复制（等价于 y，TextYankPost 会自动同步到 lemonade）
vnoremap <C-c> y

" Ctrl+V 从 lemonade 粘贴
nnoremap <C-v> :let @" = system(s:lemonade .. ' paste')<CR>gP
inoremap <C-v> <C-r>"
vnoremap <C-v> :<C-u>let @" = system(s:lemonade .. ' paste')<CR>gP
```

## sudo vim 共享配置

```bash
sudo ln -sf ~/.vimrc /root/.vimrc
```

确保 lemonade 二进制对 root 可执行（`/home/elf004/go/bin/lemonade` 是 world-executable 即可）。

## 按键行为对照

### Neovim

| 操作 | 实际执行 | 触发 lemonade | 依赖 |
|------|---------|:-:|------|
| 可视模式 `y` | `"` → 同步到 `"+` | ✅ | 需 `clipboard=unnamedplus` |
| 可视模式 Ctrl+C | `"+y` | ✅ | 直接写 `"+`，不依赖 clipboard 选项 |
| 可视模式 `"+y` | `"+y` | ✅ | 同上 |

### Vim

| 操作 | 实际执行 | 触发 lemonade | 依赖 |
|------|---------|:-:|------|
| 可视模式 `y` | yank + TextYankPost 回调 | ✅ | TextYankPost 自动命令 |
| 可视模式 Ctrl+C | yank + TextYankPost 回调 | ✅ | 同上 |
| 任意模式 yank 操作 | TextYankPost 回调 | ✅ | 同上 |

## 踩坑记录

### 1. LazyVim 在 SSH 下清空 clipboard 选项

**问题**: Neovim 中 `y` 无法触发 lemonade，但 Ctrl+C 可以，且无报错。

**根因**: LazyVim 的 `options.lua` 检测到 SSH 环境时会清空 clipboard：

```lua
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
```

并在 VeryLazy 事件中将 `clipboard` 恢复为 `""`，覆盖了 init.lua 中设好的 `unnamedplus`。

**修复**: 将 `vim.o.clipboard = "unnamedplus"` 放到 VeryLazy 回调中，确保在 LazyVim 的清空逻辑之后执行。

### 2. Ctrl+C 与 y 的差异（Neovim）

- Ctrl+C 映射为 `"+y`，**直接向 `"+` 寄存器写内容**，不走 clipboard 选项，所以不受影响
- `y` 写 `"` 寄存器，需通过 `clipboard=unnamedplus` 同步到 `"+`，因此 clipboard 选项必须正确

### 3. Vim 不支持 g:clipboard

**问题**: Vim 中配置了 `g:clipboard` 和 `clipboard=unnamedplus`，但不起作用。

**根因**: 该 Vim 版本缺少 `clipboard_plus` 特性（`has("clipboard_plus") == 0`），
不支持 `g:clipboard` 自定义剪贴板提供者。

**修复**: 改用 `TextYankPost` 自动命令 + `system()` 调用 lemonade。

### 4. lemonade 连接被拒

**症状**: `dial tcp 127.0.0.1:2489: connect: connection refused`

**排查**:
- 本地 `lemonade server` 是否运行
- SSH 隧道是否建立（`ss -tlnp | grep 2489`）
- SSH 命令是否加了 `-R 2489:127.0.0.1:2489`

## 验证方法

```bash
# Neovim: 检查 clipboard 选项
nvim --headless -c 'lua print(vim.o.clipboard)' -c 'qa!'

# Neovim: 检查 g:clipboard
nvim --headless -c 'lua print(vim.inspect(vim.g.clipboard))' -c 'qa!'

# Neovim: 触发 VeryLazy 后检查 clipboard 是否保留
nvim --headless -u ~/.config/nvim/init.lua \
    -c 'lua vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })' \
    -c 'lua print(vim.o.clipboard)' -c 'qa!'

# Vim: 验证 TextYankPost 事件
vim --not-a-term -c 'autocmd TextYankPost * echo "op=" . v:event.operator' \
    -c 'normal! ihello world' -c 'normal! Vy' -c 'q!'
```
