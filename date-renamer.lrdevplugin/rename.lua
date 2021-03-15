--[[ This plugin renames collections from a format of day_month_year_descriptions
to year-month-day_description, to ensure sorted by date in Lightroom panel
(since it doesn't let you sort any other way).

Similarly for day_month_year-day_month_year_description, it renames to
year-month-day_to_year-month-day_description.
]]

-- Import Lightroom namespaces - each returns a constructor function
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrErrors = import 'LrErrors'
local LrTasks = import 'LrTasks'

-- Utilities to uniformly format parts of dates
local function zero_pad(s)
    if string.len(s) == 1 then
        return "0" .. s
    else
        return s
    end
end

local function pad_year(year)
    if string.match(year, "^20%d%d$") then
        return year
    else
        return "20" .. year
    end
end

local function format_description(descr)
    -- Uniformly format the description string, e.g. remove spaces, capitalisation
    descr = string.gsub(descr, " ", "_")
    first_letter = string.sub(descr, 1, 1)
    first_letter = string.upper(first_letter)
    second_onwards = string.sub(descr, 2)
    return first_letter .. second_onwards
end

local function create_collection_newname(name)
    -- Generate new collection name from current name

    -- Look to see if double-date pattern
    -- Lua doesn't have lookaheads in its patterns,
    -- so we have to do double vs single-dates manually
    local dbl_date_pattern = '(%d%d?)_(%d%d?)_(%d%d)-(%d%d?)_(%d%d?)_(%d%d)[_ ](.+)'
    local dbl_date_match = string.match(name, dbl_date_pattern)

    local single_date_pattern = '(%d%d?)_(%d%d?)_(%d%d)[_ ](.+)'
    local single_date_match = string.match(name, single_date_pattern)

    -- Single date match also matches the double date pattern, so need to check double date first
    if dbl_date_match then
        day1, month1, year1, day2, month2, year2, descr = string.match(name, dbl_date_pattern)
        day1 = zero_pad(day1)
        month1 = zero_pad(month1)
        year1 = pad_year(year1)
        day2 = zero_pad(day2)
        month2 = zero_pad(month2)
        year2 = pad_year(year2)
        descr = format_description(descr)

        local newname = string.format("%s-%s-%s_to_%s-%s-%s_%s", year1, month1, day1, year2, month2, day2, descr)
        return newname

    elseif single_date_match then
        day1, month1, year1, descr = string.match(name, single_date_pattern)
        day1 = zero_pad(day1)
        month1 = zero_pad(month1)
        year1 = pad_year(year1)
        descr = format_description(descr)

        local newname = string.format("%s-%s-%s_%s", year1, month1, day1, descr)
        return newname

    else
        return nil
    end
end

local function main ()
    local catalog = LrApplication.activeCatalog()
    local collections = catalog:getChildCollections()
    for i, coll in ipairs(collections) do
        local name = coll:getName()
        local newname = create_collection_newname(name)

        if not newname then
            LrDialogs.message('Cannot parse collection ' .. name .. ', skipping')

        else
            -- Dialog for user to confirm rename, or quit entire process
            local message = "Renaming " .. name .. " to " .. newname
            local rename_verb = 'Rename'  -- action = 'ok'
            local skip_verb = 'Skip' -- action = 'cancel'
            local quit_verb = 'Stop renaming loop' -- action = 'other'
            local action = LrDialogs.confirm(message, nil, rename_verb, skip_verb, quit_verb)
            if action == 'ok' then
                local a = "1"
            elseif action == 'other' then
                break
            end
        end
    end
end

LrTasks.startAsyncTask(main)