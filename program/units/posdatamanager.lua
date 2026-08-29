local ram = require("ram")
local grid = require("grid")
ram.addpage(ram.data,"posdatamanager")
ram.addpage(ram.data.posdatamanager,"metadata")
ram.addpage(ram.data.posdatamanager,"nest")
ram.addpage(ram.data.posdatamanager,"ally")
ram.addpage(ram.data.posdatamanager,"enemy")
ram.addpage(ram.data.posdatamanager,"viewer")
ram.addpage(ram.data.posdatamanager,"report")
ram.addpage(ram.data.posdatamanager,"special")
local function idgen()
    local id=0
    return function()
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
        if countTable[key] then countTable[key]=idgen() end
    end
end

local function checkbasic(tabl) -- {type, data, data, ...}
    if not typevalidTable[tabl[1]] then return nil, 15 end -- точно тип существует
    if tabl[1]=="nest" and #(ram.getdata(ram.data.posdatamanager.nest))>0 then return nil, 16 end -- точно не nest или точно nest пустой
    if #tabl~=typevalidTable[tabl[1]] then return nil, 17 end -- точно нужно количество элементов
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
    if not targettype[tabl[6]] then return nil, 18 end
    return tabl,0
end

local function checkspecial(tabl)
    if tabl[7]~="-s" and tabl[7]~="-n" then return nil,18 end
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
        ['unit']= {}},
    ["enemy"] = {
        ['user'] = {checkbasic,checkoffset,checktype,checkspecial},
        ['unit']= {}},
    ["viewer"] = {
        ['user'] = {checkbasic},
        ['unit']= {}},
    ["report"] = {
        ['user'] = {checkbasic,checkreport},
        ['unit']= {}}
}