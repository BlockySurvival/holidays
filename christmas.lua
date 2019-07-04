-- Special ice block so that we can convert it back to water
minetest.register_node("holidays:ice", {
    description = "Holiday Ice",
    tiles = {"default_ice.png"},
    is_ground_content = false,
    paramtype = "light",
    groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 3},
    sounds = default.node_sound_glass_defaults(),
    drop = "default:ice"
})

-- Is it Christmas?
if holidays.holiday == holidays.holidays.christmas then
    -- ABM to convert surface water to ice
    local place_ice = function(pos)
        minetest.set_node(pos, {name = "holidays:ice"})
    end

    minetest.register_abm({
        label = "Place Ice",
        nodenames = {"default:water_source"},
        neighbors = {"air"},
        interval = 1,
        chance = 10,
        action = place_ice
    })

    -- Special chest textures
    local chestdef = minetest.registered_nodes["default:chest"]
    chestdef.tiles = {
        "christmas_chest_top.png",
        "christmas_chest_inside.png",
        "christmas_chest_side.png",
        "christmas_chest_side.png",
        "christmas_chest_side.png",
        "christmas_chest_front.png",
    }
    minetest.register_node(":default:chest", chestdef)
    local chestdef_open = minetest.registered_nodes["default:chest_open"]
    chestdef_open.tiles = {
        "christmas_chest_top.png",
        "christmas_chest_inside.png",
        "christmas_chest_side.png",
        "christmas_chest_side.png",
        "christmas_chest_front.png",
        "christmas_chest_inside.png",
    }
    minetest.register_node(":default:chest_open", chestdef_open)
    local chestdef_locked = minetest.registered_nodes["default:chest_locked"]
    chestdef_locked.tiles = {
        "christmas_chest_top.png",
        "christmas_chest_inside.png",
        "christmas_chest_side.png",
        "christmas_chest_side.png",
        "christmas_chest_side.png",
        "christmas_chest_locked_front.png",
    }
    minetest.register_node(":default:chest_locked", chestdef_locked)
    local chestdef_locked_open = minetest.registered_nodes["default:chest_locked_open"]
    chestdef_locked_open.tiles = {
        "christmas_chest_top.png",
        "christmas_chest_inside.png",
        "christmas_chest_side.png",
        "christmas_chest_side.png",
        "christmas_chest_locked_front.png",
        "christmas_chest_inside.png",
    }
    minetest.register_node(":default:chest_locked_open", chestdef_locked_open)
else
    -- LBM to remove ice
    local remove_ice = function(pos)
        minetest.set_node(pos, {name = "default:water_source"})
    end

    minetest.register_lbm({
        name = "holidays:remove_ice",
        nodenames = {"holidays:ice"},
        run_at_every_load = false,
        action = remove_ice
    })
end
