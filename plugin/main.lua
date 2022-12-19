fast = require('fast')

vim.api.nvim_set_keymap('n', ',2', ':lua fast.board()<cr>', {})

vim.api.nvim_set_keymap('v', ',3', ':lua fast.git()<cr>', {})

vim.api.nvim_set_keymap('n', ',0', ':lua fast.close()<cr>', {})

vim.api.nvim_set_keymap('n', ',[', ':vertical botright copen 60<cr>', {})
vim.api.nvim_set_keymap('n', ',]', ':cclose<cr>', {})
vim.api.nvim_set_keymap('n', ',c', ':AsyncRun -focus=0 ', {})

-- repeat last command
vim.api.nvim_set_keymap('n', ',,', ':@:<cr>', {})

vim.api.nvim_set_keymap('n', ',x', ':bw<cr>', {})

