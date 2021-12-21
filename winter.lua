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
    minetest.override_item("default:water_source", {tiles = {"winter_ice.png"}})
    minetest.override_item("default:dirt_with_grass", {
        tiles =  {
            "default_snow.png", "default_dirt.png",
            {name = "default_dirt.png^default_snow_side.png",
                    tileable_vertical = false}
        }
    })

    -- ABM to convert surface water to ice
    --[[
    -- Spreading ice & snow, maybe next year after the cleanup LBM has taken full effect
     minetest.register_abm({
        label = "Holiday Ice Spread",
        nodenames = {
            "holidays:ice",
            "default:ice",
        },
        neighbors = {"air"},
        interval = 10,
        chance = 10,
        catch_up = false,
        action = function(pos, node)
            local num = minetest.find_nodes_in_area_under_air(
                {x = pos.x - 1, y = pos.y - 2, z = pos.z - 1},
                {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
                "default:water_source")
            if #num > 0 then
                minetest.set_node(num[math.random(#num)], {name = "holidays:ice"})
            end
        end,
    })
    minetest.register_abm({
        label = "Holiday Snow Spread",
        nodenames = {
            "holidays:ice",
            "holidays:dirt_with_snow",
            "default:ice",
            "default:snowblock",
            "default:dirt_with_snow",
        },
        neighbors = {"air"},
        interval = 10,
        chance = 10,
        catch_up = false,
        action = function(pos, node)
            local num = minetest.find_nodes_in_area_under_air(
                {x = pos.x - 1, y = pos.y - 2, z = pos.z - 1},
                {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
                "default:dirt_with_grass")
            if #num > 0 then
                minetest.set_node(num[math.random(#num)], {name = "holidays:dirt_with_snow"})
            end
        end,
    })
    ]]

    minetest.register_craft({
        output = "bucket:bucket_river_water",
        type = "shapeless",
        recipe = {"bucket:bucket_water"},
    })
    minetest.register_craft({
        output = "bucket:bucket_water",
        type = "shapeless",
        recipe = {"bucket:bucket_river_water"},
    })
    minetest.register_craft({
        output = "default:river_water_source",
        type = "shapeless",
        recipe = {"default:water_source"},
    })
    minetest.register_craft({
        output = "default:water_source",
        type = "shapeless",
        recipe = {"default:river_water_source"},
    })
    minetest.register_craft({
        output = "default:water_source",
        type = "cooking",
        recipe = "default:ice",
    })
else
    -- LBM to remove ice
    minetest.register_lbm({
        label = "Remove Holiday Ice & Dirt Immediately",
        name = "holidays:remove_ice_and_snow",
        nodenames = {"holidays:ice","holidays:dirt_with_snow"},
        run_at_every_load = true,
        action = function(pos, node)
            if node.name == "holidays:ice" then
                minetest.set_node(pos, {name = "default:water_source"})
            elseif node.name == "holidays:dirt_with_snow" then
                minetest.set_node(pos, {name = "default:dirt_with_grass"})
            end
        end,
    })
end
