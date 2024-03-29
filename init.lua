holidays = {}

holidays.modname = minetest.get_current_modname()
holidays.modpath = minetest.get_modpath(holidays.modname)

function holidays.log(level, message, ...)
    return minetest.log(level, ("[%s] %s"):format(holidays.modname, message:format(...)))
end

--[[
    local time = os.time() -- a number
    os.date("*t", time) -- {year = 1998, month = 9, day = 16, yday = 259, wday = 4,
     hour = 23, min = 48, sec = 10, isdst = false}
]]--

local function date_lte(d1, d2)
    return d1.month < d2.month or (d1.month == d2.month and d1.day <= d2.day)
end

local function date_range_predicate(start, stop)
    if date_lte(start, stop) then
        return function(date)
            return date_lte(start, date) and date_lte(date, stop)
        end
    else
        return function(date)
            return date_lte(date, stop) or date_lte(start, date)
        end
    end
end

local function or_(...)
    local funs = {...}
    return function(date)
        for _, fun in ipairs(funs) do
            if fun(date) then return true end
        end
        return false
    end
end

-- Easter calculation, copied from dateutil (see LICENSE)
local floor = math.floor
local function get_month_and_day(p)
    return {month=3 + floor((p + 26)/30), day=1 + (p + 27 + floor((p + 6)/40)) % 31}
end

local function is_easter(date)
    local y = date.year
    local g = y % 19
    local c = floor(y / 100)
    local h = (c - floor(c/4) - floor((8*c + 13)/25) + 19*g + 15) % 30
    local i = h - (floor(h/28))*(1 - (floor(h/28))*floor(29/(h + 1))*floor((21 - g)/11))
    local j = (y + floor(y/4) + i + 2 - c + floor(c/4)) % 7
    local p = i - j

    local start = get_month_and_day(p - 4)
    local stop = get_month_and_day(p + 1)
    return date_lte(start, date) and date_lte(date, stop)
end

holidays.schedule = {
    christmas = date_range_predicate({month=12, day=1}, {month=12, day=26}),  -- 2019 date
    easter = is_easter,
    fireworks = or_(
            date_range_predicate({month=7, day=2}, {month=7, day=5}), -- july 4th
            date_range_predicate({month=12, day=27}, {month=1, day=10})  -- new years
    ),
    winter = date_range_predicate({month=12, day=21}, {month=1, day=1}),
    presents = date_range_predicate({month=11, day=6}, {month=1, day=10}),
}

function holidays.is_holiday_active(holiday_name)
    local time = os.time()
    local date = os.date("*t", time)
    local predicate = holidays.schedule[holiday_name]
    return predicate and predicate(date)
end

dofile(holidays.modpath .. "/christmas.lua")
dofile(holidays.modpath .. "/easter.lua")
dofile(holidays.modpath .. "/fireworks.lua")
dofile(holidays.modpath .. "/winter.lua")
dofile(holidays.modpath .. "/presents.lua")
