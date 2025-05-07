-- We set up local lua debugger, this is optional but suggested!

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
   require("lldebugger").start()
end

if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
   local lldebugger = require "lldebugger"
   lldebugger.start()
   local run = love.run
   --- @diagnostic disable-next-line
   function love.run(...)
       local f = lldebugger.call(run, false, ...)
       return function(...) return lldebugger.call(f, false, ...) end
   end
end
