local ballistic = {
  [1]="Invalid argument at ballistic module's input, check input correction and try again.\n",
  [2]="Out of range! increase powder charges or check distance argument.\n"
}
local grid = {
  [3]="Invalid argument at parse command, check input correction and try again.\n",
  [4]="NaN argument detected on coordinate convertion input, check input correction and try again.\n",
  [5]="coordintes input exceeded map limits, this may be possible with using target moving predictor or a similar program, check calculation chain correction and try again.\n"
}
local main = {
  [6] = "Unkown command. Check input, call help command, and try again.\n"
}
local ram = {
  [7] = "Page creating error — page already exist. Please clear ram via ramoverride or ptoceed with full program restart.\n",
  [8] = "Attempted call of non existing page. Please check your command chain and try again. You may try memory clear via ramoverride or full program restart.\n",
  [9] = "Attemted call of non existing cell. This is unusual condidion, proceed with ramoverride command or full program restart.\n",
  [10] = "Attemted call of non existing data. Check input correction, try again or proceed with ramoverride command or full program restart.\n"
}
local help = {
  [11] = "Attempted call of non existing help page. Please check input correction. This may also be caused by a lack of help.lua update."
}
local db = {
  [12] = "Attempted call of non existing database key. this is unusual condition. please check that program is up to date. Reinstall if required."
}
local errorList ={
  BALLISTIC = ballistic,
  GRID = grid,
  MAIN = main,
  RAM = ram,
  HELP = help,
  DB = db
}
local persiststring= "if error persist, please write an issue on project repository page.\n"
local unknown="undocumented error detected, this may be caused because of mistype in running module or lack of handler update. Please write an issue on project repository page.\n"
local standartout="experienced error code: "
local function handler(err)
for modulename,errtable in pairs(errorList) do
    if errtable[err] then
      return "[".. modulename .."] "..errtable[err]..persiststring..standartout..tostring(err).."\n"
    end
end
return unknown..standartout..tostring(err).."\n"
end
return {handler=handler}