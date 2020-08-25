local Draw = require("api.Draw")
local IUiLayer = require("api.gui.IUiLayer")
local InputHandler = require("api.gui.InputHandler")
local IInput = require("api.gui.IInput")

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
end

function TestLayer:draw()
   Draw.set_color(255, 255, 255)
   Draw.filled_rect(50, 50, 100, 100)
end

function TestLayer:update()
end

return TestLayer
