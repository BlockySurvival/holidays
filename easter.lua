local REWARDS = {
    -- relative weights of getting a particular reward
    ['farming:chocolate_dark'] = 100,
    ['farming:turkish_delight'] = 10,
    ['default:gold_ingot'] = 5,
    ['default:diamond'] = 1,
    ['mobs_animal:bunny'] = 1,
}


local function scale(weighted_choices)
    local scaled_choices = {}
    local total_weight = 0
    for _, weight in pairs(weighted_choices) do
        total_weight = total_weight + weight
    end
    for name, weight in pairs(weighted_choices) do
        table.insert(scaled_choices, {name=name, weight=weight/total_weight})
    end
    return scaled_choices
end


local SCALED_REWARDS = scale(REWARDS)


local function random_reward()
    local rv = math.random()

    for _, reward in pairs(SCALED_REWARDS) do
        if rv < reward.weight then
            return reward.name
        else
            rv = rv - reward.weight
        end
    end

    -- should never get here, but just in case
    minetest.log('warning', '[holidays:easter] unexpected behavior picking a reward')
    return scaled_rewards[1].name
end


minetest.register_node('holidays:easter_egg', {
	description = 'Easter egg',
	drawtype = 'mesh',
	mesh = 'holidays_easter_egg.obj',
	tiles = { 'holidays_easter_egg_tile.png', },
	groups = { dig_immediate = 3 },
	paramtype = 'light',
	inventory_image = 'holidays_easter_egg.png',
	wield_image = 'holidays_easter_egg.png',
    on_dig = function(pos, node, player)
        if holidays.holiday == holidays.holidays.easter then
            -- only reward players during easter
            local stack = ItemStack({name = random_reward()})
            stack = player:get_inventory():add_item("main", stack)

            if not stack:is_empty() then
                minetest.item_drop(stack, player, pos)
            end
        end
        minetest.remove_node(pos)
    end
})


if holidays.holiday == holidays.holidays.easter then
else
    -- remove easter eggs after easter
    minetest.register_lbm({
        name = 'holidays:remove_easter_eggs',
        nodenames = {'holidays:easter_egg'},
        run_at_every_load = false,
        action = function(pos)
            minetest.remove_node(pos)
        end
    })
end
