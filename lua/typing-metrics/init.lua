-- Main file for typing-metrics.nvim
local M = {}

M.config = {
	-- Default config values
	word_length = 5,
	update_interval = 1000,
	history_size = 10,
	target_wpm = 60,
	bar_direction = "vertical",
}

M.start_time = nil
M.char_count = 0
M.history = {}

function M.setup(user_config)
	if user_config == nil then
		user_config = {}
	end

	-- Merge user config with default config
	for k, v in pairs(user_config) do
		M.config[k] = v
	end

	-- Setup Autocmds for TextChanged and TextChangedI
	vim.api.nvim_create_autocmd({ "InsertCharPre" }, {
		callback = M.on_text_changed,
	})

	vim.api.nvim_create_autocmd({ "InsertEnter" }, {
		callback = M.insert_start,
	})

	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		callback = M.insert_stop,
	})
end

-- Function to get current time
local function get_current_time()
	return vim.loop.hrtime() / 1e9 -- high-resolution time in seconds
end

-- Function to calculate wpm and add it to history
local function update_wpm()
	if M.start_time == nil then -- If start_time is nil, we are not typing
		return
	end

	local elapsed_time = get_current_time() - M.start_time
	-- If the time elapsed is less than the update interval, do nothing
	if elapsed_time < M.config.update_interval / 1000 then
		return
	end

	local wpm = math.floor(M.char_count / M.config.word_length / (elapsed_time / 60))

	table.insert(M.history, wpm)

	if #M.history > M.config.history_size then
		table.remove(M.history, 1)
	end
end

-- Function to update character count and calculate WPM
function M.on_text_changed()
	M.char_count = M.char_count + 1
	update_wpm()
end

function M.insert_start()
	M.start_time = get_current_time()
	M.char_count = 0
end

function M.insert_stop()
	update_wpm()
	M.start_time = nil
	M.char_count = 0
end

-- API functions for external use

-- Function to get average WPM from history
function M.get_avg()
	local sum = 0
	for _, v in ipairs(M.history) do
		sum = sum + v
	end
	return sum / #M.history
end

-- Function to get history
function M.get_history()
	return M.history
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

-- return module table
return M
