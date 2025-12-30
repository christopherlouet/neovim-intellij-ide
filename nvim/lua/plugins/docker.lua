return {
  {
    "krisajenkins/telescope-docker.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("telescope_docker")
      require("telescope_docker").setup({})
      vim.keymap.set("n", "<leader>dp", "<cmd>Telescope telescope_docker docker_ps<cr>", { desc = "Docker containers" })
      vim.keymap.set("n", "<leader>di", "<cmd>Telescope telescope_docker docker_images<cr>", { desc = "Docker images" })
      vim.keymap.set("n", "<leader>dv", "<cmd>Telescope telescope_docker docker_volumes<cr>", { desc = "Docker volumes" })
    end,
  },
}
