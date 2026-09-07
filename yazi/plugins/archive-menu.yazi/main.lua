--- @since 26.5.6
-- Archive operations menu plugin for Yazi
-- 归档操作菜单插件

local is_windows = ya.target_family() == "windows"

-- 获取选中或悬停的文件
local get_files = ya.sync(function()
	local tab = cx.active
	local paths = {}
	for _, f in pairs(tab.selected) do
		paths[#paths + 1] = tostring(f.url)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths, tostring(tab.current.cwd)
end)

-- 检查命令是否可用
local function is_cmd_available(cmd)
	local check = is_windows 
		and string.format("where %s >nul 2>&1", cmd)
		or string.format("command -v %s >/dev/null 2>&1", cmd)
	return os.execute(check)
end

-- 查找第一个可用的命令
local function find_cmd(cmds)
	for _, cmd in ipairs(cmds) do
		if is_cmd_available(cmd) then
			return cmd
		end
	end
	return nil
end

-- 通知函数
local function notify(content, level)
	ya.notify {
		title = "Archive",
		content = content,
		level = level or "info",
		timeout = 4,
	}
end

-- 主菜单
local function show_main_menu()
	return ya.which {
		cands = {
			{ on = "c", desc = "压缩（Compress）" },
			{ on = "x", desc = "解压到当前目录（Extract here）" },
			{ on = "s", desc = "智能解压（Smart extract）" },
			{ on = "e", desc = "解压到...（Extract to...）" },
		},
	}
end

-- 压缩格式选择菜单
local function show_format_menu()
	return ya.which {
		cands = {
			{ on = "z", desc = "zip" },
			{ on = "7", desc = "7z" },
			{ on = "r", desc = "rar" },
			{ on = "g", desc = "tar.gz" },
			{ on = "x", desc = "tar.xz" },
			{ on = "b", desc = "tar.bz2" },
			{ on = "Z", desc = "tar.zst" },
			{ on = "j", desc = "jar (zip)" },
		},
	}
end

-- 获取文件的相对路径（用于压缩）
local function get_relative_paths(files, cwd)
	local cwd_url = Url(cwd)
	local relative = {}
	for _, file in ipairs(files) do
		local file_url = Url(file)
		local rel = file_url:strip_prefix(cwd_url)
		if rel then
			table.insert(relative, tostring(rel))
		else
			-- 如果无法获取相对路径，使用文件名
			table.insert(relative, file_url.name)
		end
	end
	return relative
end

-- 压缩功能
local function compress_files(files, cwd)
	local format_choice = show_format_menu()
	if not format_choice then return end
	
	local formats = { "zip", "7z", "rar", "tar.gz", "tar.xz", "tar.bz2", "tar.zst", "zip" }
	local ext = formats[format_choice]
	
	local name, event = ya.input {
		title = string.format("压缩为 .%s:", ext),
		pos = { "top-center", y = 3, w = 50 },
	}
	if event ~= 1 or name == "" then return end
	
	local output = string.format("%s.%s", name, ext)
	local output_path = string.format("%s/%s", cwd, output)
	local cmd, args
	
	-- 获取相对路径
	local rel_files = get_relative_paths(files, cwd)
	
	-- 根据格式选择命令
	if ext == "zip" then
		cmd = find_cmd({ "7z", "7zz", "7za", "zip" })
		if cmd and cmd:match("^7z") then
			args = { "a", "-tzip", output }
			for _, f in ipairs(rel_files) do
				table.insert(args, f)
			end
		elseif cmd == "zip" then
			args = { "-r", output }
			for _, f in ipairs(rel_files) do
				table.insert(args, f)
			end
		end
	elseif ext == "7z" then
		cmd = find_cmd({ "7z", "7zz", "7za" })
		if cmd then
			args = { "a", output }
			for _, f in ipairs(rel_files) do
				table.insert(args, f)
			end
		end
	elseif ext == "rar" then
		cmd = find_cmd({ "rar" })
		if cmd then
			args = { "a", output }
			for _, f in ipairs(rel_files) do
				table.insert(args, f)
			end
		end
	elseif ext:match("^tar%.") then
		cmd = find_cmd({ "tar" })
		if cmd then
			-- tar 格式统一处理
			local comp_flags = {
				["tar.gz"] = "z",
				["tar.xz"] = "J",
				["tar.bz2"] = "j",
			}
			local flag = comp_flags[ext]
			if ext == "tar.zst" then
				args = { "-cf", output, "--zstd" }
			else
				args = { "-c" .. (flag or "") .. "f", output }
			end
			for _, f in ipairs(rel_files) do
				table.insert(args, f)
			end
		end
	end
	
	if not cmd then
		notify("未找到压缩工具：" .. ext, "error")
		return
	end
	
	-- 执行压缩
	local child, err = Command(cmd):arg(args):cwd(cwd):spawn()
	if not child then
		notify("执行失败: " .. tostring(err), "error")
		return
	end
	
	local status = child:wait()
	
	if status and status.success then
		notify(string.format("已创建：%s", output))
		ya.emit("refresh", {})
	else
		notify("压缩失败", "error")
	end
end

-- 根据工具和文件构建解压命令，password 为 nil 时不带密码
local function build_extract_args(cmd, file, dest, password)
	if cmd == "tar" then
		-- tar 不支持加密，password 参数忽略
		local args = { "-xf", file }
		if dest then
			table.insert(args, "-C")
			table.insert(args, dest)
		end
		return args
	elseif cmd:match("^7z") then
		local args = { "x", file, "-o" .. (dest or "."), "-y" }
		if password then
			table.insert(args, "-p" .. password)
		end
		return args
	elseif cmd == "unzip" then
		local args = { "-q", file, "-d", dest }
		if password then
			-- unzip 的 -P 必须紧接密码，且放在文件名之前
			table.insert(args, 1, password)
			table.insert(args, 1, "-P")
		end
		return args
	elseif cmd == "unrar" then
		local args = { "x", "-y" }
		if password then
			table.insert(args, "-p" .. password)
		end
		table.insert(args, file)
		table.insert(args, dest .. "/")
		return args
	end
	return {}
end

-- 执行一次解压，返回是否成功
local function run_extract(cmd, args, cwd)
	local child, err = Command(cmd):arg(args):cwd(cwd):spawn()
	if not child then
		return false, "spawn failed: " .. tostring(err)
	end
	local status = child:wait()
	return status and status.success, nil
end

-- 解压功能（方案 A：失败后自动弹密码框重试）
local function extract_files(files, cwd, mode)
	for _, file in ipairs(files) do
		local output_dir = nil

		if mode == "input" then
			local dir, event = ya.input {
				title = "解压到目录:",
				pos = { "top-center", y = 3, w = 50 },
				value = cwd,
			}
			if event ~= 1 or dir == "" then return end
			output_dir = dir
		elseif mode == "smart" then
			-- 智能解压：创建与压缩包同名的文件夹
			local file_url = Url(file)
			local basename = file_url.stem or file_url.name
			output_dir = string.format("%s/%s", cwd, basename)
		end

		local dest = output_dir or cwd

		-- 选择工具
		local cmd
		if is_cmd_available("tar") and file:match("%.tar") then
			cmd = "tar"
		elseif find_cmd({ "7z", "7zz", "7za" }) then
			cmd = find_cmd({ "7z", "7zz", "7za" })
		elseif is_cmd_available("unzip") and file:match("%.zip$") then
			cmd = "unzip"
		elseif is_cmd_available("unrar") and file:match("%.rar$") then
			cmd = "unrar"
		else
			notify("未找到解压工具", "error")
			return
		end

		-- 如果需要创建目录（智能解压模式）
		if output_dir and mode == "smart" then
			local mkdir_status = Command("mkdir"):arg("-p"):arg(output_dir):status()
			if not mkdir_status or not mkdir_status.success then
				notify("无法创建目录: " .. output_dir, "error")
				return
			end
		end

		-- 第一次尝试：无密码
		local ok = run_extract(cmd, build_extract_args(cmd, file, dest, nil), cwd)

		if not ok then
			-- tar 不支持加密，直接报失败
			if cmd == "tar" then
				notify("解压失败", "error")
				return
			end

			-- 弹出密码输入框
			local password, event = ya.input {
				title = "输入密码:",
				pos = { "top-center", y = 3, w = 40 },
				obscure = true,
			}
			-- 用户取消则放弃
			if event ~= 1 then return end

			-- 第二次尝试：带密码
			ok = run_extract(cmd, build_extract_args(cmd, file, dest, password), cwd)

			if not ok then
				notify("解压失败（密码错误或文件损坏）", "error")
				return
			end
		end

		local file_url = Url(file)
		notify("已解压: " .. (file_url.name or ""))
		ya.emit("refresh", {})
	end
end

return {
	entry = function()
		ya.emit("escape", { visual = true })
		
		local files, cwd = get_files()
		if #files == 0 then
			notify("未选中文件", "warn")
			return
		end
		
		local choice = show_main_menu()
		if not choice then return end
		
		if choice == 1 then
			-- 压缩
			compress_files(files, cwd)
		elseif choice == 2 then
			-- 解压到当前目录
			extract_files(files, cwd, "here")
		elseif choice == 3 then
			-- 智能解压
			extract_files(files, cwd, "smart")
		elseif choice == 4 then
			-- 解压到指定目录
			extract_files(files, cwd, "input")
		end
	end,
}
