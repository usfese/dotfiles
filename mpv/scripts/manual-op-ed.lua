local mp = require("mp")

-- =========================
-- ⏭ 跳 OP
-- =========================
local function skip_op()
	local pos = mp.get_property_number("time-pos") or 0

	-- 常见 OP 在 0~90 秒
	mp.set_property("time-pos", math.min(pos + 90, pos + 120))
	mp.osd_message("⏭ Skipped OP", 2)
end

-- =========================
-- ⏭ 跳 ED
-- =========================
local function skip_ed()
	local duration = mp.get_property_number("duration") or 0
	local pos = mp.get_property_number("time-pos") or 0

	if duration > 0 then
		local target = duration - 120
		mp.set_property("time-pos", target)
		mp.osd_message("⏭ Skipped ED", 2)
	end
end

-- =========================
-- ⏩ 快进 / 回退
-- =========================
local function seek_forward()
	mp.command("seek 10")
	mp.osd_message("⏩ +10s", 1)
end

local function seek_backward()
	mp.command("seek -10")
	mp.osd_message("⏪ -10s", 1)
end

-- =========================
-- 🎮 绑定按键
-- =========================

mp.add_key_binding("Ctrl+o", "skip-op", skip_op)
mp.add_key_binding("Ctrl+e", "skip-ed", skip_ed)

mp.add_key_binding("Alt+RIGHT", "seek-fwd", seek_forward)
mp.add_key_binding("Alt+LEFT", "seek-back", seek_backward)
