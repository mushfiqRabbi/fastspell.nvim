local interface = require "lua/interface"

---@param input SpellResponse
local function cspell_result_callback(input)
    print(vim.inspect(input))
end


interface.setup(cspell_result_callback)

interface.send_cspell_request({
    Kind = "partial",
    startLine = 3,
    text = "baad spllng test"
});


