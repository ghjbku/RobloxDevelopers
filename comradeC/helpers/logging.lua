local getenv
getenv = os.getenv
local lustache = require("lustache")
local logger = { }
logger.colors = {
  [8] = {
    black = '[30m',
    red = '[31m',
    green = '[32m',
    yellow = '[33m',
    blue = '[34m',
    magenta = '[35m',
    cyan = '[36m',
    white = '[37m',
    reset = '[0m'
  },
  [16] = {
    bright_black = '[30;1m',
    bright_red = '[31;1m',
    bright_green = '[32;1m',
    bright_yellow = '[33;1m',
    bright_blue = '[34;1m',
    bright_magenta = '[35;1m',
    bright_cyan = '[36;1m',
    bright_white = '[37;1m'
  },
  [256] = {
    link = '[4;38;5;14m',
    framed = '[51m'
  }
}
logger.palette = { }
local term = getenv("TERM")
local color = getenv("COLORTERM")
local theme = 8
local truecolor = false
if term and (term == 'xterm' or term:find('-256color$')) then
  theme = 256
else
  theme = 8
end
truecolor = (color and (color == 'truecolor' or color == '24bit')) or false
for i, v in pairs(logger.colors) do
  if i <= theme then
    for color, code in pairs(v) do
      logger.palette[color] = "\27" .. tostring(code)
    end
  end
end
if truecolor then
  logger.palette.rgb = function(text, render)
    return render("\27[38;2;" .. tostring(text:gsub(', ', ';')) .. "m")
  end
end
logger.render = function(text, toEnv)
  if toEnv == nil then
    toEnv = { }
  end
  local env = logger.palette
  for i, v in pairs(toEnv) do
    env[i] = v
  end
  local data = lustache:render(text, logger.palette)
  data = data:gsub('&#x2F;', '/')
  return data
end
return logger
