return {
  {
    "krisajenkins/telescope-docker.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("telescope_docker")
      require("telescope_docker").setup({})
      vim.keymap.set("n", "<leader>Dp", "<cmd>Telescope telescope_docker docker_ps<cr>", { desc = "Docker containers" })
      vim.keymap.set("n", "<leader>Di", "<cmd>Telescope telescope_docker docker_images<cr>", { desc = "Docker images" })
      vim.keymap.set(
        "n",
        "<leader>Dv",
        "<cmd>Telescope telescope_docker docker_volumes<cr>",
        { desc = "Docker volumes" }
      )
    end,
  },
}
