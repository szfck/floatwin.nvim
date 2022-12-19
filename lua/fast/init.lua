local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

local wins = {}

local function open_win(lines)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)

  local opts = {}
  opts['relative'] = 'cursor' 
  opts['width'] = 150
  opts['height'] = 50
  opts['col'] = 30
  opts['row'] = 3
  opts['focusable'] = true
  opts['border'] = 'rounded'
  local win = vim.api.nvim_open_win(buf, 0, opts)
  wins[#wins + 1] = win
end

local function close_win()
  for index, win in ipairs(wins) do
      -- Call foo in a protected environment
    local status, err = pcall(vim.api.nvim_win_close, win, true)
  end
  wins = {}
end

local function shell(command)
  local f = io.popen(command)
  local output = f:read("*all")
  f:close()

  local lines = {}
  for line in string.gmatch(output, "(.-)\n") do
    lines[#lines + 1] = line
  end
  return lines
end


local function add(array1, array2)
  for _, value in ipairs(array2) do
    table.insert(array1, value)
  end
end

local function choose_one_from(n)
  local number = math.random(1,n)
  return number == 1
end

local function gen_intro(lines)
  time = shell("date +%H:%M")[1]
  lines[#lines + 1] = "Time is " .. time
end

local board_lines = nil
local board_last_update_time = nil

local function display_board()
  local timestamp = os.time()
  if board_last_update_time == nil or timestamp - board_last_update_time > 60 * 30 then
    local lines = {}
    gen_intro(lines)
    board_lines = lines
    board_last_update_time = timestamp
  end

  open_win(board_lines)
end

local function display_git()
  local text = get_visual_selection()
  limit = 1000
  context = 5
  dir = '~/codebase'
  file_type = vim.bo.filetype

  if file_type == 'c' or file_type == 'cpp' or file_type == 'hpp' or file_type == 'h' or file_type == 'cc' then
    include = "--include=*.{h,c,cpp,cc,hpp}"
  else
    include = "--include=*.{" ..  file_type .. "}"
  end

  lines = shell("grep " .. text .. " -m " .. limit .. " -C " .. context .. " -r " .. dir .. " " .. include)
  open_win(lines)
end

return {
  git = display_git,
  board = display_board,
  close = close_win,
}
