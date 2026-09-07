local mp = require("mp")

local function show(text)
	mp.osd_message(text, 2)
end

mp.register_event("file-loaded", function()
	local profile = mp.get_property("profile") or "unknown"

	if profile == "anime-normal" then
		show("🎞 Anime Normal Mode")
	elseif profile == "anime-upscale" then
		show("🔥 Anime Upscale Mode")
	elseif profile == "cinema" then
		show("🎬 Cinema Mode")
	else
		show("🎮 Default Mode")
	end
end)
