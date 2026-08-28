local general = {
  ["help"] = [[this is general help page for more info check help command or command -h
  parse index_cords -- convert index coordinates in numerical format.
  convert numerical_cords -- convert numerical coordinates in index format.
  calculate distance charges -- estimate required angle and round flight time.
  ramoverride -- full wipe of in-program dynamic memory.
  exit -- exit the program.]]
}
local ballistic = {
  ["calculate"] = "calculate <range> <charges> -- return a required angle and round flight time.\n"
}
local grid = {
  ["parse"] = "parse <square index> <subsquare index> -- return x and y coordinates of the middle of selected point.\n",
  ["convert"] = "convert <cord x> <cord y> -- return index of square and subsquare associated with selected coordinates.\n"
}
local ram = {
  ["ramoverride"] = "ramoverride -- proceed with full dynamic memory wipe. All user commited data will be deleted.\n"
}
local helpTable = {
  general,
  ballistic,
  grid,
  ram
}
local function show(cmd)
  for _,page in ipairs(helpTable) do
    if page[cmd] then
      return page[cmd],0
    end
  end
  return nil,11
end
return {show=show}