require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})

require("full-border"):setup()

require("mime-ext.local"):setup({
	-- Expand the default filename database (lowercase), for example:
	with_files = {
		makefile = "text/makefile",
		-- ...
	},

	-- Expand the default extension database (lowercase), for example:
	with_exts = {
		mk = "text/makefile",
		-- ...
	},

	-- Empty the default filename and extension databases,
	-- use only the custom ones configured with `with_files` and `with_exts`
	custom_only = false,

	-- If the MIME type is not in both filename and extension databases,
	-- then fallback to Yazi's preset `mime.local` plugin, which uses `file(1)`
	fallback_file1 = false,
})
require("githead"):setup({
	order = {
		"__spacer__",
		"stashes",
		"__spacer__",
		"state",
		"__spacer__",
		"staged",
		"__spacer__",
		"unstaged",
		"__spacer__",
		"untracked",
		"__spacer__",
		"branch",
		"remote_branch",
		"__spacer__",
		"tag",
		"__spacer__",
		"commit",
		"__spacer__",
		"behind_ahead_remote",
		"__spacer__",
	},

	branch_borders = "{}",
	branch_prefix = "|",
	branch_color = "#7aa2f7",
	remote_branch_color = "#9ece6a",
	always_show_remote_branch = true,
	always_show_remote_repo = true,

	tag_symbol = "󰓼",
	always_show_tag = true,
	tag_color = "#bb9af7",

	commit_symbol = "",
	always_show_commit = true,
	commit_color = "#e0af68",

	staged_color = "#73daca",
	staged_symbol = "●",

	unstaged_color = "#e0af68",
	unstaged_symbol = "✗",

	untracked_color = "#f7768e",
	untracked_symbol = "?",

	state_color = "#f5c359",
	state_symbol = "󱐋",

	stashes_color = "#565f89",
	stashes_symbol = "⚑",
})

require("ffmpeg-stats"):setup({
	-- Which stats should be shown by default upon opening yazi
	duration = false,
	resolution = false,
	codec = false,
	fps = false,
	bitrate = false,
	audio_codec = false,
	audio_channels = false,
	format = false,
	aspect = false,

	-- Uses theme colour by default
	-- style = ui.Style():fg("cyan"),
})

require("fs-usage"):setup()
