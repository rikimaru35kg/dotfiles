return {
  {
    "nvim-mini/mini.bufremove",
    version = "*",
    keys = {
      {
        "Q",
        function() require("mini.bufremove").delete(0, false) end,
        desc = "Delete buffer (keep window)",
      },
    },
  },
}

