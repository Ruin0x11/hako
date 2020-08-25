--- @module math

--- Clamps a number `i` between two numbers `min` and `max`.
---
--- @tparam number i
--- @tparam number min
--- @tparam number max
--- @treturn number
function math.clamp(i, min, max)
   return math.min(max, math.max(min, i))
end

--- If `v` is negative, returns `-1`. Else, returns `1`.
---
--- @tparam number v
--- @treturn integer
function math.sign(v)
   return (v >= 0 and 1) or -1
end

--- Rounds a number to the specified number of digits.
---
--- @tparam number v
--- @tparam[opt] uint digits
--- @treturn number
function math.round(v, digits)
   digits = digits or 0
   local bracket = 1 / (10 ^ digits)
   return math.floor(v/bracket + math.sign(v) * 0.5) * bracket
end

--- Returns "integer" if x is an integer, "float" if it is a float, or nil if x is not a number.
---
--- Ported from 5.3.
--- @param x
--- @treturn string
function math.type(x)
   if type(x) ~= "number" then
      return nil
   end

   if math.floor(x) == x then
      return "integer"
   end

   return "float"
end
