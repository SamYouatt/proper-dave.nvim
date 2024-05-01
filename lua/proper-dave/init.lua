---@type boolean
local vim_is_dark
---@type boolean
local system_is_dark

---@param background string
local function set_vim_background(background)
    vim.api.nvim_set_option_value("background", background, {})
end

local function is_system_dark_mode()
    local query = "defaults read -g AppleInterfaceStyle"

    local function stdout_callback(_, data, _)
        system_is_dark = data[1] == "Dark"
    end

    vim.fn.jobstart(query, {
        stdout_buffered = true,
        on_stdout = stdout_callback,
    })
end

local function check_theme()
    is_system_dark_mode()

    if system_is_dark ~= vim_is_dark then
        if system_is_dark then
            set_vim_background("dark")
        else
            set_vim_background("light")
        end

        vim_is_dark = system_is_dark
    end
end

local function setup()
    check_theme()

    local loop_time_ms = 3000
    vim.fn.timer_start(loop_time_ms, check_theme, { ["repeat"] = -1 })
end

return { setup = setup }
