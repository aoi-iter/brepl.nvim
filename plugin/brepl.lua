vim.api.nvim_create_user_command("BReplOpen", require("brepl").repl_open, {})
vim.api.nvim_create_user_command("BReplSend", require("brepl").repl_send, {})
vim.api.nvim_create_user_command("BReplClose", require("brepl").repl_close, {})
