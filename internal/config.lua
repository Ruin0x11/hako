local fs = require("util.fs")

local config = {}

config["base.default_font"] = "kochi-gothic-subst.ttf"
if fs.is_file("data/font/MS-Gothic.ttf") then
   config["base.default_font"] = "MS-Gothic.ttf"
end

-- Don't overwrite existing values in the current config.
config.on_hotload = function(old, new)
   for k, v in pairs(new) do
      if old[k] == nil then
         old[k] = v
      end
   end
end

return config
