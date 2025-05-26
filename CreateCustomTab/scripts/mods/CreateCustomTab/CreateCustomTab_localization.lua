local mod = get_mod("CreateCustomTab")

-- Global Localizations
-- Used by the menus
mod:add_global_localize_strings({
	loc_enhanced_descriptions_dictionary_name = {
		en = "Glossary",
		ru = "Футанари",
		["zh-cn"] = "男娘",
	},
})

-- Local Localizations
return {
	mod_description = {
		en = "Creates a custom tab in the Operative menu for demonstration purposes",
	},
}
