local InputHandler = require("api.gui.InputHandler")
local IUiLayer = require("api.gui.IUiLayer")
local IInput = require("api.gui.IInput")
local KeyHandler = require("api.gui.KeyHandler")
local Log = require("api.Log")
local SaveFs = require("api.SaveFs")

local draw = require("internal.draw")

local root_layer = class.class("root_layer", IUiLayer)

root_layer:delegate("keys", IInput)

function root_layer:init()
   self.sublayer = nil
   self.repl = nil

   local keys = KeyHandler:new(true)
   self.keys = InputHandler:new(keys)
   self.keys:bind_keys(self:make_keymap())
   self.keys:focus()
end

function root_layer:make_keymap()
   return {
      repl = function()
         self:query_repl()
      end
   }
end

function root_layer:set_layer(sublayer)
   assert(class.is_an(IUiLayer, sublayer))
   self.sublayer = sublayer
   self.keys:forward_to(self.sublayer)
end

function root_layer:query_repl()
   if self.repl == nil then
      self:setup_repl()
   end

   if draw.is_layer_active(self.repl) then
      return
   end

   -- The repl could get hotloaded, so keep it in an upvalue.
   local repl = self.repl
   repl:query()

   if repl then
      repl:save_history()
   end
end

function root_layer:setup_repl()
   -- avoid circular requires that depend on internal.field, since
   -- `Repl.generate_env()` auto-requires the full public API.
   local Repl = require("api.Repl")
   local ReplLayer = require("api.gui.menu.ReplLayer")

   local repl_env, history = Repl.generate_env()

   self.repl = ReplLayer:new(repl_env, { history = history, history_file = "data/repl_history" })
   self.repl:relayout()
end

function root_layer:relayout(x, y, width, height)
   self.x = x or self.x
   self.y = y or self.y
   self.width = width or self.width
   self.height = height or self.height
   if self.sublayer then
      self.sublayer:relayout(x, y, width, height)
   end
end

function root_layer:update(dt, ran_action, result)
   if self.sublayer then
      self.sublayer:update(dt)
   end
end

function root_layer:draw()
   if self.sublayer then
      self.sublayer:draw()
   end
end

return root_layer
