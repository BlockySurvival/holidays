local mp = minetest.get_modpath(minetest.get_current_modname())

holidays = {}

holidays.holidays = {
    christmas = 1,
    easter = 2,
    july4 = 3,
}

holidays.holiday = nil

dofile(mp .. "/christmas.lua")
dofile(mp .. "/easter.lua")
dofile(mp .. "/july4.lua")
