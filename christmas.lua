-- Special ice block so that we can convert it back to water
minetest.register_node("holidays:ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_glass_defaults(),
   drops = "default:ice"
})

local place_ice = function(pos)
   minetest.set_node(pos, {name = "holidays:ice"})
end

-- ABM to convert surface water to ice
minetest.register_abm({
   label = "Place Ice",
   nodenames = {"default:water_source"},
   neighbors = {"air"},
   interval = 1,
   chance = 1,
   action = place_ice
})
