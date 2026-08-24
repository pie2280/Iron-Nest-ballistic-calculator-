local ballistic = {
  [1]="Invalid argument at ballistic module's input, check input correction and try again.\n",
  [2]="Out of range! increase powder charges or check distance argument.\n"
}
local grid = {
  [3]="Invalid argument at parse command, check input correction and try again.\n",
  [4]="NaN argument detected on coordinate convertion input, check input correction and try again.\n",
  [5]="coordintes input exceeded map limits, this may be possible with using target moving predictor or a similar program, check calculation chain correction and try again.\n"
}
local errorList ={
  ballistic,
  grid
}
local persiststring= "if error persist, please write an issue on project repository page.\n"
local unknown="undocumented error detected, this may be caused because of mistype in running module or lack of handler update. Please write an issue on project repository page.\n"
local standartout="experienced error code: "
local function handler(err)
for _,errtable in ipairs(errorList) do
    if errtable[err] then
      return errtable[err]..persiststring..standartout..tostring(err).."\n"
    end
end
return unknown..standartout..tostring(err).."\n"
end
return {handler=handler}