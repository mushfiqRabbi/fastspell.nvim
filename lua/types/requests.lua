---@class CheckSpellRequest
---@field Kind "check_spell"
---@field text string
---@field languageId string?
---@field startLine number


---@class ConfigureSpellCheckerRequest
---@field Kind "configure_spell_check_request"
---@field configFilePath string


---@alias SpellRequest CheckSpellRequest | ConfigureSpellCheckerRequest
