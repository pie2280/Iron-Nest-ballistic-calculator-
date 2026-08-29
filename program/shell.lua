local current_file = debug.getinfo(1, "S").source:sub(2)
local script_dir = current_file:match("(.*[/\\])") or "./"
package.path = package.path .. ";" .. script_dir .. "?.lua"

local main = require("main")
print("Iron Nest ballisic calculator")

while true do
  io.write("INBC-shell> ")
  io.flush()
  local cmd = io.read()
  if cmd=="exit" then break end
  if cmd~="" then
    local com,arg = main.translate(cmd)
    local response = main.execute(com,arg)
    if type(response)=="table" then
      print(table.unpack(response))
    else
      print(response)
    end
  end
end