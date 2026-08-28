local ammo = {
  ["AP"] = {60,"P"},
  ["APHE"] = {250,"P"},
  ["ATMC"] = {3000,"U"},
  ["CLMN"] = {500,"IV"},
  ["CYAN"] = {750,"X"}, -- test required
  ["DRIL"] = {70,"X"},
  ["UQKE"] = {550,"P"},
  ["FLCH"] = {620,"I"},
  ["HCHE"] = {550,"X"},
  ["HE"] = {250,"X"},
  ["INCN"] = {250,"F"},
  ["LE"] = {150,"X"},
  ["PCLM"] = {150,"IV"},
  ["PHGN"] = {620,"R"},
  ["PRPG"] = {500,"U"},
  ["SMK"] = {1000,"NA"},
  ["STAR"] = {500,"N"},
  ["TEAR"] = {750,"NS"},
  ["THRM"] = {350,"F"},
  ["WP"] = {750,"RF"},
}
local movingtatgets = {
  ["train_1"] = {"J6","0:4","10:16:50",10,90},
  ["train_2"] = {"J8", "0:0","10:33:30",5,90},
  ["ship"] = {5,12},
  ["aircraft"] = {8,5000,10,180,"06:59:40",100}
}
local directions = {
  ["N"] = 0,
  ["NNE"] = 22.5,
	["NE"] = 45,
	["ENE"] = 67.5,
	["E"] = 90,
	["ESE"] = 112.5,
	["SE"] = 135,
	["SSE"] = 157.5,
	["S"] = 180,
	["SSW"] = 202.5,
	["SW"] = 225,
	["WSW"] = 247.5,
	["W"] = 270,
	["WNW"] = 292.5,
	["NW"] = 315,
	["NNW"] = 337.5
}
local accesspoint ={
  ammo,
  movingtatgets,
  directions
}
local function getinfo(key)
  for _,check in ipairs(accesspoint) do
    if check[key] then return check[key] end
  end
  return nil,12
end
return {getinfo=getinfo}