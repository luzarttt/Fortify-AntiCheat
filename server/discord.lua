local bekleyenLoglar = {}
local logGonderiliyor = false

local function LogGonder(webhook, baslik, aciklama, renk, alanlar)
    if not webhook or webhook == "" or webhook == "YOUR_WEBHOOK_URL_HERE" then return end

    local embed = {
        {
            title = baslik,
            description = aciklama,
            color = renk or Fortify.Ayarlar.LogRengi,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer = {
                text = Fortify.Ayarlar.SunucuAdi .. " • Fortify Anti-Cheat"
            },
            fields = alanlar or {}
        }
    }

    PerformHttpRequest(webhook, function(kod, metin, basliklar)
        if kod ~= 204 and kod ~= 200 then
            print("^1[Fortify] Discord log gönderilemedi. Kod: " .. tostring(kod) .. "^7")
        end
    end, "POST", json.encode({ embeds = embed }), { ["Content-Type"] = "application/json" })
end

function DiscordBanLog(kaynak, sebep, banlayanYetkili)
    local kimlikler = TumKimlikleriAl(kaynak)
    local alanlar = {
        { name = "🎮 Player", value = OyuncuAdiAl(kaynak), inline = true },
        { name = "🆔 Server ID", value = tostring(kaynak), inline = true },
        { name = "⚠️ Reason", value = sebep, inline = false },
        { name = "🔑 License", value = kimlikler.lisans, inline = false },
        { name = "🎮 Steam", value = kimlikler.steam, inline = true },
        { name = "📱 Discord", value = kimlikler.discord, inline = true },
        { name = "🌐 IP", value = kimlikler.ip, inline = true },
        { name = "👮 Banned By", value = banlayanYetkili or "Fortify Auto-Ban", inline = true },
        { name = "📅 Date", value = ZamanDamgasi(), inline = true }
    }
    LogGonder(Fortify.Ayarlar.BanWebhook, "🔨 Player Banned", "", 16711680, alanlar)
end

function DiscordTespitLog(kaynak, tespitTuru, detay)
    local kimlikler = TumKimlikleriAl(kaynak)
    local konum = nil
    if IsDuplicityVersion then
        konum = "N/A (Server)"
    end
    local alanlar = {
        { name = "🎮 Player", value = OyuncuAdiAl(kaynak), inline = true },
        { name = "🆔 Server ID", value = tostring(kaynak), inline = true },
        { name = "🚨 Detection", value = tespitTuru, inline = false },
        { name = "📋 Details", value = detay or "N/A", inline = false },
        { name = "🔑 License", value = kimlikler.lisans, inline = false },
        { name = "🎮 Steam", value = kimlikler.steam, inline = true },
        { name = "📱 Discord", value = kimlikler.discord, inline = true },
        { name = "📅 Date", value = ZamanDamgasi(), inline = true }
    }
    LogGonder(Fortify.Ayarlar.DiscordWebhook, "⚠️ Cheat Detection", "", 16744272, alanlar)
end

function DiscordUyariLog(kaynak, sebep, uyariSayisi)
    local kimlikler = TumKimlikleriAl(kaynak)
    local alanlar = {
        { name = "🎮 Player", value = OyuncuAdiAl(kaynak), inline = true },
        { name = "🆔 Server ID", value = tostring(kaynak), inline = true },
        { name = "⚠️ Warning", value = sebep, inline = false },
        { name = "🔢 Warning Count", value = tostring(uyariSayisi) .. "/" .. tostring(Fortify.Ayarlar.MaxUyari), inline = true },
        { name = "🔑 License", value = kimlikler.lisans, inline = false },
        { name = "📅 Date", value = ZamanDamgasi(), inline = true }
    }
    LogGonder(Fortify.Ayarlar.UyariWebhook, "⚠️ Player Warning", "", 16776960, alanlar)
end

function DiscordKickLog(kaynak, sebep, kicanYetkili)
    local kimlikler = TumKimlikleriAl(kaynak)
    local alanlar = {
        { name = "🎮 Player", value = OyuncuAdiAl(kaynak), inline = true },
        { name = "🆔 Server ID", value = tostring(kaynak), inline = true },
        { name = "⚠️ Reason", value = sebep, inline = false },
        { name = "🔑 License", value = kimlikler.lisans, inline = false },
        { name = "👮 Kicked By", value = kicanYetkili or "Fortify Auto-Kick", inline = true },
        { name = "📅 Date", value = ZamanDamgasi(), inline = true }
    }
    LogGonder(Fortify.Ayarlar.DiscordWebhook, "👢 Player Kicked", "", 8421504, alanlar)
end

function DiscordBaglantiLog(kaynak)
    local kimlikler = TumKimlikleriAl(kaynak)
    local alanlar = {
        { name = "🎮 Player", value = OyuncuAdiAl(kaynak), inline = true },
        { name = "🆔 Server ID", value = tostring(kaynak), inline = true },
        { name = "🔑 License", value = kimlikler.lisans, inline = false },
        { name = "🎮 Steam", value = kimlikler.steam, inline = true },
        { name = "📱 Discord", value = kimlikler.discord, inline = true },
        { name = "🌐 IP", value = kimlikler.ip, inline = true },
        { name = "📅 Date", value = ZamanDamgasi(), inline = true }
    }
    LogGonder(Fortify.Ayarlar.DiscordWebhook, "✅ Player Connected", "", 65280, alanlar)
end

function DiscordAyrilmaLog(kaynak, sebep)
    local kimlikler = TumKimlikleriAl(kaynak)
    local alanlar = {
        { name = "🎮 Player", value = OyuncuAdiAl(kaynak), inline = true },
        { name = "🆔 Server ID", value = tostring(kaynak), inline = true },
        { name = "📋 Reason", value = sebep or "Unknown", inline = false },
        { name = "🔑 License", value = kimlikler.lisans, inline = false },
        { name = "📅 Date", value = ZamanDamgasi(), inline = true }
    }
    LogGonder(Fortify.Ayarlar.DiscordWebhook, "❌ Player Disconnected", "", 16711680, alanlar)
end

function DiscordSpectateLog(hedefKaynak, izleyenYetkili)
    local hedefKimlik = TumKimlikleriAl(hedefKaynak)
    local alanlar = {
        { name = "🎯 Target Player", value = OyuncuAdiAl(hedefKaynak), inline = true },
        { name = "🆔 Target ID", value = tostring(hedefKaynak), inline = true },
        { name = "👮 Spectating Admin", value = izleyenYetkili, inline = false },
        { name = "🔑 Target License", value = hedefKimlik.lisans, inline = false },
        { name = "📅 Date", value = ZamanDamgasi(), inline = true }
    }
    LogGonder(Fortify.Ayarlar.SpectateWebhook, "👁️ Admin Spectating", "", 3447003, alanlar)
end

function DiscordPatlayiciLog(kaynak, patlayiciTuru, konum)
    local kimlikler = TumKimlikleriAl(kaynak)
    local konumStr = konum and string.format("X: %.1f, Y: %.1f, Z: %.1f", konum.x, konum.y, konum.z) or "N/A"
    local alanlar = {
        { name = "🎮 Player", value = OyuncuAdiAl(kaynak), inline = true },
        { name = "🆔 Server ID", value = tostring(kaynak), inline = true },
        { name = "💥 Explosion Type", value = tostring(patlayiciTuru), inline = true },
        { name = "📍 Location", value = konumStr, inline = false },
        { name = "🔑 License", value = kimlikler.lisans, inline = false },
        { name = "📅 Date", value = ZamanDamgasi(), inline = true }
    }
    LogGonder(Fortify.Ayarlar.DiscordWebhook, "💥 Explosion Detected", "", 16711680, alanlar)
end
