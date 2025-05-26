local mod = get_mod("CreateCustomTab")

-- ##### ┌─┐┌─┐┬─┐┌─┐┌─┐┬─┐┌┬┐┌─┐┌┐┌┌─┐┌─┐ ############################################################################
-- ##### ├─┘├┤ ├┬┘├┤ │ │├┬┘│││├─┤││││  ├┤  ############################################################################
-- ##### ┴  └─┘┴└─└  └─┘┴└─┴ ┴┴ ┴┘└┘└─┘└─┘ ############################################################################

--#region Performance
local Unit = Unit
local math = math
local table = table
local pairs = pairs
local World = World
local CLASS = CLASS
local string = string
local Camera = Camera
local get_mod = get_mod
local Localize = Localize
local tostring = tostring
local managers = Managers
--#endregion

-- ##### ┌─┐┬  ┌─┐┌─┐┌─┐  ┌─┐─┐ ┬┌┬┐┌─┐┌┐┌┌─┐┬┌─┐┌┐┌ ##################################################################
-- ##### │  │  ├─┤└─┐└─┐  ├┤ ┌┴┬┘ │ ├┤ │││└─┐││ ││││ ##################################################################
-- ##### └─┘┴─┘┴ ┴└─┘└─┘  └─┘┴ └─ ┴ └─┘┘└┘└─┘┴└─┘┘└┘ ##################################################################

-- ###########
-- Setting variables
-- ###########
local ewc = get_mod("weapon_customization")
local ewc_using_visual_equipment
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
_tabs_to_jump -- disgusting global variable so the hook can actually use it
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if ewc then 
    ewc_using_visual_equipment = ewc:get("mod_option_visible_equipment")
    if ewc_using_visual_equipment then
        _tabs_to_jump = 1    -- avoid crash
    else
        _tabs_to_jump = 2    -- place after talents tree
    end
end

mod:hook_require("scripts/ui/views/inventory_background_view/inventory_background_view", function(instance)

    -- Thank you Grasmann
    -- This function name will get overwritten by weapon customization if we use the same name (or we overwrite it, depending on load order)
    instance.add_custom_panel_enhanced_descriptions = function(self)
        -- self._custom_panel_added_enhanced_descriptions is also actually added to this game function, so this condition needs a unique name
        if not self._custom_panel_added_enhanced_descriptions and self._views_settings then
            local player = self._preview_player
            local profile = player:profile()
            local profile_archetype = profile.archetype
            local archetype_name = profile_archetype.nameCreateC
            local is_ogryn = archetype_name == "ogryn"

            -- Adds a tab to the list of tabs. +1 puts it after mastery. +2 puts it after Talents
            --  having weapon customization visible equipment makes it 
            --      without on_all_mods_loaded: +1 on top of that (with fuckery based on load order. may crash)
            --      on_all_mods_loaded: work as usual with +1, crash if you do +2 (regardless of load order), not show up if you do +3
            --  i think making it 0 would replace mastery lol (or cosmetics if you're inspecting someone else)
            self._views_settings[#self._views_settings + _tabs_to_jump] = {
                view_name = "inventory_view",
                display_name = "loc_enhanced_descriptions_dictionary_name",
                update = function (content, style, dt) end,
                context = {
                    can_exit = true,
                },
                enter = function ()
                    if self._transition_animation_id and self:_is_animation_active(self._transition_animation_id) then
                        self.transition_animation_id = self:_stop_animation(self._transition_animation_id)
                    end
                    self.transition_animation_id = self:_start_animation("transition_fade", self._widgets_by_name, self)
                end,
                leave = function ()
                    if self._transition_animation_id and self:_is_animation_active(self._transition_animation_id) then
                        self.transition_animation_id = self:_stop_animation(self._transition_animation_id)
                    end
                    self.transition_animation_id = self:_start_animation("transition_fade", self._widgets_by_name, self)
                    return {
                        force_instant_camera = true,
                    }
                end,
                view_context = {
                    can_exit = true,
                    camera_settings = {
                        {"event_inventory_set_camera_position_axis_offset", "x", is_ogryn and 1.8 or 1.45, 0.5, math_easeCubic},
                        {"event_inventory_set_camera_position_axis_offset", "y", 0, 0.5, math_easeCubic},
                        {"event_inventory_set_camera_position_axis_offset", "z", 0, 0.5, math_easeCubic},
                        {"event_inventory_set_camera_rotation_axis_offset", "x", 0, 0.5, math_easeCubic},
                        {"event_inventory_set_camera_rotation_axis_offset", "y", 0, 0.5, math_easeCubic},
                        {"event_inventory_set_camera_rotation_axis_offset", "z", 0, 0.5, math_easeCubic},
                    },
                    --[[
                        -- I have no idea what this is for
                        -- when you hover the widgets for each visible equipment slot?
                    tabs = {
                        {
                            ui_animation = "cosmetics_on_enter",
                            display_name = "COCK IN MY ASS",
                            draw_wallet = false,
                            allow_item_hover_information = true,
                            icon = "content/ui/materials/icons/system/settings/category_gameplay",
                            is_grid_layout = false,
                            camera_settings = {
                                {"event_inventory_set_camera_position_axis_offset", "x", is_ogryn and 1.8 or 1.45, 0.5, math_easeCubic},
                                {"event_inventory_set_camera_position_axis_offset", "y", 0, 0.5, math_easeCubic},
                                {"event_inventory_set_camera_position_axis_offset", "z", 0, 0.5, math_easeCubic},
                                {"event_inventory_set_camera_rotation_axis_offset", "x", 0, 0.5, math_easeCubic},
                                {"event_inventory_set_camera_rotation_axis_offset", "y", 0, 0.5, math_easeCubic},
                                {"event_inventory_set_camera_rotation_axis_offset", "z", 0, 0.5, math_easeCubic},
                            },
                            item_hover_information_offset = {0},
                            layout = {}
                        }
                    }
                    ]]
                }
            }
            -- flag to avoid creating duplicate tabs
            self._custom_panel_added_enhanced_descriptions = true
        end
    end

end)

mod:hook(CLASS.InventoryBackgroundView, "_update_has_empty_talent_nodes", function(func, self, optional_selected_nodes, ...)
    -- Custom panel
    self:add_custom_panel_enhanced_descriptions()
    -- Original function
    func(self, optional_selected_nodes, ...)
end)
