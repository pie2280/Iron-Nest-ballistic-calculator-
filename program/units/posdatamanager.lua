local ram = require("ram")
local grid = require("grid")
local function reinit()
ram.addpage(ram.data,"posdatamanager")
ram.addpage(ram.data.posdatamanager,"metadata")
ram.addpage(ram.data.posdatamanager,"nest")
ram.addpage(ram.data.posdatamanager,"ally")
ram.addpage(ram.data.posdatamanager,"enemy")
ram.addpage(ram.data.posdatamanager,"viewer")
ram.addpage(ram.data.posdatamanager,"report")
ram.addpage(ram.data.posdatamanager,"special")
ram.addpage(ram.data.posdatamanager.metadata,"ally")
ram.addpage(ram.data.posdatamanager.metadata,"enemy")
ram.addpage(ram.data.posdatamanager.metadata,"viewer")
ram.addpage(ram.data.posdatamanager.metadata,"special")
end
reinit()
local function idgen()
    local id=0
    return function(resetkey)
        if resetkey == "reset" then id = 0 return end
        id= id+1
        return id
    end
end
local countTable ={
    ["ally"]=idgen(),
    ["enemy"]=idgen(),
    ["viewer"]=idgen(),
    ["report"]=idgen(),
    ["special"]=idgen()
}
local targettype = {
    ["-i"]=true,
    ["-x"]=true,
    ["-p"]=true,
    ["-v"]=true
}
local typevalidTable = {
    ["nest"] = 4, -- checkbasic
    ["special"] = 6, -- checkbasic checkoffset
    ["ally"] = 7, -- checkbasic checkoffset checktype
    ["enemy"] = 8,-- checkbasic checkoffset checktype checkspecial
    ["viewer"] = 4, -- checkbasic
    ["report"] = 6 -- checkbasic checkreport
}
local function clearid(tabl)
    for _,key in ipairs(tabl) do
        if countTable[key] then countTable[key]("reset") end
    end
end
local function checkbasic(tabl) -- {type, data, data, ...}
    if #tabl~=typevalidTable[tabl[1]] then return nil, 16 end -- точно нужно количество элементов
    if tabl[1]=="nest" and #(ram.getdata(ram.data.posdatamanager.nest))>0 then return nil, 17 end -- точно не nest или точно nest пустой
    return tabl, 0
end
local function checkreport(tabl)
    local checknum = tonumber(tabl[5])
    if not checknum then return nil, 18 end
    if tabl[4]=="-r" then -- проверяем на флаг расстояния
        if checknum<0 then return nil, 19 end -- расстояние валидно
    elseif tabl[4]=="-d" then -- проверяем на флаг азимута
        if checknum<0 or checknum>359.9 then return nil,19 end -- азимут валиден
    else return nil,19 end -- флага нет
    return tabl,0 -- всё отлично
end
local function checkoffset(tabl)
    if not tonumber(tabl[4]) or not tonumber(tabl[5]) then return nil, 18 end
    tabl[4],tabl[5]=tonumber(tabl[4]),tonumber(tabl[5])
    return tabl,0
end
local function checktype(tabl) -- -i -x -p -v
    if tabl[#tabl]=='unit' then
         if not targettype[tabl[4]] then return nil, 18 end
    else
        if not targettype[tabl[6]] then return nil, 18 end
    end
    return tabl,0
end
local function checkspecial(tabl)
    if tabl[#tabl]=='unit' then
         if tabl[5]~="-s" and tabl[5]~="-n" then return nil,18 end
    else
        if tabl[7]~="-s" and tabl[7]~="-n" then return nil,18 end
    end
    return tabl,0
end
local requiredchecks = {
    ["nest"] = {
        ['user'] = {checkbasic},
        ['unit']= {}},
    ["special"] = {
        ['user'] = {checkbasic,checkoffset},
        ['unit']= {}},
    ["ally"] = {
        ['user'] = {checkbasic,checkoffset,checktype},
        ['unit']= {checktype}},
    ["enemy"] = {
        ['user'] = {checkbasic,checkoffset,checktype,checkspecial},
        ['unit']= {checktype,checkspecial}},
    ["viewer"] = {
        ['user'] = {checkbasic},
        ['unit']= {}},
    ["report"] = {
        ['user'] = {checkbasic,checkreport},
        ['unit']= {checkreport}}
}
local function addpos(tabl)
    local err
    local ttype = tabl[1]
    local from = tabl[#tabl]
    if not typevalidTable[ttype] then return nil,nil,nil, 15 end -- точно тип существует
    local checklist = requiredchecks[ttype][from]
    for _,check in ipairs(checklist) do
        tabl,err = check(tabl)
        if err~=0 then return nil,nil,nil,err end
    end
    table.remove(tabl,1)
    table.remove(tabl)
    if from=='user' then
        tabl[1],tabl[2] = grid.parse({tabl[1],tabl[2]})
        tabl[1] = tabl[1] + tabl[3]
        tabl[2] = tabl[2] + tabl[4]
        if tabl[1] > 20000 or tabl[1] < 0 or tabl[2] > 10000 or tabl[2] < 0 then return nil,nil,nil,20 end
        table.remove(tabl,3)
        table.remove(tabl,3)
    end
    local id = "ID"..countTable[ttype]()
    ram.data.posdatamanager[ttype][id] = tabl
    ram.adddata(ram.data.posdatamanager.metadata[ttype],id)
    return ttype,id,'posdatamanager', 0
end
local function changenestpos(tabl)
    local x,y,err = grid.parse(tabl)
    if err~=0 then return nil,err end
    local errram1 = ram.setdata(ram.data.posdatamanager.nest,1,x)
    if errram1~=0 then return nil,errram1 end
    local errram2 = ram.setdata(ram.data.posdatamanager.nest,2,y)
    if errram2~=0 then return nil,errram2 end
    return 'changenestpos',0
end
local function syncmeta(ttype)
    ram.removepage(ram.data.posdatamanager.metadata[ttype])
    ram.addpage(ram.data.posdatamanager.metadata,ttype)
    for id,_ in pairs(ram.data.posdatamanager[ttype]) do
        ram.adddata(ram.data.posdatamanager.metadata[ttype],id)
    end
end
local function removepos(tabl)
    if not typevalidTable[tabl[1]] or tabl[1]=='nest' or tabl[1]=='report' then return nil,15 end
    local id
    local idtable = {}
    local errflag =true
    for i = 2, #tabl,1 do
        id = 'ID'..tabl[i]
        if ram.data.posdatamanager[tabl[1]][id] then ram.removepage(ram.data.posdatamanager[tabl[1]],id) errflag = false table.insert(idtable,id) end
    end
    if errflag then return nil,21 end
    syncmeta(tabl[1])
    return tabl[1],idtable,"removepos",0
end
local function clearreports()
ram.removepage(ram.data.posdatamanager,'report')
ram.addpage(ram.data.posdatamanager,'report')
end
local function getmetadata(tabl)
if not typevalidTable[tabl[1]] then return nil,15 end
  local metaoutput = ram.data.posdatamanager.metadata[tabl[1]]
  return metaoutput, "getmetadata",0
end
return {addpos=addpos,clearid=clearid,changenestpos=changenestpos,syncmeta=syncmeta,removepos=removepos,reinit=reinit,clearreports=clearreports,getmetadata=getmetadata}
--TODO: upd errorhandler, help, format. proceed with test