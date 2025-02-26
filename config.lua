local interface = require("lua.util.interface")
local spell_check_request = require("lua.requests.spell_check_request")

local namespace = vim.api.nvim_create_namespace("cspell")

vim.diagnostic.config({
    update_in_insert = true
},namespace)


spell_check_request.setup(namespace, interface)
interface.setup(spell_check_request.processSpellCheckRequest)

vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI", "BufEnter", "WinScrolled"}, {
	callback = function(_)
        vim.schedule(
            function ()
                local first_line = vim.fn.line('w0')
                local last_line = vim.fn.line('w$')
                local end_line = vim.api.nvim_buf_line_count(0)
                spell_check_request.sendSpellCheckRequest(0, end_line)
            end
        )
	end
}
)





































































































