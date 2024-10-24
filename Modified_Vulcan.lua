--[[
> VULCAN PK SCRIPT [Made by BrainFuck & Trial] Modified by Software
    - This script was made and designed exclusively for propkill. It has visuals, fov, bhop, and a few unique custom concepts I came up with a while ago.
	- We wanted to come up with visually unique looking script, not something similar to 99% of the other propkill scripts around.
    - As this was mainly made for the propkill community, it COULD fuck your fps in case there would be too many players on the server you're on. (propkill servers are rarely very populated..)
	- Nevertheless, I added a few fps optimization shit to help you: 
			the fps saver convar, you should basically always keep this ON
			you can also disable the additional chams halos which is purely aesthetic and takes a lot of fps when there are too many players to render
	- I'll keep updating this script if im not too lazy.
	- This is NOT a proper cheat. This is a PROPKILL clientside script. Trying to use this on other servers will get you detected and banned unless you have a cool bypass, and as I mentioned before, your fps will most likely get fucked.
]]

local blackwhite = {
	["$pp_colour_contrast"] = 0.8,
	["$pp_colour_colour"] = 1
}



hook.Add("PreDrawOpaqueRenderables", "bw_xray", function()
	DrawColorModify(blackwhite)
end)


CreateClientConVar( "ASUS", 0, true, false )

-- BRAIN: STEAM_0:1:149906042
-- TRIAL: STEAM_0:1:68249268
-- SOFTWARE: STEAM_0:1:565888199

// VULCAN
local Vulcan = {
	version = 1.7,
	dangerous = false,
	propID = ""
}

RunConsoleCommand("cl_updaterate", 1000)
RunConsoleCommand("cl_cmdrate", 0)
RunConsoleCommand("cl_interp", 0)
RunConsoleCommand("rate", 51200)
-- RunConsoleCommand("mat_fastspecular", 0)

CreateMaterial( "White9", "UnlitGeneric", {
 [ "$basetexture" ] = "models/debug/debugwhite", 
 [ "$nocull" ] = 1, 
 [ "$model" ] = 1 
 
 }); -- fixing the debugwhite shit material

// CONVARS THERE
CreateClientConVar("VULCAN_bhop", 1, true, false)
CreateClientConVar("VULCAN_FOVEnable", 1, true, false)
CreateClientConVar("VULCAN_FOVNumber", "125", true, false)
CreateClientConVar("VULCAN_FOV_VELOCITY", 0, true, false)
CreateClientConVar("VULCAN_SAVEFPS", 1, true, false)

CreateClientConVar("VULCAN_tracers", 1, true, false)

CreateClientConVar("VULCAN_esp", 1, true, false)
CreateClientConVar("VULCAN_esp_lava", 1, true, false)

CreateClientConVar("VULCAN_3rdperson", 0, true, false)
CreateClientConVar("VULCAN_3rdperson_number", 120, true, false)

CreateClientConVar("VULCAN_trajectory", 1, true, false)
CreateClientConVar("VULCAN_P2P", 1, true, false)
CreateClientConVar("VULCAN_P2P_MOVING_ONLY", 1, true, false)

CreateClientConVar("VULCAN_xray", 1, true, false)
CreateClientConVar("VULCAN_xray_adaptive_opacity", 0, true, false)

CreateClientConVar("VULCAN_chams", 1, true, false)
CreateClientConVar("VULCAN_chams_additional_halos", 1, true, false)

CreateClientConVar("VULCAN_headbeams", 1, true, false)

CreateClientConVar("VULCAN_pingpredictboxes", 1, true, false)

CreateClientConVar("VULCAN_alert", 1, true, false)

CreateClientConVar("VULCAN_physline", 1, true, false)
CreateClientConVar("VULCAN_physline_otherplayers", 1, true, false)

CreateClientConVar("VULCAN_VelocityHUD", 0, true, false)
CreateClientConVar("Vulcan_Watermark", 0, true, false)

CreateClientConVar("Vulcan_Trails", 0, true, false)
CreateClientConVar("Vulcan_Trails_Size", 25, true, false)

CreateClientConVar("Vulcan_custom_skybox_col", "0,0,0,255", true, false)
CreateClientConVar("Vulcan_custom_skybox", 0, true, false)

CreateClientConVar("Vulcan_SurfingTracker_EVERYONE", 0, true, false)
CreateClientConVar("Vulcan_SurfingTracker", 0, true, false)
CreateClientConVar("Vulcan_SurfingTracker_PosDist", 500, true, false)
CreateClientConVar("Vulcan_SurfingTracker_RecurrencyDist", 500, true, false)
CreateClientConVar("Vulcan_SurfingTracker_PathsLength", 10, true, false)
CreateClientConVar("Vulcan_SurfingTracker_Player", "", true, false)
CreateClientConVar("Vulcan_SurfingTracker_ShowAllPaths", 0, true, false)
CreateClientConVar("Vulcan_SurfingTracker_ShowRecurrentPaths", 1, true, false)
CreateClientConVar("Vulcan_SurfingTracker_Percentage", 5, true, false)

CreateClientConVar( "Vulcan_spectator_box", 0, true, false )

CreateClientConVar( "Vulcan_crosshair", 1, true, false )
CreateClientConVar( "Vulcan_crosshair_circles", 1, true, false )
CreateClientConVar( "Vulcan_crosshair_cross", 0, true, false )
CreateClientConVar( "Vulcan_crosshair_dot", 0, true, false )
CreateClientConVar( "Vulcan_crosshair_circles_size", 1, true, false )
CreateClientConVar( "Vulcan_crosshair_cross_size", 6, true, false )
CreateClientConVar( "Vulcan_crosshair_dot_size", 1, true, false )
CreateClientConVar( "Vulcan_crosshair_color", "255,255,255", true, false )
CreateClientConVar( "Vulcan_crosshair_opacity", 255, true, false )


local maxvel = 0

MsgC(Color(255,255,0), [[
> VULCAN PK SCRIPT LOADED! THIS WAS MADE BY BRAINFUCK AND TRIAL EXCLUSIVELY FOR PK SERVERS, ENJOY!
- The commands prefix is VULCAN, type VULCAN_menu to open the menu :)
]])

local colors = {
	skybox_custom_col = Color(unpack(string.Explode(",", GetConVarString("Vulcan_custom_skybox_col")))),
	crosshair_color = Color(unpack(string.Explode(",", GetConVarString("Vulcan_crosshair_color")))),
}

local function refresh()
	colors.skybox_custom_col = Color(unpack(string.Explode(",", GetConVarString("Vulcan_custom_skybox_col"))))
	colors.crosshair_color = Color(unpack(string.Explode(",", GetConVarString("Vulcan_crosshair_color"))))
end
hook.Add ("Think", "refresh", refresh )

local function lavacolor(n, t)
	if n == 1 then
		return math.Round((255 - (math.floor(math.sin(RealTime() * 3.5 ) * 40 + 50 ) ) ) / t, 2), math.Round((math.floor(math.sin(RealTime() * 3.5 + 2 ) * 55 + 65 ) ) / t, 2), 0
	elseif n == 2 then
		return 255 / t , 0.6- math.Round((math.floor(math.sin(RealTime() * 3.5 + 2 ) * 55 + 65 ) ) / t, 2), 0
	end
end

local function spacecolor(n, t)
	if n == 1 then
		return math.Round( (math.floor(math.sin(RealTime() * 3.5 ) * 30 + 40 ) ) / t, 2), 0, math.Round((math.floor(math.sin(RealTime() * 3.5 ) * 55 + 65 ) ) / t, 2)
	elseif n == 2 then
		return 0.6- math.Round((math.floor(math.sin(RealTime() * 4 ) * 55 + 65 ) ) / t, 2), 0, 0.6- math.Round((math.floor(math.sin(RealTime() * 4) * 55 + 65 ) ) / t, 2)
	end
end

-- for k,v in next, game.GetWorld():GetMaterials() do
	-- local asd = Material(v)
	-- asd:SetVector("$color2", Vector(0.2, 0.2, 0.2))
-- end

local O_player_GetAll = player.GetAll

-- function player.GetAll()

	-- local players = O_player_GetAll()
	
	-- local right_players = {}
	
	-- for k,v in pairs(players) do
		-- if v:GetNWString("arena") == LocalPlayer():GetNWString("arena") then
			-- right_players[#right_players + 1] = v
		-- end
	-- end
	
	-- return right_players
-- end


// IsOutOfFOV (very usefull for optimization, thanks Grump)
local function IsOutOfFOV( ent )
	if GetConVarNumber("VULCAN_SAVEFPS") == 1 then
		if LocalPlayer():GetObserverMode() == 0 then
			local Width = ent:BoundingRadius()
			local Disp = ent:GetPos() -LocalPlayer():GetShootPos()
			local Dist = Disp:Length()
			local MaxCos = math.abs( math.cos( math.acos( Dist /math.sqrt( Dist *Dist +Width *Width ) ) +56 *( math.pi /180 ) ) )
			Disp:Normalize()
			local dot = Disp:Dot( LocalPlayer():EyeAngles():Forward() )
			return dot <MaxCos
		end
	end
end


// lazyness
local function validation(x)
	return IsValid(x) && x:Alive() && x != LocalPlayer() && x:Team() != TEAM_SPECTATOR && team.GetName(x:Team()) != "Spectator" && x:GetObserverMode() == 0;
end

local function validation_with_localplayer(x)
	return IsValid(x) && x:Alive() && x:Team() != TEAM_SPECTATOR && team.GetName(x:Team()) != "Spectator" && x:GetObserverMode() == 0;
end

local function is_spectator(x)
	if x:Team() != TEAM_SPECTATOR && team.GetName(x:Team()) != "Spectator" && x:GetObserverMode() == 0 then return false end
	return true
end

local maxvel = 0
local function velocityshower()
	if LocalPlayer():GetVelocity():Length() > maxvel then maxvel = LocalPlayer():GetVelocity():Length() end

	if(GetConVarNumber("VULCAN_VelocityHUD") == 1) then
		draw.SimpleTextOutlined( math.Round(maxvel, 0), "DermaLarge", ScrW() /2, ScrH() /9-25, Color(255,255,255,255), 1, 1, 2, Color(50,50,50,255) )
		draw.SimpleTextOutlined( math.Round(LocalPlayer():GetVelocity():Length(), 0), "DermaLarge", ScrW() /2, ScrH() /9, Color(255,255,255,255), 1, 1, 2, Color(50,50,50,255) )
	end
end
hook.Add("HUDPaint", "velocityshower", velocityshower)

Vulcan.TotalTraveled = 0
Vulcan.TotalTimeSurfed = 0
Vulcan.AvgVel = 0
local delaying = 0
local prev_pos

local function traveled_dist()
	if not is_spectator(LocalPlayer()) and LocalPlayer():GetVelocity():LengthSqr() > 1000000 then
		if not prev_pos then prev_pos = LocalPlayer():GetPos() end
		if CurTime() > delaying then
			Vulcan.TotalTraveled = Vulcan.TotalTraveled + prev_pos:Distance(LocalPlayer():GetPos())
			Vulcan.TotalTimeSurfed = Vulcan.TotalTimeSurfed + 0.1
			Vulcan.AvgVel = math.Round(Vulcan.TotalTraveled/Vulcan.TotalTimeSurfed, 0)
			prev_pos = LocalPlayer():GetPos()
			delaying = CurTime() + 0.1
		end
	end
end
hook.Add("Think", "traveled_dist", traveled_dist)


local function Units_Convert(units)
	local meters
	if units < 53 then return units end -- 53 units is one meter (i think)
	meters = math.Round((units/16)/3.281, 0) -- 1 foot = 16 units and 1 meter = 1 foot / 3.281 (easier formula would be units * 1.905 / 100 but its less accurate i think)
	if meters >= 1000 then -- yeeeha we got one kilometer!
		meters = tostring(math.Round(meters/1000,1)) .. " km"
	else
		meters = tostring(meters) .. " m"
	end
	return meters
end

local function speed_to_kmh(a,b,c)
	c = tonumber(c[1])
	return print(math.Round((c*15/352)*1.60934, 0))
end
concommand.Add("vel_convert_kmh", speed_to_kmh)


local function speed_to_mph(a,b,c)
	c = tonumber(c[1])
	return print(math.Round(((c*15/352)*1.60934)/1.609, 0))
end
concommand.Add("vel_convert_mph", speed_to_mph)


surface.CreateFont( "TheDefaultSettings", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 14.5,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local function Watermark()
	if(GetConVarNumber("Vulcan_Watermark") == 1) then 
		local plyvel = math.Round(LocalPlayer():GetVelocity():Length(), 0)
		draw.SimpleTextOutlined( "Vulcan Propkill Script", "Trebuchet24", 10, 20, Color(lavacolor(2,1)), 3, 1, 1.3, Color(lavacolor(1,2)) )
		draw.SimpleTextOutlined( "Server:  "..GetHostName(), "TheDefaultSettings", 10, 40, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		draw.SimpleTextOutlined( "Tickrate:  "..  math.Round( 1/engine.TickInterval()) .. "", "TheDefaultSettings", 10, 53, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		draw.SimpleTextOutlined( "Gamemode:  "..engine.ActiveGamemode(), "TheDefaultSettings", 10, 66, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		draw.SimpleTextOutlined( "Date:  "..os.date("%A, %d, %B %Y"), "TheDefaultSettings", 10, 79, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		draw.SimpleTextOutlined( "FPS:  "..math.Round( 1 / FrameTime()), "TheDefaultSettings", 10, 92, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		if not is_spectator(LocalPlayer()) then
			draw.SimpleTextOutlined( "Velocity:  "..plyvel.." (".. math.Round((plyvel*15/352)*1.60934, 0) .."km/h)", "TheDefaultSettings", 10, 105, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		else
			draw.SimpleTextOutlined( "Velocity:  0", "TheDefaultSettings", 10, 105, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		end
		draw.SimpleTextOutlined( "Avg Velocity:  "..Vulcan.AvgVel.." (".. math.Round((Vulcan.AvgVel*15/352)*1.60934, 0) .."km/h)", "TheDefaultSettings", 10, 118, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		draw.SimpleTextOutlined( "Surfed Distance:  "..math.Round(Vulcan.TotalTraveled, 0).." ("..Units_Convert(math.Round(Vulcan.TotalTraveled, 0))..")", "TheDefaultSettings", 10, 131, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		draw.SimpleTextOutlined( "physgunprop:  ".. Vulcan.propID, "TheDefaultSettings", 10, 144, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		draw.SimpleTextOutlined( "PropKills:  ".. Vulcan.PropKills, "TheDefaultSettings", 10, 157, Color(255,255,255,255), 3, 1, 1.3, Color(50,50,50,255) )
		
	end
end
hook.Add("HUDPaint", "Watermark", Watermark)

// ESP
local function ESP()
	if GetConVarNumber("VULCAN_esp") == 1 then
		for k,v in next, player.GetAll() do -- Apparently, using "in next" is faster than "in pairs"
			if !IsOutOfFOV(v) then
				if validation(v) and LocalPlayer():GetObserverTarget() != v then
					local vpos = v:EyePos():ToScreen()
					if GetConVarNumber("VULCAN_esp_lava") == 1 then
						draw.SimpleTextOutlined ( v:Name(), "DebugFixed", vpos.x, vpos.y -10, Color(255, 255, 0, 255), 1, 1, 1, Color(255,0,0, 255))
					else
						draw.SimpleTextOutlined ( v:Name(), "DebugFixed", vpos.x, vpos.y -10, Color(255, 255, 255, 255), 1, 1, 1, Color(50, 50, 50, 255))
					end
				end
			end
		end
	end
end
hook.Add("HUDPaint", "names", ESP)

-- // trajectory (draws a red line in the direction of a propsurfing target) // --
local function TRAJECTORY()
	if GetConVarNumber("VULCAN_trajectory") == 1 then
		for k,v in pairs(player.GetAll()) do
			if validation(v) and !IsOutOfFOV(v) and LocalPlayer():GetObserverTarget() != v then
				if v:GetVelocity():LengthSqr() > 1440000 then
					local Dist = math.Clamp( v:GetShootPos():Distance( LocalPlayer():GetShootPos() ), 100, 1000 )
					local StretchX = Dist/100
					local StretchY = Dist/200
					local TraceStart = v:LocalToWorld(v:OBBCenter())
					local linepos = util.QuickTrace(TraceStart, Vector(v:GetVelocity().x * 10, v:GetVelocity().y * 10, 0), v)
					if TraceStart:Distance(linepos.HitPos) > 400 then
					cam.Start3D()
						cam.IgnoreZ(true)
						render.SetMaterial( Material( "sprites/tp_beam001" ) )
						render.DrawBeam( TraceStart, linepos.HitPos , 50, StretchX, StretchY, Color(lavacolor(1,1)) )
					cam.End3D()
				end
			end
		end
	end
end
end
hook.Add("RenderScreenspaceEffects", "trajectory", TRAJECTORY)


// credits to trial for the physline concept, I just added and fixed a few things
local myprops = {}
local yourvictims = {}

local function prop_logger(ply,wep,enabled,targ,bone,pos)
	if (IsValid(ply)) and (ply == LocalPlayer()) and (enabled) and IsValid(targ) and targ:GetClass() == "prop_physics" then
		if (!myprops[targ]) then
			myprops[targ] = true
		end
	end
	if GetConVarNumber("VULCAN_physline") != 1 and GetConVarNumber("VULCAN_physline_otherplayers") != 1 then return true end
	if myprops[targ] then
	if GetConVarNumber("VULCAN_physline") != 1 then return true end
		-- if ply == LocalPlayer() then
		Vulcan.CPos = LocalPlayer():EyePos() + EyeAngles():Forward() * 50
		Vulcan.prop = targ
		Vulcan.propID = targ:GetModel()
		Vulcan.entPOS = targ:LocalToWorld(targ:OBBCenter())
		Vulcan.entPOSI = targ:GetPos()
		Vulcan.propmod = Vulcan.propID
		Vulcan.physlineOn = true
		-- end
		return false
	else
		if ply == LocalPlayer() then
			Vulcan.propID = ""
			Vulcan.physlineOn = false
		else
			if GetConVarNumber("VULCAN_physline_otherplayers") != 1 then return true end
			if IsValid(targ) and IsValid(ply) then
				Vulcan.srcPos = wep:GetAttachment( 1 ).Pos
				if ( !ply:ShouldDrawLocalPlayer() and ply == LocalPlayer() ) then
					if ply:GetViewModel():GetAttachment( 1 ).Pos then
						Vulcan.srcPos = ply:GetViewModel():GetAttachment( 1 ).Pos
					end
				end
				Vulcan.entPOS2 = targ:LocalToWorld(targ:OBBCenter())
				Vulcan.otherphysline = true
			else
				Vulcan.otherphysline = false
			end
		end
		return false
	end
	return true
end
hook.Add("DrawPhysgunBeam", "heye", prop_logger)

local function physLine()
		if Vulcan.physlineOn == true and GetConVarNumber("VULCAN_physline") == 1 then
			cam.Start3D()
				render.SetMaterial(Material("cable/redlaser"))
				render.DrawBeam(Vulcan.CPos, Vulcan.entPOS, 5, 1, 1, Color(255, 0, 255, 255))
				render.DrawLine(Vulcan.CPos, Vulcan.entPOS, Color(lavacolor(2,1)))
			//prop:SetModel("models/props_junk/watermelon01.mdl")
			cam.End3D()
		end
		if Vulcan.otherphysline == true and GetConVarNumber("VULCAN_physline_otherplayers") == 1 then
			cam.Start3D()
				render.SetMaterial(Material("cable/redlaser"))
				render.DrawBeam(Vulcan.srcPos, Vulcan.entPOS2, 5, 1, 1, Color(255, 0, 255, 255))
				render.DrawLine(Vulcan.srcPos, Vulcan.entPOS2, Color(255,0,0,255))
			//prop:SetModel("models/props_junk/watermelon01.mdl")
			cam.End3D()
		end
end
hook.Add("HUDPaint", "kaosssuw3s", physLine)


 -- // PROPTOPLAYERS TRACERS // --
local function proptoplayer()

	local propPOS2
	local ent

	if GetConVarNumber("VULCAN_P2P") == 1 then

		for k, v in pairs( ents.FindByClass( "prop_physics" ) ) do

		if (!myprops[v]) then continue end
		
			if Vulcan.physlineOn == true and LocalPlayer():KeyDown(IN_ATTACK) then

				for c,b in pairs(player.GetAll()) do
					if GetConVarNumber("VULCAN_P2P_MOVING_ONLY") == 1 then
						ent = v
					else
						ent = Vulcan.prop
					end
					if ent:GetPos():Distance(b:GetPos()) < 2000 then
						if validation(b) then
							local propPOS = v:LocalToWorld(v:OBBCenter())
							local Dist = math.Clamp( b:GetShootPos():Distance( LocalPlayer():GetShootPos() ), 1500, 2500 )
							local StretchX = Dist/200
							local StretchY = Dist/400
							
							if Vulcan.prop and IsValid(Vulcan.prop) then
								propPOS2 = Vulcan.prop:LocalToWorld(Vulcan.prop:OBBCenter())
							end

							if GetConVarNumber("VULCAN_P2P_MOVING_ONLY") == 1 then
								if v:GetVelocity():LengthSqr() > 10000 then
									if b:GetVelocity():Length() != 0 then
										cam.Start3D()
											render.SetMaterial(Material("trails/laser"))
											render.DrawBeam(propPOS, b:EyePos(), 45, StretchX, StretchY, Color(255, 225, 0, 255))
											render.DrawLine(propPOS, b:EyePos(), Color(255,125,0,255))
										cam.End3D()
									end
								end
							else
								if propPOS2 then
									cam.Start3D()
										render.SetMaterial(Material("trails/laser"))
										render.DrawBeam(propPOS2, b:EyePos(), Dist/30, StretchX, StretchY, Color(255, 225, 0, 255))
										render.DrawLine(propPOS2, b:EyePos(), Color(255,125,0,255))
									cam.End3D()
								end
							end

						end
					end
				end
				
			end

		end

	end
	
end
hook.Add ("HUDPaint", "proptoplayer", proptoplayer) // 35

// CHAMS
local function CHAMS()
	for k,v in next, player.GetAll() do
	local oldgetpos = v:GetPos()
	local DIS = v:GetPos():Distance(LocalPlayer():GetPos()) / 500 -- credits to trial for this
		if validation(v) then
			if !IsOutOfFOV(v) then
				if GetConVarNumber("VULCAN_chams") == 1 then
					v:SetColor(Color(0,0,0,0)) -- making the prop invisible before you put the visuals on it so the opacity will be perfectly toggleable
					cam.IgnoreZ( true )
					v:SetRenderMode( RENDERMODE_TRANSALPHA )
					render.SuppressEngineLighting(true)
						-- lava visuals here
						render.MaterialOverride(Material("!White9"))
						render.SetColorModulation( 1, 1, 0.7 )
						render.SetBlend(1)
					v:DrawModel()
					render.SuppressEngineLighting(false)
					cam.IgnoreZ(false)
				else
					v:SetColor(Color(255,255,255,255))
				end
			else
				v:SetColor(Color(255,255,255,255))
			end
		end
		v:SetPos(oldgetpos)
	end
end
hook.Add("PreDrawEffects", "playerchams", CHAMS)

hook.Add( "PreDrawHalos", "AddStaffHalos", function()
	if GetConVarNumber("VULCAN_chams") == 1 then
		local validplayers = {}
		local validplayers_lookup = {}

		for k,v in next, player.GetAll() do
			if !IsOutOfFOV(v) and validation(v) then
				if !validplayers_lookup[v] then -- faster than using table.hasvalue
					validplayers[#validplayers + 1] = v -- building the halos tbl
					validplayers_lookup[v] = #validplayers -- storing the key so i can access it later
				end
			else
				if validplayers_lookup[v] then
					validplayers_lookup[v] = nil
					table.remove(validplayers, validplayers_lookup[v]) -- faster than removebykey
				end
			end
		end

		if #validplayers > 0 then
			halo.Add( validplayers, Color( 255, 0, 0 ), 1, 1, 2, false, true )
			if GetConVarNumber("VULCAN_chams_additional_halos") == 1 then 
				halo.Add( validplayers, Color( 255, 255, 0 ), 1, 2, 2, true, true )
				halo.Add( validplayers, Color( 255, 0, 0 ), 1, 10, 10, true, true )
			end
		end
	end

end )

// XRAY
local function XRAY()
	for k,v in next, ents.FindByClass("prop_physics") do
	local DIS = v:GetPos():Distance(LocalPlayer():GetPos()) / 500 -- credits to trial for this
		if !IsOutOfFOV(v) then
			if GetConVarNumber("VULCAN_xray") == 1 then
				v:SetColor(Color(0,0,0,0)) -- making the prop invisible before you put the visuals on it so the opacity will be perfectly toggleable

				-- pre-mat (fixing the gate issue with the !White9 mat)
				cam.IgnoreZ( true )
				v:SetRenderMode( RENDERMODE_TRANSALPHA )
				render.SuppressEngineLighting(true)
					render.MaterialOverride(Material("!White9"))
					render.SetColorModulation( lavacolor(2, 255) )
					if GetConVarNumber("VULCAN_xray_adaptive_opacity") == 1 then
						render.SetBlend(0.1 + DIS)
					else
						render.SetBlend(1)
					end
				v:DrawModel()
				render.SuppressEngineLighting(false)
				cam.IgnoreZ(false)

				-- main material
				cam.IgnoreZ( true )
				v:SetRenderMode( RENDERMODE_TRANSALPHA )
				render.SuppressEngineLighting(true)
					render.MaterialOverride(Material("models/shadertest/vertexlitselfilluminatedenvmappedtexture.mdl"))
					render.SetColorModulation( lavacolor(1, 255) )
					if GetConVarNumber("VULCAN_xray_adaptive_opacity") == 1 then
						render.SetBlend(0.3 + DIS)
					else
						render.SetBlend(1)
					end
				-- boxes here
				render.DrawWireframeBox(v:GetPos(), v:GetAngles(), v:OBBMaxs() - Vector(-0.25, -0.25, -0.25) , v:OBBMins() + Vector(-0.25, -0.25, -0.25) , Color(lavacolor(1,1)))
				render.DrawWireframeBox(v:GetPos(), v:GetAngles(), v:OBBMaxs() - Vector(-0.75, -0.75, -0.75) , v:OBBMins() + Vector(-0.75, -0.75, -0.75) , Color(0,0,0))
				render.DrawWireframeBox(v:GetPos(), v:GetAngles(), v:OBBMaxs() - Vector(-1.25, -1.25, -1.25) , v:OBBMins() + Vector(-1.25, -1.25, -1.25) , Color(lavacolor(1,1)))
				v:DrawModel()
				render.SuppressEngineLighting(false)
				cam.IgnoreZ(false)

				-- second material(gotta add some movement! :D)
				cam.IgnoreZ( true )
				v:SetRenderMode( RENDERMODE_TRANSALPHA )
				render.SuppressEngineLighting(true)
					render.MaterialOverride(Material("models/effects/comball_sphere"))
					render.SetColorModulation( lavacolor(2, 255) )
					if GetConVarNumber("VULCAN_xray_adaptive_opacity") == 1 then
						render.SetBlend(0.1 + DIS)
					else
						render.SetBlend(1)
					end
				v:DrawModel()
				render.SuppressEngineLighting(false)
				cam.IgnoreZ(false)
			else
				v:SetColor(Color(255,255,255,255))
			end
		else
			v:SetColor(Color(255,255,255,255))
		end
	end
end
hook.Add("PreDrawEffects", "propsvisuals", XRAY)

hook.Add("Think", "dsgdfgxds", function()
	if LocalPlayer():GetVelocity():Length() > maxvel then maxvel = LocalPlayer():GetVelocity():Length() end
    if gui.IsGameUIVisible() or gui.IsConsoleVisible() or LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP or LocalPlayer():IsTyping() then return end
	if GetConVarNumber("VULCAN_bhop") == 1 then
        if (input.IsKeyDown(KEY_SPACE)) then
            if LocalPlayer():IsOnGround() then
                if LocalPlayer():IsTyping() then return end
                    RunConsoleCommand("+jump")
                    jumped = 1
                else
                    RunConsoleCommand("-jump")
                    jumped = 0
            end
			elseif LocalPlayer():IsOnGround() then
				if jumped == 1 then
                    RunConsoleCommand("-jump")
                    jumped = 0
			end
        end
    end
end)

 // FOV CHANGER
local function fov_changer(ply, pos, ang, fov)

	local view = {}

	if (!IsValid(ply)) then return end
	if GetConVarNumber("VULCAN_FOVEnable") == 1 then
		view.fov = GetConVar("VULCAN_FOVNumber"):GetInt()
		if GetConVarNumber("VULCAN_FOV_VELOCITY") == 1 then
			view.fov =  math.Clamp(GetConVar("VULCAN_FOVNumber"):GetInt() + LocalPlayer():GetVelocity():Length() / 60, GetConVar("VULCAN_FOVNumber"):GetInt(), 140) -- trial's idea, feels good but unplayable in propkill :D
		end
	end
	
	if GetConVarNumber("VULCAN_3rdperson") == 1 then
		view.origin = pos - ang:Forward() * GetConVarNumber("VULCAN_3rdperson_number")
	end

	return view 

end
hook.Add("CalcView", "fovchanger", fov_changer)


-- // ROTATING FUNCTIONS // -- (from 3SP as all the rotates are the same thing)
concommand.Add("brain_ROTATE2", function()
	LocalPlayer():SetEyeAngles(Angle(-LocalPlayer():EyeAngles().x, LocalPlayer():EyeAngles().y - 180, LocalPlayer():EyeAngles().z))
	RunConsoleCommand("+jump")
	timer.Simple(0.01, function()
		RunConsoleCommand("-jump")
	end)
end)

concommand.Add("brain_ROTATE", function()
	LocalPlayer():SetEyeAngles(Angle(-LocalPlayer():EyeAngles().x, LocalPlayer():EyeAngles().y - 180, LocalPlayer():EyeAngles().z))
end)

-- // tracers (old design) // -- 
local function MYTRAERS()
	if ( GetConVarNumber("VULCAN_tracers") == 1 ) then
		for k,v in next, player.GetAll() do
		local Dist = math.Clamp( v:GetShootPos():Distance( LocalPlayer():GetShootPos() ), 100, 2500 )
			if validation(v) and LocalPlayer():GetObserverMode() == 0 then
				cam.Start3D()
					cam.IgnoreZ(true)
					render.SetMaterial(Material("sprites/tp_beam001"))
					render.DrawBeam(LocalPlayer():GetPos() + EyeAngles():Forward() * 80, v:GetPos(), Dist/125, 1, 1, Color(lavacolor(1,1)))
					render.DrawLine(LocalPlayer():GetPos() + EyeAngles():Forward() * 80, v:GetPos(), Color(lavacolor(2,1)))
				cam.End3D()
			end
		end
	end
end
hook.Add("RenderScreenspaceEffects", "tracerslel", MYTRAERS)

local function HEADBEAMS()

local hbcolor = Color(50,50,50,255)

	if GetConVarNumber("VULCAN_headbeams") == 1 then

		for k,v in pairs(player.GetAll()) do

			if validation(v) and !IsOutOfFOV(v) then

			local Origin = v:GetPos() + Vector( 0, 0, 40 ) 
			local Up = util.TraceLine( { start = Origin, endpos = Origin + Vector( 0, 0, 16384 ), filter = { v }, mask = MASK_SHOT } )
			local Dist = math.Clamp( v:GetShootPos():Distance( LocalPlayer():GetShootPos() ), 1500, 2500 )
			local V = { Start = v:EyePos(), End = Up.HitPos, Width = Dist /40  }
			local StretchX = Dist/200
			local StretchY = Dist/400

				-- for u,f in pairs(ents.FindByClass("prop_physics")) do -- turning the color red when a prop is over players head
					if IsValid(Up.Entity) and Up.Entity:GetClass() == "prop_physics" then
						hbcolor = Color(255,0,0,255)
					else
						hbcolor = Color(50,50,50,255)
					end
				-- end

				cam.Start3D()
					cam.IgnoreZ(true)
					render.SetMaterial( Material( "trails/smoke" ) )
					render.DrawBeam( V.Start , V.End, V.Width, StretchX, StretchY, hbcolor )
				cam.End3D()
			end
		end
	end
end
hook.Add("RenderScreenspaceEffects", "HEADBEAMS", HEADBEAMS)

local function VMENU()
	local base = vgui.Create("DFrame")
		base:SetSize(240, 375)
		base:Center()
		base:MakePopup()
		base:SetTitle("VULCAN SCRIPT   **DEV TESTING**")
		
		base.lblTitle.UpdateColours = function(label)
			label:SetTextStyleColor(Color(247, 252, 248))
		end
		
		base.btnMaxim:Hide()
		base.btnMinim:Hide()
		
		
		base.Paint = function(self, w, h)
			surface.SetDrawColor(218-25, 124-25, 8)
			surface.DrawRect(0, 0, w, h)
				
			surface.SetDrawColor(247, 252, 248)
			surface.DrawOutlinedRect(0, 0, w, h)
			
			
			surface.SetDrawColor(90, 90, 88)
			surface.DrawRect(2, 2, w - 4, h - 350)
			
			surface.DrawRect(10, 50, 40, 30)
			
			
			surface.SetDrawColor(218-25, 124-25, 8)
			surface.DrawOutlinedRect(1, 1, w - 2, h -351)	
			
		
			surface.DrawRect(2, 35, w - 4, h - 37)		
			surface.SetDrawColor(112, 117, 113)
			
			
			surface.SetDrawColor(226, 164, 79)
			surface.DrawLine(80, 36, 80, 370 )
			surface.DrawLine(160, 36, 160, 370 )
			
			//surface.SetDrawColor(90, 90, 88)
			//surface.DrawRect(18, 49, 20, 20)
			
			
			// horiz line
			for i = 1, 4 do
				//surface.SetDrawColor(112, 117, 113)
				surface.SetDrawColor(226, 164, 79)
				surface.DrawLine(3, 25 + i * 65, 247, 25 + i * 65 )
			
			end
				
		end
		
		local visuals = vgui.Create("DLabel", base)
			visuals:SetText("VISUALS:")
			visuals:SetPos(10,35)
			visuals:SetFont("TargetIDSmall")
			visuals:SizeToContents(true)
		
		local b1 = vgui.Create("DCheckBoxLabel", base)
			b1:SetPos(30, 58)
			b1:SetText("ESP")
			b1:SetConVar("VULCAN_esp")
			b1:SetFont("TargetIDSmall")
			
		
		local b2 = vgui.Create("DCheckBoxLabel", base)
			b2:SetPos(30, 75)
			b2:SetText("ESP LAVA")
			b2:SetConVar("VULCAN_esp_lava")
			b2:SetFont("TargetIDSmall")

		local b3 = vgui.Create("DCheckBoxLabel", base)
			b3:SetPos(30, 103)
			b3:SetText("XRAY")
			b3:SetConVar("VULCAN_xray")
			b3:SetFont("TargetIDSmall")
			
		
		local b4 = vgui.Create("DCheckBoxLabel", base)
			b4:SetPos(30, 120)
			b4:SetText("XRAY SMART OPACITY")
			b4:SetConVar("VULCAN_xray_adaptive_opacity")
			b4:SetFont("TargetIDSmall")
		
		local b5 = vgui.Create("DCheckBoxLabel", base)
			b5:SetPos(30, 147)
			b5:SetText("CHAMS")
			b5:SetConVar("VULCAN_chams")
			b5:SetFont("TargetIDSmall")
			
		
		local b6 = vgui.Create("DCheckBoxLabel", base)
			b6:SetPos(30, 164)
			b6:SetText("CHAMS HALOS")
			b6:SetConVar("VULCAN_chams_additional_halos")
			b6:SetFont("TargetIDSmall")

		local b7 = vgui.Create("DCheckBoxLabel", base)
			b7:SetPos(30, 191)
			b7:SetText("TRACERS")
			b7:SetConVar("VULCAN_tracers")
			b7:SetFont("TargetIDSmall")
			
		
		local b8 = vgui.Create("DCheckBoxLabel", base)
			b8:SetPos(30, 208)
			b8:SetText("PING PREDICTION BOXES")
			b8:SetConVar("VULCAN_pingpredictboxes")
			b8:SetFont("TargetIDSmall")
			b8:SetToolTip("Draw boxes around players moving according to their ping")

		local b66 = vgui.Create("DCheckBoxLabel", base)
			b66:SetPos(30, 225)
			b66:SetText("HEADBEAMS")
			b66:SetConVar("VULCAN_headbeams")
			b66:SetFont("TargetIDSmall")

		local misc = vgui.Create("DLabel", base)
			misc:SetText("MISC:")
			misc:SetPos(10,248)
			misc:SetFont("TargetIDSmall")
			misc:SizeToContents(true)

		local b9 = vgui.Create("DCheckBoxLabel", base)
			b9:SetPos(30, 269)
			b9:SetText("FPS SAVER")
			b9:SetConVar("VULCAN_SAVEFPS")
			b9:SetFont("TargetIDSmall")
			b9:SetToolTip("Disable visuals when they are out of your field of view")

		local b10 = vgui.Create("DCheckBoxLabel", base)
			b10:SetPos(30, 286)
			b10:SetText("BACK-ATTACK ALERT")
			b10:SetToolTip("Draw an alert when a prop is about to kill you from behind")
			b10:SetConVar("VULCAN_alert")
			b10:SetFont("TargetIDSmall")

		local b11 = vgui.Create("DCheckBoxLabel", base)
			b11:SetPos(30, 303)
			b11:SetText("BHOP")
			b11:SetConVar("VULCAN_bhop")
			b11:SetFont("TargetIDSmall")

		local b12 = vgui.Create("DCheckBoxLabel", base)
			b12:SetPos(30, 320)
			b12:SetText("FOV:")
			b12:SetConVar("VULCAN_FOVEnable")
			b12:SetFont("TargetIDSmall")

		local fovnumber = vgui.Create( "DNumberWang", base )
			fovnumber:SetPos( 90, 320 )
			fovnumber:SetSize( 40, 15 )
			fovnumber:SetMin(0)
			fovnumber:SetMax(179)
			fovnumber:SetValue(GetConVarNumber("VULCAN_FOVNumber"))
			function fovnumber:OnValueChanged(value)
				GetConVar("VULCAN_FOVNumber"):SetInt(value)
			end

		local b13 = vgui.Create("DCheckBoxLabel", base)
			b13:SetPos(30, 337)
			b13:SetText("VELOCITY FOV")
			b13:SetToolTip("Higher velocity = higher FOV")
			b13:SetConVar("VULCAN_FOV_VELOCITY")
			b13:SetFont("TargetIDSmall")
end
concommand.Add("VULCAN_menu", VMENU)

function PingPredict()
	if GetConVarNumber("VULCAN_pingpredictboxes") == 1 then
		for k,v in next, player.GetAll() do
			local pos = v:GetPos() + (v:GetVelocity()/1000)*(((LocalPlayer():Ping()/5) - 1) )
			local pos2 = v:GetPos() + (v:GetVelocity()*LocalPlayer():Ping()/1000 )
			local DIS = v:GetPos():Distance(LocalPlayer():GetPos()) / 500
			if validation(v) then
				render.SuppressEngineLighting(true)
					if v:IsOnGround() then
						render.DrawWireframeBox(pos2, v:GetAngles(), v:OBBMaxs() - Vector(-0.25, -0.25, -0.25) , v:OBBMins() + Vector(-0.25, -0.25, -0.25) , Color(lavacolor(1,1)))
						render.DrawWireframeBox(pos2, v:GetAngles(), v:OBBMaxs() - Vector(-0.75, -0.75, -0.75) , v:OBBMins() + Vector(-0.75, -0.75, -0.75) , Color(0,0,0))
						render.DrawWireframeBox(pos2, v:GetAngles(), v:OBBMaxs() - Vector(-1.25, -1.25, -1.25) , v:OBBMins() + Vector(-1.25, -1.25, -1.25) , Color(lavacolor(1,1)))
					else
						if v:GetVelocity():LengthSqr() >= 490000 then
							render.DrawWireframeBox(pos, v:GetAngles(), v:OBBMaxs() - Vector(-0.25, -0.25, -0.25) , v:OBBMins() + Vector(-0.25, -0.25, -0.25) , Color(lavacolor(1,1)))
							render.DrawWireframeBox(pos, v:GetAngles(), v:OBBMaxs() - Vector(-0.75, -0.75, -0.75) , v:OBBMins() + Vector(-0.75, -0.75, -0.75) , Color(0,0,0))
							render.DrawWireframeBox(pos, v:GetAngles(), v:OBBMaxs() - Vector(-1.25, -1.25, -1.25) , v:OBBMins() + Vector(-1.25, -1.25, -1.25) , Color(lavacolor(1,1)))
						else
							render.DrawWireframeBox(pos2, v:GetAngles(), v:OBBMaxs() - Vector(-0.25, -0.25, -0.25) , v:OBBMins() + Vector(-0.25, -0.25, -0.25) , Color(lavacolor(1,1)))
							render.DrawWireframeBox(pos2, v:GetAngles(), v:OBBMaxs() - Vector(-0.75, -0.75, -0.75) , v:OBBMins() + Vector(-0.75, -0.75, -0.75) , Color(0,0,0))
							render.DrawWireframeBox(pos2, v:GetAngles(), v:OBBMaxs() - Vector(-1.25, -1.25, -1.25) , v:OBBMins() + Vector(-1.25, -1.25, -1.25) , Color(lavacolor(1,1)))
						end
					end
				render.SuppressEngineLighting(false)
			end
		end
	end
end
hook.Add("PreDrawEffects", "PingPredict", PingPredict)

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

-- // danger (kills yourself when a prop is about to kill you lul) // --
local function DANGEROUS()
	if GetConVarNumber("VULCAN_alert") == 1 then
		for k,v in next, ents.FindByClass( "prop_physics" ) do
		if (myprops[v]) then continue end
		local entpos = v:LocalToWorld(v:OBBCenter())
		local endpos = util.QuickTrace (  entpos, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )
		local entpos2 = v:LocalToWorld(v:OBBMins())
		local endpos2 = util.QuickTrace (  entpos2, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )
		local entpos3 = v:LocalToWorld(v:OBBMaxs())
		local endpos3 = util.QuickTrace (  entpos3, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )
		local entpos4 = v:LocalToWorld(v:OBBCenter() + Vector(0,0,40))
		local endpos4 = util.QuickTrace (  entpos4, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )
		local entpos5 = v:LocalToWorld(v:OBBCenter() - Vector(0,0,40))
		local endpos5 = util.QuickTrace (  entpos5, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )
		local entpos6 = v:LocalToWorld(v:OBBMins() + Vector(0,0,40))
		local endpos6 = util.QuickTrace (  entpos6, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )
		local entpos7 = v:LocalToWorld(v:OBBMaxs() - Vector(0,0,40))
		local endpos7 = util.QuickTrace (  entpos7, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )
		local entpos8 = v:LocalToWorld(v:OBBMaxs() - Vector(0,45,0))
		local endpos8 = util.QuickTrace (  entpos8, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )
		local entpos9 = v:LocalToWorld(v:OBBMaxs() - Vector(0,0,76))
		local endpos9 = util.QuickTrace (  entpos9, Vector(v:GetVelocity().x / 5, v:GetVelocity().y / 5, 0), v )

			-- cam.Start3D()
				-- cam.IgnoreZ(true)
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos, endpos.HitPos, 125, 50, 50, _Color(255,0,0,255) )
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos2, endpos2.HitPos, 125, 50, 50, _Color(255,0,0,255) )
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos3, endpos3.HitPos, 125, 50, 50, _Color(255,0,0,255) )
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos4, endpos4.HitPos, 125, 50, 50, _Color(255,0,0,255) )
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos5, endpos5.HitPos, 125, 50, 50, _Color(255,0,0,255) )
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos6, endpos6.HitPos, 125, 50, 50, _Color(255,0,0,255) )
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos7, endpos7.HitPos, 125, 50, 50, _Color(255,0,0,255) )
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos8, endpos8.HitPos, 125, 50, 50, _Color(255,0,0,255) )
				-- render.SetMaterial( Material( "sprites/tp_beam001" ) )
				-- render.DrawBeam( entpos9, endpos9.HitPos, 125, 50, 50, _Color(255,0,0,255) )
			-- cam.End3D()

			if endpos.Entity == LocalPlayer() or 
			endpos2.Entity == LocalPlayer() or 
			endpos3.Entity == LocalPlayer() or 
			endpos4.Entity == LocalPlayer() or 
			endpos5.Entity == LocalPlayer() or 
			endpos6.Entity == LocalPlayer() or 
			endpos7.Entity == LocalPlayer() then
				if IsOutOfFOV(v) then
					Vulcan.dangerous = true
					hook.Add("HUDPaint", "dflksjhdf", function()
						draw.SimpleText("DANGER!", "DermaDefault", (ScrW() / 2)+11, 15 + (k * 10), Color(255,0,0,255) )
						draw.OutlinedBox(0, 0, ScrW(), ScrH(), 6, Color(255,0,0,255))
					end)
				end
			else
				if (Vulcan.dangerous) then
					hook.Remove("HUDPaint", "dflksjhdf")
				end
				Vulcan.dangerous = false
			end
		end
	end
end
hook.Add("RenderScreenspaceEffects", "itsdangerousdude", DANGEROUS)

hook.Add("PostDraw2DSkyBox", "removeSkybox1", function()
	if GetConVarNumber("Vulcan_custom_skybox") == 1 then
		render.Clear(colors.skybox_custom_col.r, colors.skybox_custom_col.g, colors.skybox_custom_col.b, 255)
	end
	return true	
end)

hook.Add("PostDrawSkyBox", "removeSkybox2", function()
	if GetConVarNumber("Vulcan_custom_skybox") == 1 then
		render.Clear(colors.skybox_custom_col.r, colors.skybox_custom_col.g, colors.skybox_custom_col.b, 255)
	end
	return true	
end)

Vulcan.Spectators = {}

hook.Add("Think", "specdetect", function()
    for k,v in pairs( player.GetAll() ) do
		if( v:GetObserverTarget() and v != LocalPlayer() and v:GetObserverTarget() == LocalPlayer() and !table.HasValue( Vulcan.Spectators, v ) ) then
			RunConsoleCommand( "play", "vo/announcer_alert.wav" )
			chat.AddText( Color(0,255,0,255), v:Nick(), Color(255,0,0,255), " Started Spectating you!" )
			table.insert( Vulcan.Spectators, v )
		end
	end
	for k,v in pairs( Vulcan.Spectators ) do
		if( !IsValid( v ) ) then table.remove( Vulcan.Spectators, k ) continue end
		if( !v:GetObserverTarget() or ( v:GetObserverTarget() and v:GetObserverTarget() != LocalPlayer() ) ) then
			chat.AddText( Color(0,255,0,255), v:Nick(), Color(255,0,0,255), " stopped spectating you." )
			RunConsoleCommand( "play", "bot/clear3.wav" )
			table.remove( Vulcan.Spectators, k )
		end
	end
end)

hook.Add("HUDPaint", "specbox", function()
    if GetConVarNumber("Vulcan_spectator_box") == 1 and #Vulcan.Spectators > 0 then
        surface.SetDrawColor( Color(50, 50, 90, 255) )
        surface.DrawRect( (ScrW() / 2) - 150, 0, 300, (#Vulcan.Spectators * 20) + 30)
        surface.SetDrawColor( Color(0, 0, 0, 250) )
        surface.DrawRect( (ScrW() / 2) - 145, 0 + 25, 290, (#Vulcan.Spectators * 20) )
        draw.SimpleText("These people are spectating you", "DermaDefault", (ScrW() / 2) - 63, 0 + 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        for k, v in pairs( Vulcan.Spectators ) do
            if !v:IsValid() then continue end -- let this pass silently, it only spams briefly when some faggot dcs anyway
            draw.SimpleText(v:Nick(), "DermaDefault", (ScrW() / 2) - 140, 0 + 8 + (k * 20), Color(255,255,255,255) )
        end
    end    
end)


local function crosshair()
	if ( GetConVarNumber ("Vulcan_crosshair") == 1 and GetConVarNumber ("Vulcan_crosshair_circles") == 1 ) then
		local x = ScrW() / 2
		local y = ScrH() / 2
		surface.DrawCircle(x, y, 5.5*GetConVarNumber("Vulcan_crosshair_circles_size"), 0,200,255,50)
		surface.DrawCircle(x, y, 2*GetConVarNumber("Vulcan_crosshair_circles_size"), 0,255,0,50)

	elseif

	( GetConVarNumber("Vulcan_crosshair") == 1 and GetConVarNumber("Vulcan_crosshair_dot") == 1 ) then
		local x = ScrW() / 2
		local y = ScrH() / 2
		surface.DrawCircle(x, y, GetConVarNumber("Vulcan_crosshair_dot_size"), Color(colors.crosshair_color.r, colors.crosshair_color.g, colors.crosshair_color.b, GetConVarNumber("Vulcan_crosshair_opacity")))

	elseif

	( GetConVarNumber ("Vulcan_crosshair") == 1 and GetConVarNumber("Vulcan_crosshair_cross") == 1 ) then
		surface.SetDrawColor(colors.crosshair_color.r, colors.crosshair_color.g, colors.crosshair_color.b, GetConVarNumber("Vulcan_crosshair_opacity"))
		surface.DrawLine(ScrW() / 2, ScrH() / 2 - GetConVarNumber("Vulcan_crosshair_cross_size"), ScrW() / 2, ScrH() / 2 + GetConVarNumber("Vulcan_crosshair_cross_size"))
		surface.DrawLine(ScrW() / 2 - GetConVarNumber("Vulcan_crosshair_cross_size"), ScrH() / 2, ScrW() / 2 + GetConVarNumber("Vulcan_crosshair_cross_size"), ScrH() / 2)
	end
end
hook.Add("HUDPaint", "crosshair", crosshair)

Vulcan.PropKills = 0

gameevent.Listen("entity_killed")
hook.Add( "entity_killed", "entity_killed", function(data)

	local inflictor_index = data.entindex_inflictor
	local attacker_index = data.entindex_attacker
	local damagebits = data.damagebits
	local victim_index = data.entindex_killed

		if Entity(victim_index) != LocalPlayer() then
			if (myprops[Entity(inflictor_index)]) then
				Vulcan.PropKills = Vulcan.PropKills + 1
			end
		end
end)


Vulcan.TrailsPos = {}
local integer = 1
local delaying_trails = 0
local trails_deletion = false

hook.Add("Think", "trails_think", function()
	if GetConVarNumber("Vulcan_Trails") == 1 then
		for k,v in pairs(player.GetAll()) do
			if validation(v) then
				if v:GetVelocity():LengthSqr() > 490000 then
					if not Vulcan.TrailsPos[v] then
						Vulcan.TrailsPos[v] = {}
					end
					local tbl = Vulcan.TrailsPos[v]
					if tbl then
						if #tbl > 1 then -- if there is already a pos inside the tbl then check the dist before adding a new pos
							-- if not tbl[#tbl-1] and trails_deletion then print("wtf?", trails_deletion, #tbl-1) end
							-- if tbl[#tbl-1] then
								if tbl[#tbl]:Distance(v:GetPos()) > 100 then
									if #tbl == GetConVarNumber("Vulcan_Trails_Size") then
										table.remove(tbl, 1)
										tbl[GetConVarNumber("Vulcan_Trails_Size")] = v:GetPos()
									else
										tbl[#tbl+1] = v:GetPos() -- adding a new pos
									end
								end
							-- else
								-- print("wtf?", #tbl, #tbl-1)
							-- end
						else
							tbl[#tbl+1] = v:GetPos() -- add the first pos
						end
					end
				else
					if v:GetVelocity():LengthSqr() == 20.25 then return end -- theres a glitch when players are surfing while holding their props pushing themselves, the vel gets reset to 4.5 wtf
					if Vulcan.TrailsPos[v] and next(Vulcan.TrailsPos[v]) then
						-- Vulcan.TrailsPos[v] = {}
						-- print("player stopped with a trail")
						if Vulcan.TrailsPos[v][integer] then
							if CurTime() > delaying_trails then
								trails_deletion = true
								Vulcan.TrailsPos[v][integer] = nil
								delaying_trails = CurTime() + 0.015

								if integer == GetConVarNumber("Vulcan_Trails_Size") then 
									Vulcan.TrailsPos[v] = {}
									integer = 1
								else
									if Vulcan.TrailsPos[v][integer+1] then
										integer = integer + 1
									else
										Vulcan.TrailsPos[v] = {}
										integer = 1
									end
								end

							end
						end
					end
				end
			else
				if Vulcan.TrailsPos[v] and next(Vulcan.TrailsPos[v]) then
					Vulcan.TrailsPos[v] = {}
				end
			end
		end
	end
end)

concommand.Add("trails_tbl", function()
	PrintTable(Vulcan.TrailsPos)
	-- PrintTable(Vulcan.PathsNumber)
end)

hook.Add("PreDrawEffects", "trails", function()
	if GetConVarNumber("Vulcan_Trails") == 1 then
		for k,v in pairs(player.GetAll()) do
			if Vulcan.TrailsPos[v] then
				for a,b in pairs(Vulcan.TrailsPos[v]) do
					if Vulcan.TrailsPos[v][a+1] then
						render.DrawLine(Vulcan.TrailsPos[v][a], Vulcan.TrailsPos[v][a+1], Color(lavacolor(2,1)))
					end
				end
			end
		end
	end
end)


hook.Add("Think", "AdjustMaterialTransparency", function()
    if input.IsButtonDown(MOUSE_5) or GetConVarNumber("ASUS") == 1 then
        for k, v in pairs(game.GetWorld():GetMaterials()) do
            Material(v):SetFloat("$alpha", 0.8)
        end
    else 
        for k, v in pairs(game.GetWorld():GetMaterials()) do
            Material(v):SetFloat("$alpha", 1)
        end
    end
end)




