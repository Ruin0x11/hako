local Log = require("api.Log")
local draw = require("internal.draw")
local Input = require("api.Input")

function Input.reload_keybinds()
   Log.debug("Reloading keybinds.")

   local layer = draw.get_current_layer()
   if layer then
      layer.layer:focus()
   end
end

return Input
