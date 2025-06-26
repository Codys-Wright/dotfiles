{
  pkgs,
  nvf,
  ...
}: let
  customNeovim = nvf.lib.neovimConfiguration {
    pkgs = pkgs.unstable;
    modules = [
      {
        vim = {
          theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
          };
          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;

          # Mini plugins
          mini = {
            surround.enable = true;
            pairs.enable = true;
            files.enable = true;
            pick.enable = true;
            comment.enable = true;
            indentscope.enable = true;
            cursorword.enable = true;
            hipatterns.enable = true;
            icons.enable = true;
          };

          # Which-key keybind helper
          binds.whichKey = {
            enable = true;
            setupOpts = {
              preset = "helix";
            };
            register = {
              # Group definitions
              "<leader><tab>" = "tabs";
              "<leader>c" = "code";
              "<leader>d" = "debug";
              "<leader>dp" = "profiler";
              "<leader>f" = "file/find";
              "<leader>g" = "git";
              "<leader>gh" = "hunks";
              "<leader>q" = "quit/session";
              "<leader>s" = "search";
              "<leader>u" = "ui";
              "<leader>x" = "diagnostics/quickfix";
              "<leader>b" = "buffer";
              "<leader>w" = "windows";
              "[" = "prev";
              "]" = "next";
              "g" = "goto";
              "gs" = "surround";
              "z" = "fold";

              # Better descriptions
              "gx" = "Open with system app";
            };
          };

          # Custom keymaps for snacks
          keymaps = [
            # Top Pickers & Explorer
            {
              key = "<leader><space>";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.smart()<CR>";
              silent = true;
              desc = "Smart Find Files";
            }
            {
              key = "<leader>,";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.buffers()<CR>";
              silent = true;
              desc = "Buffers";
            }
            {
              key = "<leader>/";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.grep()<CR>";
              silent = true;
              desc = "Grep";
            }
            {
              key = "<leader>:";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.command_history()<CR>";
              silent = true;
              desc = "Command History";
            }
            {
              key = "<leader>e";
              mode = ["n"];
              action = "<cmd>lua Snacks.explorer()<CR>";
              silent = true;
              desc = "File Explorer";
            }

            # Find
            {
              key = "<leader>fb";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.buffers()<CR>";
              silent = true;
              desc = "Buffers";
            }
            {
              key = "<leader>fc";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<CR>";
              silent = true;
              desc = "Find Config File";
            }
            {
              key = "<leader>ff";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.files()<CR>";
              silent = true;
              desc = "Find Files";
            }
            {
              key = "<leader>fg";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_files()<CR>";
              silent = true;
              desc = "Find Git Files";
            }
            {
              key = "<leader>fp";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.projects()<CR>";
              silent = true;
              desc = "Projects";
            }
            {
              key = "<leader>fr";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.recent()<CR>";
              silent = true;
              desc = "Recent";
            }

            # Git
            {
              key = "<leader>gb";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_branches()<CR>";
              silent = true;
              desc = "Git Branches";
            }
            {
              key = "<leader>gl";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_log()<CR>";
              silent = true;
              desc = "Git Log";
            }
            {
              key = "<leader>gL";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_log_line()<CR>";
              silent = true;
              desc = "Git Log Line";
            }
            {
              key = "<leader>gs";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_status()<CR>";
              silent = true;
              desc = "Git Status";
            }
            {
              key = "<leader>gS";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_stash()<CR>";
              silent = true;
              desc = "Git Stash";
            }
            {
              key = "<leader>gd";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_diff()<CR>";
              silent = true;
              desc = "Git Diff (Hunks)";
            }
            {
              key = "<leader>gf";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_log_file()<CR>";
              silent = true;
              desc = "Git Log File";
            }

            # Search
            {
              key = "<leader>s\"";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.registers()<CR>";
              silent = true;
              desc = "Registers";
            }
            {
              key = "<leader>s/";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.search_history()<CR>";
              silent = true;
              desc = "Search History";
            }
            {
              key = "<leader>sa";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.autocmds()<CR>";
              silent = true;
              desc = "Autocmds";
            }
            {
              key = "<leader>sb";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lines()<CR>";
              silent = true;
              desc = "Buffer Lines";
            }
            {
              key = "<leader>sB";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.grep_buffers()<CR>";
              silent = true;
              desc = "Grep Open Buffers";
            }
            {
              key = "<leader>sc";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.command_history()<CR>";
              silent = true;
              desc = "Command History";
            }
            {
              key = "<leader>sC";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.commands()<CR>";
              silent = true;
              desc = "Commands";
            }
            {
              key = "<leader>sd";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.diagnostics()<CR>";
              silent = true;
              desc = "Diagnostics";
            }
            {
              key = "<leader>sD";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.diagnostics_buffer()<CR>";
              silent = true;
              desc = "Buffer Diagnostics";
            }
            {
              key = "<leader>sg";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.grep()<CR>";
              silent = true;
              desc = "Grep";
            }
            {
              key = "<leader>sh";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.help()<CR>";
              silent = true;
              desc = "Help Pages";
            }
            {
              key = "<leader>sH";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.highlights()<CR>";
              silent = true;
              desc = "Highlights";
            }
            {
              key = "<leader>si";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.icons()<CR>";
              silent = true;
              desc = "Icons";
            }
            {
              key = "<leader>sj";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.jumps()<CR>";
              silent = true;
              desc = "Jumps";
            }
            {
              key = "<leader>sk";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.keymaps()<CR>";
              silent = true;
              desc = "Keymaps";
            }
            {
              key = "<leader>sl";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.loclist()<CR>";
              silent = true;
              desc = "Location List";
            }
            {
              key = "<leader>sm";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.marks()<CR>";
              silent = true;
              desc = "Marks";
            }
            {
              key = "<leader>sM";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.man()<CR>";
              silent = true;
              desc = "Man Pages";
            }
            {
              key = "<leader>sp";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lazy()<CR>";
              silent = true;
              desc = "Search for Plugin Spec";
            }
            {
              key = "<leader>sq";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.qflist()<CR>";
              silent = true;
              desc = "Quickfix List";
            }
            {
              key = "<leader>sR";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.resume()<CR>";
              silent = true;
              desc = "Resume";
            }
            {
              key = "<leader>su";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.undo()<CR>";
              silent = true;
              desc = "Undo History";
            }
            {
              key = "<leader>sw";
              mode = ["n" "x"];
              action = "<cmd>lua Snacks.picker.grep_word()<CR>";
              silent = true;
              desc = "Visual selection or word";
            }
            {
              key = "<leader>uC";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.colorschemes()<CR>";
              silent = true;
              desc = "Colorschemes";
            }

            # LSP
            {
              key = "gd";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_definitions()<CR>";
              silent = true;
              desc = "Goto Definition";
            }
            {
              key = "gD";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_declarations()<CR>";
              silent = true;
              desc = "Goto Declaration";
            }
            {
              key = "gr";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_references()<CR>";
              silent = true;
              desc = "References";
            }
            {
              key = "gI";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_implementations()<CR>";
              silent = true;
              desc = "Goto Implementation";
            }
            {
              key = "gy";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_type_definitions()<CR>";
              silent = true;
              desc = "Goto T[y]pe Definition";
            }
            {
              key = "<leader>ss";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_symbols()<CR>";
              silent = true;
              desc = "LSP Symbols";
            }
            {
              key = "<leader>sS";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>";
              silent = true;
              desc = "LSP Workspace Symbols";
            }

            # Other
            {
              key = "<leader>z";
              mode = ["n"];
              action = "<cmd>lua Snacks.zen()<CR>";
              silent = true;
              desc = "Toggle Zen Mode";
            }
            {
              key = "<leader>Z";
              mode = ["n"];
              action = "<cmd>lua Snacks.zen.zoom()<CR>";
              silent = true;
              desc = "Toggle Zoom";
            }
            {
              key = "<leader>.";
              mode = ["n"];
              action = "<cmd>lua Snacks.scratch()<CR>";
              silent = true;
              desc = "Toggle Scratch Buffer";
            }
            {
              key = "<leader>S";
              mode = ["n"];
              action = "<cmd>lua Snacks.scratch.select()<CR>";
              silent = true;
              desc = "Select Scratch Buffer";
            }
            {
              key = "<leader>bd";
              mode = ["n"];
              action = "<cmd>lua Snacks.bufdelete()<CR>";
              silent = true;
              desc = "Delete Buffer";
            }
            {
              key = "<leader>cR";
              mode = ["n"];
              action = "<cmd>lua Snacks.rename.rename_file()<CR>";
              silent = true;
              desc = "Rename File";
            }
            {
              key = "<leader>gB";
              mode = ["n" "v"];
              action = "<cmd>lua Snacks.gitbrowse()<CR>";
              silent = true;
              desc = "Git Browse";
            }
            {
              key = "<leader>gg";
              mode = ["n"];
              action = "<cmd>lua Snacks.lazygit()<CR>";
              silent = true;
              desc = "Lazygit";
            }
            {
              key = "<leader>un";
              mode = ["n"];
              action = "<cmd>lua Snacks.notifier.hide()<CR>";
              silent = true;
              desc = "Dismiss All Notifications";
            }
            {
              key = "<c-/>";
              mode = ["n"];
              action = "<cmd>lua Snacks.terminal()<CR>";
              silent = true;
              desc = "Toggle Terminal";
            }
            {
              key = "<c-_>";
              mode = ["n"];
              action = "<cmd>lua Snacks.terminal()<CR>";
              silent = true;
              desc = "Toggle Terminal";
            }
            {
              key = "]]";
              mode = ["n" "t"];
              action = "<cmd>lua Snacks.words.jump(vim.v.count1)<CR>";
              silent = true;
              desc = "Next Reference";
            }
            {
              key = "[[";
              mode = ["n" "t"];
              action = "<cmd>lua Snacks.words.jump(-vim.v.count1)<CR>";
              silent = true;
              desc = "Prev Reference";
            }

            # Which-key specific keymaps
            {
              key = "<leader>?";
              mode = ["n"];
              action = "<cmd>lua require('which-key').show({ global = false })<CR>";
              silent = true;
              desc = "Buffer Keymaps (which-key)";
            }
            {
              key = "<c-w><space>";
              mode = ["n"];
              action = "<cmd>lua require('which-key').show({ keys = '<c-w>', loop = true })<CR>";
              silent = true;
              desc = "Window Hydra Mode (which-key)";
            }

            # LazyVim base keymaps
            # Better up/down
            {
              key = "j";
              mode = ["n" "x"];
              action = "v:count == 0 ? 'gj' : 'j'";
              expr = true;
              silent = true;
              desc = "Down";
            }
            {
              key = "<Down>";
              mode = ["n" "x"];
              action = "v:count == 0 ? 'gj' : 'j'";
              expr = true;
              silent = true;
              desc = "Down";
            }
            {
              key = "k";
              mode = ["n" "x"];
              action = "v:count == 0 ? 'gk' : 'k'";
              expr = true;
              silent = true;
              desc = "Up";
            }
            {
              key = "<Up>";
              mode = ["n" "x"];
              action = "v:count == 0 ? 'gk' : 'k'";
              expr = true;
              silent = true;
              desc = "Up";
            }

            # Move to window using ctrl hjkl
            {
              key = "<C-h>";
              mode = ["n"];
              action = "<C-w>h";
              desc = "Go to Left Window";
            }
            {
              key = "<C-j>";
              mode = ["n"];
              action = "<C-w>j";
              desc = "Go to Lower Window";
            }
            {
              key = "<C-k>";
              mode = ["n"];
              action = "<C-w>k";
              desc = "Go to Upper Window";
            }
            {
              key = "<C-l>";
              mode = ["n"];
              action = "<C-w>l";
              desc = "Go to Right Window";
            }

            # Resize window using ctrl arrow keys
            {
              key = "<C-Up>";
              mode = ["n"];
              action = "<cmd>resize +2<cr>";
              desc = "Increase Window Height";
            }
            {
              key = "<C-Down>";
              mode = ["n"];
              action = "<cmd>resize -2<cr>";
              desc = "Decrease Window Height";
            }
            {
              key = "<C-Left>";
              mode = ["n"];
              action = "<cmd>vertical resize -2<cr>";
              desc = "Decrease Window Width";
            }
            {
              key = "<C-Right>";
              mode = ["n"];
              action = "<cmd>vertical resize +2<cr>";
              desc = "Increase Window Width";
            }

            # Move Lines
            {
              key = "<A-j>";
              mode = ["n"];
              action = "<cmd>execute 'move .+' . v:count1<cr>==";
              desc = "Move Down";
            }
            {
              key = "<A-k>";
              mode = ["n"];
              action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
              desc = "Move Up";
            }
            {
              key = "<A-j>";
              mode = ["i"];
              action = "<esc><cmd>m .+1<cr>==gi";
              desc = "Move Down";
            }
            {
              key = "<A-k>";
              mode = ["i"];
              action = "<esc><cmd>m .-2<cr>==gi";
              desc = "Move Up";
            }
            {
              key = "<A-j>";
              mode = ["v"];
              action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
              desc = "Move Down";
            }
            {
              key = "<A-k>";
              mode = ["v"];
              action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
              desc = "Move Up";
            }

            # Buffers
            {
              key = "<S-h>";
              mode = ["n"];
              action = "<cmd>bprevious<cr>";
              desc = "Prev Buffer";
            }
            {
              key = "<S-l>";
              mode = ["n"];
              action = "<cmd>bnext<cr>";
              desc = "Next Buffer";
            }
            {
              key = "[b";
              mode = ["n"];
              action = "<cmd>bprevious<cr>";
              desc = "Prev Buffer";
            }
            {
              key = "]b";
              mode = ["n"];
              action = "<cmd>bnext<cr>";
              desc = "Next Buffer";
            }
            {
              key = "<leader>bb";
              mode = ["n"];
              action = "<cmd>e #<cr>";
              desc = "Switch to Other Buffer";
            }
            {
              key = "<leader>`";
              mode = ["n"];
              action = "<cmd>e #<cr>";
              desc = "Switch to Other Buffer";
            }
            {
              key = "<leader>bo";
              mode = ["n"];
              action = "<cmd>lua Snacks.bufdelete.other()<cr>";
              desc = "Delete Other Buffers";
            }
            {
              key = "<leader>bD";
              mode = ["n"];
              action = "<cmd>bd<cr>";
              desc = "Delete Buffer and Window";
            }

            # Clear search with escape
            {
              key = "<esc>";
              mode = ["i" "n" "s"];
              action = "<cmd>noh<cr><esc>";
              desc = "Escape and Clear hlsearch";
            }

            # Clear search, diff update and redraw
            {
              key = "<leader>ur";
              mode = ["n"];
              action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
              desc = "Redraw / Clear hlsearch / Diff Update";
            }

            # Better search behavior
            {
              key = "n";
              mode = ["n"];
              action = "'Nn'[v:searchforward].'zv'";
              expr = true;
              desc = "Next Search Result";
            }
            {
              key = "n";
              mode = ["x"];
              action = "'Nn'[v:searchforward]";
              expr = true;
              desc = "Next Search Result";
            }
            {
              key = "n";
              mode = ["o"];
              action = "'Nn'[v:searchforward]";
              expr = true;
              desc = "Next Search Result";
            }
            {
              key = "N";
              mode = ["n"];
              action = "'nN'[v:searchforward].'zv'";
              expr = true;
              desc = "Prev Search Result";
            }
            {
              key = "N";
              mode = ["x"];
              action = "'nN'[v:searchforward]";
              expr = true;
              desc = "Prev Search Result";
            }
            {
              key = "N";
              mode = ["o"];
              action = "'nN'[v:searchforward]";
              expr = true;
              desc = "Prev Search Result";
            }

            # Add undo break-points
            {
              key = ",";
              mode = ["i"];
              action = ",<c-g>u";
              silent = true;
            }
            {
              key = ".";
              mode = ["i"];
              action = ".<c-g>u";
              silent = true;
            }
            {
              key = ";";
              mode = ["i"];
              action = ";<c-g>u";
              silent = true;
            }

            # Save file
            {
              key = "<C-s>";
              mode = ["i" "x" "n" "s"];
              action = "<cmd>w<cr><esc>";
              desc = "Save File";
            }

            # Keywordprg
            {
              key = "<leader>K";
              mode = ["n"];
              action = "<cmd>norm! K<cr>";
              desc = "Keywordprg";
            }

            # Better indenting
            {
              key = "<";
              mode = ["v"];
              action = "<gv";
              silent = true;
            }
            {
              key = ">";
              mode = ["v"];
              action = ">gv";
              silent = true;
            }

            # Commenting
            {
              key = "gco";
              mode = ["n"];
              action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
              desc = "Add Comment Below";
            }
            {
              key = "gcO";
              mode = ["n"];
              action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
              desc = "Add Comment Above";
            }

            # Lazy
            {
              key = "<leader>l";
              mode = ["n"];
              action = "<cmd>Lazy<cr>";
              desc = "Lazy";
            }

            # New file
            {
              key = "<leader>fn";
              mode = ["n"];
              action = "<cmd>enew<cr>";
              desc = "New File";
            }

            # Location list
            {
              key = "<leader>xl";
              mode = ["n"];
              action = "<cmd>lua vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose() or vim.cmd.lopen()<cr>";
              desc = "Location List";
            }

            # Quickfix list
            {
              key = "<leader>xq";
              mode = ["n"];
              action = "<cmd>lua vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose() or vim.cmd.copen()<cr>";
              desc = "Quickfix List";
            }
            {
              key = "[q";
              mode = ["n"];
              action = "<cmd>cprev<cr>";
              desc = "Previous Quickfix";
            }
            {
              key = "]q";
              mode = ["n"];
              action = "<cmd>cnext<cr>";
              desc = "Next Quickfix";
            }

            # Diagnostics
            {
              key = "<leader>cd";
              mode = ["n"];
              action = "<cmd>lua vim.diagnostic.open_float()<cr>";
              desc = "Line Diagnostics";
            }
            {
              key = "]d";
              mode = ["n"];
              action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
              desc = "Next Diagnostic";
            }
            {
              key = "[d";
              mode = ["n"];
              action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
              desc = "Prev Diagnostic";
            }
            {
              key = "]e";
              mode = ["n"];
              action = "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>";
              desc = "Next Error";
            }
            {
              key = "[e";
              mode = ["n"];
              action = "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>";
              desc = "Prev Error";
            }
            {
              key = "]w";
              mode = ["n"];
              action = "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })<cr>";
              desc = "Next Warning";
            }
            {
              key = "[w";
              mode = ["n"];
              action = "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })<cr>";
              desc = "Prev Warning";
            }

            # Git Browse
            {
              key = "<leader>gY";
              mode = ["n" "x"];
              action = "<cmd>lua Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end, notify = false })<cr>";
              desc = "Git Browse (copy)";
            }

            # Quit
            {
              key = "<leader>qq";
              mode = ["n"];
              action = "<cmd>qa<cr>";
              desc = "Quit All";
            }

            # Highlights under cursor
            {
              key = "<leader>ui";
              mode = ["n"];
              action = "<cmd>lua vim.show_pos()<cr>";
              desc = "Inspect Pos";
            }
            {
              key = "<leader>uI";
              mode = ["n"];
              action = "<cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input('I')<cr>";
              desc = "Inspect Tree";
            }

            # Terminal mappings in terminal mode
            {
              key = "<C-/>";
              mode = ["t"];
              action = "<cmd>close<cr>";
              desc = "Hide Terminal";
            }
            {
              key = "<c-_>";
              mode = ["t"];
              action = "<cmd>close<cr>";
              desc = "Hide Terminal";
            }

            # Windows
            {
              key = "<leader>-";
              mode = ["n"];
              action = "<C-W>s";
              desc = "Split Window Below";
            }
            {
              key = "<leader>|";
              mode = ["n"];
              action = "<C-W>v";
              desc = "Split Window Right";
            }
            {
              key = "<leader>wd";
              mode = ["n"];
              action = "<C-W>c";
              desc = "Delete Window";
            }

            # Tabs
            {
              key = "<leader><tab>l";
              mode = ["n"];
              action = "<cmd>tablast<cr>";
              desc = "Last Tab";
            }
            {
              key = "<leader><tab>o";
              mode = ["n"];
              action = "<cmd>tabonly<cr>";
              desc = "Close Other Tabs";
            }
            {
              key = "<leader><tab>f";
              mode = ["n"];
              action = "<cmd>tabfirst<cr>";
              desc = "First Tab";
            }
            {
              key = "<leader><tab><tab>";
              mode = ["n"];
              action = "<cmd>tabnew<cr>";
              desc = "New Tab";
            }
            {
              key = "<leader><tab>]";
              mode = ["n"];
              action = "<cmd>tabnext<cr>";
              desc = "Next Tab";
            }
            {
              key = "<leader><tab>d";
              mode = ["n"];
              action = "<cmd>tabclose<cr>";
              desc = "Close Tab";
            }
            {
              key = "<leader><tab>[";
              mode = ["n"];
              action = "<cmd>tabprevious<cr>";
              desc = "Previous Tab";
            }

            # UI Plugin keymaps
            # Bufferline keymaps
            {
              key = "<leader>bp";
              mode = ["n"];
              action = "<cmd>BufferLineTogglePin<cr>";
              desc = "Toggle Pin";
            }
            {
              key = "<leader>bP";
              mode = ["n"];
              action = "<cmd>BufferLineGroupClose ungrouped<cr>";
              desc = "Delete Non-Pinned Buffers";
            }
            {
              key = "<leader>br";
              mode = ["n"];
              action = "<cmd>BufferLineCloseRight<cr>";
              desc = "Delete Buffers to the Right";
            }
            {
              key = "<leader>bl";
              mode = ["n"];
              action = "<cmd>BufferLineCloseLeft<cr>";
              desc = "Delete Buffers to the Left";
            }
            {
              key = "[B";
              mode = ["n"];
              action = "<cmd>BufferLineMovePrev<cr>";
              desc = "Move buffer prev";
            }
            {
              key = "]B";
              mode = ["n"];
              action = "<cmd>BufferLineMoveNext<cr>";
              desc = "Move buffer next";
            }

            # Noice keymaps
            {
              key = "<S-Enter>";
              mode = ["c"];
              action = "<cmd>lua require('noice').redirect(vim.fn.getcmdline())<cr>";
              desc = "Redirect Cmdline";
            }
            {
              key = "<leader>snl";
              mode = ["n"];
              action = "<cmd>lua require('noice').cmd('last')<cr>";
              desc = "Noice Last Message";
            }
            {
              key = "<leader>snh";
              mode = ["n"];
              action = "<cmd>lua require('noice').cmd('history')<cr>";
              desc = "Noice History";
            }
            {
              key = "<leader>sna";
              mode = ["n"];
              action = "<cmd>lua require('noice').cmd('all')<cr>";
              desc = "Noice All";
            }
            {
              key = "<leader>snd";
              mode = ["n"];
              action = "<cmd>lua require('noice').cmd('dismiss')<cr>";
              desc = "Dismiss All";
            }
            {
              key = "<leader>snt";
              mode = ["n"];
              action = "<cmd>lua require('noice').cmd('pick')<cr>";
              desc = "Noice Picker";
            }
            {
              key = "<c-f>";
              mode = ["i" "n" "s"];
              action = "<cmd>lua if not require('noice.lsp').scroll(4) then return '<c-f>' end<cr>";
              expr = true;
              silent = true;
              desc = "Scroll Forward";
            }
            {
              key = "<c-b>";
              mode = ["i" "n" "s"];
              action = "<cmd>lua if not require('noice.lsp').scroll(-4) then return '<c-b>' end<cr>";
              expr = true;
              silent = true;
              desc = "Scroll Backward";
            }
          ];

          # Snacks.nvim utility collection
          utility.snacks-nvim = {
            enable = true;
            setupOpts = {
              bigfile = {enabled = true;};
              dashboard = {enabled = false;}; # Disable dashboard to avoid lazy.nvim dependency
              explorer = {enabled = true;};
              indent = {enabled = true;};
              input = {enabled = true;};
              picker = {enabled = true;};
              notifier = {enabled = true;};
              quickfile = {enabled = true;};
              scope = {enabled = true;};
              scroll = {enabled = true;};
              statuscolumn = {enabled = true;};
              words = {enabled = true;};
            };
          };

          assistant = {
            avante-nvim.enable = true;
          };

          lsp.enable = true;
          treesitter.enable = true;

          languages = {
            nix.enable = true;
            ts.enable = true;
            rust.enable = true;
            markdown.enable = true;
            html.enable = true;
            clang.enable = true;
            sql.enable = true;
            lua.enable = true;
            python.enable = true;
          };

          # UI Components
          ui.noice = {
            enable = true;
            setupOpts = {
              lsp = {
                override = {
                  "vim.lsp.util.convert_input_to_markdown_lines" = true;
                  "vim.lsp.util.stylize_markdown" = true;
                  "cmp.entry.get_documentation" = true;
                };
              };
              routes = [
                {
                  filter = {
                    event = "msg_show";
                    any = [
                      {find = "%d+L, %d+B";}
                      {find = "; after #%d+";}
                      {find = "; before #%d+";}
                    ];
                  };
                  view = "mini";
                }
              ];
              presets = {
                bottom_search = true;
                command_palette = true;
                long_message_to_split = true;
              };
            };
          };

          # Bufferline/Tabline
          tabline.nvimBufferline = {
            enable = true;
            mappings = {
              closeCurrent = "<leader>bd";
              cycleNext = "<S-l>";
              cyclePrevious = "<S-h>";
              moveNext = "]B";
              movePrevious = "[B";
              pick = "<leader>bc";
            };
            setupOpts = {
              options = {
                diagnostics = "nvim_lsp";
                always_show_bufferline = false;
                offsets = [
                  {
                    filetype = "neo-tree";
                    text = "Neo-tree";
                    highlight = "Directory";
                    text_align = "left";
                  }
                  {
                    filetype = "snacks_layout_box";
                  }
                ];
              };
            };
          };
        };
      }
    ];
  };
in {
  home.packages = [customNeovim.neovim];
}
