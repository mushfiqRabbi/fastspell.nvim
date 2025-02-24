local interface = require "lua/interface"

interface.setup()

interface.send_cspell_request({
    Kind = "partial",
    startLine = 3,
    text = "baad spllng test"
});



print(os.clock())
interface.send_cspell_request({
    Kind = "partial",
    startLine = 4,
    text = "test"
});
