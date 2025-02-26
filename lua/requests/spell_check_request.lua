local M = {}

---@class Request
---@field is_in_execution boolean inclusive, 0 indexed
---@field in_queue boolean exclusive

---@class SpellCheckRequestArgs
---@field line_start number
---@field line_end number


---@type table<integer, Request>
local requests_by_buffer = {}

---@param namespace number
---@param interface Interface
function M.setup(namespace, interface)
	M.interface = interface
	M.namespace = namespace
	---@type table<integer, Request>
	M.requests_by_buffer = {}
end

---@return Request
function M.getCurrentBufferRequests()
	local current_buffer = vim.nvim_get_current_buf()
	if requests_by_buffer[current_buffer] == nil then
		requests_by_buffer[current_buffer] = {
			is_in_execution = false,
			in_queue = false,
		}
	end
	return requests_by_buffer[current_buffer]
end

function M.processSpellCheckRequest(input)
	assert(input.kind == "lint")

	---@type vim.Diagnostic[]
	local diagnostics = {}

	for _, value in ipairs(input.problems) do
		table.insert(diagnostics, {
			lnum = value.lineStart,
			col = value.lineOfset,
			end_col = value.lineOfset + #value.word,
			serverity = vim.diagnostic.severity.HINT,
			message = "Misspelled word: " .. value.word,
		})
	end

	vim.diagnostic.reset(M.namespace, vim.api.nvim_get_current_buf())
	vim.diagnostic.set(M.namespace, vim.api.nvim_get_current_buf(), diagnostics)
end

---@param args SpellCheckRequestArgs
function M.sendSpellCheckRequest(args)
	local buffer = vim.api.nvim_get_current_buf()
	local linesArray = vim.api.nvim_buf_get_lines(buffer, args.line_start, args.line_end, true)
	local lines = table.concat(linesArray, "\n")
	M.interface.send_request({
		Kind = "check_spell",
		text = lines,
		startLine = args.line_start,
	})
end

return M
