---Property Net manipulate Script designed like an hvh cheat. INS for menu
---ignite net i dont think works


local whi = Color(200, 200, 200, 200)
local Bg = Color(0, 0, 0, 230)
local But = Color(50, 50, 50, 200)

local vars = {
  Aura = false,
  Cursor = true,
  AuraKey = MOUSE_4,
  CursorKey = MOUSE_5,
  DissolveType = "Disintegrate",
  AuraRange = 200,
  ShowAura = true,
  AlwaysAura = false,
  Hollow = true,
  HollowKey = MOUSE_MIDDLE,
}


surface.CreateFont("Font", {
    font = "Arial",
    extended = true,
	weight = 50,
    antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = true,
	outline = true,
    size = 15
})

surface.CreateFont("bigg", {
    font = "Arial",
    extended = true,
    strikeout = true,
    size = 30
})


local function checkbox(name, tooltip, val, x, y, parent)
    local checkbox = vgui.Create("DCheckBox", parent)
    checkbox:SetPos(x, y)
    checkbox:SetSize(17, 17)
    checkbox:SetChecked(vars[val])

    if isstring(tooltip) then
        checkbox:SetTooltip(tooltip)
    end

    function checkbox:OnChange(bval)
        vars[val] = bval
    end

    function checkbox:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, But)

        if self:GetChecked() then
            draw.RoundedBox(0, 3, 3, w - 6, h - 6, whi)
        end

        return true 
    end

    local label = vgui.Create("DLabel", parent)
    label:SetText(name)
    label:SetPos(x + 22, y+1)
    label:SetFont("Font")
    label:SizeToContents()
end


local function slider(name, val, min, max, x, y, dec, parent)
    local slider = vgui.Create("DNumSlider", parent)
    slider:SetMin(min)
    slider:SetMax(max)
    slider:SetText("")  
    slider:SetSize(400, 10)
    slider:SetPos(x - 170, y + 17)
    slider.Scratch:Hide()  
    slider.TextArea:Hide()  
    slider:SetValue(vars[val])
    slider:SetDecimals(dec)


    local valueLabel = vgui.Create("DLabel", parent)
    valueLabel:SetPos(x + 90, y ) 
    valueLabel:SetFont("Font")
    valueLabel:SetText(math.Round(slider:GetValue(), dec))  
    valueLabel:SizeToContents()


    function slider:OnValueChanged(num)
        vars[val] = num
        valueLabel:SetText(math.Round(num, dec))  
        valueLabel:SizeToContents()  
    end


    slider.Slider.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 1, w, h, Color(50,50,50))  
    end


    slider.Slider.Knob:SetSize(10, 10) 
    slider.Slider.Knob.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))  
    end

    local label = vgui.Create("DLabel", parent)
    label:SetText(name)
    label:SetPos(x, y)
    label:SetFont("Font")
    label:SizeToContents()
end

local function combobox(name, options, val, x, y, parent)
    local comboBox = vgui.Create("DComboBox", parent)
    comboBox:SetPos(x, y+22)
    comboBox:SetSize(130, 15)

    comboBox.Paint = function(self, w, h)
    local bgColor = self:IsHovered() and Color(50,50,50) or Color( 80,80,80)
    draw.RoundedBox(0, 0, 0, w, h, bgColor)
    draw.SimpleText("▼", "Font", w ,h/2.5, Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
    self:SetTextColor(Color(200, 200, 200))
    self:SetFont("Font")
    self:DrawTextEntryText(self:GetTextColor(), Color(200, 200, 200), Color(200, 200, 200))
end
    comboBox.DropButton.Paint = function() end

    DMenuOption.Paint = function(self, w, h, index, value, data)
        draw.RoundedBox(0, 0, 0, w, h, Color(50,50,50))
        self:SetTextColor(Color(200, 200, 200))
        self:SetFont("Font")
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(50/1.5, 50/1.5, 50/1.5))
        end
    end


    comboBox:SetValue(vars[val] or options[1])

    for _, option in ipairs(options) do
        comboBox:AddChoice(option)
    end

    function comboBox:OnSelect(index, value, data)
        vars[val] = value
    end

    local label = vgui.Create("DLabel", parent)
    label:SetText(name)
    label:SetPos(x, y)
    label:SetSize(200, 25)
    label:SetFont("Font")
    label:SetTextColor(Color(200, 200, 200))
end

local function CreateKeybind(x, y, val, par)

	local keyBind = vgui.Create("DBinder", par)
	keyBind:SetValue(vars[val])
 	keyBind:SetSize(50, 15)
 	keyBind:SetPos(x, y)
 	keyBind.OnChange = function()
 		vars[val] = keyBind:GetValue()
 	end
        keyBind.Paint = function(self, w, h)	
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
	surface.SetDrawColor(50, 50, 50)
	surface.DrawOutlinedRect(0, 0, w, h, 1)
        self:SetTextColor(Color(255, 255, 255))
    end

end



---Frame
local function ui()
 if IsValid(frame) then
        frame:Close()
        frame = nil
    else
	frame = vgui.Create("DFrame")
	frame:SetSize(300, 300) 
	frame:Center()
	frame:SetTitle("") 
	frame:SetDraggable(true) 
	frame:ShowCloseButton(false) 
	frame:MakePopup() 

   


	--- Main Menu Paint
	frame.Paint = function(self, w, h)
	    draw.RoundedBox(2, 0, 0, w, h, Bg)
        surface.SetDrawColor(whi)
        surface.DrawOutlinedRect(0, 0, w, h)
        draw.RoundedBox(0, 0, 0, w, 29, Bg)
            surface.SetDrawColor(Color(255,255,255))
            surface.SetMaterial(Material("gui/center_gradient"))
            surface.DrawTexturedRect(0,0,w,29)
	    draw.SimpleText("Divinity", "Font", 7, 8, Color(255,255,255))
	end

        local DType = {"Disintegrate", "Instant", "Ignite"}  

        checkbox("Aura","Creates a sphere around you where nothing can get in", "Aura", 15, 40, frame)
        CreateKeybind(70, 40, "AuraKey", frame)
        checkbox("Cursor","Where you look gets dissolved", "Cursor", 15, 60, frame)
        CreateKeybind(80, 60, "CursorKey", frame)
        checkbox("Hollow Purple","Imaginary Mass", "Hollow", 15, 80, frame)
        CreateKeybind(120, 80, "HollowKey", frame)
        combobox("Dissolve Type", DType, "DissolveType", 15, 100, frame)
        checkbox("Show Aura","Shows a sphere where Aura is", "ShowAura", 15, 140, frame)
        checkbox("Always Aura","Always have Aura on", "AlwaysAura", 15, 160, frame)
        slider("Aura Range", "AuraRange", 0, 100000, 15, 180, 0, frame)


   
   	
end
end

--- menu functions

hook.Add("Think", "insmenu", function()
    if input.IsKeyDown(KEY_INSERT) then
        if not okk then
            ui()
            okk = true
        end
    else
        okk = false
    end
end)

--- Aura

hook.Add("Think", "aura", function()
    if not IsValid(LocalPlayer()) then return end
    if not (input.IsButtonDown(vars.AuraKey) or vars.AlwaysAura) then return end
    if not vars.Aura then return end

    for _, ent in ipairs(ents.FindInSphere(LocalPlayer():GetPos(), vars.AuraRange)) do
    if IsValid(ent)
        and not ent:IsPlayer()
        and not ent:IsWeapon()
        and ent:GetClass() ~= "viewmodel"
        and ent:GetClass() ~= "gmod_hands"
        and ent:GetClass() ~= "physgun_beam"
        and ent:GetModel() ~= "models/props/de_inferno/wine_barrel_p9.mdl"
    then
        if vars.DissolveType == "Disintegrate" then
        net.Start("properties")
            net.WriteString("rb655_dissolve")
            net.WriteEntity(ent)
        net.SendToServer()
        else
        net.Start("properties")
            net.WriteString("remove")
            net.WriteEntity(ent)
        net.SendToServer()
        end
    end
    end
end)

--- Cursor

hook.Add("Think", "Cursor", function()
    if not IsValid(LocalPlayer()) then return end
    if not input.IsButtonDown(vars.CursorKey) then return end
    if not vars.Cursor then return end

    local trace = LocalPlayer():GetEyeTrace()
    if not trace then return end

    local ent = trace.Entity
    if not IsValid(ent) then return end

    if IsValid(ent)
        and not ent:IsPlayer()
        and not ent:IsWeapon()
        and ent:GetClass() ~= "viewmodel"
        and ent:GetClass() ~= "gmod_hands"
        and ent:GetClass() ~= "physgun_beam"
    then
        if vars.DissolveType == "Disintegrate" then
        net.Start("properties")
            net.WriteString("rb655_dissolve")
            net.WriteEntity(ent)
        net.SendToServer()
        elseif vars.DissolveType == "Instant" then
        net.Start("properties")
            net.WriteString("remove")
            net.WriteEntity(ent)
        net.SendToServer()
        elseif vars.DissolveType == "Ignite" then
        net.Start("properties")
            net.WriteString("ignite")
            net.WriteEntity(ent)
        net.SendToServer()
        end
    end
end)


--- Aura Sphere

hook.Add("PostDrawTranslucentRenderables", "DrawDesRangeSphere", function()
    if not IsValid(LocalPlayer()) then return end
    if not (input.IsButtonDown(vars.AuraKey) or vars.AlwaysAura) then return end
    if not vars.ShowAura then return end
    if not vars.Aura then return end

    render.SetColorMaterial()
    render.DrawWireframeSphere(
        LocalPlayer():GetPos(),
        vars.AuraRange,
        30, 
        30, 
        Color(0, 200, 255, 50), 
        true
    )
end)

--- Hollow Purple

local HollowProjectile = nil
local HollowCooldown = 0

hook.Add("Think", "Hollow", function()
    if not IsValid(LocalPlayer()) then return end
    if not vars.Hollow then return end

    if input.IsButtonDown(vars.HollowKey)
        and CurTime() > HollowCooldown
        and not HollowProjectile
    then
        HollowCooldown = CurTime() + 5

        HollowProjectile = {
            startPos = LocalPlayer():GetShootPos(),
            pos = LocalPlayer():GetShootPos(),
            dir = LocalPlayer():GetAimVector(),
            distance = 0
        }
    end

    if not HollowProjectile then return end

    local speed = 2000
    local frameMove = speed * FrameTime()

    HollowProjectile.pos = HollowProjectile.pos + HollowProjectile.dir * frameMove
    HollowProjectile.distance = HollowProjectile.distance + frameMove

    for _, ent in ipairs(ents.FindInSphere(HollowProjectile.pos, 600)) do
        if IsValid(ent)
            and not ent:IsPlayer()
            and not ent:IsWeapon()
            and ent:GetClass() ~= "viewmodel"
            and ent:GetClass() ~= "gmod_hands"
            and ent:GetClass() ~= "physgun_beam"
        then
            if vars.DissolveType == "Disintegrate" then
                net.Start("properties")
                    net.WriteString("rb655_dissolve")
                    net.WriteEntity(ent)
                net.SendToServer()
            else
                net.Start("properties")
                    net.WriteString("remove")
                    net.WriteEntity(ent)
                net.SendToServer()
            end
        end
    end

    if HollowProjectile.distance >= 20000 then
        HollowProjectile = nil
    end
end)

local glowMat = Material("sprites/light_glow02_add")

hook.Add("PostDrawTranslucentRenderables", "Hollow_RenderSphere", function()
    if not HollowProjectile then return end

    local range = 600
    local pos = HollowProjectile.pos

    local pulse = math.sin(CurTime() * 3) * 8
    local size = range + pulse

    render.SetColorMaterial()

    render.DrawSphere(
        pos,
        size,
        60,
        60,
        Color(0, 120, 255, 230)
    )


    render.SetMaterial(glowMat)
    render.DrawSprite(
        pos,
        size * 2.5,
        size * 2.5,
        Color(0, 150, 255, 180)
    )

    render.DrawSprite(
        pos,
        size * 2,
        size * 2,
        Color(255, 255, 255, 220)
    )
end)
