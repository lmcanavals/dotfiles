local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- local tablet = "device[wacom-one-by-wacom-m-pen]"
local ssfile = "$HOME/Pictures/Screenshots/$(date '+%Y%m%d_%H%M%S_%N').png"
local srfile = "$HOME/Videos/Screencasts/$(date '+%Y%m%d_%H%M%S_%N').mp4"
local myEsp = "x"

-- programs we use
local browser = "xdg-open https://google.com"
local clipboardTool = 'cliphist list | fuzzel --placeholder="  clipboard" --dmenu | cliphist decode | wl-copy'
local fileManager = "uwsm-app -- dolphin"
local lvolbri = "lvolbri"
local mailClient = "uwsm-app -- thunderbird"
local menuDrun = 'fuzzel --placeholder="󰀻  applications" --show-actions'
local menuRun = 'fuzzel --placeholder=" _ command" --list-executables-in-path'
local fyi = "fyi -u low -i computer"
local terminal = "uwsm-app -- foot"

-- submap names 󰫮󰫯󰫰󰫱󰫲󰫳󰫴󰫵󰫶󰫷󰫸󰫹󰫺󰫻󰫼󰫽󰫾󰫿󰬀󰬁󰬂󰬃󰬄󰬅󰬆󰬇┃┊│
local groups = "󰓩 : 󰬁 Togl │󰫹 Lck │󰌒 │ │"
local power = " : 󰫹  │ 󰫾 󰍃 │ 󰬀 󰒲 │ 󰫵 󰤄 │ 󰫿 󰜉 │ 󰫽 󰐥"
local scrGrab = "󰹑 : 󰫲 󱇣│󰬀 󰉏│󰫿 "
local swappy = "󱇣 : 󰫮󰍺│󰫼󰍹│󰬄│󰫿󰩭"
local save = "󰉏 : 󰫮󰍺│󰫼󰍹│󰬄│󰫿󰩭"
local rec = " : 󰫼 󰍹│󰫿 󰩭│󰬀 "
local window = " 󰙕 : 󰞗 │󰞖 │󰞙 │󰞘"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
if hl.get_config("general.layout") == "scrolling" then
	hl.bind(mainMod .. " + left", hl.dsp.layout("focus left"))
	hl.bind(mainMod .. " + right", hl.dsp.layout("focus right"))
	hl.bind(mainMod .. " + page_up", hl.dsp.layout("colresize +conf"))
	hl.bind(mainMod .. " + page_down", hl.dsp.layout("colresize -conf"))
	hl.bind(mainMod .. " + space", hl.dsp.layout("fit all"))
	hl.bind(mainMod .. " + SHIFT + left", hl.dsp.layout("swapcol l"))
	hl.bind(mainMod .. " + SHIFT + right", hl.dsp.layout("swapcol r"))
	hl.bind(mainMod .. " + SHIFT + page_up", hl.dsp.layout("consume_or_expel next"))
	hl.bind(mainMod .. " + SHIFT + page_down", hl.dsp.layout("consume_or_expel prev"))
else
	hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
	hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
	hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
end
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + G", hl.dsp.submap(groups))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(fyi .. ' Missing "Settings Win+I"'))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + M", hl.dsp.submap(power))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menuDrun))
hl.bind(mainMod .. " + S", hl.dsp.submap(scrGrab))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + W", hl.dsp.submap(window))
hl.bind(mainMod .. " + X", hl.dsp.workspace.toggle_special(myEsp))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(clipboardTool))

hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("systemctl --user reload waybar"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(menuRun))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("lshot -f " .. ssfile .. "'swappy -f' -r"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special:" .. myEsp }))

hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + escape", hl.dsp.submap("reset"), { submap_universal = true })
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("uwsm-app -- lmojis"))
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
local function hyprZoom(mode)
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
local function zoomHelper(mode)
	return function()
		hyprZoom(mode)
	end
end
hl.bind(mainMod .. " + ALT + 0", zoomHelper("reset"))
hl.bind(mainMod .. " + ALT + mouse_down", zoomHelper("in"))
hl.bind(mainMod .. " + ALT + mouse_up", zoomHelper("out"))
hl.bind(mainMod .. " + ALT + equal", zoomHelper("in"), { repeating = true })
hl.bind(mainMod .. " + ALT + minus", zoomHelper("out"), { repeating = true })
hl.bind(mainMod .. " + ALT + KP_ADD", zoomHelper("in"), { repeating = true })
hl.bind(mainMod .. " + ALT + KP_SUBTRACT", zoomHelper("out"), { repeating = true })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(lvolbri .. " -m vol_up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(lvolbri .. " -m vol_down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(lvolbri .. " -m vol_mute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(lvolbri .. " -m mic_mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(lvolbri .. " -m bright_down"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(lvolbri .. " -m bright_up"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(lvolbri .. " -m next_track"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(lvolbri .. " -m play_pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(lvolbri .. " -m play_pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(lvolbri .. " -m prev_track"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(lvolbri .. " -m play_stop"), { locked = true })

-- Other special keys
hl.bind("Print", hl.dsp.submap(scrGrab), { locked = true })
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

-- Helper function to auto close submap after hitting a key when catchall is not an option
local function hitAndReset(func)
	return function()
		hl.dispatch(func)
		hl.dispatch(hl.dsp.submap("reset"))
	end
end

hl.define_submap(groups, function()
	hl.bind("T", hl.dsp.group.toggle())
	hl.bind("L", hl.dsp.group.lock_active({ action = "toggle" }))
	hl.bind("left", hl.dsp.window.move({ group_aware = true, direction = "l" }))
	hl.bind("right", hl.dsp.window.move({ group_aware = true, direction = "r" }))
	hl.bind("tab", hl.dsp.group.next())
	hl.bind("SHIFT + left", hl.dsp.group.move_window({ forward = false }))
	hl.bind("SHIFT + right", hl.dsp.group.move_window())
	hl.bind("SHIFT + tab", hl.dsp.group.prev())
	hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.define_submap(power, "reset", function()
	hl.bind("L", hl.dsp.exec_cmd("loginctl lock-session"))
	hl.bind("Q", hl.dsp.exec_cmd("uwsm stop"))
	hl.bind("S", hl.dsp.exec_cmd("systemctl -i suspend"))
	hl.bind("H", hl.dsp.exec_cmd("systemctl -i hibernate"))
	hl.bind("R", hl.dsp.exec_cmd("systemctl -i reboot"))
	hl.bind("P", hl.dsp.exec_cmd("systemctl -i poweroff"))
	hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.define_submap(scrGrab, function()
	hl.bind("E", hl.dsp.submap(swappy))
	hl.bind("S", hl.dsp.submap(save))
	hl.bind("R", hl.dsp.submap(rec))
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.define_submap(swappy, "reset", function()
		hl.bind("A", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -e 'swappy -f'"))
		hl.bind("O", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -e 'swappy -f' -o"))
		hl.bind("W", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -e 'swappy -f' -w"))
		hl.bind("R", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -e 'swappy -f' -r"))
		hl.bind("SHIFT + A", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -e 'swappy -f' -d 2"))
		hl.bind("SHIFT + O", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -e 'swappy -f' -d 2 -o"))
		hl.bind("SHIFT + W", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -e 'swappy -f' -d 2 -w"))
		hl.bind("SHIFT + R", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -e 'swappy -f' -d 2 -r"))
		hl.bind("escape", hl.dsp.submap("reset"))
	end)
	hl.define_submap(save, "reset", function()
		hl.bind("A", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -c"))
		hl.bind("O", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -c -o"))
		hl.bind("W", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -c -w"))
		hl.bind("R", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -c -r"))
		hl.bind("SHIFT + A", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -c -d 2"))
		hl.bind("SHIFT + O", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -c -d 2 -o"))
		hl.bind("SHIFT + W", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -c -d 2 -w"))
		hl.bind("SHIFT + R", hl.dsp.exec_cmd("lshot -f " .. ssfile .. " -c -d 2 -r"))
		hl.bind("escape", hl.dsp.submap("reset"))
	end)
	hl.define_submap(rec, "reset", function()
		hl.bind("O", hl.dsp.exec_cmd("lwfrec -f " .. srfile))
		hl.bind("R", hl.dsp.exec_cmd("lwfrec -f " .. srfile .. " -r"))
		hl.bind("S", hl.dsp.exec_cmd("lwfrec --stop"))
		hl.bind("escape", hl.dsp.submap("reset"))
	end)
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
	hl.bind("SHIFT + right", hl.dsp.window.resize({ x = 5, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + left", hl.dsp.window.resize({ x = -5, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + up", hl.dsp.window.resize({ x = 0, y = -5, relative = true }), { repeating = true })
	hl.bind("SHIFT + down", hl.dsp.window.resize({ x = 0, y = 5, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + right", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + left", hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + up", hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true })
	hl.bind("SHIFT + CONTROL + down", hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true })
	hl.bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
	hl.bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

	hl.bind("C", hitAndReset(hl.dsp.window.center()))
	hl.bind("F", hitAndReset(hl.dsp.window.fullscreen({ action = "toggle" })))
	hl.bind("P", hitAndReset(hl.dsp.window.pin({ action = "toggle" })))
	hl.bind("V", hitAndReset(hl.dsp.window.float({ action = "toggle" })))

	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
end)
