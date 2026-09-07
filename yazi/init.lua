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
