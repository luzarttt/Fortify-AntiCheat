local sonKonum = nil
local sonHiz = 0
local sonSaglik = 200
local sonZirh = 100
local tespitSayaci = {}
local uyariCooldown = {}

local function TespitRaporla(tur, detay, otoBan)
    if uyariCooldown[tur] and (GetGameTimer() - uyariCooldown[tur]) < 10000 then return end
    uyariCooldown[tur] = GetGameTimer()
    if not tespitSayaci[tur] then tespitSayaci[tur] = 0 end
    tespitSayaci[tur] = tespitSayaci[tur] + 1
    if otoBan then
        TriggerServerEvent("fortify:otoBanla", tur .. ": " .. tostring(detay))
    else
        TriggerServerEvent("fortify:tespitBildir", tur, detay)
    end
end

local function GodModeTespit()
    if not Fortify.Ayarlar.GodModeKontrol then return end
    local ped = PlayerPedId()
    if not IsEntityDead(ped) then
        local saglik = GetEntityHealth(ped)
        if saglik > Fortify.Ayarlar.MaxSaglik then
            TespitRaporla("God Mode", "Health: " .. tostring(saglik), true)
            SetEntityHealth(ped, Fortify.Ayarlar.MaxSaglik)
        end
        if GetPedArmour(ped) > Fortify.Ayarlar.MaxZirh then
            TespitRaporla("Max Armor Hack", "Armor: " .. tostring(GetPedArmour(ped)), false)
            SetPedArmour(ped, Fortify.Ayarlar.MaxZirh)
        end
    end
end

local function GorünmezlikTespit()
    if not Fortify.Ayarlar.InvisibleKontrol then return end
    local ped = PlayerPedId()
    if not IsEntityVisible(ped) then
        TespitRaporla("Invisibility Hack", "Player is invisible", true)
        SetEntityVisible(ped, true, false)
    end
end

local function SuperZiplamaTespit()
    if not Fortify.Ayarlar.SuperJumpKontrol then return end
    local ped = PlayerPedId()
    if GetEntityHeightAboveGround(ped) > 50.0 and not IsPedInAnyVehicle(ped, false) and not IsPedFalling(ped) then
        TespitRaporla("Super Jump", "Height: " .. tostring(GetEntityHeightAboveGround(ped)), false)
    end
end

local function NoclipTespit()
    if not Fortify.Ayarlar.NoclipKontrol then return end
    local ped = PlayerPedId()
    if GetEntityCollisionDisabled(ped) then
        TespitRaporla("NoClip", "Collision disabled", true)
    end
end

local function HizTespit()
    if not Fortify.Ayarlar.HizKontrol then return end
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local arac = GetVehiclePedIsIn(ped, false)
        local hiz = GetEntitySpeed(arac) * 3.6
        if hiz > Fortify.Ayarlar.MaxHiz then
            TespitRaporla("Speed Hack", string.format("Speed: %.1f km/h", hiz), false)
        end
    end
end

local function TeleportTespit()
    if not Fortify.Ayarlar.TeleportKontrol then return end
    local ped = PlayerPedId()
    local mevcutKonum = GetEntityCoords(ped)
    if sonKonum then
        local mesafe = MesafeHesapla(mevcutKonum, sonKonum)
        local ped_aracta = IsPedInAnyVehicle(ped, false)
        local limitMesafe = ped_aracta and (Fortify.Ayarlar.TeleportMesafe * 2) or Fortify.Ayarlar.TeleportMesafe
        if mesafe > limitMesafe and not IsScreenFadedOut() then
            TespitRaporla("Teleport", string.format("Distance: %.1f units", mesafe), false)
        end
    end
    sonKonum = mevcutKonum
    TriggerServerEvent("fortify:konumGuncelle", { x = mevcutKonum.x, y = mevcutKonum.y, z = mevcutKonum.z })
end

local function SilahTespit()
    if not Fortify.Ayarlar.SilahKontrol then return end
    local ped = PlayerPedId()
    for _, silah in ipairs(Fortify.Ayarlar.YasakliSilahlar) do
        local silahHash = GetHashKey(silah)
        if HasPedGotWeapon(ped, silahHash, false) then
            RemoveWeaponFromPed(ped, silahHash)
            TespitRaporla("Illegal Weapon", silah, false)
        end
    end
end

local function AracTespit()
    if not Fortify.Ayarlar.AracKontrol then return end
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local arac = GetVehiclePedIsIn(ped, false)
        if GetPedInVehicleSeat(arac, -1) == ped then
            local aracModeli = GetEntityModel(arac)
            for _, yasakliArac in ipairs(Fortify.Ayarlar.YasakliAraclar) do
                if aracModeli == GetHashKey(yasakliArac) then
                    TaskLeaveVehicle(ped, arac, 0)
                    Wait(1000)
                    DeleteVehicle(arac)
                    TespitRaporla("Illegal Vehicle", yasakliArac, false)
                    break
                end
            end
        end
    end
end

local function AracModifikasyonTespit()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local arac = GetVehiclePedIsIn(ped, false)
        if GetPedInVehicleSeat(arac, -1) == ped then
            if IsToggleModOn(arac, 18) then
                ToggleVehicleMod(arac, 18, false)
                TespitRaporla("Vehicle God Mode", "Vehicle invincibility enabled", true)
            end
            if GetVehicleEnginePowerMultiplier(arac) > 2.5 then
                SetVehicleEnginePowerMultiplier(arac, 1.0)
                TespitRaporla("Engine Power Hack", "Multiplier: " .. tostring(GetVehicleEnginePowerMultiplier(arac)), false)
            end
        end
    end
end

local function MenuTespit()
    if not Fortify.Ayarlar.MenuKontrol then return end
    local menuTespit = false
    for _, bellek in ipairs(Fortify.Ayarlar.MenuModlari) do
        if GetResourceState("menu_" .. tostring(bellek)) == "started" then
            menuTespit = true
            break
        end
    end
end

local function RagdollTespit()
    local ped = PlayerPedId()
    local zorlamaRagdoll = GetPedConfigFlag(ped, 184, true)
    if not zorlamaRagdoll then return end
end

CreateThread(function()
    while true do
        Wait(Fortify.Ayarlar.KontrolAraligi)
        GodModeTespit()
        GorünmezlikTespit()
        SuperZiplamaTespit()
        NoclipTespit()
        SilahTespit()
        AracTespit()
        AracModifikasyonTespit()
        MenuTespit()
    end
end)

CreateThread(function()
    while true do
        Wait(Fortify.Ayarlar.HizKontrolAraligi)
        HizTespit()
        TeleportTespit()
    end
end)

print("^2[Fortify] Detection module loaded.^7")
