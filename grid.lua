local function parse(cords)
  local parseTable = {A=1,B=2,C=3,D=4,E=5,F=6,G=7,H=8,I=9,J=10,K=11,L=12,M=13,N=14,O=15,P=16,Q=17,R=18,S=19,T=20}
  local pri1,pri2,sec1,sec2 = string.match(cords,"(%a)(%d+)%s+(%d):(%d)%s*")
  if not pri1 then return nil,nil,3 end
  local x = (parseTable[string.upper(pri1)]-1)*1000+tonumber(sec1)*100+50
  local y = (tonumber(pri2)-1)*1000+tonumber(sec2)*100+50
  return x,y,0
end

local function convert(x,y)
  if tonumber(x)==nil or tonumber(y)==nil then return nil, 4 end
  if x>20000 or y>10000 or x<0 or y<0 then return nil,5 end
  if x == 20000 then x = 19950 end
  if y == 10000 then y = 9950 end
  
  local convertTable ={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T"}
  local pri1 = convertTable[math.floor(x/1000)+1]
  local pri2 = math.floor(y/1000)+1
  local sec1 = math.floor((x%1000)/100)
  local sec2 = math.floor((y%1000)/100)
  return string.format("%s%d %d:%d",pri1,pri2,sec1,sec2), 0
end