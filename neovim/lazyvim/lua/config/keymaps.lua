-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "<localleader>ip", function()
  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if venv ~= nil then
    -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
    venv = string.match(venv, "/.+/(.+)")
    vim.cmd(("MoltenInit %s"):format(venv))
  else
    vim.cmd("MoltenInit python3")
  end
end, { desc = "Initialize Molten for python3", silent = true })

vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator", silent = true })
vim.keymap.set(
  "n",
  "<localleader>os",
  ":noautocmd MoltenEnterOutput<CR>",
  { desc = "open output window", silent = true }
)
vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
vim.keymap.set(
  "v",
  "<localleader>r",
  ":<C-u>MoltenEvaluateVisual<CR>gv",
  { desc = "execute visual selection", silent = true }
)
vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })

-- if you work with html outputs:
vim.keymap.set("n", "<localleader>mx", ":MoltenOpenInBrowser<CR>", { desc = "open output in browser", silent = true })

-- quarto keymaps
local runner = require("quarto.runner")
vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
vim.keymap.set("n", "<localleader>RA", function()
  runner.run_all(true)
end, { desc = "run all cells of all languages", silent = true })

--Toggleterm python keymaps
local python_term = require("toggleterm.terminal").Terminal:new({ cmd = "python3", hidden = true, direction = "float" })
vim.keymap.set("n", "<C-p>", function()
  python_term:toggle()
end, { noremap = true, silent = true })
local molten_term =
  require("toggleterm.terminal").Terminal:new({ cmd = quarto_notebook_cmd, hidden = true, direction = "float" })
vim.keymap.set("n", "<C-p>", function()
  molten_term:toggle()
end, { noremap = true, silent = true })
vim.keymap.set("t", "<C-p>", function()
  vim.cmd("stopinsert")
  molten_term:toggle()
end, { noremap = true, silent = true })
