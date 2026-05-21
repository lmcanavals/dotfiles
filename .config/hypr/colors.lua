local t = require("theme")
local M = {}

M.alert = "rgb(" .. t.orange .. ")"
M.bg_attention = "rgb(" .. t.dark5 .. ")"
M.bg_main = "rgba(" .. t.bg .. "bf)"
M.bg_critical = "rgb(" .. t.red1 .. ")"
M.bg_hover = "rgb(" .. t.dark3 .. ")"
M.bg_widget = "rgba(" .. t.bg_dark .. "40)"
M.bg_widget_r = "rgb(" .. t.green .. ")"
M.border0 = "rgba(" .. t.blue .. "80)"
M.border1 = "rgba(" .. t.blue0 .. "80)"
M.border2 = "rgba(" .. t.blue0 .. "40)"
M.border3 = "rgba(" .. t.blue7 .. "40)"
M.border_main = "rgb(" .. t.bg .. ")"
M.box_shadow = "rgba(" .. t.bg_highlight .. "40)"
M.fg_attention = "rgb(" .. t.yellow .. ")"
M.fg_attention_raw = t.yellow
M.fg_critical = "rgb(" .. t.blue6 .. ")"
M.fg_hover = "rgb(" .. t.gitchange .. ")"
M.fg_widget = "rgb(" .. t.green .. ")"
M.fg_widget_r = "rgb(" .. t.bg_dark .. ")"
M.fg_dimmed = "rgb(" .. t.comment .. ")"
M.fg_dimmed_raw = t.comment
M.fg_readonly = "rgb(" .. t.red .. ")"
M.text_shadow1 = "rgba(" .. t.cyan .. "bf)"
M.text_shadow2 = "rgba(" .. t.red .. "bf)"

return M
