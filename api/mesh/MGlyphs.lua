local tove = require("thirdparty.tove.init")
local freetype = require("freetype")

local MGlyphs = class.class("MGlyph")

function MGlyphs:init(glyphs)
   self.glyphs = glyphs
end

local function to_vector(glyph, g)
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

function MGlyphs:to_vector(subdivisions)
   local g = tove.newGraphics()
   g:setDisplay("mesh", tove.newRigidTesselator(subdivisions or 2))
   g:setLineColor(1, 1, 1)

   fun.iter(self.glyphs):each(function(glyph) to_vector(glyph, g) end)
   g:stroke()

   return g
end

function MGlyphs:to_mesh(subdivisions)
   local g = self:to_vector(subdivisions)
   g:draw()
   return g._cache.mesh._mesh
end

return MGlyphs
