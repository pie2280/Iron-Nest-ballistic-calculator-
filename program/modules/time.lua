local function Tparse(str)
    local hours,minutes,seconds = string.match(tostring(str),"^(%d+):(%d+):(%d+)$")
    local mhr,mmr,msr=tonumber(hours),tonumber(minutes),tonumber(seconds)
    if not mhr or not mmr or not msr then return nil,13 end
    if mhr<0 or mmr<0 or msr<0 then return nil,13 end
    if mhr>23 or mmr>59 or msr>59 then return nil,13 end
    local Tsec= msr+(mmr*60)+(mhr*3600)
    return Tsec,"Tparse",0
end

local function Tconvert(time)
    if type(time)~="number" then return nil,14 end
    local Atime = math.floor(time+0.5)%86400
    local ahr,amr,asr = math.floor(Atime/3600),math.floor((Atime%3600)/60),Atime%60
    local out = string.format("%02d:%02d:%02d",ahr,amr,asr)
    return out,"Tconvert",0
end
return {Tparse=Tparse,Tconvert=Tconvert}