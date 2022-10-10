local buf_util = {}

buf_util.get_ft = function()
    return vim.bo.filetype
end

local get_current_line_num = function()
    local r, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
    return r
end

local repl_id = nil
local repl_buffer = nil

local move_bottom = function()
    if repl_id ~= nil then
        local winid = vim.fn.bufwinid(repl_buffer)
        vim.fn.win_execute(winid, '$')
    end
end

local get_buffer_lines = function()
    return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

buf_util.repl_open = function(cmd)
    local cur_win = vim.api.nvim_get_current_win()

    if repl_id == nil then
        vim.api.nvim_command('set splitbelow')
        vim.api.nvim_command('new')

        local opt = {
            on_stdout = move_bottom
        }

        repl_id = vim.fn.termopen(cmd, opt)
        repl_buffer = vim.fn.bufname()
    else
        vim.api.nvim_command('set splitbelow')
        vim.api.nvim_command('split')
        vim.api.nvim_command(string.format('buffer %s', repl_buffer))
    end

    vim.api.nvim_set_current_win(cur_win)
end

buf_util.send_data = function(separator)
    local buf_lines = get_buffer_lines()
    local line_num = get_current_line_num()

    local block_lines = {}

    if string.find(buf_lines[line_num], separator) ~= nil then
        return
    end

    table.insert(block_lines, buf_lines[line_num])

    for i = line_num - 1, 1, -1 do
        if string.find(buf_lines[i], separator) ~= nil then
            break
        end
        table.insert(block_lines, 1, buf_lines[i])
    end

    for i = line_num + 1, #buf_lines do
        if string.find(buf_lines[i], separator) ~= nil then
            break
        end
        table.insert(block_lines, buf_lines[i])
    end

    local data = table.concat(block_lines, "\n")
    if repl_id ~= nil then
        vim.api.nvim_chan_send(repl_id, data)
        vim.api.nvim_chan_send(repl_id, "\n")
    end
end


buf_util.repl_close = function()
    if repl_id == nil then
        return
    end
    vim.api.nvim_command(string.format('bdelete! %s', repl_buffer))
    repl_id = nil
    repl_buffer = nil
end

return buf_util
