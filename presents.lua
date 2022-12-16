
local pnum = 0

local function register_present(c1, c2, lvl)
    local old_name = "presents:present_" .. tostring(pnum)
    local new_name = "holidays:present_" .. tostring(pnum)
    minetest.register_node(new_name, {
        description = "Christmas Present " .. lvl,
        tiles = {
            "presents_blank.png^[multiply:" .. c1 .. "^(presents_bow.png^[multiply:" .. c2 .. ")",
            "presents_blank.png^[multiply:" .. c1 .. "^(presents_cross.png^[multiply:" .. c2 .. ")",
            "presents_blank.png^[multiply:" .. c1 .. "^(presents_line.png^[multiply:" .. c2 .. ")"
        },
        paramtype2 = "facedir",
        groups = {oddly_diggable_by_hand = 1, crumbly = 2},
        on_punch = function(pos, node, puncher, pointed_thing)
            if not puncher or not puncher:is_player() then return end
            minetest.chat_send_player(puncher:get_player_name(), "Bring this present to the Christmas shop to redeem it!")
        end,
        stack_max = 65535
    })
    pnum = pnum + 1
    minetest.register_alias_force(new_name, old_name)
end

register_present("#bb2528", "#146b3a", "(Rare)")
register_present("#146b3a", "#bb2528", "(Unusual)")
register_present("#bb2528", "#f0f0f0", "(Common)")

if holidays.is_holiday_active("presents") then
    holidays.log("action", "presents enabled")
    minetest.register_on_dignode(function(pos, oldnode, digger)
        if not digger or not digger:is_player() then return end
        local n = math.random(1, 1000)
        if n <= 10 then
            if n == 1 then
                minetest.item_drop(ItemStack("presents:present_0"), digger, pos)
            elseif n <= 3 then
                minetest.item_drop(ItemStack("presents:present_1"), digger, pos)
            else
                minetest.item_drop(ItemStack("presents:present_2"), digger, pos)
            end
        end
    end)
end
