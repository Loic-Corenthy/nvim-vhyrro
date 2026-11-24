-- blink.cmp source providing the `llogtable` snippet: a markdown table with
-- one row per weekday (Monday to Friday) of the current week, with dates.

local LOG_WIDTH = 70

local source = {}

function source.new()
    return setmetatable({}, { __index = source })
end

-- Dates (os.time values) for Monday..Friday of the current week.
-- On Saturday/Sunday this still returns the week that is ending.
local function current_week_days()
    local now = os.date("*t")
    -- wday: 1 = Sunday, 2 = Monday, ... 7 = Saturday
    local days_since_monday = (now.wday + 5) % 7
    local days = {}
    for i = 0, 4 do
        -- Use noon so DST changes can never shift the date; os.time
        -- normalises out-of-range day values across month/year boundaries.
        days[#days + 1] = os.time({
            year = now.year,
            month = now.month,
            day = now.day - days_since_monday + i,
            hour = 12,
        })
    end
    return days
end

-- Month/year label for the week, e.g. "November 2026". If the week spans two months
-- it becomes "November – December 2026" or "December 2026 – January 2027".
local function month_heading(first, last)
    local first_month, last_month = os.date("%B", first), os.date("%B", last)
    local first_year, last_year = os.date("%Y", first), os.date("%Y", last)
    if first_year ~= last_year then
        return string.format("%s %s – %s %s", first_month, first_year, last_month, last_year)
    elseif first_month ~= last_month then
        return string.format("%s – %s %s", first_month, last_month, last_year)
    end
    return string.format("%s %s", first_month, first_year)
end

-- Pad to a display width. string.format's %-Ns counts bytes, which would
-- misalign cells containing the multi-byte "–".
local function pad(text, width)
    return text .. string.rep(" ", width - vim.fn.strdisplaywidth(text))
end

local function build_body()
    local days = current_week_days()
    local day_header = string.format("Day (%s)", month_heading(days[1], days[#days]))
    -- At least wide enough for "Wednesday dd".
    local day_width = math.max(12, vim.fn.strdisplaywidth(day_header))
    local blank = string.rep(" ", LOG_WIDTH)
    local rows = {}
    for i, t in ipairs(days) do
        rows[#rows + 1] = string.format("| %s | ${%d:%s} |", pad(os.date("%A %d", t), day_width), i, blank)
    end
    return table.concat({
        string.format("| %s | %s |", pad(day_header, day_width), pad("Log", LOG_WIDTH)),
        string.format("| %s | %s |", string.rep("-", day_width), string.rep("-", LOG_WIDTH)),
        table.concat(rows, "\n"),
        "$0",
    }, "\n")
end

function source:get_completions(_, callback)
    callback({
        is_incomplete_forward = false,
        is_incomplete_backward = false,
        items = {
            {
                label = "llogtable",
                kind = require("blink.cmp.types").CompletionItemKind.Snippet,
                insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
                -- Built on every request so the dates are always current.
                insertText = build_body(),
                documentation = { kind = "markdown", value = "Weekly log table (Monday to Friday, current week)" },
            },
        },
    })
end

return source
