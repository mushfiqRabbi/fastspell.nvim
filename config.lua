local interface = require("lua.util.interface")
local x = require("lua.requests.spell_check_request")

local namespace = vim.api.nvim_create_namespace("cspell")

vim.diagnostic.config({
    update_in_insert = true
},namespace)

local sendSpellCheckRequest = x.createSendSpellCheckRequest(interface)
local processSpellCheckRequest = x.createProcessSpellCheckRequest(namespace, interface)

interface.setup(processSpellCheckRequest)

vim.api.nvim_create_autocmd("TextChanged", {
	callback = function(ev)
        vim.schedule(
            function ()
                sendSpellCheckRequest(0,2)
            end
        )
	end,
})
