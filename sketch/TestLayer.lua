local Draw = require("api.Draw")
local IUiLayer = require("api.gui.IUiLayer")
local InputHandler = require("api.gui.InputHandler")
local IInput = require("api.gui.IInput")
local MFonts = require("api.mesh.MFonts")

local TestLayer = class.class("TestLayer", IUiLayer)

TestLayer:delegate("input", IInput)

function TestLayer:init(bones, this_bone)
   self.input = InputHandler:new()
   self.input:bind_keys(self:make_keymap())
end

function TestLayer:make_keymap()
   return {
      shift = function() self.canceled = true end
   }
end

function TestLayer:relayout(x, y, width, height)
   local f = MFonts:new()
   f:add_font("thirdparty/luapower/media/fonts/OpenSans-Regular.ttf", "open sans")
   local glyphs = f:make_glyph("fff", 11)
   self.vector = glyphs:to_vector()
   self.mesh = glyphs:to_mesh()
end

function TestLayer:draw()
   Draw.clear(192, 192, 192)
   Draw.set_color(0, 0, 0)
   self.vector:draw(109, 700)

   for i = 1, self.mesh:getVertexCount() do
      local x, y = self.mesh:getVertex(i)
      love.graphics.circle("line", x + 109, y + 700, 80.0)
   end
end

function TestLayer:update()
end

return TestLayer
