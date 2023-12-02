-- Setup functions etc for this plugin module
local typ = require("typing-metrics.init")
typ.setup()

vim.api.nvim_create_user_command("TypeMetricsAvg", function()
	print(typ.get_avg())
end, {})

vim.api.nvim_create_user_command("TypeMetricsHistory", function()
	print(vim.inspect(typ.history))
end, {})

return typ
