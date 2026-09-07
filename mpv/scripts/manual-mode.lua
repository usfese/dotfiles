local mp = require("mp")

local function set_mode(mode)
	if mode == "anime" then
		mp.commandv("apply-profile", "anime-normal")
		mp.osd_message("🎞 Manual: Anime Normal", 2)
	elseif mode == "upscale" then
		mp.commandv("apply-profile", "anime-upscale")
		mp.osd_message("🔥 Manual: Anime Upscale", 2)
	elseif mode == "cinema" then
		mp.commandv("apply-profile", "cinema")
		mp.osd_message("🎬 Manual: Cinema Mode", 2)
	elseif mode == "auto" then
		mp.osd_message("🤖 Auto Mode (Lua)", 2)
		-- 不强制 profile，让 auto-profile.lua 接管
	end
end

-- =====================
-- 🎮 按键绑定
-- =====================

mp.add_key_binding("F1", "mode-anime", function()
	set_mode("anime")
end)

mp.add_key_binding("F2", "mode-upscale", function()
	set_mode("upscale")
end)

mp.add_key_binding("F3", "mode-cinema", function()
	set_mode("cinema")
end)

mp.add_key_binding("F4", "mode-auto", function()
	set_mode("auto")
end)
mp.set_property("user-data/manual-mode", "true")
