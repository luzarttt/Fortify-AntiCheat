local mevcutZaman = GetGameTimer()

function ZamanDamgasi()
    return os.date("%d/%m/%Y %H:%M:%S")
end

function OyuncuAdiAl(kaynak)
    return GetPlayerName(kaynak) or "Unknown"
end

function OyuncuLisansAl(kaynak)
    for i = 0, GetNumPlayerIdentifiers(kaynak) - 1 do
        local kimlik = GetPlayerIdentifier(kaynak, i)
        if string.sub(kimlik, 1, 8) == "license:" then
            return kimlik
        end
    end
    return "license:unknown"
end

function OyuncuDiscordAl(kaynak)
    for i = 0, GetNumPlayerIdentifiers(kaynak) - 1 do
        local kimlik = GetPlayerIdentifier(kaynak, i)
        if string.sub(kimlik, 1, 8) == "discord:" then
            return kimlik
        end
    end
    return "discord:unknown"
end

function OyuncuSteamAl(kaynak)
    for i = 0, GetNumPlayerIdentifiers(kaynak) - 1 do
        local kimlik = GetPlayerIdentifier(kaynak, i)
        if string.sub(kimlik, 1, 6) == "steam:" then
            return kimlik
        end
    end
    return "steam:unknown"
end

function OyuncuIPAl(kaynak)
    for i = 0, GetNumPlayerIdentifiers(kaynak) - 1 do
        local kimlik = GetPlayerIdentifier(kaynak, i)
        if string.sub(kimlik, 1, 3) == "ip:" then
            return kimlik
        end
    end
    return "ip:unknown"
end

function TumKimlikleriAl(kaynak)
    local kimlikler = {}
    kimlikler.lisans = OyuncuLisansAl(kaynak)
    kimlikler.discord = OyuncuDiscordAl(kaynak)
    kimlikler.steam = OyuncuSteamAl(kaynak)
    kimlikler.ip = OyuncuIPAl(kaynak)
    return kimlikler
end

function YetkiKontrol(kaynak)
    local oyuncuAdi = OyuncuAdiAl(kaynak)
    for _, rank in ipairs(Fortify.Ayarlar.YetkiliRanklar) do
        if IsPlayerAceAllowed(kaynak, "fortify." .. rank) then
            return true
        end
    end
    return false
end

function RenkHexCevir(renk)
    return string.format("%06X", renk)
end

function MesafeHesapla(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dz = pos1.z - pos2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end
