local mp = minetest.get_modpath(minetest.get_current_modname())

holidays = {}

holidays.holidays = {
   christmas = 1,
   easter = 2,
}

holidays.holiday = holidays.holidays.easter

dofile(mp .. "/christmas.lua")
dofile(mp .. "/easter.lua")
