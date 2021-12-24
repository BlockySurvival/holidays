-- Is it Christmas?
if true then
-- if holidays.is_holiday_active("christmas") then
    holidays.log("action", "christmas enabled")

    -- Special tree textures
    if minetest.get_modpath('moretrees') then
        minetest.override_item("moretrees:cedar_leaves", {
            tiles = {
                "christmas_moretrees_cedar_leaves.png",
            }
        })
        minetest.override_item("moretrees:cedar_sapling", {
            tiles = {
                "christmas_moretrees_cedar_sapling.png",
            }
        })
        minetest.override_item("moretrees:cedar_cone", {
            tiles = {
                "christmas_moretrees_cedar_cone.png",
            }
        })


        minetest.override_item("moretrees:spruce_leaves", {
            tiles = {
                "christmas_moretrees_spruce_leaves.png",
            }
        })
        minetest.override_item("moretrees:spruce_sapling", {
            tiles = {
                "christmas_moretrees_spruce_sapling.png",
            }
        })
        minetest.override_item("moretrees:spruce_cone", {
            tiles = {
                "christmas_moretrees_spruce_cone.png",
            }
        })


        minetest.override_item("moretrees:fir_leaves", {
            tiles = {
                "christmas_moretrees_fir_leaves.png",
            }
        })
        minetest.override_item("moretrees:fir_sapling", {
            tiles = {
                "christmas_moretrees_fir_sapling.png",
            }
        })
        minetest.override_item("moretrees:fir_cone", {
            tiles = {
                "christmas_moretrees_fir_cone.png",
            }
        })


        minetest.override_item("moretrees:oak_leaves", {
            tiles = {
                "christmas_moretrees_oak_leaves.png",
            }
        })
        minetest.override_item("moretrees:oak_sapling", {
            tiles = {
                "christmas_moretrees_oak_sapling.png",
            }
        })
        minetest.override_item("moretrees:acorn", {
            tiles = {
                "christmas_moretrees_acorn.png",
            }
        })
    end

    minetest.override_item("default:pine_needles", {
        tiles = {
            "christmas_pine_needles.png",
        }
    })
    minetest.override_item("default:pine_sapling", {
        tiles = {
            "christmas_pine_sapling.png",
        }
    })

    minetest.override_item("default:pine_bush_needles", {
        tiles = {
            "christmas_pine_needles.png",
        }
    })
    minetest.override_item("default:pine_bush_sapling", {
        tiles = {
            "christmas_pine_bush_sapling.png",
        }
    })

    -- Special chest textures
    minetest.override_item("default:chest", {
        tiles = {
            "christmas_chest_top.png",
            "christmas_chest_inside.png",
            "christmas_chest_side.png",
            "christmas_chest_side.png",
            "christmas_chest_side.png",
            "christmas_chest_front.png",
        }
    })
    minetest.override_item("default:chest_open", {
        tiles = {
            "christmas_chest_top.png",
            "christmas_chest_inside.png",
            "christmas_chest_side.png",
            "christmas_chest_side.png",
            "christmas_chest_front.png",
            "christmas_chest_inside.png",
        }
    })

    if minetest.get_modpath('digilines') then
        minetest.override_item("digilines:chest", {
            tiles = {
                "christmas_chest_top.png",
                "christmas_chest_top.png",
                "christmas_chest_side.png",
                "christmas_chest_side.png",
                "christmas_chest_side.png",
                "christmas_chest_front.png",
            }
        })
    end
    if minetest.get_modpath('technic_chests') then
        minetest.override_item("technic:mithril_chest", {
            tiles = {
                "christmas_blue_chest_top.png",
                "christmas_blue_chest_top.png",
                "christmas_blue_chest_side.png",
                "christmas_blue_chest_side.png",
                "christmas_blue_chest_side.png",
                "christmas_blue_chest_front.png",
            }
        })
        minetest.override_item("technic:mithril_locked_chest", {
            tiles = {
                "christmas_blue_chest_top.png",
                "christmas_blue_chest_top.png",
                "christmas_blue_chest_side.png",
                "christmas_blue_chest_side.png",
                "christmas_blue_chest_side.png",
                "christmas_blue_chest_lock.png",
            }
        })
    end
    if minetest.get_modpath('hook') then
        minetest.override_item("hook:pchest_node", {
            tiles = {
                "christmas_green_chest_top.png",
                "christmas_green_chest_top.png",
                {
                    image = "christmas_green_chest_side_animated.png",
                    backface_culling = true,
                    animation = {
                        type = "vertical_frames",
                        aspect_w = 16,
                        aspect_h = 16,
                        length = 2
                    },
                },
            }
        })
    end

    minetest.override_item("default:chest_locked", {
        tiles = {
            "christmas_chest_top.png",
            "christmas_chest_inside.png",
            "christmas_chest_side.png",
            "christmas_chest_side.png",
            "christmas_chest_side.png",
            "christmas_chest_locked_front.png",
        }
    })
    minetest.override_item("default:chest_locked_open", {
        tiles = {
            "christmas_chest_top.png",
            "christmas_chest_inside.png",
            "christmas_chest_side.png",
            "christmas_chest_side.png",
            "christmas_chest_locked_front.png",
            "christmas_chest_inside.png",
        }
    })

    -- Torches
    minetest.override_item("default:torch", {
        inventory_image = "christmas_torch_on_floor.png",
        tiles = {
            {
                image = "christmas_torch_on_floor_animated.png",
                backface_culling = false,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 5
                },
            },
        }
    })

    minetest.override_item("default:torch_wall", {
        tiles = {
            {
                image = "christmas_torch_on_floor_animated.png",
                backface_culling = false,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 5
                },
            },
        }
    })

    --[[
    -- Doesn't look good
    minetest.override_item("default:torch_ceiling", {
        tiles = {
            {
                image = "christmas_torch_on_floor_animated.png",
                backface_culling = false,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 5
                },
            },
        }
    })
    ]]
end
