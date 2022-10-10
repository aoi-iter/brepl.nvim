local buf_util = require("brepl.buf_util")

local M = {}

M.repl_open = function(ft_config)
    local ft = buf_util.get_ft()
    if ft_config[ft] then
        buf_util.repl_open(ft_config[ft].cmd)
    else
        print("unrecognized filetype")
    end
end

M.repl_send = function (ft_config)
    local ft = buf_util.get_ft()
    if ft_config[ft] then
        buf_util.send_data(ft_config[ft].separator)
    else
        print("unrecognized filetype")
    end
end

M.repl_close = buf_util.repl_close

return M
