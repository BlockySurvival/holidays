if holidays.is_holiday_active("winter") then
    holidays.log("action", "winter enabled")
end


-- Special ice block so that we can convert it back to water
minetest.register_node("holidays:ice", {
    description = "Holiday Ice",
    tiles = {"default_ice.png"},
    is_ground_content = false,
    paramtype = "light",
    groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 3, not_in_creative_inventory = 1},
    sounds = default.node_sound_glass_defaults(),
    drop = "default:ice"
})


if holidays.is_holiday_active("winter") then
    -- ABM to convert surface water to ice
    minetest.register_abm({
        label = "Place Holiday Ice",
        nodenames = {"default:water_source"},
        neighbors = {"air"},
        interval = 1,
        chance = 10,
        action = function(pos)
            minetest.set_node(pos, {name = "holidays:ice"})
        end
    })
else
    -- ABM to remove ice
    minetest.register_abm({
        label = "Remove Holiday Ice",
        nodenames = {"holidays:ice"},
        interval = 1,
        chance = 10,
        action = function(pos)
            minetest.set_node(pos, {name = "default:water_source"})
        end
    })
end
