---@class Interface
local M = {}

---Initialize the process
---@param  callback function(SpellResponse)
---@param settings FastSpellSettings
function M.setup(callback, settings)
    local stdin = vim.loop.new_pipe(false)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    local handle
    --handle, _ = vim.loop.spawn('start_server.cmd', {
    handle, _ = vim.loop.spawn(settings.server_code_path, {
        stdio = {stdin, stdout, stderr},
    }, function(code, _)
        print('Process exited with code: ' .. code)
    end)

    if not handle then
        error("Failed to spawn process")
        return
    end

    M.stdin = stdin
    M.settings = settings

    stdout:read_start(function(err, data)
        if err then
            error("Error reading from stdout: " .. err)
            return
        end
        if data then
            vim.schedule(function()
                local response_object = vim.fn.json_decode(data)
                callback(response_object)
            end)
        end
    end)
end

---@param input_object SpellRequest
function M.send_request(input_object)
    local json_str = vim.fn.json_encode(input_object)
    -- local encoded_data = encode_base64(json_str)
    M.stdin:write(json_str .. "\n")
end

return M
