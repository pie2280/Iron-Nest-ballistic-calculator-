local current_file = debug.getinfo(1, "S").source:sub(2)
local script_dir = current_file:match("(.*[/\\])") or "./"
package.path = package.path .. ";" .. script_dir .. "modules/?.lua"
package.path = package.path .. ";" .. script_dir .. "units/?.lua"

local format = require("format")
local ram = require("ram")
local calc = require("ballistic")
local err = require("errorhandler")
local grid = require("grid")
local helpy = require("help")
local commandTable ={
  ["parse"]=grid.parse,
  ["calculate"]=calc.calc,
  ["convert"]=grid.convert,
  ["ramoverride"]=ram.cleardata,
  ["help"]=helpy.show
}
local function translate(cmd_str)local cmd
  local argTable = {}
  for argument in string.gmatch(cmd_str,"%S+") do
    if not cmd then
      cmd=string.lower(argument)
    else
      table.insert(argTable,argument)
    end
  end
  if #argTable==0 and (cmd~="ramoverride" and cmd~="help") then table.insert(argTable,"-h") end
  return cmd,argTable
end

local function execute(key,arg)
  local ishelp
  local result
  if not commandTable[key] then return err.handler(6) end
  if arg[1]=="-h" then
    ishelp=1
    result = {helpy.show(key)}
  elseif #arg==0 and key=="help" then
    ishelp=1
    result = {helpy.show("help")}
  else
    result ={commandTable[key](arg)}
  end
  if result[#result]~=0 then return err.handler(table.remove(result)) end
  table.remove(result)
  if ishelp then return table.unpack(result) end
  local marker = table.remove(result)
  local output ={format.template(result,marker)}
  if #output==1 then return table.unpack(output) end
  return output
end
return {translate = translate, execute = execute}