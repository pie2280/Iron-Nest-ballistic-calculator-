local function calc(x,y)
  local angle= (60*tonumber(x))/(5000*tonumber(y))
  local Ftime = (tonumber(x)/(tonumber(y)*5000))*38
  return angle,Ftime
end

print("Iron Nest, ballistic calculator")
while true do
  io.write("target range:  ")
  local range = io.read()
  if range=="exit" then break end
  
  io.write("powder charges: ")
  local amount = io.read()
  if amount=="exit" then break end
  if type(tonumber(range))=="nil" or type(tonumber(amount))=="nil" then
    print("invalid argument")
  else
    local Rrange,Rtime = calc(range,amount)
    if Rrange >60.00 then
      print("Out of range!")
    else
      io.write("elevation: ")
      io.write(string.format("%.2f", Rrange).."°".."\n")
      io.write(string.format("flight time: %.2f seconds\n", Rtime))
    end
  end
  print("----------------")
end