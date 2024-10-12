	
--- requires zxcmodule
--- e to cstrafe
--- beta version 0.2
--- credits go to, Replica, Venom


require("zxcmodule")   
local vgui, surface, Color, input, hook, KEY_INSERT, pairs, string, timer, file, util = vgui, surface, Color, input, hook, KEY_INSERT, pairs, string, timer, file, util;  	   
local KEY_UP, KEY_DOWN, KEY_RIGHT, KEY_LEFT = KEY_UP, KEY_DOWN, KEY_RIGHT, KEY_LEFT;  	   
local player = player; 	   
local Vector = Vector;  	   
local Angle = Angle;  	   
local bit = bit;  	   
local FindMetaTable = FindMetaTable;  	   
local team = team;  	   
local me = LocalPlayer();  	   
local draw = draw;  	   
local SortedPairs = SortedPairs;  	   
local aimtarget;  	   
local pcall = pcall;  	   
local require = require;  	   
local debug = debug;  	   
local table = table;  	   
local gameevent = gameevent;  	   
local Entity = Entity;  	   
local ScrW, ScrH = ScrW, ScrH;  	   
local RunConsoleCommand = RunConsoleCommand;  	   
local GAMEMODE = GAMEMODE;  	   
local CurTime = CurTime;  	   
local cam = cam;  	   
local CreateMaterial = CreateMaterial;  	   
  	   
local em = FindMetaTable"Entity";  	   
local pm = FindMetaTable"Player";  	   
local cm = FindMetaTable"CUserCmd";  	   
local wm = FindMetaTable"Weapon";  	   
local am = FindMetaTable"Angle";  	   
local vm = FindMetaTable"Vector";  	   
  	   	   
  	   
local omsg;  	   
  	   
local menvars = {  	   
	["Cheat Name"] = "SW Scripts",  	   
}  	   
  	   
if (file.Exists("rmenu/"..menvars["Cheat Name"].."/mvars.txt", "DATA")) then  	   
	menvars = util.JSONToTable(file.Read("rmenu/"..menvars["Cheat Name"].."/mvars.txt"), "DATA");  	   
else  	   
	file.CreateDir("rmenu");  	   
	file.CreateDir("rmenu/"..menvars["Cheat Name"]);  	   
	file.Write("rmenu/"..menvars["Cheat Name"].."/mvars.txt", util.TableToJSON(menvars, true));  	   
end  	   
  	   
local vars = {  	   
	["ESP"] = {  	   
		{"2D Box", 1, 1},  	   
		{"Healthbar", 1, 1},  	   
		{"3D Box", 0, 1},  	   
		{"Skeleton", 1, 1},  	   
		{"Name", 1, 1},  	   
		{"Health", 0, 1},  	   
		{"Distance", 0, 1},		  	   
		{"Rank", 0, 1},  	  	     	   
	},  	   
	["Misc"] = {  	   	    	   
		{"Bunnyhop", 1, 1},
                {"Auto Strafe", 1, 1}, 
                {"Circle Strafe", 1, 1},
                {"AutoSC", 1, 1}, 	   
	},  	   
        ["Visuals"] = {  	   
		{"Crazy", 0, 1},  	   
		{"Crosshair", 1, 1}, 
                {"Speedometer", 1, 1}, 	   
		{"Chams", 0, 1},  	   
		{"No Hands", 0, 1},  	   
		{"No Sky", 0, 1}, 
                {"FOV", 1, 1}, 
                {"Prop Chams", 0, 1},	   
	},  	   
	["Menu"] = {  	   
		{"Crazy", 0, 1},  	   
		{"Pos X", 75},  	   
		{"Pos Y", 175},  	   
		{"", ""},  	   
		{"Background R", 0, 255},  	   
		{"Background G", 0, 255},  	   
		{"Background B", 0, 255},  	   
		{"Background A", 245, 255},  	   
		{"", ""},  	   
		{"Bar R", 100, 255},  	   
		{"Bar G", 100, 255},  	   
		{"Bar B", 255, 255},  	   
		{"", ""},  	   
		{"Text R", 255, 255},  	   
		{"Text G", 255, 255},  	   
		{"Text B", 255, 255},  	   
		{"", ""},  	   
		{"Outline R", 0, 255},  	   
		{"Outline G", 0, 255},  	   
		{"Outline B", 0, 255},  	   
	},  	   
};  	   
  	   
  	   
local function gBool(a, b)  	   
	if (!vars[a]) then return false; end  	   
	local bool;  	   
	for k,v in next, vars[a] do  	   
		if v[1] == b then bool = (v[2] > 0 && true); end  	   
	end  	   
	return(bool);  	   
end  	   
  	   
local function gInt(a, b)  	   
	if (!vars[a]) then return 0; end  	   
	local val;  	   
	for k, v in next, vars[a] do  	   
		if v[1] == b then val = v[2]; end  	   
	end  	   
	return(val || 0);  	   
end  	   
  	   
local menuopen, selmade;  	   
local cursel = 1;  	   
  	   
local showtabs = {};  	   
  	   
local function UpdateVar(h, var)  	   
	if (!vars[h]) then return; end  	   
	for k,v in pairs(vars[h]) do  	   
		if v[1] == var[1] then  	   
			vars[h][k] = var;  	   
		end  	   
	end  	   
end  	   
  	   
local function loadconfig()  	   
	if (file.Exists("rmenu/"..menvars["Cheat Name"].."/vars.txt", "DATA")) then  	   
		local ttt = util.JSONToTable(file.Read("rmenu/"..menvars["Cheat Name"].."/vars.txt", "DATA"));  	   
		for k,v in pairs(ttt) do  	   
			for _,i in pairs(v) do  	   
				UpdateVar(k, i);  	   
			end  	   
		end  	   
	end  	   
end  	   
  	   
local drawtext;  	   
local mh;  	   
  	   
local function Menu()  	   
	local larrowdown, rarrowdown, darrowdown, uarrowdown;  	   
	local main = vgui.Create("DFrame");  	   
	main:SetSize(170, 5);  	   
	main:SetTitle("");  	   
	main:ShowCloseButton(false);  	   
	main:SetDraggable(false);  	   
	main:SetPos(gInt("Menu", "Pos X"), gInt("Main", "Pos Y"));  	   
	  	   
	local allitems = 0;  	   
	local sel = 0;  	   
	  	   
	function main:Paint(w, h)  	   
		menvars["BGColor"] = Color(gInt("Menu", "Background R"), gInt("Menu", "Background G"), gInt("Menu", "Background B"), gInt("Menu", "Background A"))  	   
		menvars["TXTColor"] = Color(gInt("Menu", "Text R"), gInt("Menu", "Text G"), gInt("Menu", "Text B"), 255)  	   
		menvars["OutlineColor"] = Color(gInt("Menu", "Outline R"), gInt("Menu", "Outline G"), gInt("Menu", "Outline B"), 255)  	   
		menvars["BarColor"] = Color(gInt("Menu", "Bar R"), gInt("Menu", "Bar G"), gInt("Menu", "Bar B"), 255)  	   
		local backcolor = menvars["BGColor"];  	   
		local txtcolor = menvars["TXTColor"];  	   
		local outcolor = menvars["OutlineColor"];  	   
		local barcol = menvars["BarColor"];  	   
		if (gBool("Menu", "Crazy")) then  	   
			backcolor = Color(math.random(255), math.random(255), math.random(255), backcolor.a);  	   
			barcol = Color(math.random(255), math.random(255), math.random(255));  	   
			outcolor = barcol;  	   
			local aa = math.random(3);  	   
			txtcolor = Color(aa == 1 && math.random(255) - barcol.r || math.random(255), aa == 2 && math.random(255) - barcol.g || math.random(255), aa == 3 && math.random(255) - barcol.b || math.random(255));  	   
		end  	   
		allitems = 0;  	   
		surface.SetTextColor(txtcolor);  	   
		local hh = 25;  	   
		surface.SetFont("BudgetLabel");  	   
		surface.SetDrawColor(backcolor);  	   
		surface.DrawRect(0, 0, w, h);  	   
  	   
		  	   
		surface.SetDrawColor(barcol);  	   
		surface.DrawRect(0, 0, w, 20);  	   
		  	   
		local ww, hh2 = surface.GetTextSize(menvars["Cheat Name"]);  	   
		  	   
		surface.SetTextPos(w / 2 - (ww / 2), 2);  	   
		surface.DrawText(menvars["Cheat Name"]);  	   
		  	   
		for k,v in SortedPairs(vars) do  	   
			allitems = allitems + 1;  	   
			local citem = allitems;  	   
			if (cursel == citem) then  	   
				if (sel != 0) then  	   
					showtabs[k] = !showtabs[k];  	   
					sel = 0;  	   
				end  	   
				surface.SetDrawColor(barcol);  	   
				surface.DrawRect(0, hh, w, 15);  	   
			end  	   
			surface.SetTextPos(5, hh);  	   
			surface.DrawText((showtabs[k] and "[-] " or "[+] ")..k);  	   
			hh = hh + 15;  	   
			if (!showtabs[k]) then continue; end  	   
			for _, var in next, vars[k] do  	   
				allitems = allitems + 1;  	   
				local curitem = allitems;	  	   
				if (cursel == curitem) then  	   
					if (sel != 0) then  	   
						if (k == "Menu" && string.find(vars[k][_][1], "Pos")) then sel = sel * 5; end  	   
						if (vars[k][_][1] != "" && !(vars[k][_][3] && (vars[k][_][2] + sel >  vars[k][_][3]))) then  	   
							vars[k][_][2] = (vars[k][_][2] + sel >= 0 && vars[k][_][2] + sel || (vars[k][_][1] == "Max X" || vars[k][_][1] == "Max Y" || vars[k][_][1] == "Min Y" || vars[k][_][1] == "Min X") && vars[k][_][2] + sel || vars[k][_][2]);  	   
							timer.Simple(.05, function()  	   
								if ((larrowdown || rarrowdown)  && cursel == curitem && k == "Menu" || (larrowdown || rarrowdown) && cursel == curitem && (vars[k][_][1] == "Max X" || vars[k][_][1] == "Max Y" || vars[k][_][1] == "Min Y" || vars[k][_][1] == "Min X")) then  	   
									larrowdown = false;  	   
									rarrowdown = false;  	   
								end  	   
							end);  	   
						end  	   
						sel = 0;  	   
					end  	   
					drawtext = (vars[k][_][4] && vars[k][_][4] || "");  	   
					mh = hh;  	   
					surface.SetDrawColor(barcol);  	   
					surface.DrawRect(0, hh, w, 16);  	   
				end  	   
				surface.SetTextPos(15, hh);  	   
				local n = vars[k][_][1];  	   
				if (n != "") then  	   
					surface.DrawText(vars[k][_][1]..":");  	   
				end  	   
				surface.SetTextPos(130, hh);  	   
				if (n != "" && k != "Menu" && vars[k][_][1] != "Max X" && vars[k][_][1] != "Max Y" && vars[k][_][1] != "Min Y" && vars[k][_][1] != "Min X") then  	   
					surface.DrawText(vars[k][_][2]..".00");  	   
				else  	   
					surface.DrawText(vars[k][_][2]);  	   
				end  	   
				hh = hh + 15;  	   
			end  	   
		end  	   
		  	   
		allitems = allitems + 1;  	   
		local curitem = allitems;  	   
		  	   
		if (cursel == curitem) then  	   
			if (sel != 0) then  	   
				showtabs["Save/Load"] = !showtabs["Save/Load"];  	   
				sel = 0;  	   
			end  	   
			surface.SetDrawColor(barcol);  	   
			surface.DrawRect(0, hh, w, 15);  	   
		end  	   
		  	   
		surface.SetTextPos(5, hh);  	   
		surface.DrawText((showtabs["Save/Load"] and "[-] " or "[+] ").."Save/Load");  	   
	  	   
		hh = hh + 15;  	   
		  	   
		if (showtabs["Save/Load"]) then  	   
			allitems = allitems + 1;  	   
			local citem = allitems;  	   
			local tr = "0.00";  	   
			if (cursel == citem) then  	   
				if (sel != 0) then  	   
					sel = 0;  	   
					tr = "1.00";  	   
					file.Write("rmenu/"..menvars["Cheat Name"].."/vars.txt", util.TableToJSON(vars, true));  	   
					file.Write("rmenu/"..menvars["Cheat Name"].."/mvars.txt", util.TableToJSON(menvars, true));  	   
				end  	   
				surface.SetDrawColor(barcol);  	   
				surface.DrawRect(0, hh, w, 15);  	   
			end  	   
			surface.SetTextPos(15, hh);  	   
			surface.DrawText("Save:");  	   
			surface.SetTextPos(130, hh);  	   
			surface.DrawText(tr);  	   
			hh = hh+15;  	   
			  	   
			  	   
			allitems = allitems + 1;  	   
			local citem2 = allitems;  	   
			local tr2 = "0.00";  	   
			if (cursel == citem2) then  	   
				if (sel != 0) then  	   
					sel = 0;  	   
					tr2 = "1.00";  	   
					loadconfig();  	   
				end  	   
				surface.SetDrawColor(barcol);  	   
				surface.DrawRect(0, hh, w, 15);  	   
			end  	   
			surface.SetTextPos(15, hh);  	   
			surface.DrawText("Load:");  	   
			surface.SetTextPos(130, hh);  	   
			surface.DrawText(tr2);  	   
			hh = hh+15;  	   
		end  	   
		  	   
		  	   
		  	   
		main:SetSize(170, hh + 5);  	   
		  	   
		main:SetPos(gInt("Menu", "Pos X"), gInt("Menu", "Pos Y"));  	   
  	   
		surface.SetDrawColor(outcolor);  	   
		surface.DrawOutlinedRect(0, 0, 170, hh + 5);  	   
	end  	   
	  	   
	function main:Think()  	   
		if (input.IsKeyDown(KEY_UP) && !uarrowdown) then  	   
			if (cursel - 1 > 0) then  	   
				cursel = cursel - 1;  	   
			else  	   
				cursel = allitems;  	   
			end  	   
			uarrowdown = true;  	   
		elseif (!input.IsKeyDown(KEY_UP)) then  	   
			uarrowdown = false;  	   
		end  	   
		  	   
		if (input.IsKeyDown(KEY_DOWN) && !darrowdown) then  	   
			if (cursel < allitems) then  	   
				cursel = cursel + 1;  	   
			else  	   
				cursel = 1;  	   
			end  	   
			darrowdown = true;  	   
		elseif (!input.IsKeyDown(KEY_DOWN)) then  	   
			darrowdown = false;  	   
		end  	   
		  	   
		if (input.IsKeyDown(KEY_LEFT) && !larrowdown) then  	   
			sel = -1;  	   
			larrowdown = true;  	   
		elseif (!input.IsKeyDown(KEY_LEFT)) then  	   
			larrowdown = false;  	   
		end  	   
		  	   
		if (input.IsKeyDown(KEY_RIGHT) && !rarrowdown) then  	   
			sel = 1;  	   
			rarrowdown = true;  	   
		elseif (!input.IsKeyDown(KEY_RIGHT)) then  	   
			rarrowdown = false;  	   
		end  	   
		if (input.IsKeyDown(KEY_INSERT) && !insertdown2) then  	   
			main:Close();  	   
			drawtext = "";  	   
			menuopen = false;  	   
		end  	   
	end  	   
end  	   
  	   
local insertdown = false;  	   
  	   
function GAMEMODE:Think()  	   
	if (input.IsKeyDown(KEY_INSERT) && !menuopen && !insertdown) then  	   
		menuopen = true;  	   
		insertdown = true;  	   
		Menu();  	   
	elseif (!input.IsKeyDown(KEY_INSERT) && !menuopen) then  	   
		insertdown = false;  	   
	end  	   
	if (input.IsKeyDown(KEY_INSERT) && insertdown && menuopen) then  	   
		insertdown2 = true;  	   
	else  	   
		insertdown2 = false;  	   
	end  	   
end  	   
  	   
loadconfig();  	   
  	   
--- esp

local em = FindMetaTable("Entity");  	   
local cm = FindMetaTable("CUserCmd");  	   
local pm = FindMetaTable("Player");  	   
local vm = FindMetaTable("Vector");  	   
local am = FindMetaTable("Angle");  	   
local wm = FindMetaTable("Weapon");  	   
  	   
  	   
local function ESP(ent)  	   
	local pos = em.GetPos(ent);  	   
	local pos2 = pos + Vector(0, 0, 70);  	   
	local pos = vm.ToScreen(pos);  	   
	local pos2 = vm.ToScreen(pos2);  	   
	local h = pos.y - pos2.y;  	   
	local w = h / 2;  	   
	local col = (gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color(0,0,0));  	   
	if (gBool("ESP", "2D Box")) then  	   
		surface.SetDrawColor(col);  	   
		surface.DrawOutlinedRect(pos.x - w / 2, pos.y - h, w, h);  	   
		surface.DrawOutlinedRect(pos.x - w / 2 + 2, pos.y - h + 2, w - 4, h - 4);  	   
		local ocol = (gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || team.GetColor(pm.Team(ent)));  	   
		surface.SetDrawColor(ocol);  	   
		surface.DrawOutlinedRect(pos.x - w / 2 - 1, pos.y - h - 1, w + 2, h + 2);  	   
		surface.DrawOutlinedRect(pos.x - w / 2 + 1, pos.y - h + 1, w - 2, h - 2);  	   
	end  	   
	if (gBool("ESP", "Healthbar")) then  	   
		local bgcol = (gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color(0, 0, 0));  	   
		surface.SetDrawColor(bgcol);  	   
		surface.DrawRect(pos.x - (w/2) - 7, pos.y - h - 1, 5, h + 2);  	   
		local hp = em.Health(ent);  	   
		local col1 = gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color(0,255,0);  	   
		surface.SetDrawColor((100 - hp) * 2.55, hp * 2.55, 0);  	   
		local hp = hp * h / 100;  	   
		local diff = h - hp;  	   
		surface.DrawRect(pos.x - (w / 2) - 6, pos.y - h + diff, 3, hp);  	   
	end  	   
	  	   
	local hh = 0;  	   
	  	   
	local txtstyle = gBool("ESP", "Text Style");  	   
	  	   
	if (gBool("ESP", "Name")) then  	   
		local col1 = gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color(0,200,0);  	   
		local col2 = gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color(200,72,52);  	   
		local friendstatus = pm.GetFriendStatus(ent);  	   
		if (!txtstyle) then  	   
			draw.SimpleText(pm.Name(ent), "BudgetLabel", pos.x, pos.y - h - (friendstatus == "friend" && 7 || 7), col1, 1, 1);  	   
			if (friendstatus == "friend") then  	   
				draw.SimpleText("Friend", "BudgetLabel", pos.x, pos.y - h - 17, col2, 1, 1);  	   
			end  	   
		else  	   
			draw.SimpleText(pm.Name(ent), "BudgetLabel", pos.x + (w/2) + 5, pos.y - h + 3 + hh, col1, 0, 1);  	   
			hh = hh + 10;  	   
			if (friendstatus == "friend") then  	   
				draw.SimpleText("Friend", "BudgetLabel", pos.x + (w/2) + 5, pos.y - h + 3 + hh, col2, 0, 1);  	   
				hh = hh + 10;  	   
			end  	   
		end  	   
	end  	   
	if (gBool("ESP", "Health")) then  	   
		hh = hh + 10;  	   
		local col1 = gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color((100 - em.Health(ent)) * 2.55, em.Health(ent) * 2.55, 0);  	   
			draw.SimpleText("H:"..em.Health(ent), "BudgetLabel", pos.x, pos.y - 2, col1, 1, 0);  	   
	end  	   
	if (gBool("ESP", "Distance")) then  	   
		local col = gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color(255,210,255);  	   
			draw.SimpleText("D:"..math.ceil(vm.Distance(em.GetPos(ent), em.GetPos(me))), "BudgetLabel", pos.x, pos.y - 2 + hh, col, 1, 0);  	   
		hh = hh + 10;  	   
	end  	   
	if (gBool("ESP", "Rank")) then  	   
		local col = gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color(170,0,170);  	   
			draw.SimpleText("R:"..pm.GetUserGroup(ent), "BudgetLabel", pos.x, pos.y - 2 + hh, col, 1, 0);  	   
	end  	   
end  	   
  	   
local function GB(ent, bone)  	   
	local bone = em.LookupBone(ent, bone);  	   
	return(bone && vm.ToScreen(em.GetBonePosition(ent, bone)) || nil);  	   
end  	   
  	   
local function DrawCrosshair()  	   
	if (!gBool("Visuals", "Crosshair")) then return; end  	   
	surface.SetDrawColor((gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255))) || Color(0,255,0));  	   
	local w, h = ScrW(), ScrH();  	   
	surface.DrawLine(w / 2 - 15, h / 2, w / 2 - 5, h / 2);  	   
	surface.DrawLine(w / 2 + 15, h / 2, w / 2 + 5, h / 2);  	   
	surface.DrawLine(w / 2, h / 2 - 15, w / 2, h / 2 - 5);  	   
	surface.DrawLine(w / 2, h / 2 + 15, w / 2, h / 2 + 5);  	   
end  	   
  	   
function GAMEMODE:HUDShouldDraw(str)  	   
	if (str == "CHudCrosshair" && gBool("Visuals", "Crosshair")) then return false; else return true; end  	   
end   	   
  	   
local function Skeleton(ent)  	   
	if (!gBool("ESP", "Skeleton")) then return; end  	   
  	   
	local b = {  	   
		head = GB(ent, "ValveBiped.Bip01_Head1"),  	   
		neck = GB(ent, "ValveBiped.Bip01_Neck1"),  	   
		spine4 = GB(ent, "ValveBiped.Bip01_Spine4"),  	   
		spine2 = GB(ent, "ValveBiped.Bip01_Spine2"),  	   
		spine1 = GB(ent, "ValveBiped.Bip01_Spine1"),  	   
		spine = GB(ent, "ValveBiped.Bip01_Spine"),  	   
		rarm = GB(ent, "ValveBiped.Bip01_R_UpperArm"),  	   
		rfarm = GB(ent, "ValveBiped.Bip01_R_Forearm"),  	   
		rhand = GB(ent, "ValveBiped.Bip01_R_Hand"),  	   
		larm = GB(ent, "ValveBiped.Bip01_L_UpperArm"),  	   
		lfarm = GB(ent, "ValveBiped.Bip01_L_Forearm"),  	   
		lhand = GB(ent, "ValveBiped.Bip01_L_Hand"),  	   
		rthigh = GB(ent, "ValveBiped.Bip01_R_Thigh"),  	   
		rcalf = GB(ent, "ValveBiped.Bip01_R_Calf"),  	   
		rfoot = GB(ent, "ValveBiped.Bip01_R_Foot"),  	   
		rtoe = GB(ent, "ValveBiped.Bip01_R_Toe0"),  	   
		lthigh = GB(ent, "ValveBiped.Bip01_L_Thigh"),  	   
		lcalf = GB(ent, "ValveBiped.Bip01_L_Calf"),  	   
		lfoot = GB(ent, "ValveBiped.Bip01_L_Foot"),  	   
		ltoe = GB(ent, "ValveBiped.Bip01_L_Toe0"),  	   
	}  	   
	  	   
	if (!b.head||!b.neck||!b.spine4||!b.spine2||!b.spine1||!b.spine||!b.rarm||!b.rfarm||!b.rarm||!b.rhand||!b.larm||!b.lfarm||!b.lhand||!b.rthigh||!b.rcalf||!b.rfoot||!b.rtoe||!b.lthigh||!b.lcalf||!b.lfoot||!b.ltoe) then return; end  	   
	  	   
	local col = gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || Color(255,255,255);  	   
	  	   
	surface.SetDrawColor(col);  	   
	surface.DrawLine(b.head.x, b.head.y, b.neck.x, b.neck.y);  	   
	surface.DrawLine(b.neck.x, b.neck.y, b.spine4.x, b.spine4.y);  	   
	surface.DrawLine(b.spine4.x, b.spine4.y, b.spine2.x, b.spine2.y);  	   
	surface.DrawLine(b.spine2.x, b.spine2.y, b.spine1.x, b.spine1.y);  	   
	surface.DrawLine(b.spine1.x, b.spine1.y, b.spine.x, b.spine.y);  	   
	  	   
	surface.DrawLine(b.spine4.x, b.spine4.y, b.rarm.x, b.rarm.y);  	   
	surface.DrawLine(b.rarm.x, b.rarm.y, b.rfarm.x, b.rfarm.y);  	   
	surface.DrawLine(b.rfarm.x, b.rfarm.y, b.rhand.x, b.rhand.y);  	   
	  	   
	surface.DrawLine(b.spine4.x, b.spine4.y, b.larm.x, b.larm.y);  	   
	surface.DrawLine(b.larm.x, b.larm.y, b.lfarm.x, b.lfarm.y);  	   
	surface.DrawLine(b.lfarm.x, b.lfarm.y, b.lhand.x, b.lhand.y);  	   
	  	   
	surface.DrawLine(b.spine.x, b.spine.y, b.rthigh.x, b.rthigh.y);  	   
	surface.DrawLine(b.rthigh.x, b.rthigh.y, b.rcalf.x, b.rcalf.y);  	   
	surface.DrawLine(b.rcalf.x, b.rcalf.y, b.rfoot.x, b.rfoot.y);  	   
	surface.DrawLine(b.rfoot.x, b.rfoot.y, b.rtoe.x, b.rtoe.y);  	   
	  	   
	surface.DrawLine(b.spine.x, b.spine.y, b.lthigh.x, b.lthigh.y);  	   
	surface.DrawLine(b.lthigh.x, b.lthigh.y, b.lcalf.x, b.lcalf.y);  	   
	surface.DrawLine(b.lcalf.x, b.lcalf.y, b.lfoot.x, b.lfoot.y);  	   
	surface.DrawLine(b.lfoot.x, b.lfoot.y, b.ltoe.x, b.ltoe.y);  	   
end  	   
  	   
function GAMEMODE:DrawOverlay()  	   
	local allplys = player.GetAll();  	   
	for i = 1, #allplys do  	   
		local v = allplys[i];  	   
		if (!v || !em.IsValid(v) || v == me || em.Health(v) < 1) then continue; end  	   
		ESP(v);  	   
		Skeleton(v);  	   
	end  	   
	DrawCrosshair();  	   
  	   
	if (!mh || !drawtext || drawtext == "") then return; end  	   
	surface.SetTextColor(menvars["TXTColor"]);  	   
	surface.SetFont("BudgetLabel");  	   
	local w, h = surface.GetTextSize(drawtext);  	   
	surface.SetTextPos( gInt("Menu", "Pos X") + 180, mh + (h / 2.5));  	   
	surface.DrawText(drawtext);  	   
end 

local mat = CreateMaterial("", "VertexLitGeneric", {  	   
	["$basetexture"] = "models/debug/debugwhite",   	   
	["$model"] = 1,   	   
	["$ignorez"] = 1,  	   
});  	   
  	   
local mat2 = CreateMaterial(" ", "VertexLitGeneric", {  	   
	["$basetexture"] = "models/debug/debugwhite",   	   
	["$model"] = 1,   	   
	["$ignorez"] = 0,  	   
});  	   
  	   
function GAMEMODE:RenderScreenspaceEffects()  	   
	if (!gBool("Visuals", "Chams")) then return; end  	   
	local allplys = player.GetAll();  	   
	for i = 1, #allplys do  	   
		local v = allplys[i];  	   
		if (!v || !em.IsValid(v) || v == me || em.Health(v) < 1 || pm.Team(v) == 1002) then continue; end  	   
		local col = gBool("Visuals", "Crazy") && Color(math.random(255), math.random(255), math.random(255)) || team.GetColor(pm.Team(v));  	   
		cam.Start3D();  	   
			render.MaterialOverride(mat);  	   
			render.SetColorModulation(col.b / 255, col.r / 255, col.g / 255);  	   
			em.DrawModel(v);  	   
			render.MaterialOverride(mat2);  	   
			render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255);  	   
			em.DrawModel(v);  	   
			render.SetColorModulation(1, 1, 1);  	   
		cam.End3D();  	   
	end  	   
end 

SizeW = 0.6 * ScrW()
SizeH = 0.6 * ScrH()
CenterX = (ScrW()/2) - SizeW/2
CenterY = (ScrH()/2) - SizeH/2

hook.Add("HUDPaint", "Velocity", function()
if (gBool("Visuals", "Speedometer")) then
local mespeed = math.Round(me:GetVelocity():Length())
draw.SimpleText( "Velocity: "..mespeed, "BudgetLabel",SizeW/1.24,  SizeH/0.8,  Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0 , 0 ))  
end    
end)
 	   
  	   
  	   
function GAMEMODE:PreDrawSkyBox()  	   
	if (!gBool("Visuals", "No Sky")) then return; end  	   
	render.Clear(50, 50, 50, 255);  	   
	return true;  	   
end  	   
  	   
  	   
local ogethands = pm.GetHands; -- Note: Only for c_ viewmodels  	   
  	   
function pm.GetHands(...)  	   
	return(!gBool("Visuals", "No Hands") && ogethands(...));  	   
end 

local function fov()
  if (gBool("Visuals", "FOV")) then
    local ta = {}
    ta.fov = 120
    return ta
  end
end
hook.Add("CalcView", "fov", fov)

local function cham()

material = ("Models/effects/comball_sphere") 

    for k,v in pairs(ents.FindByClass("prop_physics")) do
        if (gBool("Visuals", "Prop Chams")) then
            xray = 1
            cam.Start3D()
            local distance = v:GetPos():Distance(me:GetPos())
                cam.IgnoreZ(true)
                v:SetRenderMode(RENDERMODE_TRANSALPHA)
                v:SetColor(Color(0,255,255,255))
                 render.MaterialOverride(Material(material))
                v:DrawModel()  
                render.DrawWireframeBox(v:GetPos(), v:GetAngles(), v:OBBMins() + Vector(5, 5, 5), v:OBBMaxs() - Vector(5, 5, 5), Color(0,255,255,255))
                v:AddEffects(256)
            cam.End3D()
            else
                xray = 0
                v:SetColor(Color(255,255,255,255))
        end
    end
end
hook.Add("RenderScreenspaceEffects", "cham", cham)
	   

------ movement

local prev_yaw = 0
local last_ground_pos = 0
local real_ang = Angle()
local cstrafe_predict_ticks = 30
local cstrafe_angle_step = 1
local cstrafe_angle_maxstep = 5
local cstrafe_dir = 0
local cstrafe_ground_diff = 5

local function MovementFix( cmd, wish_yaw )

	local pitch = math.NormalizeAngle( cmd:GetViewAngles().x )
	local inverted = -1
	
	if ( pitch > 89 || pitch < -89 ) then
		inverted = 1
	end

	local ang_diff = math.rad( math.NormalizeAngle( ( cmd:GetViewAngles().y - wish_yaw )*inverted ) )

	local forwardmove = cmd:GetForwardMove()
	local sidemove = cmd:GetSideMove()

	local new_forwardmove = forwardmove*-math.cos( ang_diff )*inverted + sidemove*math.sin( ang_diff )
	local new_sidemove = forwardmove*math.sin( ang_diff )*inverted + sidemove*math.cos( ang_diff )

	cmd:SetForwardMove( new_forwardmove )
	cmd:SetSideMove( new_sidemove )
	
end

local function PredictVelocity( velocity, viewangles, dir, maxspeed, accel )

	local forward = viewangles:Forward()
	local right = viewangles:Right()
	
	local fmove = 0
	local smove = ( dir == 1 ) && -10000 || 10000
	
	forward.z = 0
	right.z = 0
	
	forward:Normalize()
	right:Normalize()

	local wishdir = Vector( forward.x*fmove + right.x*smove, forward.y*fmove + right.y*smove, 0 )
	local wishspeed = wishdir:Length()
	
	wishdir:Normalize()
	
	if ( wishspeed != 0 && wishspeed > maxspeed ) then
		wishspeed = maxspeed
	end
	
	local wishspd = wishspeed
	
	if ( wishspd > 30 ) then
		wishspd = 30
	end
	
	local currentspeed = velocity:Dot( wishdir )
	local addspeed = wishspd - currentspeed
	
	if ( addspeed <= 0 ) then
		return velocity
	end
	
	local accelspeed = accel * wishspeed * engine.TickInterval()
	
	if ( accelspeed > addspeed ) then
		accelspeed = addspeed
	end
	
	return velocity + ( wishdir * accelspeed )

end

local function PredictMovement( viewangles, dir, angle )

	local pm

	local sv_airaccelerate = GetConVarNumber( "sv_airaccelerate" )
	local sv_gravity = GetConVarNumber( "sv_gravity" )
	local maxspeed = LocalPlayer():GetMaxSpeed()
	local jump_power = LocalPlayer():GetJumpPower()

	local origin = LocalPlayer():GetNetworkOrigin()
	local velocity = LocalPlayer():GetAbsVelocity()
	
	local mins = LocalPlayer():OBBMins()
	local maxs = LocalPlayer():OBBMaxs()
	
	local on_ground = LocalPlayer():IsFlagSet( FL_ONGROUND )
	
	for i = 1, cstrafe_predict_ticks do

		viewangles.y = math.NormalizeAngle( math.deg( math.atan2( velocity.y, velocity.x ) ) + angle )

		velocity.z = velocity.z - ( sv_gravity * engine.TickInterval() * 0.5 )

		if ( on_ground ) then
		
			velocity.z = jump_power
			velocity.z = velocity.z - ( sv_gravity * engine.TickInterval() * 0.5 )
			
		end

		velocity = PredictVelocity( velocity, viewangles, dir, maxspeed, sv_airaccelerate )
		
		local endpos = origin + ( velocity * engine.TickInterval() )

		pm = util.TraceHull( {
			start = origin,
			endpos = endpos,
			filter = LocalPlayer(),
			maxs = maxs,
			mins = mins,
			mask = MASK_PLAYERSOLID
		} )
		
		if ( ( pm.Fraction != 1 && pm.HitNormal.z <= 0.9 ) || pm.AllSolid || pm.StartSolid ) then
			return false
		end
		
		if ( pm.Fraction != 1 ) then
		
			local time_left = engine.TickInterval()

			for j = 1, 2 do
			
				time_left = time_left - ( time_left * pm.Fraction )

				local dot = velocity:Dot( pm.HitNormal )
				
				velocity = velocity - ( pm.HitNormal * dot )

				dot = velocity:Dot( pm.HitNormal )

				if ( dot < 0 ) then
					velocity = velocity - ( pm.HitNormal * dot )
				end

				endpos = pm.HitPos + ( velocity * time_left )

				pm = util.TraceHull( {
					start = pm.HitPos,
					endpos = endpos,
					filter = LocalPlayer(),
					maxs = maxs,
					mins = mins,
					mask = MASK_PLAYERSOLID
				} )
				
				if ( ( pm.Fraction != 1 && pm.HitNormal.z <= 0.9 ) || pm.AllSolid || pm.StartSolid ) then
					return false
				end

				if ( pm.Fraction == 1 ) then
					break
				end
			
			end
			
		end
		
		origin = pm.HitPos
		
		if ( ( last_ground_pos - origin.z ) > cstrafe_ground_diff ) then
			return false
		end
		
		pm = util.TraceHull( {
			start =  Vector( origin.x, origin.y, origin.z + 2 ),
			endpos = Vector( origin.x, origin.y, origin.z - 1 ),
			filter = LocalPlayer(),
			maxs = Vector( maxs.x, maxs.y, maxs.z * 0.5 ),
			mins = mins,
			mask = MASK_PLAYERSOLID
		} )
		
		on_ground = ( ( pm.Fraction < 1 || pm.AllSolid || pm.StartSolid ) && pm.HitNormal.z >= 0.7 )
		
		velocity.z = velocity.z - ( sv_gravity * engine.TickInterval() * 0.5 )

	end

	return true

end

local function CircleStrafe( cmd )

	local angle = 0
	
	for i = 1, 2 do
	
		angle = 0
		local path_found = false
		local step = ( cstrafe_dir == 1 ) && cstrafe_angle_step || -cstrafe_angle_step
		
		while ( true ) do
		
			if ( cstrafe_dir == 1 ) then
			
				if ( angle > cstrafe_angle_maxstep ) then
					break
				end
			
			else
			
				if ( angle < -cstrafe_angle_maxstep ) then
					break
				end
			
			end

			if ( PredictMovement( cmd:GetViewAngles(), cstrafe_dir, angle ) ) then
			
				path_found = true
				break
			
			end

			angle = angle + step
		
		end
		
		if ( path_found ) then
			break
		end
		
		if ( cstrafe_dir == 1 ) then
			cstrafe_dir = 0
		else
			cstrafe_dir = 1
		end
	
	end
	
	local velocity = LocalPlayer():GetAbsVelocity()
	local viewangles = cmd:GetViewAngles()
	
	viewangles.y = math.NormalizeAngle( math.deg( math.atan2( velocity.y, velocity.x ) ) + angle )
	
	cmd:SetViewAngles( viewangles )
	cmd:SetSideMove( ( cstrafe_dir == 1 ) && -10000 || 10000 )

end

local function AutoStrafe( cmd )

	if ( input.IsKeyDown( KEY_E ) ) && (gBool("Misc", "Circle Strafe")) then
	
		CircleStrafe( cmd )
	
	else

		local ang_diff = math.NormalizeAngle( real_ang.y - prev_yaw )
		
		if ( math.abs( ang_diff ) > 0 ) then
		
			if ( ang_diff > 0 ) then
				cmd:SetSideMove( -10000 )
			else
				cmd:SetSideMove( 10000 )
			end
		
		else
		
			local vel = LocalPlayer():GetAbsVelocity()
			local vel_yaw = math.NormalizeAngle( math.deg( math.atan2( vel.y, vel.x ) ) )
			local vel_yaw_diff = math.NormalizeAngle( real_ang.y - vel_yaw )
			
			if ( vel_yaw_diff > 0 ) then
				cmd:SetSideMove( -10000 )
			else
				cmd:SetSideMove( 10000 )
			end

			local viewangles = cmd:GetViewAngles()
			viewangles.y = vel_yaw
			cmd:SetViewAngles( viewangles )
			
		end

		prev_yaw = real_ang.y
		
	end
	
end

hook.Add( "CreateMove", "AutoStrafe_CreateMove", function( cmd )
local weapon = LocalPlayer():GetActiveWeapon()

	real_ang = real_ang + Angle( cmd:GetMouseY() * 0.023, -cmd:GetMouseX() * 0.023, 0 )
	real_ang.x = math.Clamp( real_ang.x, -89, 89 )
	real_ang:Normalize()
	
	if ( cmd:CommandNumber() == 0 ) then
		cmd:SetViewAngles( real_ang )
		return
	end

	if ( LocalPlayer():IsFlagSet( FL_ONGROUND ) ) then
		last_ground_pos = LocalPlayer():GetNetworkOrigin().z
	end

	if ( cmd:KeyDown( IN_JUMP ) ) then

		if ( !LocalPlayer():IsFlagSet( FL_ONGROUND ) ) then
			cmd:RemoveKey( IN_JUMP )
		end
              if (gBool("Misc", "Auto Strafe")) then 
		AutoStrafe( cmd )
              end
		
	end
	
	-- run EnginePred here
    if IsValid(weapon) and string.find(weapon:GetClass(), "swcs") then
          ded.StartPredictionn = false
       else 
          ded.StartPrediction(cmd)
       end

	local wish_yaw = cmd:GetViewAngles().y
	
	local viewangles = cmd:GetViewAngles()
	viewangles.y = real_ang.y
	cmd:SetViewAngles( viewangles )
		
	MovementFix( cmd, wish_yaw )
    if IsValid(weapon) and string.find(weapon:GetClass(), "swcs") then
          ded.FinishPredictionn = false
       else 
          ded.FinishPrediction(cmd)
       end
end )

--- misc

lastEvent = 0

local originalChatAddText = chat.AddText

chat.AddText = function(...)
    if type(select(1, ...)) == "table" and
       select(1, ...).r == 162 and 
       select(1, ...).g == 255 and 
       select(1, ...).b == 162 and 
       select(1, ...).a == 255 and 
       type(select(2, ...)) == "string" and 
       select(2, ...):sub(1, 25) == "[SC] first person to say " then
       
        lastEvent = os.time()
       if (gBool("Misc", "AutoSC")) then
        RunConsoleCommand("say", string.match(select(2, ...), "(%d+)"))
       end
    end
    
    return originalChatAddText(...)
end

