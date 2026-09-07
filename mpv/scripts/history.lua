local mp = require("mp")

local history_file = os.getenv("HOME") .. "/.mpv_history"

local function read_all()
	local list = {}
	local seen = {}

	local f = io.open(history_file, "r")
	if not f then
		return list
	end

	for line in f:lines() do
		if not seen[line] then
			table.insert(list, line)
			seen[line] = true
		end
	end

	f:close()
	return list
end

local function write_all(list)
	local f = io.open(history_file, "w")
	if not f then
		return
	end

	for _, v in ipairs(list) do
		f:write(v .. "\n")
	end

	f:close()
end

mp.register_event("file-loaded", function()
	local path = mp.get_property("path")
	if not path then
		return
	end

	local list = read_all()

	-- 移除旧记录
	local new_list = { path }

	for _, v in ipairs(list) do
		if v ~= path then
			table.insert(new_list, v)
		end
	end

	write_all(new_list)
end)
