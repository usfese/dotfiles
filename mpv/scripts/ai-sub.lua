local mp = require("mp")
local utils = require("mp.utils")

-- 获取当前视频对应的 srt 绝对路径
local function get_srt_path()
	local path = mp.get_property("path")
	if not path then
		return nil
	end
	local base_path = path:gsub("%.%w+$", "")
	return base_path .. ".srt"
end

local function toggle_ai_sub()
	local path = mp.get_property("path")
	if not path or path:match("^http") then
		mp.osd_message("仅支持本地视频文件")
		return
	end

	local srt_path = get_srt_path()

	-- 检查本地是否已有生成的字幕
	local f = io.open(srt_path, "r")
	if f then
		f:close()
		-- 如果已有字幕，则切换字幕显示状态（开/关）
		mp.commandv("sub-reload")
		mp.command("cycle sub-visibility")
		local vis = mp.get_property("sub-visibility")
		if vis == "yes" then
			mp.osd_message("AI 字幕：开")
		else
			mp.osd_message("AI 字幕：关")
		end
	else
		-- 如果没有字幕，启动后台 Python 脚本生成
		mp.osd_message("正在使用 fast-whisper 生成 AI 字幕，请稍候...")

		-- 【修复路径获取】安全地获取当前 scripts 文件夹路径
		local scripts_dir = mp.find_config_file("scripts")
		if not scripts_dir then
			mp.osd_message("无法找到 mpv 配置目录")
			return
		end
		local py_script = utils.join_path(scripts_dir, "fast_whisper_sub.py")

		-- 异步调用 Python，防止 mpv 播放器卡死
		mp.command_native_async({
			name = "subprocess",
			args = { "python", py_script, path },
			-- 加上下面这行，强行注入 Arch 的 CUDA 路径
			env = { "LD_LIBRARY_PATH=/opt/cuda/lib64:/opt/cuda/targets/x86_64-linux/lib" },
			capture_stdout = true,
			capture_stderr = true,
		}, function(success, result, error)
			if result and result.status == 0 then
				mp.osd_message("AI 字幕生成成功！已自动加载")
				mp.commandv("sub-add", srt_path)
			else
				mp.osd_message("AI 字幕生成失败，请检查控制台")
				if result then
					print("Whisper Error: " .. (result.stderr or "未知错误"))
				end
			end
		end)
	end
end

-- 绑定 F7 按键
mp.add_forced_key_binding("F7", "toggle-ai-sub", toggle_ai_sub)
