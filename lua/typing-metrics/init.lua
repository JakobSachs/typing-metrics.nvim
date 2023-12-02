-- Main file for typing-metrics.nvim
local M = {}

M.config = {
    -- Default config values
    word_length = 5,
    update_interval = 500,
    average_size = 3,
    target_wpm = 60,
    bar_direction = "vertical",
}

M.char_count = 0
M.average = {}

-- Function to get current time
local function get_current_time()
    return vim.loop.hrtime() / 1e9 -- high-resolution time in seconds
end

local function update_wpm()
    local wpm = math.floor(M.char_count / M.config.word_length * 60)
    table.insert(M.average, wpm)

    if #M.average > M.config.average_size then
        table.remove(M.average, 1)
    end

    M.char_count = 0
end

-- Function to update character count and calculate WPM
function M.on_text_changed()
    M.char_count = M.char_count + 1
end

-- API functions for external use

-- Function to get average WPM from average
function M.get_avg()
    local sum = 0
    for _, v in ipairs(M.average) do
        sum = sum + v
    end
    return sum / #M.average
end

-- Function to get statusline-component as a string
function M.get_statusline_raw()
    return string.format("WPM: %3d", M.get_avg())
end

-- Function to get statusline-component as a nice unicode bar
M.v_bar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
M.h_bar = { "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█" }

function M.get_statusline()
    local wpm = M.get_avg()
    local bar = ""
    local bar_idx = math.min(math.floor(wpm / M.config.target_wpm * 8), #M.v_bar - 1)

    local bar_char = M.v_bar
    if M.config.bar_direction == "horizontal" then
        bar_char = M.h_bar
    end

    bar = bar_char[bar_idx + 1]
    return bar
end

local function on_timer()
    update_wpm()
end

-- Start a Timer
function M.start_timer()
    local timer = vim.loop.new_timer()
    timer:start(M.config.update_interval, M.config.update_interval, vim.schedule_wrap(on_timer)) -- 1000ms delay, 1000ms interval
end

function M.setup(user_config)
    if user_config == nil then
        user_config = {}
    end

    -- Merge user config with default config
    for k, v in pairs(user_config) do
        M.config[k] = v
    end

    -- Setup Autocmds for insert mode
    vim.api.nvim_create_autocmd({ "InsertCharPre" }, {
        callback = M.on_text_changed,
    })

    -- Create autocmds for opening buffers to pop ups etc
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
        callback = function()
        end,

    })



    -- Start timer
    M.start_timer()
end

-- return module table
return M
