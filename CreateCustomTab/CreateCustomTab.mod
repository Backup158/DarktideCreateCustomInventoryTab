return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`CreateCustomTab` encountered an error loading the Darktide Mod Framework.")

		new_mod("CreateCustomTab", {
			mod_script       = "CreateCustomTab/scripts/mods/CreateCustomTab/CreateCustomTab",
			mod_data         = "CreateCustomTab/scripts/mods/CreateCustomTab/CreateCustomTab_data",
			mod_localization = "CreateCustomTab/scripts/mods/CreateCustomTab/CreateCustomTab_localization",
		})
	end,
	packages = {},
}
