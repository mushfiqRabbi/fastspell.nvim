# Installation

## Requirements

This project is based on [cspell](https://github.com/streetsidesoftware/cspell)
and therefore requires node to be install in your system (and in your path)

On install you should run the [install.sh](./lua/scripts/install.sh) or [install.cmd](./lua/scripts/install.cmd)
scripts (depending on your OS). This will install all the node dependency and build the project.


## Using lazy.nvim

```lua
return {
	"lucaSartore/fastspell.nvim",
    -- automatically run the installation script on windows and linux)
    run = "./lua/scripts/install." .. (vim.fn.has("win32") and "cmd" or "sh")
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
