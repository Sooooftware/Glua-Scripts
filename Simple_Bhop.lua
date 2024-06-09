local ply = LocalPlayer() --- makes localplayer shorter 
local function Bhop() 

    if input.IsKeyDown( KEY_SPACE ) and ply:IsOnGround() and ply:IsTyping() == false then --- if hold space and if your player is on ground and not typing then 
      RunConsoleCommand("+jump") --- just runs jump using console
      else
      RunConsoleCommand("-jump") --- if you arent jumping then cancels jump
    end
end

timer.Create( "Bhopper", 0, 0.01, Bhop) --- makes the entire bhop function run every 0.01 sec resulting in bhop
