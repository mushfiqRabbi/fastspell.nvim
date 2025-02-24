-- local requests = require("types.requests")
-- local responses = require("types.responses")
local M = {}
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

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
            print("got: " .. data)
            print(os.clock())
            local decoded_data = decode_base64(data)
            local response_object = vim.fn.json_decode(decoded_data)
            callback(response_object)
        end
    end)
end

---send a request to the cspell server
---@param input_object SpellRequest
function M.send_cspell_request(input_object)
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
