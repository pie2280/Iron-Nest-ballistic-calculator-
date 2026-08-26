local current_file = debug.getinfo(1, "S").source:sub(2)
local script_dir = current_file:match("(.*[/\\])") or "./"
package.path = package.path .. ";" .. script_dir .. "modules/?.lua"


local ram = require("ram")
local calc = require("ballistic")
local err = require("errorhandler")
local grid = require("grid")
local commandTable ={
  ["parse"]=grid.parse,
  ["calculate"]=calc.calc,
  ["convert"]=grid.convert,
  ["ramoverride"]=ram.cleardata
}
local function translate(cmd_str)local cmd
  local argTable = {}
  for argument in string.gmatch(cmd_str,"%S+") do
    if not cmd then
      cmd=argument
    else
      table.insert(argTable,argument)
    end
  end
--if #argTable==0 and cmd~="ramoverride" then table.insert(argTable,"-h") end
    return cmd,argTable
end

local function execute(key,arg)
  if not commandTable[key] then return err.handler(6) end
  local result ={commandTable[key](table.unpack(arg))}
  if result[#result]~=0 then return err.handler(table.remove(result)) end
  table.remove(result)
  return result
end
return {translate = translate, execute = execute}