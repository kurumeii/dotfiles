---@class  CspellConfig.dictionaryDefinitions
---@field name string
---@field path string

---@class CspellConfig
---@field dictionaryDefinitions CspellConfig.dictionaryDefinitions[]
---@field dictionaries string[]
---@field words string[]

---@alias MiniHookFunction fun(param: { path: string, source: string, name: string })

---@class MiniHooks
---@field post_install? MiniHookFunction
---@field post_checkout? MiniHookFunction
---@field pre_install? MiniHookFunction
---@field pre_checkout? MiniHookFunction

--- @class MiniLoadSpec
--- @field source string -- Either the git repo or the plugin path
--- @field depends? table<string> -- Table of plugin repos
--- @field hooks? MiniHooks -- Table of hooks
--- @field later? boolean -- Whether to execute later
--- @field cb? function --  Callback function !avoid if possible
--- @field opts? table -- Options to pass to the plugin use with name if module name is not equal to source
--- @field name? string -- Provided a name to use with opts
--- @field disable? boolean -- Whether to disable the plugin
--- @field version? string -- Version of the plugin?
