local mp = require("mp")

local save_file = os.getenv("HOME") .. "/.mpv_resume"

local function load_resume(path)
	local f = io.open(save_file, "r")
	if not f then
		return nil
	end

	for line in f:lines() do
		local p, pos = line:match("^(.-)|(.+)$")
		if p == path then
			return tonumber(pos)
		end
	end

	return nil
end

local function save_resume(path, pos)
	if not path or not pos then
		return
	end

	local lines = {}
	local found = false

	local f = io.open(save_file, "r")
	if f then
		for line in f:lines() do
			local p = line:match("^(.-)|")
			if p ~= path then
				table.insert(lines, line)
			end
		end
		f:close()
	end

	table.insert(lines, path .. "|" .. tostring(pos))

	local w = io.open(save_file, "w")
	for _, l in ipairs(lines) do
		w:write(l .. "\n")
	end
	w:close()
end

mp.register_event("file-loaded", function()
	local path = mp.get_property("path")
	local pos = load_resume(path)

	if pos and pos > 10 then
		mp.set_property("time-pos", pos)
		mp.osd_message("▶ Resumed", 2)
	end
end)

mp.register_event("shutdown", function()
	local path = mp.get_property("path")
	local pos = mp.get_property_number("time-pos")
	save_resume(path, pos)
end)
