local interface = require("util.interface")
local spell_check_request = require("requests.spell_check_request")


local M = {}

---@class FastSpellSetup
local default_settings = {
    namespace = "fastspell",
    server_code_path = debug.getinfo(1).source
}

vim.notify(default_settings.server_code_path)

function M.setup(user_settings)
    ---@type FastSpellSetup
    local settings = vim.tbl_deep_extend("force", default_settings, user_settings or {})

    local namespace = vim.api.nvim_create_namespace(settings.namespace)

    vim.diagnostic.config({
        update_in_insert = true
    },namespace)


    spell_check_request.setup(namespace, interface)
    interface.setup(spell_check_request.processSpellCheckRequest)

    M.sendSpellCheckRequest = spell_check_request.sendSpellCheckRequest

end

return M
