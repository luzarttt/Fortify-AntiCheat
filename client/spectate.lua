local izliyorMu = false
local izlenenOyuncu = nil
local izlemeKamerasi = nil
local orijinalKonum = nil

local function SpectateBaslat(hedefServerId)
    if izliyorMu then return end
    local hedefPed = GetPlayerPed(GetPlayerFromServerId(hedefServerId))
    if not hedefPed or hedefPed == 0 then
        TriggerEvent("chat:addMessage", { color = {255, 0, 0}, args = {"[Fortify]", "Player not found or not connected."} })
        return
    end
    orijinalKonum = GetEntityCoords(PlayerPedId())
    izlenenOyuncu = hedefServerId
    izliyorMu = true
    NetworkRequestControlOfEntity(hedefPed)
    SetEntityLocallyInvisible(PlayerPedId())
    SetLocalPlayerInvisibleLocally(true)
    FreezeEntityPosition(PlayerPedId(), true)
    RequestCollisionAtCoord(GetEntityCoords(hedefPed))
    local kameraKonum = GetEntityCoords(hedefPed)
    izlemeKamerasi = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(izlemeKamerasi, kameraKonum.x, kameraKonum.y, kameraKonum.z + 2.0)
    SetCamActive(izlemeKamerasi, true)
    RenderScriptCams(true, true, 500, true, true)
    AttachCamToEntity(izlemeKamerasi, hedefPed, 0.0, -4.0, 2.0, true)
    TriggerServerEvent("fortify:speklateBildir", hedefServerId)
    TriggerEvent("chat:addMessage", { color = {0, 255, 255}, args = {"[Fortify]", "Now spectating: " .. GetPlayerName(GetPlayerFromServerId(hedefServerId))} })
end

local function SpectateBitir()
    if not izliyorMu then return end
    if izlemeKamerasi then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(izlemeKamerasi, false)
        DestroyCam(izlemeKamerasi, false)
        izlemeKamerasi = nil
    end
    SetEntityLocallyVisible(PlayerPedId())
    SetLocalPlayerInvisibleLocally(false)
    FreezeEntityPosition(PlayerPedId(), false)
    if orijinalKonum then
        SetEntityCoords(PlayerPedId(), orijinalKonum.x, orijinalKonum.y, orijinalKonum.z, false, false, false, true)
    end
    izliyorMu = false
    izlenenOyuncu = nil
    orijinalKonum = nil
    TriggerEvent("chat:addMessage", { color = {0, 255, 0}, args = {"[Fortify]", "Spectate mode ended."} })
end

local function SpectateGuncelle()
    if not izliyorMu or not izlenenOyuncu then return end
    local hedefOyuncu = GetPlayerFromServerId(izlenenOyuncu)
    if not hedefOyuncu or hedefOyuncu == -1 then
        SpectateBitir()
        TriggerEvent("chat:addMessage", { color = {255, 255, 0}, args = {"[Fortify]", "Player disconnected, spectate ended."} })
        return
    end
end

CreateThread(function()
    while true do
        Wait(0)
        if izliyorMu then
            SpectateGuncelle()
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            if IsControlJustPressed(0, 194) then
                SpectateBitir()
            end
        end
    end
end)

RegisterNetEvent("fortify:spectateBaslat")
AddEventHandler("fortify:spectateBaslat", function(hedefId)
    SpectateBaslat(hedefId)
end)

RegisterNetEvent("fortify:spectateBitir")
AddEventHandler("fortify:spectateBitir", function()
    SpectateBitir()
end)

RegisterCommand(Fortify.Ayarlar.SpectateKomut, function(args)
    if not args[1] then
        TriggerEvent("chat:addMessage", { color = {255, 255, 0}, args = {"[Fortify]", "Usage: /" .. Fortify.Ayarlar.SpectateKomut .. " [playerID]"} })
        return
    end
    if izliyorMu then
        SpectateBitir()
        return
    end
    local hedefId = tonumber(args[1])
    if not hedefId then
        TriggerEvent("chat:addMessage", { color = {255, 0, 0}, args = {"[Fortify]", "Invalid player ID."} })
        return
    end
    TriggerServerEvent("fortify:spectateIzin", hedefId)
end)

RegisterNetEvent("fortify:spectateIzinVerildi")
AddEventHandler("fortify:spectateIzinVerildi", function(hedefId)
    SpectateBaslat(hedefId)
end)

RegisterNetEvent("fortify:spectateReddedildi")
AddEventHandler("fortify:spectateReddedildi", function()
    TriggerEvent("chat:addMessage", { color = {255, 0, 0}, args = {"[Fortify]", "You don't have permission to spectate."} })
end)

print("^2[Fortify] Spectate module loaded.^7")
