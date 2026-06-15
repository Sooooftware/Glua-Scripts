---Legit Backtrack up to 1 second. using your shoot pos. (Pls paste from this. i like it when more cheats use backtrack)

require("zxcmodule")

local me = LocalPlayer

local records = {}

local TICK_INTERVAL = engine.TickInterval()
local MAX_BACKTRACK = 1.0
local MAX_RECORDS = math.floor(MAX_BACKTRACK / TICK_INTERVAL)

ded.SetInterpolation(false)
ded.SetSequenceInterpolation(false)
ded.SetInterpolationAmount(0)


local function IsValidTarget(ply)
    if not IsValid(ply) then return false end
    if ply == me() then return false end
    if not ply:Alive() then return false end
    if ply:IsDormant() then return false end
    return true
end

local function TimeToTicks(time)
    return math.floor((time / TICK_INTERVAL) + 0.5)
end

local function GetLerp()

    local interp = GetConVar("cl_interp"):GetFloat()
    local ratio = GetConVar("cl_interp_ratio"):GetFloat()
    local updaterate = GetConVar("cl_updaterate"):GetFloat()

    if updaterate <= 0 then
        updaterate = 66
    end

    local lerp = math.max(interp, ratio / updaterate)

    return lerp
end

local function GetShootPos()
    return me():GetShootPos()
end

local function Visible(pos)

    local tr = util.TraceLine({
        start = GetShootPos(),
        endpos = pos,
        filter = me(),
        mask = MASK_SHOT
    })

    return not tr.Hit
end

local function GetFovToPos(pos)

    local ang = ded.GetViewAngles()
    local forward = ang:Forward()

    local dir = (pos - GetShootPos()):GetNormalized()

    return math.deg(
        math.acos(
            math.Clamp(forward:Dot(dir), -1, 1)
        )
    )
end


local function StoreRecord(ply)

    records[ply] = records[ply] or {}

    local simtime = ded.GetSimulationTime(ply)
    if not simtime or simtime <= 0 then
        return
    end

    local tbl = records[ply]

    local newest = tbl[1]
    if newest and newest.simtime == simtime then
        return
    end


    ded.StartSimulation(ply)

        ded.SimulateTick()

        local origin = ply:GetPos()
        local velocity = ply:GetVelocity()

    ded.FinishSimulation()



    local mins = ply:OBBMins()
    local maxs = ply:OBBMaxs()

    local center = origin + Vector(0, 0, 40)

    local corrected = simtime + GetLerp()

    local rec = {
     origin = origin,
     velocity = velocity,
     center = center,
     mins = mins,
     maxs = maxs,
     simtime = simtime,
     tick = TimeToTicks(simtime)
    }

    table.insert(tbl, 1, rec)

    while #tbl > MAX_RECORDS do
        table.remove(tbl)
    end

end


hook.Add("PreFrameStageNotify", "bt_build_records", function(stage)
    if stage ~= 3 then
        return
    end

    for _, ply in ipairs(player.GetAll()) do

        if not IsValidTarget(ply) then
            records[ply] = nil
            continue
        end

        StoreRecord(ply)
    end
end)

local function FindBestRecord()

    local bestRecord
    local bestFov = math.huge

    for ply, tbl in pairs(records) do

        if not IsValidTarget(ply) then
            continue
        end

        for i = 1, #tbl do

            local rec = tbl[i]
            if not rec then continue end

            local fov = GetFovToPos(rec.center)

            if fov > 180 then
                continue
            end

            if fov < bestFov then

                bestFov = fov
                bestRecord = rec

            end
        end
    end

    return bestRecord
end


hook.Add("PreCreateMove", "bt_shoot", function(cmd)

    if not input.IsMouseDown(MOUSE_LEFT) then
        return
    end

    local rec = FindBestRecord()
    if not rec then return end

    local curtime = ded.GetCurTime(cmd)

    local targetTime = rec.simtime
    local delta = curtime - targetTime


    local serverArrive = curtime + ded.GetLatency(0) + ded.GetLatency(1)

    local diff = serverArrive - targetTime


    if diff < 0.2 then

        ded.NetSetConVar("cl_interpolate", "0")
        ded.NetSetConVar("cl_interp", "0")

        local tick = TimeToTicks(targetTime)

        ded.SetCommandTick(cmd, tick)

    else

        ded.NetSetConVar("cl_interpolate", "1")

        local lerp = curtime - targetTime

        ded.NetSetConVar("cl_interp", tostring(lerp))

        local tick = TimeToTicks(curtime)


        ded.SetCommandTick(cmd, tick - 1)
    end
end)


hook.Add("PostDrawOpaqueRenderables", "bt_visualize", function() --- This is GAY
    for ply, tbl in pairs(records) do

        for i = 1, math.min(#tbl, 80) do

            local rec = tbl[i]
            if not rec then continue end

            render.DrawWireframeBox(
                rec.origin,
                angle_zero,
                rec.mins,
                rec.maxs,
                Color(255, 0, 0),
                true
            )
        end
    end
end)


