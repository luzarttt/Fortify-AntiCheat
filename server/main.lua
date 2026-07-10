local oyuncuUyarilari = {}
local oyuncuVerileri = {}

local function UyariEkle(kaynak, sebep)
    if not oyuncuUyarilari[kaynak] then
        oyuncuUyarilari[kaynak] = 0
    end
    oyuncuUyarilari[kaynak] = oyuncuUyarilari[kaynak] + 1
    DiscordUyariLog(kaynak, sebep, oyuncuUyarilari[kaynak])
    TriggerClientEvent("fortify:uyariGoster", kaynak, sebep, oyuncuUyarilari[kaynak])
    print("^3[Fortify] Warning issued to " .. OyuncuAdiAl(kaynak) .. " (" .. oyuncuUyarilari[kaynak] .. "/" .. Fortify.Ayarlar.MaxUyari .. "): " .. sebep .. "^7")
    if oyuncuUyarilari[kaynak] >= Fortify.Ayarlar.MaxUyari then
        OyuncuBanla(kaynak, "Reached maximum warnings: " .. sebep, "Fortify Auto-Ban", "Permanent")
    end
end

AddEventHandler("fortify:uyariEkle", function(kaynak, sebep)
    UyariEkle(kaynak, sebep)
end)

AddEventHandler("playerDropped", function()
    local kaynak = source
    oyuncuUyarilari[kaynak] = nil
    oyuncuVerileri[kaynak] = nil
end)

RegisterNetEvent("fortify:tespitBildir")
AddEventHandler("fortify:tespitBildir", function(tespitTuru, detay)
    local kaynak = source
    if not kaynak or kaynak == 0 then return end
    DiscordTespitLog(kaynak, tespitTuru, detay)
    print("^1[Fortify] Detection: " .. OyuncuAdiAl(kaynak) .. " | " .. tespitTuru .. " | " .. tostring(detay) .. "^7")
    UyariEkle(kaynak, tespitTuru .. ": " .. tostring(detay))
end)

RegisterNetEvent("fortify:otoBanla")
AddEventHandler("fortify:otoBanla", function(sebep)
    local kaynak = source
    if not kaynak or kaynak == 0 then return end
    OyuncuBanla(kaynak, sebep, "Fortify Auto-Ban", "Permanent")
end)

RegisterNetEvent("fortify:patlayiciTespit")
AddEventHandler("fortify:patlayiciTespit", function(patlayiciTuru, konum)
    local kaynak = source
    if not kaynak or kaynak == 0 then return end
    DiscordPatlayiciLog(kaynak, patlayiciTuru, konum)
    UyariEkle(kaynak, "Illegal Explosion Type: " .. tostring(patlayiciTuru))
end)

RegisterNetEvent("fortify:konumGuncelle")
AddEventHandler("fortify:konumGuncelle", function(konum)
    local kaynak = source
    if not kaynak or kaynak == 0 then return end
    if not oyuncuVerileri[kaynak] then
        oyuncuVerileri[kaynak] = {}
    end
    oyuncuVerileri[kaynak].sonKonum = konum
    oyuncuVerileri[kaynak].sonGuncelleme = GetGameTimer()
end)

AddEventHandler("explosionEvent", function(kaynak, ev)
    if not kaynak or kaynak == 0 then return end
    if not Fortify.Ayarlar.ExplosionKontrol then return end
    local yasakliTurler = {3, 4, 5, 9, 11, 14, 15, 16, 20, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 37, 38, 39, 40, 41, 42, 43, 44, 45, 47, 48, 49, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62}
    for _, tur in ipairs(yasakliTurler) do
        if ev.explosionType == tur then
            DiscordPatlayiciLog(kaynak, ev.explosionType, ev.posX and { x = ev.posX, y = ev.posY, z = ev.posZ } or nil)
            UyariEkle(kaynak, "Illegal Explosion (Type: " .. tostring(ev.explosionType) .. ")")
            return false
        end
    end
end)

RegisterCommand("fortifyinfo", function(kaynak, args)
    if kaynak ~= 0 and not YetkiKontrol(kaynak) then return end
    local hedef = args[1] and tonumber(args[1])
    if not hedef or not GetPlayerName(hedef) then
        if kaynak ~= 0 then
            TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "Player not found."} })
        end
        return
    end
    local kimlikler = TumKimlikleriAl(hedef)
    local uyariSayisi = oyuncuUyarilari[hedef] or 0
    local bilgi = string.format(
        "^3[Fortify] Player Info^7\nName: %s\nID: %s\nWarnings: %s/%s\nLicense: %s\nSteam: %s\nDiscord: %s\nIP: %s",
        OyuncuAdiAl(hedef), tostring(hedef), tostring(uyariSayisi), tostring(Fortify.Ayarlar.MaxUyari),
        kimlikler.lisans, kimlikler.steam, kimlikler.discord, kimlikler.ip
    )
    if kaynak == 0 then
        print(bilgi)
    else
        TriggerClientEvent("chat:addMessage", kaynak, { color = {0, 255, 255}, args = {"[Fortify]", bilgi} })
    end
end, true)

RegisterCommand("fortifyonline", function(kaynak, args)
    if kaynak ~= 0 and not YetkiKontrol(kaynak) then return end
    local oyuncular = GetPlayers()
    local mesaj = "^2[Fortify] Online Players (" .. #oyuncular .. "):^7\n"
    for _, id in ipairs(oyuncular) do
        mesaj = mesaj .. string.format("  [%s] %s\n", id, OyuncuAdiAl(tonumber(id)))
    end
    if kaynak == 0 then
        print(mesaj)
    else
        TriggerClientEvent("chat:addMessage", kaynak, { color = {0, 255, 0}, args = {"[Fortify]", mesaj} })
    end
end, true)

RegisterNetEvent("fortify:spectateIzin")
AddEventHandler("fortify:spectateIzin", function(hedefId)
    local kaynak = source
    if not YetkiKontrol(kaynak) then
        TriggerClientEvent("fortify:spectateReddedildi", kaynak)
        return
    end
    if not GetPlayerName(hedefId) then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "Player not found."} })
        return
    end
    DiscordSpectateLog(hedefId, OyuncuAdiAl(kaynak))
    TriggerClientEvent("fortify:spectateIzinVerildi", kaynak, hedefId)
end)

RegisterNetEvent("fortify:speklateBildir")
AddEventHandler("fortify:speklateBildir", function(hedefId)
    local kaynak = source
    DiscordSpectateLog(hedefId, OyuncuAdiAl(kaynak))
end)

AddEventHandler("onResourceStart", function(kaynakAdi)
    if kaynakAdi == GetCurrentResourceName() then
        print("^2[Fortify] Anti-Cheat System v2.0 - Initialized^7")
        print("^2[Fortify] All protection modules active.^7")
    end
end)
