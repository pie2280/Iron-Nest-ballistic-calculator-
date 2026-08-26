  local parseTable = {A=1,B=2,C=3,D=4,E=5,F=6,G=7,H=8,I=9,J=10,K=11,L=12,M=13,N=14,O=15,P=16,Q=17,R=18,S=19,T=20}
  local convertTable ={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T"}
local function parse(cords1,cords2)
  local pri1,pri2 = string.match(cords1,"(%a)(%d+)")
  local sec1,sec2 = string.match(cords2,"(%d):(%d)")
  if not pri1 or not pri2 or not sec1 or not sec2 then return nil,nil,3 end
  if not parseTable[string.upper(pri1)] then return nil,nil,3 end
  local pri2n, sec1n, sec2n = tonumber(pri2),tonumber(sec1),tonumber(sec2)
  if pri2n<1 or pri2n>10 or sec1n<0 or sec1n>9 or sec2n<0 or sec2n>9 then return nil,nil,3 end
  local x = (parseTable[string.upper(pri1)]-1)*1000+sec1n*100+50
  local y = (pri2n - 1)*1000+sec2n*100+50
  return x,y,0
end
local function convert(x,y)
  local numx, numy= tonumber(x), tonumber(y)
  if not numx or not numy then return nil, 4 end
  if numx>20000 or numy>10000 or numx<0 or numy<0 then return nil,5 end
  if numx == 20000 then numx = 19950 end
  if numy == 10000 then numy = 9950 end
  local pri1 = convertTable[math.floor(numx/1000)+1]
  local pri2 = math.floor(numy/1000)+1
  local sec1 = math.floor((numx%1000)/100)
  local sec2 = math.floor((numy%1000)/100)
  return string.format("%s%d %d:%d",pri1,pri2,sec1,sec2), 0
end
return { parse = parse, convert = convert }