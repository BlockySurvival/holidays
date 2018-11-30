local mp = minetest.get_modpath(minetest.get_current_modname())

holidays = {}

holidays.holidays = {
   christmas = 1
}

holidays.holiday = holidays.holidays.christmas

dofile(mp .. "/christmas.lua")
