-- Main file for type-metrics.nvim
local M = {}

M.start_time = nil
M.char_count = 0
M.history = {}

-- Function to get current time
local function get_current_time()
	return vim.loop.hrtime() / 1e9 -- high-resolution time in seconds
end

-- Function to calculate wpm and add it to history
local function calculate_wpm()
	if M.start_time == nil then
		return
	end
	local elapsed_time = get_current_time() - M.start_time
	local wpm = math.floor(M.char_count / 5 / (elapsed_time / 60))

	table.insert(M.history, wpm)
	if #M.history > 10 then
		table.remove(M.history, 1)
	end
end

-- Function to update character count and calculate WPM
function M.on_text_changed()
	M.char_count = M.char_count + 1
	calculate_wpm()
end

function M.insert_start()
	M.start_time = get_current_time()
	M.char_count = 0
end

function M.insert_stop()
	calculate_wpm()
	M.start_time = nil
	M.char_count = 0
end

function M.setup()
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

function M.get_statusline()
	return string.format("WPM: %d", M.get_avg())
end

return M
