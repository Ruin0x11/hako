package.path = package.path .. ";./thirdparty/?.lua;./?/init.lua"

local dir_sep = package.config:sub(1,1)
local is_windows = dir_sep == "\\"

if is_windows then
   package.path = package.path .. ";..\\lib\\luasocket\\?.lua;..\\lib\\lua-vips\\?.lua"
   package.cpath = package.cpath .. ";..\\lib\\luautf8\\?.dll;..\\lib\\luasocket\\?.dll;..\\lib\\luafilesystem\\?.dll"
else
   package.cpath = package.cpath .. ";../lib/?.so"
end

class = require("util.class")

require("ext")

inspect = require("thirdparty.inspect")
fun = require("thirdparty.fun")

-- prevent new globals from here on out.
require("thirdparty.strict")

-- Hook the global `require` to support hotloading.
require("internal.env").hook_global_require()
