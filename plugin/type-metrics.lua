-- Setup functions etc for this plugin module
local init = require("type-metrics.init")

vim.register_keystroke_callback(function(key)
    init.on_key_pressed(key)
end, 'tracker')
