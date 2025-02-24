-- local requests = require("types.requests")
-- local responses = require("types.responses")
local M = {}

local function encode_base64(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
local function decode_base64(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

vim.fn.system('base64', "hello world"):gsub('\n', '')
-- Initialize the process
function M.setup()
    local stdin = vim.loop.new_pipe(false)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    local handle
    local pid
    handle, pid = vim.loop.spawn('npm start', {
        stdio = {stdin, stdout, stderr},
        cwd = "../jslib/"
    }, function(code, signal)
        print('Process exited with code: ' .. code)
    end)

    if not handle then
        error("Failed to spawn process")
        return
    end

    M.handle = handle
    M.stdin = stdin
    M.stdout = stdout
    M.stderr = stderr
    M.pid = pid

    -- Handle stdout data
    stdout:read_start(function(err, data)
        if err then
            error("Error reading from stdout: " .. err)
            return
        end
        if data then
            M.last_response = data
        end
    end)

    -- Handle stderr data
    stderr:read_start(function(err, data)
        if err then
            error("Error reading from stderr: " .. err)
            return
        end
        if data then
            print("Server error: " .. data)
        end
    end)
end

---send a request to the cspell server
---@param input_object SpellRequest
---@return SpellResponse
function M.send_cspell_request(input_object)
    -- Convert input object to JSON
    local json_str = vim.fn.json_encode(input_object)
    if not json_str then
        error("Failed to encode object to JSON")
        return {
            kind = "error",
            message = "Error with json serialization"
        }
    end

    -- Encode to base64
    local encoded_data = encode_base64(json_str)

    -- Clear last response
    M.last_response = nil

    -- Send to server
    M.stdin:write(encoded_data .. "\n")

    -- Wait for response (simple polling implementation)
    local timeout = 5000  -- 5 seconds timeout
    local start_time = vim.loop.now()
    while not M.last_response do
        vim.loop.sleep(10)  -- Sleep for 10ms
        if (vim.loop.now() - start_time) > timeout then
            error("Timeout waiting for response")
            return nil
        end
    end

    -- Decode response from base64
    local decoded_data = decode_base64(M.last_response)

    -- Parse JSON response
    local response_object = vim.fn.json_decode(decoded_data)
    if not response_object then
        error("Failed to decode response JSON")
        return nil
    end

    return response_object
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
