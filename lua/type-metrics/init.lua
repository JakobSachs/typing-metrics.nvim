-- Main file for type-metrics.nvim
local M = {}

function M.setup(opts)
    print("TypeMetrics setup")

    vim.register_keystroke_callback(function(key)
        print("Key pressed: " .. key)
    end)
end

return
