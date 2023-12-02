-- Setup functions etc for this plugin module
local init = require("type-metrics.init")
init.setup()

vim.api.nvim_create_user_command("TypeMetricsMax",
    function()
        print(init.get_max(), "max")
    end, {}
)
