-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- The following is the quarto and molten settings
--
-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
-- You can then use :NewNotebook folder/notebook_name to start a new notebook from scratch!
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      
     
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      
     
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. ".ipynb"
  local file = io.open(path, "w")
  if file then
    file:write(default_notebook)
    file:close()
    vim.cmd("edit " .. path)
  else
    print("Error: Could not open new notebook file for writing.")
  end
end

vim.api.nvim_create_user_command("NewNotebook", function(opts)
  new_notebook(opts.args)
end, {
  nargs = 1,
  complete = "file",
})

--For toggleterm
local function markdown_codeblock(language, content)
  return "\\`\\`\\`{" .. language .. "}\n" .. content .. "\n\\`\\`\\`"
end

local quarto_notebook_cmd = 'nvim -c enew -c "set filetype=quarto"'
  .. ' -c "norm GO## IPython\nThis is Quarto IPython notebook. Syntax is the same as in markdown\n\n'
  .. markdown_codeblock("python", "# enter code here\n")
  .. '"'
  .. ' -c "norm Gkk"'
  -- This line needed because QuartoActivate and MoltenInit commands must be accessible; should be adjusted depending on plugin manager
  .. " -c \"lua require('lazy.core.loader').load({'molten-nvim', 'quarto-nvim'}, {cmd = 'Lazy load'})\""
  .. ' -c "MoltenInit python3" -c QuartoActivate -c startinsert'
