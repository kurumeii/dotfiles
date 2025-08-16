local lint = require('lint')
local utils = require('utils')
local valid_config_file = {
  '.cspell.json',
  '.cspell.yaml',
  '.cspell.yml',
  '.cspell.jsonc',
  '.cspell.config.yaml',
  '.cspell.config.yml',
  'cspell.json',
  'cspell.yaml',
  'cspell.yml',
  'cspell.jsonc',
  'cspell.config.yaml',
  'cspell.config.yml',
}

local H = {}

---@param file string
---@return '.json'|'.yaml'|'.yml'|'.jsonc'
local function read_ext(file)
  return file:match('^.+(%..+)$')
end

function H.config_path()
  for idx, config_file in pairs(valid_config_file) do
    local path = vim.fn.getcwd() .. '/' .. config_file ---@type string
    if vim.uv.fs_stat(path) then
      return path
    elseif idx == #valid_config_file then
      utils.notify_once('Cspell config file not found', 'WARN')
      return nil
    end
  end
end

---@return CspellConfig|nil
function H.read_config()
  local file = H.config_path()
  if not file then
    return nil
  end
  local lines = vim.fn.readfile(file)
  local ext = read_ext(file)
  local handle_jsonc = function(txt)
    local ok, decoded = pcall(vim.json.decode, txt)
    if not ok then
      utils.notify('Failed to decode json file: ' .. decoded, 'ERROR')
      return nil
    end
    return decoded
  end
  if ext == '.json' or ext == '.jsonc' then
    return handle_jsonc(table.concat(lines, '\n'))
  elseif ext == '.yaml' or ext == '.yml' then
    local cmd = string.format('yq eval -Pj %s', file)
    local process, err = io.popen(cmd)
    if err or not process then
      utils.notify('Failed to run yq: ' .. err, 'ERROR')
    else
      local json_str = process:read('*a')
      process:close()
      return handle_jsonc(json_str)
    end
  else
    utils.notify('Unsupported file type', 'ERROR')
    return nil
  end
end

---@param content CspellConfig
function H.write_config(content)
  local file_path = H.config_path()
  if not file_path then
    return
  end
  local ext = read_ext(file_path)
  local json_encoded = vim.json.encode(content)
  if ext == '.yml' or ext == '.yaml' then
    local cmd = string.format('yq eval -P - > %s', file_path)
    local process, err = io.popen(cmd, 'w')
    if err or not process then
      utils.notify('Failed to run yq: ' .. err, 'ERROR')
      return
    end
    process:write(json_encoded)
    process:close()
  elseif ext == '.json' or ext == '.jsonc' then
    local process, err = io.open(file_path, 'w')
    if not process or err then
      utils.notify('Failed to open file: ' .. err, 'ERROR')
      return
    end
    process:write(json_encoded)
    process:close()
  else
  end
end

---@param dict_path string
---@param word string
function H.append_word(dict_path, word)
  local fd = io.open(dict_path, 'a+')
  if not fd then
    return
  end
  fd:write(word .. '\n')
  fd:close()
end

---@param word table<string> | string
function H.add_to_right_place(word)
  local config = H.read_config()
  if not config then
    return
  end
  local dicts = config.dictionaryDefinitions or {}
  local adaptive_add = function(dict_path)
    if type(word) == 'table' and #word > 1 then
      for _, w in ipairs(word) do
        H.append_word(dict_path, w)
      end
    elseif type(word) == 'string' then
      H.append_word(dict_path, word)
    else
      utils.notify('Unsupported type', 'ERROR')
    end
  end
  -- If there is no dictionary
  if #dicts == 0 then
    config.words = config.words or {}
    if type(word) == 'table' then
      for _, w in pairs(word) do
        table.insert(config.words, w)
      end
    else
      table.insert(config.words, word)
    end
    H.write_config(config)
  elseif #dicts == 1 then
    --  If there is only one dictionary
    adaptive_add(dicts[1].path)
  else
    -- Show ui select
    vim.ui.select(dicts, {
      prompt = 'Select dictionary: ',
      format_item = function(item)
        return 'Add to dictionary: ' .. item.name
      end,
    }, function(d)
      if not d then
        utils.notify('Cancelled', 'WARN')
        return
      end
      adaptive_add(d.path)
    end)
  end
end

local file = H.config_path()
if not file then
  return nil
else
  lint.linters_by_ft = {
    ['*'] = { 'cspell' },
  }
  lint.linters.cspell = function()
    local default_config = require('lint.linters.cspell')
    local config = vim.deepcopy(default_config)
    config.args = {
      'lint',
      '--no-color',
      '--no-progress',
      '--no-summary',
      type(H.config_path()) == 'string' and '--config=' .. H.config_path() or '',
      function()
        return 'stdin://' .. vim.api.nvim_buf_get_name(0)
      end,
    }
    return config
  end
end

utils.map('n', utils.L('csc'), function()
  vim.ui.select({ 'yaml', 'json' }, {
    prompt = 'Choose a cspell config file',
    format_item = function(item)
      return 'Create cspell.' .. item
    end,
  }, function(choice)
    if not choice then
      return utils.notify('Cancelled!', 'INFO')
    end
    local result = os.execute('cspell init --format ' .. choice .. ' --locale en,vi')
    if result then
      utils.notify('Created config file', 'INFO')
    else
      utils.notify('Failed to create ' .. choice .. ' error: ' .. result, 'ERROR')
    end
  end)
end, 'Code create a config file')
utils.map('n', utils.L('csw'), function()
  vim.ui.input({ prompt = 'Enter the word to add to the dictionary: ' }, function(word)
    if not word or word == '' then
      return utils.notify('Cancelled input', 'WARN')
    end
    local config = H.read_config()
    if not config then
      return
    end
    -- Add word to right place
    H.add_to_right_place(word)
    vim.cmd('e!')
  end)
end, 'Code add word to dictionary')
utils.map('n', utils.L('csW'), function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
  local diagnostics = vim.diagnostic.get(bufnr, {
    lnum = cursor[1] - 1,
    severity = 'INFO',
  })
  local diagnostics_map = {}
  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.source == 'cspell' then
      table.insert(diagnostics_map, diagnostic)
    end
  end
  -- E.g. "Unknown word ( word )"
  local word = diagnostics_map[1].message:match('%((.+)%)') ---@type string?
  if not word then
    return
  end
  local result = vim.fn.confirm('Add ' .. word .. ' to dictionary ?', '&Yes\n&No', 1, 'Question')
  if result ~= 1 then
    utils.notify('Cancelled', 'WARN')
    return
  end
  local config = H.read_config()
  if not config then
    return
  end
  H.add_to_right_place(word)
  vim.cmd('e!')
end, 'Code add diagnostic word to dictionary')
utils.map('n', utils.L('csa'), function()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)
  local word_to_add = {} ---@type string[]
  for _, diagnostic in pairs(diagnostics) do
    if diagnostic.source == 'cspell' then
      local word = diagnostic.message:match('%((.+)%)')
      table.insert(word_to_add, word)
    end
  end
  if #word_to_add == 0 then
    utils.notify('No word to add', 'INFO')
    return
  end
  word_to_add = utils.uniq(word_to_add)
  local result = vim.fn.confirm('Add ' .. #word_to_add .. ' word to dictionary ?', '\v&Yes\n&No', 1, 'Question')
  if result ~= 1 then
    utils.notify('Cancelled', 'WARN')
    return
  end
  local config = H.read_config()
  if not config then
    return
  end
  H.add_to_right_place(word_to_add)
  vim.cmd('e!')
end, 'Code add all diagnostic words to dictionary')
