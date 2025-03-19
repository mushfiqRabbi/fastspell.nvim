# What is fastspell.nvim and why is it needed

As a guy with dyslexia I often struggle with spelling, especially when writing English (my second language)
I have always tried to mitigate this issues with good tools, however each nvim spell checker that I tried
had some issues, and therefore I created my own.

## What are the current options, and what are their limitations

### Nvim's spell checker
Yes, neovim has his own integrated spell checker that can be enabled, however after using it for more than 
10 seconds you will realized that is not really optimal for code. It is in fact NOT able to correctly
run a spell checker on CamelCase or snake_case text

![alt text](./img/example1.png "example")

### Cspell + nvim-lint
The obvious solution to the camel case problem is to use something like [cspell](https://github.com/streetsidesoftware/cspell)
which is designed from the ground up with code in mind. Moreover there are already some cspell integration for neovim,
such as [nvim-lint](https://github.com/mfussenegger/nvim-lint) however, when I tried those I encountered another problem...
They are too slow, and they can't provide "as you type" feedback.

#### fastspell vs nvim-lint speed comparison (video)
[![fastspell vs nvim-lint speed comparison (video)](https://img.youtube.com/vi/nYdt2MwCHm8/0.jpg)](https://www.youtube.com/watch?v=nYdt2MwCHm8)

Here I would like to point out that this is not nvim-lint or cspell's fault. It is simply the case that some optimizations
are impossible within the nvim-lint structure (due to the fact that nvim-lint is designed to support virtually infinite
different kinds of linters).

However by removing the "multiple linters" requirements, and designing a linter client specific for cspell I was able
to make significant optimizations that resulted in this plugin being 100x faster.

Just for the record I would also like to say that my "significant optimizations" aren't something fancy at all.
All I needed to do to achieve this 100x performance uplift is to keep the node instance constantly in memory
and avoid creating a new one every time a spell checking request is made.

Note that this will have a sizable impact on your memory usage (It's javascript after all...) But it is not something
extreme (about 100MB on my machine)

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

        -- call setup to initialize fastspell
        fastspell.setup({
            -- Optionally put your custom configurations here
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

## Setup configurations

When you call setup, you can pass a table with a set of options to configure cspell, including:

- `namespace`: name of the nvim namespace that the spelling errors will be part of. Default to `fastspell`
- `server_code_path`: this should point to, [start_server.sh](./lua/scripts/start_server.sh) or [start_server.cmd](./lua/scripts/start_server.cmd)
 (depending on your OS). By default this path should be set automatically, however if you are having some problems you can try set it manually
- `filter_by_buf_type`: boolean, if set to `true` the spelling request will be only made for buffer with type "" (empty string). This will make sure
that spelling error are reported only for file buffer (filtering out for example terminal, UI elements such as [new-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) etcetera).
Default to `true`
- `diagnostic_severity`: The severity of the spelling diagnostic (see `:help vim.diagnostic.severity`). Default to vim.diagnostic.severity.INFO
- `cspell_json_file_path`: Path where to find the `cspell.json` file. That can be used to configure the spell checking behavior

## configure spell checking behavior

using the property `cspell_json_file_path` you can point to a `cspell.json` file where you can put some spelling configuration that are specific for your needs.
for example:

### configuration of a cspell.json file
```lua
    -- you can configure cspell like this
    fastspell.setup({
        cspell_json_file_path = vim.fn.stdpath("config") .. "/cspell.json"
    })
```

### example of a cspell.json file
Find more documentation [here](https://github.com/streetsidesoftware/cspell/blob/main/docs/configuration/index.md)
```json
{
    "version": "0.2",
    "language": "en",
    "words": [
        "fastspell", "nvim"
    ]
}
```

## Trigger events, and effect area

Fastspell doesn't start automatically out of the box, but it requires you to set up a trigger. This is done to ensure an higher level of customizability.
Here there are a few examples on what you can do with cspell

### Spell check all of the text on screen

This configuration only check for spelling error on the lines of the current buffer that are displayed on screen.
This has the advantage of being faster with respect to checking the entire buffer, with the disadvantage of not
being able to provide diagnostic about the entire document
```lua
vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI", "BufEnter", "WinScrolled"}, {
    callback = function(_)
        local first_line = vim.fn.line('w0')-1
        local last_line = vim.fn.line('w$')
        fastspell.sendSpellCheckRequest(first_line, last_line)
    end,
})
```


### Spell check only the text that is being written

This is my personal favorite, since I like having spell checker while writing code, but not necessarily when reading code.
So here we run the spell checker only in the line the cursor is currently in, and the two adjacent to it.

```lua
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI"}, {
    callback = function(_)
        local current_row = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[1]
        local first_line = current_row-2
        local last_line = current_row+1
        fastspell.sendSpellCheckRequest(first_line, last_line)
    end,
})
```


### Spell check the entire document

If you want to always spell check the entire document, you can! However this can cause performance issue on large files (approximately > 25k lines)

Here is the configuration to do so:

```lua
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI"}, {
    callback = function(_)
        local buffer = vim.api.nvim_get_current_buf()
        local first_line = 0
        local last_line =vim.api.nvim_buf_line_count(buffer)
        fastspell.sendSpellCheckRequest(first_line, last_line)
    end,
})
```

### Spell check only when requested

Another configuration option is to run spell checking only on explicit request


```lua
vim.api.nvim_set_keymap("n", "<leader>sc", "", {
	noremap = true,
	silent = true,
    desc = "[S]pell [C]heck",
	callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        local first_line = 0
        local last_line =vim.api.nvim_buf_line_count(buffer)
        fastspell.sendSpellCheckRequest(first_line, last_line)
	end,
})
```

### Delete all spell diagnostic

You can also set up a command to clear all spell diagnostics with this code:
```lua
vim.api.nvim_set_keymap("n", "<leader>si", "", {
    noremap = true,
    silent = true,
    desc = "[S]pell [I]gnore",
    callback = function()
        fastspell.sendSpellCheckRequest(0,0)
    end,
})
```
