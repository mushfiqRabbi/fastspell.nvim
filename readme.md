# Installation

## Requirements

This project is based on [cspell](https://github.com/streetsidesoftware/cspell)
and therefore requires node to be install in your system (and in your path)

On install you should run the [install.sh](./lua/scripts/install.sh) or [install.cmd](./lua/scripts/install.cmd)
scripts (depending on your OS). This will install all the node dependency and build the project.
If you use the configuration shown below, this should run automatically for you.

Note that the first time you install the plugin it is likely that you'll see some error the first time you launch nvim.
This is because the build script hasn't finished by the time the first request to the server is made.
If this appends to you, just reboot nvim the first time, and then you'll be fine.

## Using lazy.nvim

```lua
return {
	"lucaSartore/fastspell.nvim",
    -- automatically run the installation script on windows and linux)
    -- if this doesn't work for some reason, you can 
    build = function ()
        local base_path = vim.fn.stdpath("data") .. "/lazy/fastspell.nvim"
        local cmd = base_path .. "/lua/scripts/install." .. (vim.fn.has("win32") and "cmd" or "sh")
        vim.system({cmd})
    end,

	config = function()
		local fastspell = require("fastspell")

        fastspell.setup({
            -- your custom configurations
        })

        -- decide when to run the spell checking (see :help events for full list)
        vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI", "BufEnter", "WinScrolled"}, {
            callback = function(_)
                -- decide the area in your buffer that will be checked. This is the default configuration,
                -- and look for spelling mistakes ONLY in the lines of the bugger that are currently displayed
                -- for more advanced configurations see the section bellow
                local first_line = vim.fn.line('w0')-1
                local last_line = vim.fn.line('w$')
                fastspell.sendSpellCheckRequest(first_line, last_line)
			end,
		})
	end,
}
```


# Configuration
