return {
  {
    "krisajenkins/telescope-docker.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>Dp", "<cmd>Telescope telescope_docker docker_ps<cr>", desc = "Docker containers" },
      { "<leader>Di", "<cmd>Telescope telescope_docker docker_images<cr>", desc = "Docker images" },
      { "<leader>Dv", "<cmd>Telescope telescope_docker docker_volumes<cr>", desc = "Docker volumes" },
    },
    config = function()
      require("telescope").load_extension("telescope_docker")
      require("telescope_docker").setup({})
    end,
  },
}
