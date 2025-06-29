-- word wrap
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.list = false -- extra option I set in addition to the ones in your question

-- conceal level
vim.o.conceallevel = 1

-- Windows クリップボードとの連携
local function is_wsl()
  local handle = io.popen("uname -r")
  local result = handle:read("*a")
  handle:close()
  return result:lower():find("microsoft") ~= nil

end

if is_wsl() then
  -- WSL環境でのクリップボード操作
  
  -- <leader>y でヤンクした内容をWindowsクリップボードに保存
  vim.keymap.set({'n', 'v'}, '<leader>y', function()
    -- 現在の無名レジスタの内容を一時保存
    local saved_reg = vim.fn.getreg('"')
    local saved_regtype = vim.fn.getregtype('"')
    
    -- 通常のヤンク実行
    if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
      vim.cmd('normal! y')
    else
      vim.cmd('normal! yy')  -- ノーマルモードでは行全体
    end
    
    -- ヤンクした内容をWindowsクリップボードに送信

    local yanked_text = vim.fn.getreg('"')
    if yanked_text ~= "" then
      vim.fn.system('clip.exe', yanked_text)
    end
    

    -- 無名レジスタを元に戻す（他のレジスタに影響しない）
    vim.fn.setreg('"', saved_reg, saved_regtype)
  end, { desc = 'Yank to Windows clipboard' })
  
  -- <leader>p でWindowsクリップボードからペースト

  vim.keymap.set('n', '<leader>p', function()
    local clipboard = vim.fn.system('powershell.exe -command "Get-Clipboard" | tr -d "\\r"')
    -- 改行文字の正規化
    clipboard = clipboard:gsub('\r\n', '\n'):gsub('\r', '\n')
    if clipboard:sub(-1) == '\n' then
      clipboard = clipboard:sub(1, -2)
    end
    
    if clipboard ~= "" then
      vim.api.nvim_put(vim.split(clipboard, '\n'), 'l', true, true)
    end
  end, { desc = 'Paste from Windows clipboard' })
  
  -- ビジュアルモードでの<leader>p（選択範囲を置換）
  vim.keymap.set('v', '<leader>p', function()
    local clipboard = vim.fn.system('powershell.exe -command "Get-Clipboard" | tr -d "\\r"')
    clipboard = clipboard:gsub('\r\n', '\n'):gsub('\r', '\n')
    if clipboard:sub(-1) == '\n' then
      clipboard = clipboard:sub(1, -2)
    end
    
    if clipboard ~= "" then
      -- 選択範囲を削除してからペースト
      vim.cmd('normal! d')
      vim.api.nvim_put(vim.split(clipboard, '\n'), 'c', false, true)
    end
  end, { desc = 'Replace selection with Windows clipboard' })

else
  -- 非WSL環境での設定

  if vim.fn.has('mac') == 1 then
    -- macOS環境
    vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
    vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
  elseif vim.fn.has('unix') == 1 then
    -- Linux環境
    if vim.fn.executable('xclip') == 1 then
      vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
      vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
    end
  end
end
