local draw = require("internal.draw")
local TestLayer = require("sketch.TestLayer")
local root = require("game.root")
local Repl = require("api.Repl")
local SaveFs = require("api.SaveFs")

local game = {}

local function cb(dt)
   SaveFs.load_game("main")

   local layer = TestLayer:new()

   root:set_layer(layer)

   root:query()
end

local function startup()
   rawset(_G, "pause", function(...) return Repl.pause(...) end)
end

function game.update(dt)
   startup()

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
