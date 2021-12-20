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

local registered_christmas_nexuses = {}
local registered_humbug_nexuses = {}
local effect_radius = 25

local function in_range_of_nexus(nexus, pos)
    if math.abs(nexus.x - pos.x) > effect_radius then
        return false
    end
    if math.abs(nexus.z - pos.z) > effect_radius then
        return false
    end
    if math.abs(nexus.y - pos.y) > effect_radius then
        return false
    end
    return true
end
local function in_range_of_nexuses(nexuses, pos)
    for _,nexus in pairs(nexuses) do
        if in_range_of_nexus(nexus, pos) then
            return true
        end
    end
    return false
end

minetest.register_node("holidays:christmas_nexus", {
    description = "Christmas Nexus",
    tiles = {"christmas_chest_top.png"},
    is_ground_content = false,
    groups = {oddly_breakable_by_hand=3},
    sounds = default.node_sound_wood_defaults(),
    on_construct = function(pos)
        local key = minetest.pos_to_string(pos)
        registered_christmas_nexuses[key] = pos
    end,
    on_destruct = function(pos)
        local key = minetest.pos_to_string(pos)
        registered_christmas_nexuses[key] = nil
    end
})

local humbug_tiles = {"default_coal_block.png^default_mineral_coal.png"}
if minetest.get_modpath("caverealms") then
    table.insert(humbug_tiles, "caverealms_coal_dust.png^default_mineral_coal.png")
end
minetest.register_node("holidays:humbug_nexus", {
    description = "Humbug Nexus",
    tiles = humbug_tiles,
    is_ground_content = false,
    groups = {oddly_breakable_by_hand=3},
    sounds = default.node_sound_stone_defaults(),
    on_construct = function(pos)
        local key = minetest.pos_to_string(pos)
        registered_humbug_nexuses[key] = pos
    end,
    on_destruct = function(pos)
        local key = minetest.pos_to_string(pos)
        registered_humbug_nexuses[key] = nil
    end
})


if holidays.is_holiday_active("winter") then

    -- Register any nexuses that are loaded
    minetest.register_lbm({
        label = "Register Holiday Nexuses",
        name = "holidays:register_nexuses",
        nodenames = {"holidays:christmas_nexus","holidays:humbug_nexus"},
        run_at_every_load = true,
        action = function(pos, node)
            if node.name == "holidays:christmas_nexus" then
                local key = minetest.pos_to_string(pos)
                if not registered_christmas_nexuses[key] then
                    registered_christmas_nexuses[key] = pos
                end
            elseif node.name == "holidays:humbug_nexus" then
                local key = minetest.pos_to_string(pos)
                if not registered_humbug_nexuses[key] then
                    registered_humbug_nexuses[key] = pos
                end
            end
        end,
    })

    -- Create ice & snow like before, but only if there's a christmas nexus and no humbug nexus
    minetest.register_abm({
        label = "Place Holiday Ice",
        nodenames = {"default:water_source"},
        neighbors = {"air"},
        interval = 2.1,
        chance = 7,
        catch_up = false,
        action = function(pos)
            if not in_range_of_nexuses(registered_christmas_nexuses, pos)
               or in_range_of_nexuses(registered_humbug_nexuses, pos)
            then
                return
            end
            if pos.y > 0 then
                minetest.set_node(pos, {name = "holidays:ice"})
            end
        end
    })
    minetest.register_abm({
        label = "Place Holiday Dirt",
        nodenames = {"default:dirt_with_grass"},
        neighbors = {"air"},
        interval = 2.3,
        chance = 7,
        catch_up = false,
        action = function(pos)
            if not in_range_of_nexuses(registered_christmas_nexuses, pos)
               or in_range_of_nexuses(registered_humbug_nexuses, pos)
            then
                return
            end
            minetest.set_node(pos, {name = "holidays:dirt_with_snow"})
        end
    })

    -- Remove ice and snow if there's a humbug nexus
    minetest.register_abm({
        label = "Remove Holiday Ice",
        nodenames = {"holidays:ice"},
        interval = 1.1,
        chance = 5,
        catch_up = false,
        action = function(pos)
            if not in_range_of_nexuses(registered_humbug_nexuses, pos) then
                return
            end
            minetest.set_node(pos, {name = "default:water_source"})
        end
    })
    minetest.register_abm({
        label = "Remove Holiday Dirt",
        nodenames = {"holidays:dirt_with_snow"},
        interval = 1.3,
        chance = 5,
        catch_up = false,
        action = function(pos)
            if not in_range_of_nexuses(registered_humbug_nexuses, pos) then
                return
            end
            minetest.set_node(pos, {name = "default:dirt_with_grass"})
        end
    })

    -- Spread ice and snow from existing ice and snow, unless there is a humbug nexus
    -- Copied and modified from https://github.com/Ezhh/caverealms_lite/blob/master/plants.lua
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
            if in_range_of_nexuses(registered_humbug_nexuses, pos) then
                return
            end
            local num = minetest.find_nodes_in_area_under_air(
                {x = pos.x - 1, y = pos.y - 2, z = pos.z - 1},
                {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
                "default:water_source")
            if #num > 0 then
                local chosen = num[math.random(#num)]
                if in_range_of_nexuses(registered_humbug_nexuses, chosen) then
                    return
                end
                minetest.set_node(chosen, {name = "holidays:ice"})
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
            if in_range_of_nexuses(registered_humbug_nexuses, pos) then
                return
            end
            local num = minetest.find_nodes_in_area_under_air(
                {x = pos.x - 1, y = pos.y - 2, z = pos.z - 1},
                {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
                "default:dirt_with_grass")
            if #num > 0 then
                local chosen = num[math.random(#num)]
                if in_range_of_nexuses(registered_humbug_nexuses, chosen) then
                    return
                end
                minetest.set_node(chosen, {name = "holidays:dirt_with_snow"})
            end
        end,
    })


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
    -- ABM to remove ice
    minetest.register_abm({
        label = "Remove Holiday Ice",
        nodenames = {"holidays:ice"},
        interval = 1.1,
        chance = 5,
        catch_up = false,
        action = function(pos)
            minetest.set_node(pos, {name = "default:water_source"})
        end
    })
    minetest.register_abm({
        label = "Remove Holiday Dirt",
        nodenames = {"holidays:dirt_with_snow"},
        interval = 1.3,
        chance = 5,
        catch_up = false,
        action = function(pos)
            minetest.set_node(pos, {name = "default:dirt_with_grass"})
        end
    })
end
