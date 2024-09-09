
--- mouse5 for aimbot


local ply = LocalPlayer()

--- CONVARS MY BELOVED

CreateClientConVar( "PROPAIMBOT", 0, true, false )

--- Aimbot and Pred

   local function Propaimbot(ply, target)
        local propspeed = 4200
        local gravity = 600 

        local targetheadpos = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_L_Foot"))
        local targetvelocity = target:GetVelocity()
        
        local distance = ply:GetPos():Distance(targetheadpos)
        local timetotarget = distance / propspeed
        
        local predictedpos = targetheadpos + targetvelocity * timetotarget
        local predicteddrop = 0.5 * gravity * timetotarget^2
        
         
        
        predictedpos.z = predictedpos.z - predicteddrop
        
        return predictedpos
       
    end
    
            
      
       

    
    local function aimforhead(ply, target)
        local headpos1 = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_Head1"))
        return headpos1
    end



     local function Propaimbot(ply, target)
        local propspeed = 4200
        local gravity = 600 

        local targetheadpos = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_L_Foot"))
        local targetvelocity = target:GetVelocity()
        
        local distance = ply:GetPos():Distance(targetheadpos)
        local timetotarget = distance / propspeed
        
        local predictedpos = targetheadpos + targetvelocity * timetotarget
        local predicteddrop = 0.5 * gravity * timetotarget^2
        
         
        
        predictedpos.z = predictedpos.z - predicteddrop
        
        return predictedpos
       
    end
    
            
      
       

    
    local function aimforhead(ply, target)
        local headpos1 = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_Head1"))
        return headpos1
    end






hook.Add("Think", "awesomeaimbotter", function()
        local ply = LocalPlayer()
        if not input.IsButtonDown(MOUSE_5) then return end
        
        local closesttarget = nil
        local closestdist = math.huge
        
        for _, ent in ipairs(ents.GetAll()) do
            if ent:IsPlayer() and ent:Alive() and ent ~= ply and ent:Team() == TEAM_SPECTATOR == false then
                local headpos = ent:LookupBone("ValveBiped.Bip01_Head1")
                if headpos then
                    local headworldpos = ent:GetBonePosition(headpos)
                    local screenpos = headworldpos:ToScreen()
                    local dist = math.sqrt((screenpos.x - ScrW() / 2)^2 + (screenpos.y - ScrH() / 2)^2)
                    
                    if dist < closestdist then
                        closestdist = dist
                        closesttarget = ent
                    end
                end
            end
        end
        
        if closesttarget and GetConVarNumber("PROPAIMBOT") == 1 then
            local aimpos = Propaimbot(ply, closesttarget)
            ply:SetEyeAngles((aimpos - ply:GetShootPos()):Angle())
           end
    end)








