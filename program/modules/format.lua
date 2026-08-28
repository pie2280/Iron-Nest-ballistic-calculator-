local ballistic = {
  ["ballistic"] = "elevation: %.2f °\nflight time: %.2f\n"
}
local grid = {
  ["parse"] = "coordinate x: %d\ncoordinate y: %d\n",
  ["convert"] = "index coordinate: %s\n"
}
local ram = {
    ["ramoverride"] = "ram clean successful"
}
local formats ={
  ballistic,
  grid,
  ram
}
local function template(data,key)
  for _,check in ipairs(formats) do
    if check[key] then return string.format(check[key],table.unpack(data)) end
  end
  return "fallback output!", data,key
end
return {template=template}