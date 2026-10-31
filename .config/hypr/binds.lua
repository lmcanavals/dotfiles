-------------------------
---- The other stuff ----
-------------------------

local f = require("utils").f
local exec = hl.dsp.exec_cmd
local submap = hl.dsp.submap
local win = hl.dsp.window

-------------------------
---- Declaring stuff ----
-------------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- local tablet = "device[wacom-one-by-wacom-m-pen]"
local ssfile = "$HOME/Pictures/Screenshots/$(date '+%Y%m%d_%H%M%S_%N').png"
local srfile = "$HOME/Videos/Screencasts/$(date '+%Y%m%d_%H%M%S_%N').mp4"
local myEsp = "X"

-- programs we use
local browser = "xdg-open https://google.com"
local clipboardTool = 'cliphist list | fuzzel --placeholder="  clipboard" --dmenu | cliphist decode | wl-copy'
local fileManager = "uwsm-app -- dolphin"
local mailClient = "uwsm-app -- thunderbird"
local menuDrun = 'fuzzel --placeholder="󰀻  applications" --show-actions'
local menuRun = 'fuzzel --placeholder=" _ command" --list-executables-in-path'
local fyi = "fyi -u low -i computer"
local terminal = "uwsm-app -- kitty"
local resetBar = "fyi Quickbar not_implemented_yet"
local hideBar = "fyi Quickbar not_implemented_yet"

-- submap names
local groups = "󰓩 :  Toggle │  Lock │󰌒 │ │"
local power = " :  Lock │ 󰍃 Quit │ 󰤄 Sleep │  Hibernate │ 󰜉 Reboot │ 󰐥 Poweroff"
local scrGrab = "󰹑 : 󱇣 Edit │ 󰉏 Save │  Record"
local swappy = "󱇣 : 󰍺 All │ 󰍹 Output │  Window │ 󰩭 Region"
local save = "󰉏 : 󰍺 All │ 󰍹 Output │  Window │ 󰩭 Region"
local rec = " : 󰍹 Output │ 󰩭 Region │  Stop"
local testKeys = "Test keys with wev"
local window =
	"󰘴 󰘴󰙕 : 󰞗 │󰞖 │󰞙 │󰞘 │ 󰻿 Center │ 󰊓 Fullscreen │ 󰐃 Pin │ 󱂬 [v]Float"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
if hl.get_config("general.layout") == "scrolling" then
	hl.bind(f("%s + left", mainMod), hl.dsp.layout("focus left"))
	hl.bind(f("%s + right", mainMod), hl.dsp.layout("focus right"))
	hl.bind(f("%s + page_up", mainMod), hl.dsp.layout("colresize +conf"))
	hl.bind(f("%s + page_down", mainMod), hl.dsp.layout("colresize -conf"))
	hl.bind(f("%s + space", mainMod), hl.dsp.layout("fit all"))
	hl.bind(f("%s + SHIFT + left", mainMod), hl.dsp.layout("swapcol l"))
	hl.bind(f("%s + SHIFT + right", mainMod), hl.dsp.layout("swapcol r"))
	hl.bind(f("%s + SHIFT + page_up", mainMod), hl.dsp.layout("consume_or_expel next"))
	hl.bind(f("%s + SHIFT + page_down", mainMod), hl.dsp.layout("consume_or_expel prev"))
else
	hl.bind(f("%s + J", mainMod), hl.dsp.layout("togglesplit"))
	hl.bind(f("%s + left", mainMod), hl.dsp.focus({ direction = "left" }))
	hl.bind(f("%s + right", mainMod), hl.dsp.focus({ direction = "right" }))
end
hl.bind(f("%s + B", mainMod), exec(hideBar))
hl.bind(f("%s + E", mainMod), exec(fileManager))
hl.bind(f("%s + G", mainMod), submap(groups))
hl.bind(f("%s + I", mainMod), exec(f("%s Missing Settings_Win+I", fyi)))
hl.bind(f("%s + L", mainMod), exec("loginctl lock-session"))
hl.bind(f("%s + M", mainMod), submap(power))
hl.bind(f("%s + P", mainMod), win.pseudo())
hl.bind(f("%s + Q", mainMod), exec(terminal))
hl.bind(f("%s + R", mainMod), exec(menuDrun))
hl.bind(f("%s + S", mainMod), submap(scrGrab))
hl.bind(f("%s + V", mainMod), win.float({ action = "toggle" }))
hl.bind(f("%s + W", mainMod), submap(window))
hl.bind(f("%s + X", mainMod), hl.dsp.workspace.toggle_special(myEsp))
hl.bind(f("%s + Z", mainMod), exec(clipboardTool))

hl.bind(f("%s + SHIFT + B", mainMod), exec(resetBar))
hl.bind(f("%s + SHIFT + Q", mainMod), exec(browser))
hl.bind(f("%s + SHIFT + R", mainMod), exec(menuRun))
hl.bind(f("%s + SHIFT + S", mainMod), exec(f("lshot -f %s'swappy -f' -r", ssfile)))
hl.bind(f("%s + SHIFT + V", mainMod), win.pin({ action = "toggle" }))
hl.bind(f("%s + SHIFT + X", mainMod), win.move({ workspace = f("special:%s", myEsp) }))

hl.bind(f("%s + up", mainMod), hl.dsp.focus({ direction = "up" }))
hl.bind(f("%s + down", mainMod), hl.dsp.focus({ direction = "down" }))

hl.bind(f("%s + escape", mainMod), submap("reset"), { submap_universal = true })
hl.bind(f("%s + period", mainMod), exec("uwsm-app -- lmojis"))
hl.bind(f("%s + tab", mainMod), hl.dsp.focus({ workspace = "previous" }))
hl.bind("ALT + CTRL + tab", exec(f("%s Missing Alt+Ctrl+Tab", fyi)))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(f("%s + %d", mainMod, key), hl.dsp.focus({ workspace = i }))
	hl.bind(f("%s + SHIFT + %d", mainMod, key), win.move({ workspace = i }))
end

hl.bind(f("%s + F4", mainMod), win.close())

-- Hyprzoom
local function zoomHelper(mode)
	return function()
		local currentZoom = hl.get_config("cursor.zoom_factor") or 1.0
		local newZoom = 1.0
		if mode == "in" then
			newZoom = currentZoom * 1.1
		elseif mode == "out" then
			newZoom = currentZoom / 1.1
			newZoom = newZoom < 1.0 and 1.0 or newZoom
		end
		hl.config({ cursor = { zoom_factor = newZoom } })
	end
end
hl.bind(f("%s + ALT + 0", mainMod), zoomHelper("reset"))
hl.bind(f("%s + ALT + mouse_down", mainMod), zoomHelper("in"))
hl.bind(f("%s + ALT + mouse_up", mainMod), zoomHelper("out"))
hl.bind(f("%s + ALT + equal", mainMod), zoomHelper("in"), { repeating = true })
hl.bind(f("%s + ALT + minus", mainMod), zoomHelper("out"), { repeating = true })
hl.bind(f("%s + ALT + KP_ADD", mainMod), zoomHelper("in"), { repeating = true })
hl.bind(f("%s + ALT + KP_SUBTRACT", mainMod), zoomHelper("out"), { repeating = true })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(f("%s + mouse_down", mainMod), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(f("%s + mouse_up", mainMod), hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(f("%s + mouse:272", mainMod), win.drag(), { mouse = true })
hl.bind(f("%s + mouse:273", mainMod), win.resize(), { mouse = true })

-- Laptop multimedia keys for volume
hl.bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

-- Requieres brightnessctl
hl.bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", exec("brightnessctl set 5%+"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", exec("playerctl pause"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", exec("playerctl stop"), { locked = true })

-- Other special keys
hl.bind("Print", submap(scrGrab), { locked = true })
hl.bind("XF86Calculator", exec("uwsm-app -- qalculate-qt"), { locked = true })
hl.bind("XF86Favorites", exec(f("%s Missing Favorites", fyi)), { locked = true })
hl.bind("XF86HomePage", exec(fileManager), { locked = true })
hl.bind("XF86Mail", exec(mailClient), { locked = true })
hl.bind("XF86PowerOff", submap(power), { locked = true })
hl.bind("XF86Search", exec(menuDrun), { locked = true })
hl.bind("XF86Tools", exec(f("%s Missing Tools", fyi)), { locked = true })

-- Global keybinds
for i = 9, 12 do
	hl.bind(f("SUPER + F%d", i), hl.dsp.pass({ window = "class:^(com.obsproject.Studio)$" }))
end

-- Submaps

-- Special submap to test keys
hl.bind(f("%s + SHIFT + ALT + K", mainMod), submap(testKeys))
hl.define_submap(testKeys, function()
	hl.bind(f("%s + SHIFT + ALT + K", mainMod), submap("reset"))
end)

-- Helper function to auto close submap after hitting a key when catchall is not an option
local function hitAndReset(func)
	return function()
		hl.dispatch(func)
		hl.dispatch(submap("reset"))
	end
end

hl.define_submap(groups, function()
	hl.bind("T", hl.dsp.group.toggle())
	hl.bind("L", hl.dsp.group.lock({ action = "toggle" }))
	hl.bind("left", win.move({ group_aware = true, direction = "l" }))
	hl.bind("right", win.move({ group_aware = true, direction = "r" }))
	hl.bind("tab", hl.dsp.group.next())
	hl.bind("SHIFT + left", hl.dsp.group.move_window({ forward = false }))
	hl.bind("SHIFT + right", hl.dsp.group.move_window())
	hl.bind("SHIFT + tab", hl.dsp.group.prev())
	hl.bind("escape", submap("reset"))
end)

hl.define_submap(power, "reset", function()
	hl.bind("L", exec("loginctl lock-session"))
	hl.bind("Q", exec("uwsm stop"))
	hl.bind("S", exec("systemctl -i suspend"))
	hl.bind("H", exec("systemctl -i hibernate"))
	hl.bind("R", exec("systemctl -i reboot"))
	hl.bind("P", exec("systemctl -i poweroff"))
	hl.bind("catchall", submap("reset"))
end)

hl.define_submap(scrGrab, function()
	hl.bind("E", submap(swappy))
	hl.bind("S", submap(save))
	hl.bind("R", submap(rec))
	hl.bind("escape", submap("reset"))
	hl.define_submap(swappy, "reset", function()
		hl.bind("A", exec(f("lshot -f %s -e 'swappy -f'", ssfile)))
		hl.bind("O", exec(f("lshot -f %s -e 'swappy -f' -o", ssfile)))
		hl.bind("W", exec(f("lshot -f %s -e 'swappy -f' -w", ssfile)))
		hl.bind("R", exec(f("lshot -f %s -e 'swappy -f' -r", ssfile)))
		hl.bind("SHIFT + A", exec(f("lshot -f %s -e 'swappy -f' -d 2", ssfile)))
		hl.bind("SHIFT + O", exec(f("lshot -f %s -e 'swappy -f' -d 2 -o", ssfile)))
		hl.bind("SHIFT + W", exec(f("lshot -f %s -e 'swappy -f' -d 2 -w", ssfile)))
		hl.bind("SHIFT + R", exec(f("lshot -f %s -e 'swappy -f' -d 2 -r", ssfile)))
		hl.bind("escape", submap("reset"))
	end)
	hl.define_submap(save, "reset", function()
		hl.bind("A", exec(f("lshot -f %s -c", ssfile)))
		hl.bind("O", exec(f("lshot -f %s -c -o", ssfile)))
		hl.bind("W", exec(f("lshot -f %s -c -w", ssfile)))
		hl.bind("R", exec(f("lshot -f %s -c -r", ssfile)))
		hl.bind("SHIFT + A", exec(f("lshot -f %s -c -d 2", ssfile)))
		hl.bind("SHIFT + O", exec(f("lshot -f %s -c -d 2 -o", ssfile)))
		hl.bind("SHIFT + W", exec(f("lshot -f %s -c -d 2 -w", ssfile)))
		hl.bind("SHIFT + R", exec(f("lshot -f %s -c -d 2 -r", ssfile)))
		hl.bind("escape", submap("reset"))
	end)
	hl.define_submap(rec, "reset", function()
		hl.bind("O", exec(f("lwfrec -f %s", srfile)))
		hl.bind("R", exec(f("lwfrec -f %s -r", srfile)))
		hl.bind("S", exec("lwfrec --stop"))
		hl.bind("escape", submap("reset"))
	end)
end)

hl.define_submap(window, function()
	hl.bind("right", win.move({ x = 5, y = 0, relative = true }), { repeating = true })
	hl.bind("left", win.move({ x = -5, y = 0, relative = true }), { repeating = true })
	hl.bind("up", win.move({ x = 0, y = -5, relative = true }), { repeating = true })
	hl.bind("down", win.move({ x = 0, y = 5, relative = true }), { repeating = true })
	hl.bind("CONTROL + right", win.move({ x = 25, y = 0, relative = true }), { repeating = true })
	hl.bind("CONTROL + left", win.move({ x = -25, y = 0, relative = true }), { repeating = true })
	hl.bind("CONTROL + up", win.move({ x = 0, y = -25, relative = true }), { repeating = true })
	hl.bind("CONTROL + down", win.move({ x = 0, y = 25, relative = true }), { repeating = true })
	hl.bind("SHIFT + right", win.resize({ x = 5, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + left", win.resize({ x = -5, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + up", win.resize({ x = 0, y = -5, relative = true }), { repeating = true })
	hl.bind("SHIFT + down", win.resize({ x = 0, y = 5, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + right", win.resize({ x = 25, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + left", win.resize({ x = -25, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + up", win.resize({ x = 0, y = -25, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + down", win.resize({ x = 0, y = 25, relative = true }), { repeating = true })
	hl.bind("mouse:272", win.drag(), { mouse = true })
	hl.bind("mouse:273", win.resize(), { mouse = true })

	hl.bind("C", hitAndReset(win.center()))
	hl.bind("F", hitAndReset(win.fullscreen({ action = "toggle" })))
	hl.bind("P", hitAndReset(win.pin({ action = "toggle" })))
	hl.bind("V", hitAndReset(win.float({ action = "toggle" })))

	hl.bind("escape", submap("reset"))
	hl.bind("return", submap("reset"))
end)
