local M = {}
local decode_base64 = require("lua.util.base64").decode_base64
local encode_base64 = require("lua.util.base64").encode_base64

---Initialize the process
---@param  callback function(SpellResponse)
function M.setup(callback)
    local stdin = vim.loop.new_pipe(false)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    local handle
    --handle, _ = vim.loop.spawn('start_server.cmd', {
    handle, _ = vim.loop.spawn('start_server.cmd', {
        stdio = {stdin, stdout, stderr},
    }, function(code, _)
        print('Process exited with code: ' .. code)
    end)

    if not handle then
        error("Failed to spawn process")
        return
    end

    M.stdin = stdin


    stdout:read_start(function(err, data)
        if err then
            error("Error reading from stdout: " .. err)
            return
        end
        if data then
            vim.schedule(function()
                local decoded_data = decode_base64(data)
                local response_object = vim.fn.json_decode(decoded_data)
                assert(response_object, "serialization error")
                callback(response_object)
            end)
        end
    end)
end

---send a request to the cspell server
---@param input_object SpellRequest
function M.send_request(input_object)
    -- Convert input object to JSON
    local json_str = vim.fn.json_encode(input_object)
    assert(json_str, "serialization error")
    local encoded_data = encode_base64(json_str)
    M.stdin:write(encoded_data .. "\n")
end

-- Cleanup function
function M.cleanup()
    if M.handle then
        -- Close pipes
        if M.stdin then M.stdin:close() end
        if M.stdout then M.stdout:close() end
        if M.stderr then M.stderr:close() end

        -- Close process handle
        M.handle:close()
    end
end

return M
