local data = {}

local function addpage(dest,page)
  if not dest then return 8 end
  if dest[page] then return 7 end
  dest[page]={}
  return 0
end
local function adddata(dest,info)
  if  not dest then return 8 end
  table.insert(dest,info)
  return 0
end
local function setdata(dest,pos,info)
  if not dest then return 8 end
  if not dest[pos] then return 9 end
  dest[pos] = info
  return 0
end
local function getdata(dest)
  if not dest then return 10 end
  return dest,0
end
local function removedata(dest,pos)
  if not dest then return 8 end
  if not dest[pos] then return 9 end
  table.remove(dest,pos)
  return 0
end
local function removepage(dest,key)
  if not dest or not dest[key] then return 8 end
  dest[key] = nil
  return 0
end
local function cleardata()
  for k in pairs(data) do
    data[k]=nil
  end
  return "ramoverride",0
end
return {addpage=addpage,
  adddata=adddata,
  setdata=setdata,
  getdata=getdata,
  removedata=removedata,
  removepage=removepage,
  cleardata=cleardata,
  data=data}