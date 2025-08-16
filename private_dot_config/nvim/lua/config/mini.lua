local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'

--- Use uv for later versions of Neovim
if not (vim.uv or vim.loop).fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.vim`" | redraw')
end
require('mini.deps').setup({ path = { package = path_package } })

local H = {}

---@param lazy boolean
---@param cb function
local adaptive_func = function(lazy, cb)
  return lazy and MiniDeps.later(cb) or MiniDeps.now(cb)
end

---@param specs MiniLoadSpec
local load = function(specs)
  if specs.disable then
    return
  end
  local is_git = specs.source:find('/') ~= nil
  local get_mod_name = function()
    if is_git then
      return specs.name or specs.source:match('.*/(.*)')
    else
      return specs.source
    end
  end
  local after_script = function()
    local mod_name = get_mod_name()
    if specs.cb then
      local ok, err = pcall(specs.cb)
      if not ok then
        vim.notify('Callback error in: ' .. specs.source .. '\n\t' .. tostring(err), vim.log.levels.ERROR)
      end
    elseif specs.opts then
      require(mod_name).setup(specs.opts)
    else
      require(mod_name)
    end
  end
  return adaptive_func(specs.lazy, function()
    if is_git then
      MiniDeps.add({
        source = specs.source,
        name = specs.name,
        depends = specs.depends,
        hooks = specs.hooks,
        monitor = specs.version,
      })
      after_script()
    else
      after_script()
    end
  end)
end

--- @param specs MiniLoadSpec[]
H.setup = function(specs)
  local total_specs = #specs
  local current_idx = 1

  local function load_next()
    local batch_size = 5
    local batch_end = math.min(current_idx + batch_size - 1, total_specs)
    for i = current_idx, batch_end do
      load(specs[i])
    end
    current_idx = batch_end + 1
    if current_idx <= total_specs then
      vim.schedule(load_next)
    else
      vim.schedule(function()
        vim.notify_once('MiniNvim: All plugins loaded!', vim.log.levels.INFO)
      end)
    end
  end

  load_next()
end

return H
