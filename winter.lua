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

minetest.register_node("holidays:dirt_with_snow", {
    description = "Holiday dirt with Snow",
    tiles = {"default_snow.png", "default_dirt.png",
            {name = "default_dirt.png^default_snow_side.png",
                    tileable_vertical = false}},
    is_ground_content = false,
    groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1, snowy = 1, not_in_creative_inventory = 1},
    drop = "default:dirt",
    sounds = default.node_sound_dirt_defaults({
            footstep = {name = "default_snow_footstep", gain = 0.2},
    }),
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
    minetest.register_abm({
        label = "Place Holiday Dirt",
        nodenames = {"default:dirt_with_grass"},
        neighbors = {"air"},
        interval = 1,
        chance = 10,
        action = function(pos)
            minetest.set_node(pos, {name = "holidays:dirt_with_snow"})
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
    minetest.register_abm({
        label = "Remove Holiday Dirt",
        nodenames = {"holidays:dirt_with_snow"},
        interval = 1,
        chance = 10,
        action = function(pos)
            minetest.set_node(pos, {name = "default:dirt_with_grass"})
        end
    })
end
