local function calc(x,y)
  local numx,numy = tonumber(x),tonumber(y)
  if not numx or not numy then return nil,nil,1 end
  if numy>6 or numy<=0 or numx<0 then return nil,nil,1 end
  local angle= (60*numx)/(5000*numy)
  local Ttable={3775/18,2350/9,1148/3,4750/9,23375/36,700}
  local Ftime =numx/(Ttable[numy])
  if angle>60 then return nil,nil,2 end
  return angle,Ftime,0
end
return {calc=calc}