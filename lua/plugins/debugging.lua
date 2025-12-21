return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
    },
    ft = { "python", "cpp", "cuda", "c" },
    config = function()
      require("config.debugging")
    end,
  },
}
