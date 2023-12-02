-- Main file for type-metrics.nvim
local M = {}

local key_count = 0
local start_time = nil
local last_update = nil

local function get_current_time()
    return vim.loop.hrtime() / 1e9 -- high-resolution time in seconds
end

function M.on_key_pressed(key)
    if start_time == nil then
        start_time = get_current_time()
    end

    key_count = key_count + 1
    last_update = get_current_time()

    M.update_wpm() -- Update WPM every time a key is pressed
end

function M.update_wpm()
    local current_time = get_current_time()
    local elapsed_time = current_time - start_time

    if elapsed_time > 0 then
        local wpm = (key_count / 5) / (elapsed_time / 60) -- Average word length is considered 5 characters
        print(string.format("Current WPM: %.2f", wpm))    -- Display WPM in the command line
    end
end

return M
