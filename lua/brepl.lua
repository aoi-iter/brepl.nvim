-- main module file
local module = require("brepl.module")

local M = {}
M.config = {
    ft_config = {
        python = {
            separator = "#%s*%%",
            cmd = "python",
        },
        javascript = {
            separator = "//%s*%%",
            cmd = "node"
        },
        haskell = {
            separator = "--%s*%%",
            cmd = "ghci"
        },
    }
}

-- setup is the public method to setup your plugin
M.setup = function(args)
    -- you can define your setup function here. Usually configurations can be merged, accepting outside params and
    -- you can also put some validation here for those.
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

-- "hello" is a public method for the plugin
M.repl_open = function()
    module.repl_open(M.config.ft_config)
end
M.repl_send = function()
    module.repl_send(M.config.ft_config)
end
M.repl_close = module.repl_close

return M
