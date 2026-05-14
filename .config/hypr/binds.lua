local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- local tablet = "device[wacom-one-by-wacom-m-pen]"
local ssfile = "$HOME/Pictures/Screenshots/$(date '+%Y%m%d_%H%M%S_%N').png"
local srfile = "$HOME/Videos/Screencasts/$(date '+%Y%m%d_%H%M%S_%N').mp4"

-- programs we use
local browser = "xdg-open https://google.com"
local clipboardTool = 'cliphist list | fuzzel --placeholder="  clipboard" --dmenu | cliphist decode | wl-copy'
local fileManager = "uwsm-app -- dolphin"
local localvolbri = "uwsm-app -- localvolbri.zsh"
local mailClient = "uwsm-app -- thunderbird"
local menuDrun = 'uwsm-app -- fuzzel --placeholder="󰀻  applications" --show-actions'
local menuRun = 'fuzzel --placeholder=" _ command" --list-executables-in-path'
local fyi = "uwsm-app -- fyi -u low -i computer"
local terminal = "uwsm-app -- foot"

-- hyprzoom commands
local zoomIn = "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')"
local zoomOut =
	"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')"
local zoomReset = "hyprctl -q keyword cursor:zoom_factor 1"

-- submap names
local grab = "Screengrab: 󰬺 󱇣 ┃ 󰬻 󰉏 | 󰬼 "
local swappy = "Edit: 󰬺 󰍺 ┃ 󰬻 󰍹 ┃ 󰬼  ┃ 󰬽 󰩭"
local save = "Save: 󰬺 󰍺 ┃ 󰬻 󰍹 ┃ 󰬼  ┃ 󰬽 󰩭"
local rec = "Record: 󰬺 󰍹 ┃ 󰬻 󰩭 | 󰬼 "
local power = "Session: 󰬺  ┃ 󰬻 󰍃 ┃ 󰬼 󰒲 ┃ 󰬽 󰤄 ┃ 󰬾 󰜉 ┃ 󰬿 󰐥"
local window = "Move or resize (󰘶): 󰞗 ┃ 󰞖 ┃ 󰞙 ┃ 󰞘"

hl.dispatch(hl.dsp.submap("reset"))

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + G", hl.dsp.submap(grab))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(fyi .. ' Missing "Settings Win+I"'))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + M", hl.dsp.submap(power))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menuDrun))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + W", hl.dsp.submap(window))
hl.bind(mainMod .. " + X", hl.dsp.workspace.toggle_special("󰯉"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(clipboardTool))

hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("systemctl --user reload waybar"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(menuRun))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. "'swappy -f' -r"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special:󰯉" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + escape", hl.dsp.submap("reset"), { submap_universal = true })
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("uwsm-app -- localemojis.zsh"))
hl.bind(mainMod .. " + tab", hl.dsp.exec_cmd(fyi .. " Missing Win+Tab"))
hl.bind("ALT + CTRL + tab", hl.dsp.exec_cmd(fyi .. " Missing Alt+Ctrl+Tab"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Hyprzoom
hl.bind(mainMod .. " + ALT + 0", hl.dsp.exec_cmd(zoomReset))
hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.exec_cmd(zoomIn))
hl.bind(mainMod .. " + ALT + mouse_up", hl.dsp.exec_cmd(zoomOut))
hl.bind(mainMod .. " + ALT + equal", hl.dsp.exec_cmd(zoomIn), { repeating = true })
hl.bind(mainMod .. " + ALT + minus", hl.dsp.exec_cmd(zoomOut), { repeating = true })
hl.bind(mainMod .. " + ALT + KP_ADD", hl.dsp.exec_cmd(zoomIn), { repeating = true })
hl.bind(mainMod .. " + ALT + KP_SUBTRACT", hl.dsp.exec_cmd(zoomOut), { repeating = true })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(localvolbri .. " volume_up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(localvolbri .. " volume_down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(localvolbri .. " volume_mute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(localvolbri .. " mic_mute"), { locked = true, repeating = true })
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(localvolbri .. " brightness_down"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(localvolbri .. " brightness_up"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(localvolbri .. " next_track"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(localvolbri .. " play_pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(localvolbri .. " play_pause"), { locked = true })
-- hl.bind("XF86AudioPlayPause", hl.dsp.exec_cmd(localvolbri .. " play_pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(localvolbri .. " prev_track"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(localvolbri .. " play_stop"), { locked = true })

-- Other special keys
hl.bind("Print", hl.dsp.submap(grab), { locked = true })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("uwsm-app -- qalculate-qt"), { locked = true })
hl.bind("XF86Favorites", hl.dsp.exec_cmd(fyi .. " Missing Favorites"), { locked = true })
hl.bind("XF86HomePage", hl.dsp.exec_cmd(fileManager), { locked = true })
hl.bind("XF86Mail", hl.dsp.exec_cmd(mailClient), { locked = true })
hl.bind("XF86PowerOff", hl.dsp.submap(power), { locked = true })
hl.bind("XF86Search", hl.dsp.exec_cmd(menuDrun), { locked = true })
hl.bind("XF86Tools", hl.dsp.exec_cmd(fyi .. " Missing Tools"), { locked = true })

-- Global keybinds
for i = 9, 12 do
	hl.bind("SUPER + F" .. i, hl.dsp.pass({ window = "class:^(com.obsproject.Studio)$" }))
end

-- Submaps
hl.define_submap(grab, function()
	hl.bind("Q", hl.dsp.submap(swappy))
	hl.bind("W", hl.dsp.submap(save))
	hl.bind("E", hl.dsp.submap(rec))
	hl.bind("catchall", hl.dsp.submap("reset"))
	hl.define_submap(swappy, function()
		hl.bind("1", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -e 'swappy -f'"))
		hl.bind("2", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -e 'swappy -f' -o"))
		hl.bind("3", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -e 'swappy -f' -w"))
		hl.bind("4", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -e 'swappy -f' -r"))
		hl.bind("SHIFT + 1", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -e 'swappy -f' -d 2"))
		hl.bind("SHIFT + 2", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -e 'swappy -f' -d 2 -o"))
		hl.bind("SHIFT + 3", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -e 'swappy -f' -d 2 -w"))
		hl.bind("SHIFT + 4", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -e 'swappy -f' -d 2 -r"))
		hl.bind("catchall", hl.dsp.submap("reset"))
	end)
	hl.define_submap(save, function()
		hl.bind("1", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -c"))
		hl.bind("2", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -c -o"))
		hl.bind("3", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -c -w"))
		hl.bind("4", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -c -r"))
		hl.bind("SHIFT + 1", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -c -d 2"))
		hl.bind("SHIFT + 2", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -c -d 2 -o"))
		hl.bind("SHIFT + 3", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -c -d 2 -w"))
		hl.bind("SHIFT + 4", hl.dsp.exec_cmd("localshot.zsh -f " .. ssfile .. " -c -d 2 -r"))
		hl.bind("catchall", hl.dsp.submap("reset"))
	end)
	hl.define_submap(rec, function()
		hl.bind("1", hl.dsp.exec_cmd("localwfrec.zsh -f " .. srfile))
		hl.bind("2", hl.dsp.exec_cmd("localwfrec.zsh -f " .. srfile .. " -r"))
		hl.bind("3", hl.dsp.exec_cmd("localwfrec.zsh --stop"))
		hl.bind("catchall", hl.dsp.submap("reset"))
	end)
end)

hl.define_submap(power, "reset", function()
	hl.bind("1", hl.dsp.exec_cmd("loginctl lock-session"))
	hl.bind("2", hl.dsp.exec_cmd("uwsm stop"))
	hl.bind("3", hl.dsp.exec_cmd("systemctl -i suspend"))
	hl.bind("4", hl.dsp.exec_cmd("systemctl -i hibernate"))
	hl.bind("5", hl.dsp.exec_cmd("systemctl -i reboot"))
	hl.bind("6", hl.dsp.exec_cmd("systemctl -i poweroff"))
	hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.define_submap(window, function()
	hl.bind("right", hl.dsp.window.move({ x = 5, y = 0, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.move({ x = -5, y = 0, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.move({ x = 0, y = -5, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.move({ x = 0, y = 5, relative = true }), { repeating = true })
	hl.bind("CONTROL + right", hl.dsp.window.move({ x = 25, y = 0, relative = true }), { repeating = true })
	hl.bind("CONTROL + left", hl.dsp.window.move({ x = -25, y = 0, relative = true }), { repeating = true })
	hl.bind("CONTROL + up", hl.dsp.window.move({ x = 0, y = -25, relative = true }), { repeating = true })
	hl.bind("CONTROL + down", hl.dsp.window.move({ x = 0, y = 25, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + right", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + left", hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + up", hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + down", hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true })
	hl.bind("SHIFT + right", hl.dsp.window.resize({ x = 5, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + left", hl.dsp.window.resize({ x = -5, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + up", hl.dsp.window.resize({ x = 0, y = -5, relative = true }), { repeating = true })
	hl.bind("SHIFT + down", hl.dsp.window.resize({ x = 0, y = 5, relative = true }), { repeating = true })
	hl.bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
	hl.bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

	hl.bind("C", function()
		hl.dispatch(hl.dsp.window.center())
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("F", function()
		hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle" }))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("P", function()
		hl.dispatch(hl.dsp.window.pin({ action = "toggle" }))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("V", function()
		hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
end)

-- INFO: take into account!
-- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
-- local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
