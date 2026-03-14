return {
  -- DAP UI + 依存プラグイン
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<F9>",  function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<F5>",  function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP StepOver" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP StepInto" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP StepOut" },
      { "<F6>", function()
          require("dap").terminate()
          require("dap").disconnect()
          require("dapui").close()
        end, desc = "DAP Terminate"
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      ---------------------------------------------------------
      -- ★ codelldb アダプタ設定
      ---------------------------------------------------------
      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb", -- PATH にある場合はこれでOK
      }

      ---------------------------------------------------------
      -- ★ C/C++ のデバッグ設定
      ---------------------------------------------------------
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      ---------------------------------------------------------
      -- ★ Python デバッガ（nvim-dap-python）
      ---------------------------------------------------------
      -- ① アダプタ用: Mason の debugpy を使う（仮想環境を汚さない）
      local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_debugpy)

      -- ② 実行対象用: Poetry の venv Python を自動検出
      local function get_poetry_python()
        -- Poetry venv のパスを取得（プロジェクト直下で Neovim を開いている想定）
        local venv = vim.fn.trim(vim.fn.system("poetry env info --path"))
        local py = venv .. "/bin/python"               -- Linux/WSL
        if vim.fn.has("win32") == 1 then
          py = venv .. "\\Scripts\\python.exe"         -- Windows
        end
        if vim.v.shell_error ~= 0 or vim.fn.executable(py) ~= 1 then
          return nil
        end
        return py
      end

      -- ③ DAP の起動設定で、実行時 Python を Poetry venv にする
      local dap = require("dap")
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Debug current file (Poetry venv)",
          program = "${file}",
          console = "integratedTerminal",  -- 入力が必要なら
          justMyCode = true,
          pythonPath = function()
            local p = get_poetry_python()
            if p and vim.fn.executable(p) == 1 then
              return p
            end
            if vim.fn.executable("python") == 1 then
              return "python"
            end
            return "python3"
          end,

        },
      }

      ---------------------------------------------------------
      -- ★ DAP UI の設定
      ---------------------------------------------------------
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      ---------------------------------------------------------
      -- ★ ブレークポイントの色・アイコンを見やすくする設定
      ---------------------------------------------------------
      -- 色を明るく上書き
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF5555" })        -- 赤
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#FFAA00" }) -- オレンジ
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00FF00" })           -- 緑

      -- アイコンを VSCode 風に変更
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped" })
    end,
  },
}
