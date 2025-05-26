local mod = get_mod("CreateCustomTab")

function mod.on_all_mods_loaded()
    mod:io_dofile("CreateCustomTab/scripts/mods/CreateCustomTab/InventoryViewTabEH")
end
