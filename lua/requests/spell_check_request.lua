local M = {}

function M.createProcessSpellCheckRequest(namespace, interface)
    ---@param input SpellCheckResponse
    return function (input)
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

        vim.diagnostic.reset(namespace, vim.api.nvim_get_current_buf())
        vim.diagnostic.set(
            namespace,
            vim.api.nvim_get_current_buf(),
            diagnostics
        )
    end
end

function M.createSendSpellCheckRequest(interface)
    ---@param lineStart number # inclusive, 0 indexed
    ---@param lineEnd number # exclusive
    return function (lineStart, lineEnd)
        local buffer = vim.api.nvim_get_current_buf()
        local linesArray = vim.api.nvim_buf_get_lines(buffer, lineStart, lineEnd, true)
        local lines = table.concat(linesArray, "\n")
        interface.send_request({
            Kind = "check_spell",
            text = lines,
            startLine = lineStart
        })
    end
end

return M
