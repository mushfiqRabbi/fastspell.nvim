local interface = require "lua.util.interface"
local x = require "lua.requests.spell_check_request"

local namespace = vim.api.nvim_create_namespace("cspell")

local sendSpellCheckRequest = x.createSendSpellCheckRequest(interface)
local processSpellCheckRequest = x.createProcessSpellCheckRequest(namespace, interface)


interface.setup(processSpellCheckRequest)

-- escape from terminal mode
vim.api.nvim_set_keymap("n", "ss", "", {
	noremap = true,
	silent = true,
	callback = function()
        sendSpellCheckRequest(0,2)
	end,
})

