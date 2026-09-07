local manual_override = false
if mp.get_property("user-data/manual-mode") == "true" then
	return
end
local mp = require("mp")

local function set(p)
	mp.commandv("apply-profile", p)
end

mp.register_event("file-loaded", function()
	local codec = (mp.get_property("video-codec") or ""):lower()
	local width = mp.get_property_number("width") or 0
	local height = mp.get_property_number("height") or 0
	local path = (mp.get_property("path") or ""):lower()
	local fps = mp.get_property_number("estimated-vf-fps") or 0

	-- ======================
	-- 🎬 Cinema（优先级最高）
	-- ======================
	if codec:find("hevc") or codec:find("h265") or codec:find("av1") then
		set("cinema")
		return
	end

	if height >= 1080 and fps <= 30 and not path:find("anime") then
		set("cinema")
		return
	end

	-- ======================
	-- 🎞 Anime Upscale（老番）
	-- ======================
	if height <= 960 or width <= 1280 then
		set("anime-upscale")
		return
	end

	-- ======================
	-- 🟢 Anime Normal（默认番剧）
	-- ======================
	set("anime-normal")
end)
