local tr0 = require("thirdparty.luapower.tr0")
local tove = require("thirdparty.tove.init")
local freetype = require("freetype")

local Geom = {}

local function to_vector(g, glyph)
   local outline = glyph.outline
   local points = outline.points
   local tags = outline.tags

   local contour_start = 0
   local contour_end

   for j = 0, outline.n_contours-1 do
      contour_end = outline.contours[j]
      print(contour_start, contour_end)
      local offset = contour_start
      local num_pts = contour_end - contour_start + 1

      local point = points[contour_start]
      g:moveTo(point.x, -point.y)

      for i = 0, num_pts-1 do
         local cur_i = i % num_pts + offset
         local next_i = (i+1) % num_pts + offset
         local next_next_i = (i+1) % num_pts + offset

         local x = points[cur_i].x
         local y = -points[cur_i].y
         local nx = points[next_i].x
         local ny = -points[next_i].y

         local cur_on = bit.band(tags[cur_i], freetype.C.FT_CURVE_TAG_ON) ~= 0
         local next_on = bit.band(tags[cur_i], freetype.C.FT_CURVE_TAG_ON) ~= 0
         local next_next_on = bit.band(tags[cur_i], freetype.C.FT_CURVE_TAG_ON) ~= 0
         local cur_ctl = not cur_on
         local next_ctl = not next_on
         local next_next_ctl = not next_next_on

         if cur_ctl and next_ctl then
            x = (x + nx) / 2
            y = (y + ny) / 2
            cur_ctl = false
            if i == 0 then
               g:moveTo(x, y)
            end
         end

         if not cur_ctl and next_ctl then
            local nnx = points[next_next_i].x
            local nny = -points[next_next_i].y
            if next_next_ctl then
               nnx = (nx + nnx) / 2
               nny = (ny + nny) / 2
            end
            g:curveTo(nnx, nny, nnx, nny, nx, ny)
         elseif not cur_ctl and not next_ctl then
            g:lineTo(nx, ny)
         end
      end

      contour_start = contour_end + 1
      g:closePath()
   end
end

function Geom.load_font(font, name, str)
   local tr = tr0()
   tr:add_font_file(font, name)
   local t = tr:flatten {
      font_name = name .. ",14",
      line_spacing = 1,
      str
   }

   local segs = tr:shape(t)
   local a = segs:layout(0, 0, 1, 1, "center", "bottom")

   local g = tove.newGraphics()
   g:setDisplay("mesh")
   g:setLineColor(1, 1, 1)

   local map = function(line)
      local seg = line.first
      while seg do
         local run = seg.glyph_run
         local i = 1

         local glyph_index = run.info[i].codepoint
         local px = i > 0 and run.pos[i-1].x_advance / 64 or 0
         local ox = run.pos[i].x_offset / 64
         local oy = run.pos[i].y_offset / 64

         local ax = 0
         local ay = 0

         local glyph = tr.rs:load_glyph(run.font, run.font_size, glyph_index)

         to_vector(g, glyph)

         seg = seg.next_vis
      end
   end

   fun.iter(a:checklines()):each(map)

   g:stroke()
   return g
end

return Geom
