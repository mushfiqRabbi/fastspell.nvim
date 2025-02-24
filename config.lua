local interface = require "lua/interface"
local namespace = vim.api.nvim_create_namespace("cspell")

local time_start = 0
---@param input SpellResponse
local function cspell_result_callback(input)
    print(os.clock())

    assert(input.kind == "lint")

    ---@type vim.Diagnostic[]
    local diagnostics = {}

    for _, value in ipairs(input.problems) do
        table.insert(diagnostics, {
            lnum = value.lineStart,
            col = value.lineOfset,
            end_col = value.lineOfset + #value.word,
            serverity = vim.diagnostic.severity.HINT,
            message = "Misspelled word: "..value.word
        })
    end

    vim.diagnostic.set(
        namespace,
        vim.api.nvim_get_current_buf(),
        diagnostics
    )
    print("delta t: " .. (os.clock() - time_start))
end


interface.setup(cspell_result_callback)

-- escape from terminal mode
vim.api.nvim_set_keymap("n", "ss", "", {
	noremap = true,
	silent = true,
	callback = function()
        time_start = os.clock()
        interface.send_cspell_request({
            Kind = "partial",
            startLine = 3,
            text = "baad spllng test"
        });
	end,
})

