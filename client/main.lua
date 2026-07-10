local baslatildi = false
local hudGoster = false
local sonUyariZaman = 0

RegisterNetEvent("fortify:uyariGoster")
AddEventHandler("fortify:uyariGoster", function(sebep, sayac)
    sonUyariZaman = GetGameTimer()
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~r~[Fortify Anti-Cheat]~w~\nWarning " .. sayac .. "/" .. Fortify.Ayarlar.MaxUyari .. "\nReason: " .. sebep)
    DrawNotification(false, true)
    PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", true)
end)

local function FortifyHudCiz()
    if not hudGoster then return end
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(0, 255, 100, 200)
    SetTextEntry("STRING")
    AddTextComponentString("Fortify Anti-Cheat v2.0 ~g~[ACTIVE]")
    DrawText(0.01, 0.01)
    SetTextFont(0)
    SetTextScale(0.28, 0.28)
    SetTextColour(255, 255, 255, 180)
    SetTextEntry("STRING")
    AddTextComponentString("Protected")
    DrawText(0.01, 0.04)
end

local function SilahSinirla()
    if not Fortify.Ayarlar.SilahKontrol then return end
    local ped = PlayerPedId()
    for _, silah in ipairs(Fortify.Ayarlar.YasakliSilahlar) do
        local hash = GetHashKey(silah)
        if GetSelectedPedWeapon(ped) == hash then
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        end
    end
end

local function Baslatma()
    if baslatildi then return end
    baslatildi = true
    Wait(2000)
    SetTextEntry("STRING")
    AddTextComponentString("~g~[Fortify]~w~ Anti-Cheat system active. You are being monitored.")
    DrawNotification(false, true)
    print("^2[Fortify] Client initialized.^7")
end

CreateThread(function()
    Baslatma()
end)

CreateThread(function()
    while true do
        Wait(0)
        FortifyHudCiz()
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        SilahSinirla()
    end
end)

RegisterCommand("fortifyhud", function()
    hudGoster = not hudGoster
    TriggerEvent("chat:addMessage", {
        color = {0, 255, 100},
        args = {"[Fortify]", "HUD " .. (hudGoster and "enabled." or "disabled.")}
    })
end)

RegisterNetEvent("fortify:spectateIzin")
AddEventHandler("fortify:spectateIzin", function(hedefId)
    local kaynak = source
end)

AddEventHandler("onClientResourceStart", function(kaynakAdi)
    if kaynakAdi == GetCurrentResourceName() then
        Wait(1000)
        Baslatma()
    end
end)

RegisterNetEvent("fortify:adminMesaj")
AddEventHandler("fortify:adminMesaj", function(mesaj)
    SetTextEntry("STRING")
    AddTextComponentString("~y~[Fortify Admin]~w~ " .. mesaj)
    DrawNotification(false, true)
end)

AddEventHandler("gameEventTriggered", function(ad, params)
    if ad == "CEventNetworkEntityDamage" then
        local ped = PlayerPedId()
        local hedef = params[1]
        if hedef == ped then
            local saglik = GetEntityHealth(ped)
            if saglik > Fortify.Ayarlar.MaxSaglik then
                TespitRaporla("God Mode (Damage Event)", "Health: " .. tostring(saglik), true)
            end
        end
    end
end)

print("^2[Fortify] Main client module loaded.^7")
