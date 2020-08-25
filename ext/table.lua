--- @module table

--- Merges two tables &mdash; values from first get overwritten by the second.
--- @usage
-- function some_func(x, y, args)
--     args = table.merge({option1=false}, args)
--     if opts.option1 == true then return x else return y end
-- end
-- some_func(1,2) -- returns 2
-- some_func(1,2,{option1=true}) -- returns 1
-- @tparam table tblA first table
-- @tparam table tblB second table
-- @treturn list|table a list or an associated list where tblA and tblB have been merged
function table.merge(tblA, tblB)
   if not tblB then
      return tblA
   end
   for k, v in pairs(tblB) do
      tblA[k] = v
   end
   return tblA
end

function table.imerge(tblA, tblB)
   if not tblB then
      return tblA
   end
   for _, v in ipairs(tblB) do
      table.insert(tblA, v)
   end
   return tblA
end

--- Merges two tables, where values from b are overridden by values
--- already in a.
-- @tparam table a
-- @tparam table b
-- @treturn table
function table.merge_missing(a, b)
   if not b then
      return a
   end

   for k, v in pairs(b) do
      if a[k] == nil then
         a[k] = v
      end
   end

   return a
end

--- Merges two tables, where keys from b that are not in a will have
--- their values discarded.
-- @tparam table a
-- @tparam table b
-- @treturn table
function table.merge_existing(a, b)
   if not b then
      return a
   end

   for k, v in pairs(b) do
      if a[k] ~= nil then
         a[k] = v
      end
   end

   return a
end
--- @module table

--- Merges two tables &mdash; values from first get overwritten by the second.
--- @usage
-- function some_func(x, y, args)
--     args = table.merge({option1=false}, args)
--     if opts.option1 == true then return x else return y end
-- end
-- some_func(1,2) -- returns 2
-- some_func(1,2,{option1=true}) -- returns 1
-- @tparam table tblA first table
-- @tparam table tblB second table
-- @treturn list|table a list or an associated list where tblA and tblB have been merged
function table.merge(tblA, tblB)
   if not tblB then
      return tblA
   end
   for k, v in pairs(tblB) do
      tblA[k] = v
   end
   return tblA
end

function table.imerge(tblA, tblB)
   if not tblB then
      return tblA
   end
   for _, v in ipairs(tblB) do
      table.insert(tblA, v)
   end
   return tblA
end

--- Merges two tables, where values from b are overridden by values
--- already in a.
-- @tparam table a
-- @tparam table b
-- @treturn table
function table.merge_missing(a, b)
   if not b then
      return a
   end

   for k, v in pairs(b) do
      if a[k] == nil then
         a[k] = v
      end
   end

   return a
end

--- Merges two tables, where keys from b that are not in a will have
--- their values discarded.
-- @tparam table a
-- @tparam table b
-- @treturn table
function table.merge_existing(a, b)
   if not b then
      return a
   end

   for k, v in pairs(b) do
      if a[k] ~= nil then
         a[k] = v
      end
   end

   return a
end

--- Converts n list to a set, with all keys set to "true".
-- @tparam list list
-- @tparam bool keep_map_part if true, also keep any existing entries in the map part of the table.
-- @treturn table
function table.set(list, keep_map_part)
   local tbl = {}
   if keep_map_part then
      for k, v in pairs(list) do
         if type(k) == "number" then
            tbl[v] = true
         else
            tbl[k] = v
         end
      end
   else
      for _, k in ipairs(list) do
         tbl[k] = true
      end
   end
   return tbl
end

--- Replaces one table with another such that existing
--- globals/upvalues pointing to the table will also be updated
--- in-place.
-- @tparam table tbl
-- @tparam table other
-- @treturn table
function table.replace_with(tbl, other)
   if tbl == other then
      return tbl
   end

   for k, _ in pairs(tbl) do
      tbl[k] = nil
   end

   for k, v in pairs(other) do
      tbl[k] = v
   end

   return tbl
end

local function cycle_aware_copy(t, cache)
    if type(t) ~= 'table' then return t end
    if cache[t] then return cache[t] end
    local res = {}
    cache[t] = res
    local mt = getmetatable(t)
    for k,v in pairs(t) do
        k = cycle_aware_copy(k, cache)
        v = cycle_aware_copy(v, cache)
        res[k] = v
    end
    setmetatable(res,mt)
    return res
end

--- make a deep copy of a table, recursively copying all the keys and fields.
-- This supports cycles in tables; cycles will be reproduced in the copy.
-- This will also set the copied table's metatable to that of the original.
-- @within Copying
-- @tparam table t A table
-- @treturn table new table
function table.deepcopy(t)
   return cycle_aware_copy(t,{})
end

--- Makes a shallow copy of a table.
--- @tparam table tbl
--- @treturn table
function table.shallow_copy(tbl)
   local new = {}
   for k, v in pairs(tbl) do
      new[k] = v
   end
   return new
end

-- Returns the keys of a dictionary-like table.
-- @tparam table tbl
-- @treturn list
function table.keys(tbl)
   local arr = {}
   for k, _ in pairs(tbl) do
      arr[#arr+1] = k
   end
   return arr
end

-- Returns the values of a dictionary-like table.
-- @tparam table tbl
-- @treturn list
function table.values(tbl)
   local arr = {}
   for _, v in pairs(tbl) do
      arr[#arr+1] = v
   end
   return arr
end

--- Returns the unique values in a table.
function table.unique(tbl)
   return table.keys(table.set(tbl))
end

--- Removes the specified indices from an list-like table. The indices
--- must be an list of integers with no duplicates sorted in ascending
--- order.
function table.remove_indices(arr, inds)
   local offset = 0
   for _, ind in ipairs(inds) do
      table.remove(arr, ind-offset)
      offset = offset + 1
   end
   return arr
end

function table.remove_keys(map, keys)
   for _, key in ipairs(keys) do
      map[key] = nil
   end
   return map
end

function table.remove_by(arr, f)
   local inds = {}
   for i, v in ipairs(arr) do
      if f(v) then
         inds[#inds+1] = i
      end
   end
   return table.remove_indices(arr, inds)
end

--- Removes a value from a list-like table.
---
--- @tparam table tbl
--- @tparam any value
--- @treturn[opt] any the removed value
function table.iremove_value(tbl, value)
   local result

   local ind
   for i, v in ipairs(tbl) do
      if v == value then
         ind = i
         break
      end
   end
   if ind then
      result = table.remove(tbl, ind)
   end

   return result
end

function table.iremove_by(arr, pred)
   local inds = {}
   for i, v in ipairs(arr) do
      if pred(v) then
         inds[#inds+1] = i
      end
   end

   local offset = 0
   for _, ind in ipairs(inds) do
      table.remove(arr, ind-offset)
      offset = offset + 1
   end

   return inds
end

--- Flattens an list-like table one layer down.
-- @tparam list arr
-- @treturn list
function table.flatten(arr)
   local result = {}

   local function flatten(arr)
      for _, v in ipairs(arr) do
         table.insert(result, v)
      end
   end

   for _, v in ipairs(arr) do
      flatten(v)
   end

   return result
end

table.unpack = unpack
