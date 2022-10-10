local buf_util = require("brepl.buf_util")

local M = {}

local ft_config = {
    python = {
        separator = "#%s*%%",
        cmd = "python",
    },
    javascript = {
        separator = "//%s*%%",
        cmd = "node"
    },
}


M.repl_open = function()
    local ft = buf_util.get_ft()
    if ft_config[ft] then
        buf_util.repl_open(ft_config[ft].cmd)
    else
        print("unrecognized filetype")
    end
end

M.repl_send = function ()
    local ft = buf_util.get_ft()
    if ft_config[ft] then
        buf_util.send_data(ft_config[ft].separator)
    else
        print("unrecognized filetype")
    end
end

M.repl_close = buf_util.repl_close

return M
