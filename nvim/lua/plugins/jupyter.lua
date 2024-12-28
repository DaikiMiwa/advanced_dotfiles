return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_text_output = true
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_location = "float"
      local api = vim.api

      -- 名前空間を作成
      local namespace_id = api.nvim_create_namespace "molten_cells"

      -- セルを定義する関数
      local function define_cells()
        local buf = api.nvim_get_current_buf()
        local lines = api.nvim_buf_get_lines(buf, 0, -1, false)

        -- 既存のextmarksを削除
        api.nvim_buf_clear_namespace(buf, namespace_id, 0, -1)

        -- セルの開始位置を記録
        local cell_starts = {}
        for i, line in ipairs(lines) do
          if line:match "^# %%%%" then
            table.insert(cell_starts, i) -- 1インデックス
          end
        end

        -- セルをextmarksで定義
        for idx, start_line in ipairs(cell_starts) do
          local end_line = cell_starts[idx + 1] and (cell_starts[idx + 1] - 1) or #lines

          -- 開始マーク
          local start_mark_id = api.nvim_buf_set_extmark(buf, namespace_id, start_line - 1, 0, {
            id = start_line,
          })

          -- 終了マーク
          local end_mark_id = api.nvim_buf_set_extmark(buf, namespace_id, end_line - 1, 0, {
            id = end_line,
          })
        end
      end

      -- 現在のセルの範囲を取得
      local function get_active_cell()
        local buf = api.nvim_get_current_buf()
        local cursor = api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1 -- 0インデックス

        local extmarks = api.nvim_buf_get_extmarks(buf, namespace_id, 0, -1, {})
        for i = 1, #extmarks, 2 do
          local start_mark = extmarks[i]
          local end_mark = extmarks[i + 1]

          if start_mark and end_mark then
            local start_row, end_row = start_mark[2], end_mark[2]
            if row >= start_row and row <= end_row then
              return {
                start_row = start_row,
                end_row = end_row,
                next_start = extmarks[i + 2] and extmarks[i + 2][2] or nil,
              }
            end
          end
        end
        return nil
      end

      -- アクティブセルを評価し、次のセルに遷移する関数
      local function evaluate_and_move_to_next_cell()
        -- extmarksを初期化
        define_cells()

        local cell = get_active_cell()
        if cell then
          -- セルを評価
          vim.fn.MoltenEvaluateRange(cell.start_row + 1, cell.end_row + 1)

          -- 次のセルに移動
          if cell.next_start then
            api.nvim_win_set_cursor(0, { cell.next_start + 1, 0 }) -- 1インデックスに変換して移動
          end
        end
      end

      api.nvim_create_user_command("EvaluateAndMoveToNextCell", function() evaluate_and_move_to_next_cell() end, {})

      -- キーマップに登録
      api.nvim_set_keymap("n", "<leader>mm", ":EvaluateAndMoveToNextCell<CR>", { noremap = true, silent = true })
    end,
    config = function()
      vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
      vim.keymap.set("n", "<leader>mo", ":MoltenShowOutput<CR>", { silent = true, desc = "Show Output" })
      vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "Hide Output" })
    end,
  },
}
