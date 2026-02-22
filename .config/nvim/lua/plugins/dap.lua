return {
  -- DAP UI + 依存プラグイン
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
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
      -- ★ codelldb アダプタ設定（WSL2 用）
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
      -- ★ DAP UI の設定
      ---------------------------------------------------------
      dapui.setup()
      -- vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end, {desc="Toggle Breakpoint"})
      -- vim.keymap.set("n", "<F5>", function() require("dap").continue() end, {desc="DAP Continue"})
      -- vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, {desc="DAP StepOver"})
      -- vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, {desc="DAP StepInto"})
      -- vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, {desc="DAP StepOut"})

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
