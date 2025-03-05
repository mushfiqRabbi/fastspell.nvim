-- this is just an example file useful during development to run the config
-- to run:
--      nvim -u config.lua
--      nvim -u config.lua --headless

local fastspell = require("fastspell")

fastspell.setup()

vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI", "BufEnter", "WinScrolled"}, {
	callback = function(_)
        local first_line = vim.fn.line('w0')-1
        local last_line = vim.fn.line('w$')
        fastspell.sendSpellCheckRequest(first_line, last_line)
	end
})
