local Log = require("api.Log")
local env = require("internal.env")

local hotload = {}

--- Reloads a path or a class required from a path that has been
--- required already by updating its table in-place. If either the
--- result of `require` or the existing item in package.loaded are not
--- tables, the existing item is overwritten instead.
-- @tparam string|table path
-- @tparam bool also_deps If true, also hotload any nested
-- dependencies loaded with `require` that any hotloaded chunk tries
-- to load.
-- @treturn table
function hotload.hotload(path_or_class, also_deps)
   if type(path_or_class) == "table" then
      local path = env.get_require_path(path_or_class)
      if path == nil then
         error("Unknown require path for " .. tostring(path_or_class))
      end

      path_or_class = path
   end

   local ok, result

   ok, result = xpcall(env.hotload_path, debug.traceback, path_or_class, also_deps)
   if not ok then
      Log.error("Error on hotload-path: %s", result)
   end

   if not ok then
      error(result)
   end

   return result
end

return hotload
