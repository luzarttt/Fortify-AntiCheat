local yasakliOyuncular = {}

local function BanDosyasiYukle()
    local dosya = LoadResourceFile(GetCurrentResourceName(), Fortify.Ayarlar.BanDosyasi .. ".json")
    if dosya then
        local basari, veri = pcall(json.decode, dosya)
        if basari and veri then
            yasakliOyuncular = veri
            print("^2[Fortify] " .. #yasakliOyuncular .. " banned player(s) loaded.^7")
        end
    else
        yasakliOyuncular = {}
        print("^3[Fortify] Ban file not found, creating new one.^7")
    end
end

local function BanDosyasiKaydet()
    local basari, veri = pcall(json.encode, yasakliOyuncular)
    if basari then
        SaveResourceFile(GetCurrentResourceName(), Fortify.Ayarlar.BanDosyasi .. ".json", veri, -1)
    end
end

function OyuncuYasakliMi(kaynak)
    local kimlikler = TumKimlikleriAl(kaynak)
    for _, ban in ipairs(yasakliOyuncular) do
        if ban.lisans == kimlikler.lisans or
           ban.steam == kimlikler.steam or
           ban.ip == kimlikler.ip then
            return true, ban
        end
    end
    return false, nil
end

function OyuncuBanla(kaynak, sebep, banlayanYetkili, sure)
    local kimlikler = TumKimlikleriAl(kaynak)
    local banBilgisi = {
        ad = OyuncuAdiAl(kaynak),
        lisans = kimlikler.lisans,
        steam = kimlikler.steam,
        discord = kimlikler.discord,
        ip = kimlikler.ip,
        sebep = sebep,
        banlayan = banlayanYetkili or "Fortify Auto-Ban",
        tarih = ZamanDamgasi(),
        sure = sure or "Permanent"
    }
    table.insert(yasakliOyuncular, banBilgisi)
    BanDosyasiKaydet()
    DiscordBanLog(kaynak, sebep, banlayanYetkili)
    DropPlayer(kaynak, "[Fortify Anti-Cheat] You have been banned.\nReason: " .. sebep .. "\nBanned By: " .. (banlayanYetkili or "Fortify Auto-Ban") .. "\nDuration: " .. (sure or "Permanent"))
    print("^1[Fortify] Player banned: " .. OyuncuAdiAl(kaynak) .. " | Reason: " .. sebep .. "^7")
end

function LisansBanKaldir(lisans)
    local bulundu = false
    for i = #yasakliOyuncular, 1, -1 do
        if yasakliOyuncular[i].lisans == lisans then
            table.remove(yasakliOyuncular, i)
            bulundu = true
        end
    end
    if bulundu then
        BanDosyasiKaydet()
        return true
    end
    return false
end

AddEventHandler("playerConnecting", function(ad, setKickSebep, deferrals)
    local kaynak = source
    deferrals.defer()
    Wait(0)
    deferrals.update("[Fortify] Checking player records...")
    local yasakli, banBilgisi = OyuncuYasakliMi(kaynak)
    if yasakli then
        deferrals.done("[Fortify Anti-Cheat] You are banned from this server.\nReason: " .. banBilgisi.sebep .. "\nBanned By: " .. banBilgisi.banlayan .. "\nDate: " .. banBilgisi.tarih)
    else
        deferrals.done()
        DiscordBaglantiLog(kaynak)
    end
end)

AddEventHandler("playerDropped", function(sebep)
    local kaynak = source
    DiscordAyrilmaLog(kaynak, sebep)
end)

RegisterCommand(Fortify.Ayarlar.BanKomut, function(kaynak, args, hammadde)
    if kaynak ~= 0 and not YetkiKontrol(kaynak) then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "You don't have permission to use this command."} })
        return
    end
    if not args[1] then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 255, 0}, args = {"[Fortify]", "Usage: /" .. Fortify.Ayarlar.BanKomut .. " [playerID] [reason]"} })
        return
    end
    local hedef = tonumber(args[1])
    if not hedef or not GetPlayerName(hedef) then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "Player not found."} })
        return
    end
    local sebep = table.concat(args, " ", 2) or "No reason specified"
    local banlayanAd = kaynak == 0 and "Console" or OyuncuAdiAl(kaynak)
    OyuncuBanla(hedef, sebep, banlayanAd, "Permanent")
    if kaynak ~= 0 then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {0, 255, 0}, args = {"[Fortify]", "Player " .. OyuncuAdiAl(hedef) .. " has been banned."} })
    end
end, true)

RegisterCommand(Fortify.Ayarlar.UnbanKomut, function(kaynak, args, hammadde)
    if kaynak ~= 0 and not YetkiKontrol(kaynak) then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "You don't have permission to use this command."} })
        return
    end
    if not args[1] then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 255, 0}, args = {"[Fortify]", "Usage: /" .. Fortify.Ayarlar.UnbanKomut .. " [license]"} })
        return
    end
    local lisans = args[1]
    if LisansBanKaldir(lisans) then
        print("^2[Fortify] Ban removed for license: " .. lisans .. "^7")
        if kaynak ~= 0 then
            TriggerClientEvent("chat:addMessage", kaynak, { color = {0, 255, 0}, args = {"[Fortify]", "Ban removed for: " .. lisans} })
        end
    else
        if kaynak ~= 0 then
            TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "No ban found for: " .. lisans} })
        end
    end
end, true)

RegisterCommand(Fortify.Ayarlar.KickKomut, function(kaynak, args, hammadde)
    if kaynak ~= 0 and not YetkiKontrol(kaynak) then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "You don't have permission to use this command."} })
        return
    end
    if not args[1] then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 255, 0}, args = {"[Fortify]", "Usage: /" .. Fortify.Ayarlar.KickKomut .. " [playerID] [reason]"} })
        return
    end
    local hedef = tonumber(args[1])
    if not hedef or not GetPlayerName(hedef) then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "Player not found."} })
        return
    end
    local sebep = table.concat(args, " ", 2) or "No reason specified"
    local kicanAd = kaynak == 0 and "Console" or OyuncuAdiAl(kaynak)
    DiscordKickLog(hedef, sebep, kicanAd)
    DropPlayer(hedef, "[Fortify Anti-Cheat] You have been kicked.\nReason: " .. sebep)
    if kaynak ~= 0 then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {0, 255, 0}, args = {"[Fortify]", "Player kicked successfully."} })
    end
end, true)

RegisterCommand(Fortify.Ayarlar.UyariKomut, function(kaynak, args, hammadde)
    if kaynak ~= 0 and not YetkiKontrol(kaynak) then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "You don't have permission to use this command."} })
        return
    end
    if not args[1] then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 255, 0}, args = {"[Fortify]", "Usage: /" .. Fortify.Ayarlar.UyariKomut .. " [playerID] [reason]"} })
        return
    end
    local hedef = tonumber(args[1])
    if not hedef or not GetPlayerName(hedef) then
        TriggerClientEvent("chat:addMessage", kaynak, { color = {255, 0, 0}, args = {"[Fortify]", "Player not found."} })
        return
    end
    local sebep = table.concat(args, " ", 2) or "No reason specified"
    TriggerEvent("fortify:uyariEkle", hedef, sebep)
end, true)

BanDosyasiYukle()
print("^2[Fortify] Ban system initialized.^7")
