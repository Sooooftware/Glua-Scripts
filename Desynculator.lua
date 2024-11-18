require("zxcmodule")
bSendPacket = true

hook.Add("CreateMove", "Desynculator", function(cmd)
ded.SetBSendPacket(bSendPacket)
local tickrate = math.floor(1 / engine.TickInterval())
local seqshift =  tickrate - 3

if (bSendPacket) then
 
	if (seqshift > 0) then
 
		if (!bRunning) then
 
			ded.SetOutSequenceNr(ded.GetOutSequenceNr() + seqshift)
 
			bRunning = true
 
		else
 
			ded.SetNetChokedPackets(127)
 
		end
 
	else
 
		bRunning = false
 
	end
 
end
end)