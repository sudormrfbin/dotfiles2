-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local terminal = "kitty"
local launcher = "rofi -no-lazy-grab -show drun -modi drun"

-- Default modkey (super)
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.spiral.dwindle, -- bspwm like
	awful.layout.suit.max,
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	-- awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(current_screen)
	-- Wallpaper
	set_wallpaper(current_screen)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4" }, current_screen, awful.layout.layouts[1])

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	current_screen.mylayoutbox = awful.widget.layoutbox(current_screen)
	current_screen.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	current_screen.mytaglist = awful.widget.taglist({
		screen = current_screen,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	current_screen.mytasklist = awful.widget.tasklist({
		screen = current_screen,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- Create the wibox
	current_screen.mywibox = awful.wibar({ position = "top", screen = current_screen })

	-- Add widgets to the wibox
	current_screen.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			current_screen.mytaglist,
		},
		current_screen.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),
			mytextclock,
			current_screen.mylayoutbox,
		},
	})
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- Construct a keybind that does `action` when `mod + key` is pressed.
-- @param key A key like "Left", "j", etc
-- @param action A function to run when key in pressed
-- @return awful.key() instance
local function mod(key, action)
	return awful.key({ modkey }, key, action)
end

-- Construct a keybind that does `action` when `mod + shift + key` is pressed.
-- @see mod()
local function mod_shift(key, action)
	return awful.key({ modkey, "Shift" }, key, action)
end

-- Construct a keybind that does `action` when `mod + control + key` is pressed.
-- @see mod()
local function mod_ctrl(key, action)
	return awful.key({ modkey, "Control" }, key, action)
end

-- Construct a keybind that does `action` when `mod + alt + key` is pressed.
-- @see mod()
local function mod_alt(key, action)
	return awful.key({ modkey, "Alt" }, key, action)
end

-- Construct a keybind invoked with `keyn`.
local function key(keyn, action)
	return awful.key({}, keyn, action)
end

-- Change current focussed client by direction (left, up, etc)
local function focusto(dir)
	return function()
		awful.client.focus.bydirection(dir)
	end
end

-- Swap current focussed client with client in `direction` (left, up, etc)
local function swapwith(dir)
	return function()
		awful.client.swap.bydirection(dir)
	end
end

-- Returns function that spawns `program` when called
local function spawn(program)
	return function()
		awful.spawn(program)
	end
end

local function audio(action, command)
	return key("XF86Audio"..action, spawn(command))
end

local function bright(action, command)
	return key("XF86MonBrightness"..action, spawn(command))
end

-- {{{ Key bindings
local globalkeys = gears.table.join(
	-- TODO: add keys for resizing clients
	mod("a", spawn(launcher)),
	mod("Return", spawn(terminal)),
	mod("j", focusto("down")),
	mod("k", focusto("up")),
	mod("h", focusto("left")),
	mod("l", focusto("right")),
	mod_shift("j", swapwith("down")),
	mod_shift("k", swapwith("up")),
	mod_shift("h", swapwith("left")),
	mod_shift("l", swapwith("right")),
	mod_ctrl("j", function() awful.client.incwfact(-0.10) end),
	mod_ctrl("k", function() awful.client.incwfact(0.10) end),
	mod_ctrl("h", function() awful.tag.incmwfact(-0.10) end),
	mod_ctrl("l", function() awful.tag.incmwfact(0.10) end),
	audio("LowerVolume", "amixer -D pulse sset Master 5%-"),
	audio("RaiseVolume", "amixer -D pulse sset Master 5%+"),
	audio("Mute", "amixer -D pulse set Master 1+ toggle"),
	audio("Play", "playerctl play-pause"),
	audio("Next", "playerctl next"),
	audio("Prev", "playerctl previous"),
	bright("Up", "light -A 1"),
	bright("Down", "light -U 1"),
	mod_ctrl("r", awesome.restart),
	mod_ctrl("q", awesome.quit),
	mod("space", function() awful.layout.inc(1) end),
	mod_shift("space", function() awful.layout.inc(-1) end),
	mod("Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end)
)

-- Toggle a client property like fullscreen, floating, etc.
-- Also raises the client.
local function clienttoggle(property)
	return function(client)
		client[property] = not client[property]
		client:raise()
	end
end

local clientkeys = gears.table.join(
	mod("x", function(c) c:kill() end),
	mod("f", clienttoggle("fullscreen")),
	mod("t", clienttoggle("floating")),
	mod("n", clienttoggle("maximized")),
	mod_alt("j", clienttoggle("maximized_vertical")),
	mod_alt("l", clienttoggle("maximized_horizontal"))
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
for i = 1, 4 do
	globalkeys = gears.table.join(
		globalkeys, -- View tag only.
		mod("#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end),
		mod_shift("#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end)
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey, "Shift" }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to dialogs
	{
		rule_any = { type = { "dialog" } },
		properties = { titlebars_enabled = true },
	},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
-- }}}
