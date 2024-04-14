-- Pull in the wezterm API
local wezterm = require 'wezterm'

local workspaces = {
  bernardo = '/home/gokul/Projects/bernardo',
  helix = '/home/gokul/Projects/helix',
  floem = '/home/gokul/Projects/floem',
}

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Mocha'
config.font_size = 18
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.default_cursor_style = 'SteadyBar'
-- config.command_palette_rows = 14

local act = wezterm.action

---Wezterm action to set the active tab's name
---@param name string
local function set_tab_name_action(name)
  return wezterm.action_callback(function (win, pane)
  	win:active_tab():set_title(name)
  end)
end

local interactive_tab_rename_action = act.PromptInputLine {
  description = 'Enter new name for tab',
  action = wezterm.action_callback(function(window, pane, line)
    if line then
      window:active_tab():set_title(line)
    end
  end),
}

---Switch to the tab with the given tabname, or rename the current tab to tabname
---@param tabname string
local function tab_rename_or_switch(tabname)
  return wezterm.action_callback(function (window, pane)
    for _, tab in ipairs(window:mux_window():tabs()) do
      if tab:get_title() == tabname then
        tab:activate()
        return
      end
    end

    window:active_tab():set_title(tabname)
  end)
end

---Returns whether a table contains a value or not.
---@param tbl table
---@param val any
---@return boolean
local function contains_value(tbl, val)
	for _, v in ipairs(tbl) do
	  if val == v then
    	return true
    end
  end
  return false
end

---Returns whether a workspace is open or not.
---@param ws_name string
---@return boolean
local function workspace_is_open(ws_name)
  local active_workspaces = wezterm.mux.get_workspace_names()
  return contains_value(active_workspaces, ws_name)
end

--- Wezterm action to switch/create workspaces from a predefined set of projects
local workspace_create_or_switch_action = wezterm.action_callback(function(window, pane)
  local choices = {}
  for name, _ in pairs(workspaces) do
    local label = name
    if workspace_is_open(name) then
    	label = label .. ' (active)'
    end
    table.insert(choices, {label=label, id=name})
  end

  window:perform_action(
    act.InputSelector {
      action = wezterm.action_callback(
        function(inner_window, inner_pane, id, label)
          if not id and not label then
            wezterm.log_info 'cancelled workspace switcher'
          else
            wezterm.log_info('id = ' .. id)
            wezterm.log_info('label = ' .. label)
            local was_open = workspace_is_open(id)
            inner_window:perform_action(
              act.SwitchToWorkspace {
                name = id,
                spawn = {
                  label = 'Workspace: ' .. id,
                  cwd = workspaces[id],
                },
              },
              inner_pane
            )
            if not was_open then
              -- workaround to get the window handle of the newly spawned
              -- workspace. not sure why the inner_window:active_pane() refers
              -- to the new pane in the new workspace but
              -- inner_window():active_tab() still refers to old tab in old workspace.
              local workspace_window = inner_window:active_pane():window()

              local git_tab = workspace_window:active_tab()
              git_tab:active_pane():send_text('lazygit\n\r')
              git_tab:set_title('git')

              local editor_tab = workspace_window:spawn_tab {}
              editor_tab:active_pane():send_text('hx\n\r')
              editor_tab:set_title('editor')
            end
          end
        end
      ),
      title = 'Choose Workspace',
      choices = choices,
      fuzzy = true,
      -- fuzzy_description = 'Fuzzy find and/or make a workspace',
    },
    pane
  )
end)

-------------------------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------------------------

config.keys = {
  {key='/', mods='CTRL', action=act.SpawnTab 'CurrentPaneDomain'},
  {key=',', mods='CTRL', action=act.ActivateTabRelative(-1)},
  {key='.', mods='CTRL', action=act.ActivateTabRelative(1)},
  {key='<', mods='CTRL|SHIFT', action=act.MoveTabRelative(-1)},
  {key='>', mods='CTRL|SHIFT', action=act.MoveTabRelative(1)},
  {key='r', mods='CTRL|SHIFT', action=interactive_tab_rename_action},
  {key='w', mods='CTRL|SHIFT', action=workspace_create_or_switch_action},
  {key='e', mods='CTRL|SHIFT', action=tab_rename_or_switch("editor")},
  {key='g', mods='CTRL|SHIFT', action=tab_rename_or_switch("git")},
}

-- Ctrl-{1-8} to switch tabs
for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL',
    action = act.ActivateTab(i - 1),
  })
end

-------------------------------------------------------------------------------
-- Command Palette
-------------------------------------------------------------------------------

-- wezterm.on('augment-command-palette', function(pane, window)
--   return {
--     {
--       brief = 'Rename tab',
--       icon = 'md_rename_box',
--       action = interactive_tab_rename_action,
--     },
--   }
-- end)

wezterm.on('update-right-status', function(window, pane)
  local available_workspaces = wezterm.mux.get_workspace_names()
  local status = window:active_workspace()
  if #available_workspaces > 1 then
    status = status .. ':' .. #available_workspaces
  end
  window:set_right_status(status)
end)

return config
