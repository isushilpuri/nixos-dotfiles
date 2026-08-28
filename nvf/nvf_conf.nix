{pkgs, lib, ...}:

{
  vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    statusline.lualine.enable = true;
    telescope = {
          enable = true;
          extensions = [
            {
              name = "fzf";
              packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
              setup = {
                fzf = {
                  fuzzy = true;
                  override_file_sorter = true;
                  override_generic_sorter = true;
                  case_mode = "smart_case";
                };
              };
            }
          ];
          setupOpts = {
            defaults = {
              layout_config.horizontal.prompt_position = "top";
              sorting_strategy = "ascending";
            };
            pickers.find_files.hidden = true;
          };
    };
    autocomplete.nvim-cmp.enable = true;

    languages = {
      # enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      rust.enable = true;
      python.enable = true;
    };

    formatter.conform-nvim = {
      enable = true;
    };

    options = {
          # general settings
          clipboard = "unnamedplus";
          mouse = "a";
          splitbelow = true;
          splitright = true;
          timeoutlen = 500;
          termguicolors = true;
          completeopt = "menuone,noselect";
          updatetime = 300;

          # tab settings
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
          expandtab = true;
          shiftround = true;
          autoindent = true;
          smartindent = true;
    };

    globals.mapleader = " ";
    keymaps = [
          {
            mode = "i";
            key = "kj";
            action = "<Esc>";
            silent = false;
          }
          {
            mode = "n";
            key = "<leader>w";
            action = ":w<CR>";
            silent = false;
          }
          {
            mode = "n";
            key = "<leader>q";
            action = ":q<CR>";
            silent = false;
          }
          {
            mode = "n";
            key = "<leader>ff";
            action = "<cmd>Telescope find_files<CR>";
          }
          {
            mode = "n";
            key = "<leader>fg";
            action = "<cmd>Telescope live_grep<CR>";
          }
          {
            mode = "n";
            key = "<leader>fb";
            action = "<cmd>Telescope buffers<CR>";
          }
          {
            mode = "n";
            key = "<leader>fh";
            action = "<cmd>Telescope help_tags<CR>";
          }
          {
            mode = "n";
            key = "<leader>lp";
            action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
          }
    ];

    
    git = {
        enable = true;
        gitsigns = {
          enable = true;
          setupOpts = {
            attach_to_untracked = true;
            current_line_blame = true;
            current_line_blame_opts = {
              delay = 0;
              virt_text_pos = "eol";
            };
          };
        };
    };

    terminal.toggleterm = {
          enable = true;
          lazygit = {
            enable = true;
            mappings.open = "<leader>lg";
          };
    };

    dashboard.dashboard-nvim = {
      enable = true;
      setupOpts = {
        theme = "doom";
        config = {
          header = [
            "┌───────────────────────────┐"
            "│   Welcome back, Sushil K! │"
            "└───────────────────────────┘"
          ];
          center = [
            { icon = " "; desc = "Find file"; key = "f"; action = "Telescope find_files"; }
            { icon = " "; desc = "Live grep"; key = "g"; action = "Telescope live_grep"; }
            { icon = " "; desc = "File tree"; key = "e"; action = "NvimTreeToggle"; }
            { icon = " "; desc = "Quit"; key = "q"; action = "qa"; }
          ];
          footer = [ "Tip: press ? for which-key" ];
        };
      };
    };
  };  
}
