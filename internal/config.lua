local fs = require("util.fs")

local config = {}

config["base.default_font"] = "kochi-gothic-subst.ttf"
if fs.is_file("data/font/MS-Gothic.ttf") then
   config["base.default_font"] = "MS-Gothic.ttf"
end
config["base.keybinds"] = {
   cancel = "shift",
   escape = "escape",
   quit = "escape",
   north = {"up", "kp8"},
   south = {"down", "kp2"},
   west = {"left", "kp4"},
   east = {"right", "kp6"},
   northwest = "kp7",
   northeast = "kp9",
   southwest = "kp1",
   southeast = "kp3",

   repl = "`",
   repl_page_up = {"pageup", "ctrl_u"},
   repl_page_down = {"pagedown", "ctrl_d"},
   repl_first_char = {"home", "ctrl_a"},
   repl_last_char = {"end", "ctrl_e"},
   repl_paste = "ctrl_v",
   repl_cut = "ctrl_x",
   repl_copy = "ctrl_c",
   repl_clear = "ctrl_l",
   repl_complete = "tab",
   repl_toggle_fullscreen = "ctrl_f",
}

-- Don't overwrite existing values in the current config.
config.on_hotload = function(old, new)
   for k, v in pairs(new) do
      if old[k] == nil then
         old[k] = v
      end
   end
end

return config
