-- Main file for type-metrics.nvim
local M = {}

M.start_time = nil
M.char_count = 0
M.max = 0

-- Function to get current time
local function get_current_time()
    return vim.loop.hrtime() / 1e9 -- high-resolution time in seconds
end

-- Function to calculate and display WPM
local function calculate_wpm()
    local current_time = get_current_time()
    if M.start_time == nil then
        M.start_time = current_time
    end
    local elapsed_time = current_time - M.start_time

    if elapsed_time > 0 then
        local wpm = (M.char_count / 5) / (elapsed_time / 60)
        M.max = math.max(M.max, wpm)
        print(string.format("Current WPM: %.2f\n", wpm))
    end
end

-- Function to update character count and calculate WPM
function M.on_text_changed()
    M.char_count = M.char_count + 1
    calculate_wpm()
end

function M.setup()
    -- Setup Autocmds for TextChanged and TextChangedI
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        callback = M.on_text_changed,
    })
end

return M
