local draw = require("internal.draw")
local TestLayer = require("sketch.TestLayer")

local game = {}

local function cb(dt)
   local layer = TestLayer:new()

   layer:query()
end

function game.update(dt)
   local going = true
   while going do
      local success, action = xpcall(cb, debug.traceback)
      if not success then
         local err = action
         coroutine.yield(err)
      else
         if action == "quit" then
            going = false
         end
      end
   end
end

function game.draw()
   local going = true

   while going do
      local ok, ret = xpcall(draw.draw_layers, debug.traceback)

      if not ok then
         going = coroutine.yield(ret)
      else
         going = coroutine.yield()
      end
   end
end

return game
