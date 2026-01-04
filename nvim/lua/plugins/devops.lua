return {
  -- Kubectl intégration pour Kubernetes
  {
    "ramilito/kubectl.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Kubectl" },
    keys = {
      { "<leader>k", "<cmd>Kubectl<cr>", desc = "Kubectl" },
    },
    config = function()
      require("kubectl").setup()
    end,
  },

  -- Helm charts support
  {
    "towolf/vim-helm",
    ft = "helm",
  },

  -- Terraform support avec formatage automatique
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf", "hcl" },
    config = function()
      vim.g.terraform_fmt_on_save = 1
      vim.g.terraform_align = 1
    end,
  },

  -- Ansible support
  {
    "pearofducks/ansible-vim",
    ft = { "yaml.ansible", "ansible" },
    config = function()
      vim.g.ansible_unindent_after_newline = 1
      vim.g.ansible_attribute_highlight = "ab"
      vim.g.ansible_name_highlight = "b"
      vim.g.ansible_extra_keywords_highlight = 1
    end,
  },

  -- YAML avec schémas
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>yv", "<cmd>YAMLView<cr>", desc = "YAML View" },
      { "<leader>yt", "<cmd>YAMLTelescope<cr>", desc = "YAML Telescope" },
    },
  },

  -- Systemd syntax
  {
    "wgwoods/vim-systemd-syntax",
    ft = { "systemd" },
  },
}
