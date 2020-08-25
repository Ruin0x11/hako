local tr0 = require("thirdparty.luapower.tr0")
local tove = require("thirdparty.tove.init")
local MGlyphs = require("api.mesh.MGlyphs")

local MFonts = class.class("MFonts")

function MFonts:init(font, name)
   self.tr = tr0()
end

function MFonts:add_font(font, name)
   self.tr:add_font_file(font, name)
   self.font = self.font or font
   self.name = self.name or name
end

function MFonts:make_glyph(str, font_size, font_name)
   font_size = font_size or 12
   font_name = font_name or self.name

   local t = self.tr:flatten {
      font_name = font_name .. "," .. tostring(font_size),
      line_spacing = 1,
      str
   }

   local segs = self.tr:shape(t)
   local a = segs:layout(0, 0, 1, 1, "center", "bottom")

   local g = tove.newGraphics()
   g:setDisplay("mesh")
   g:setLineColor(1, 1, 1)

   local map = function(line)
      local seg = line.first
      local res = {}
      while seg do
         local run = seg.glyph_run
         local i = 1

         local glyph_index = run.info[i].codepoint
         local px = i > 0 and run.pos[i-1].x_advance / 64 or 0
         local ox = run.pos[i].x_offset / 64
         local oy = run.pos[i].y_offset / 64

         local ax = 0
         local ay = 0

         local glyph = self.tr.rs:load_glyph(run.font, run.font_size, glyph_index)
         res[#res+1] = glyph

         seg = seg.next_vis
      end
      return res
   end

   local glyphs = fun.iter(a:checklines()):flatmap(map)
   return MGlyphs:new(glyphs)
end

return MFonts
