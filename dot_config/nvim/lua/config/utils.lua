local H = {}
local hexChars = "0123456789abcdef"

--- @param mode string | table<string> -- n, v, i, x
--- @param keys string
--- @param func function|string
--- @param desc? string
--- @param opts? vim.keymap.set.Opts
H.map = function(mode, keys, func, desc, opts)
	opts = opts or {}
	opts.desc = desc
	vim.keymap.set(mode, keys, func, opts)
end

H.L = function(key)
	return "<leader>" .. key
end
H.C = function(cmd)
	return "<cmd>" .. cmd .. "<cr>"
end

--- @param msg string
--- @param level? 'ERROR' | 'WARN' | 'INFO'
--- @param title string?
H.notify = function(msg, level, title)
	level = level or "INFO"
	vim.defer_fn(function()
		vim.notify(msg, vim.log.levels[level], { title = title or "Notification" })
	end, 1000)
end

--- @param msg string
--- @param level? 'ERROR' | 'WARN' | 'INFO'
--- @param title string?
H.notify_once = function(msg, level, title)
	level = level or "INFO"
	vim.notify_once(msg, vim.log.levels[level], { title = title or "Notification" })
end

--- @param ms integer the timeout in millisecond
--- @param fn function Callback function
H.debounce = function(ms, fn)
	local timer = vim.uv.new_timer()
	return function(...)
		local argv = { ... }
		if timer ~= nil then
			timer:start(ms, 0, function()
				timer:stop()
				vim.schedule_wrap(fn)(unpack(argv))
			end)
		end
	end
end

--- Convert hex color to RGB
--- @param hex string The hex color value (e.g., "#ff0000")
--- RGB values as [r, g, b] where each value is between 0 and 1
H.hex_to_rgb = function(hex)
	hex = string.lower(hex)
	local ret = {}
	for i = 0, 2 do
		local char1 = string.sub(hex, i * 2 + 2, i * 2 + 2)
		local char2 = string.sub(hex, i * 2 + 3, i * 2 + 3)
		local digit1 = string.find(hexChars, char1) - 1
		local digit2 = string.find(hexChars, char2) - 1
		ret[i + 1] = (digit1 * 16 + digit2) / 255.0
	end
	return ret
end

--- Converts an RGB color value to HSL. Conversion formula
--- adapted from http://en.wikipedia.org/wiki/HSL_color_space.
--- Assumes r, g, and b are contained in the set [0, 255] and
--- returns h, s, and l in the set [0, 1].
--- @param r number The red color value
--- @param g number The green color value
--- @param b number The blue color value
--- The HSL representation (h, s, l)
H.rgbToHsl = function(r, g, b)
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h = 0
	local s = 0
	local l = 0

	l = (max + min) / 2

	if max == min then
		h, s = 0, 0 -- achromatic
	else
		local d = max - min
		if l > 0.5 then
			s = d / (2 - max - min)
		else
			s = d / (max + min)
		end
		if max == r then
			h = (g - b) / d
			if g < b then
				h = h + 6
			end
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	return h * 360, s * 100, l * 100
end

--- Converts an HSL color value to RGB. Conversion formula
--- adapted from http://en.wikipedia.org/wiki/HSL_color_space.
--- Assumes h, s, and l are contained in the set [0, 1] and
--- returns r, g, and b in the set [0, 255].
--- @param h number The hue
--- @param s number The saturation
--- @param l number The lightness
--- The RGB representation (r, g, b)
H.hslToRgb = function(h, s, l)
	local r, g, b

	if s == 0 then
		r, g, b = l, l, l -- achromatic
	else
		local function hue2rgb(p, q, t)
			if t < 0 then
				t = t + 1
			end
			if t > 1 then
				t = t - 1
			end
			if t < 1 / 6 then
				return p + (q - p) * 6 * t
			end
			if t < 1 / 2 then
				return q
			end
			if t < 2 / 3 then
				return p + (q - p) * (2 / 3 - t) * 6
			end
			return p
		end

		local q
		if l < 0.5 then
			q = l * (1 + s)
		else
			q = l + s - l * s
		end
		local p = 2 * l - q

		r = hue2rgb(p, q, h + 1 / 3)
		g = hue2rgb(p, q, h)
		b = hue2rgb(p, q, h - 1 / 3)
	end

	return r * 255, g * 255, b * 255
end

--- Convert hex color to HSL
--- @param hex string The hex color value (e.g., "#ff0000")
--- HSL representation (e.g., "hsl(0, 100, 50)")
H.hexToHSL = function(hex)
	local rgb = H.hex_to_rgb(hex)
	local h, s, l = H.rgbToHsl(rgb[1], rgb[2], rgb[3])

	return string.format("hsl(%d, %d, %d)", math.floor(h + 0.5), math.floor(s + 0.5), math.floor(l + 0.5))
end

--- Converts an HSL color value to RGB in Hex representation.
--- @param h number? The hue
--- @param s number? The saturation
--- @param l number? The lightness
--- The hex representation
H.hslToHex = function(h, s, l)
	local r, g, b = H.hslToRgb(h / 360, s / 100, l / 100)
	return string.format("#%02x%02x%02x", r, g, b)
end

--- Convert RGB values to hex
--- @param r? number Red value (0-255)
--- @param g? number Green value (0-255)
--- @param b? number Blue value (0-255)
--- @param a? number Alpha value (0-1)
--- Hex color representation
H.rgbToHex = function(r, g, b, a)
	if a then
		return string.format("#%02x%02x%02x", r * a, g * a, b * a)
	end
	return string.format("#%02x%02x%02x", r, g, b)
end

--- Convert OKLCH color values to sRGB
--- @param l? number Lightness
--- @param c? number Chroma
--- @param h? number Hue
--- RGB values (0-255)
local function oklch_to_srgb(l, c, h)
	-- OKLCH -> OKLab
	local h_rad = h * math.pi / 180
	local a = c * math.cos(h_rad)
	local b = c * math.sin(h_rad)

	-- OKLab -> linear sRGB
	local L = l
	local A = a
	local B = b

	local l_ = L + 0.3963377774 * A + 0.2158037573 * B
	local m_ = L - 0.1055613458 * A - 0.0638541728 * B
	local s_ = L - 0.0894841775 * A - 1.2914855480 * B

	local l3 = l_ * l_ * l_
	local m3 = m_ * m_ * m_
	local s3 = s_ * s_ * s_

	local r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3
	local g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3
	b = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3

	-- Gamma correction
	local function to_srgb_channel(x)
		if x <= 0.0031308 then
			return 12.92 * x
		else
			return 1.055 * x ^ (1 / 2.4) - 0.055
		end
	end

	r = to_srgb_channel(r)
	g = to_srgb_channel(g)
	b = to_srgb_channel(b)

	-- Clamp and convert to 0-255
	local function clamp(x)
		return math.max(0, math.min(1, x))
	end

	return math.floor(clamp(r) * 255 + 0.5), math.floor(clamp(g) * 255 + 0.5), math.floor(clamp(b) * 255 + 0.5)
end

--- Convert OKLCH color values to hex
--- @param l? number Lightness
--- @param c? number Chroma
--- @param h? number Hue
--- @param a? number Alpha
--- Hex color representation
H.oklchToHex = function(l, c, h, a)
	local r, g, b = oklch_to_srgb(l, c, h)
	return H.rgbToHex(r, g, b, a)
end

--- @param tbl table
--- Unique values from the input table
H.uniq = function(tbl)
	local seen, result = {}, {}
	for _, value in ipairs(tbl) do
		if not seen[value] then
			seen[value] = true
			result[#result + 1] = value
		end
	end
	return result
end

--- Build blink.cmp
--- @param params table Build parameters containing path
H.build_blink = function(params)
	H.notify("Building blink.cmp", "INFO")
	local obj = vim.system({ "cargo", "build", "--release" }, { cwd = params.path }):wait()
	if obj.code == 0 then
		H.notify("Building blink.cmp done", "INFO")
	else
		H.notify("Building blink.cmp failed", "ERROR")
	end
end

---@param dot_ext string
---@param target_ft string
H.set_ft = function(dot_ext, target_ft)
	vim.api.nvim_create_autocmd({ "BufReadPost" }, {
		pattern = "*." .. dot_ext,
		desc = "Set filetype to " .. target_ft,
		callback = function(args)
			vim.bo[args.buf].ft = target_ft
		end,
	})
end

---@param lsp_name string
---@return boolean
---Whether the LSP is active
H.has_lsp = function(lsp_name)
	local find_lsp = vim.lsp.get_clients({
		name = lsp_name,
		bufnr = vim.api.nvim_get_current_buf(),
	})
	return #find_lsp > 0
end

--- @param action lsp.CodeActionKind
H.action = function(action)
	return function()
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				only = { action },
				diagnostics = {},
			},
		})
	end
end

---@param opts lsp.ExecuteCommandParams
---@param buffer? number
local execute = function(opts, buffer)
	vim.lsp.buf_request(buffer or 0, "workspace/executeCommand", {
		command = opts.command,
		arguments = opts.arguments,
	}, function(err)
		if err then
			H.notify(err.message, "ERROR")
		end
	end)
end

---@param command string
H.command = function(command)
	return function()
		execute({ command = command })
	end
end

---@param buf_id integer
---@param lhs string
---@param direction string
---@param close_on_file boolean
H.map_split = function(buf_id, lhs, direction, close_on_file)
	local MiniFiles = require("mini.files")
	local rhs = function()
		local new_target_window
		local cur_target_window = MiniFiles.get_explorer_state().target_window
		if cur_target_window ~= nil then
			vim.api.nvim_win_call(cur_target_window, function()
				vim.cmd("belowright " .. direction .. " split")
				new_target_window = vim.api.nvim_get_current_win()
			end)

			MiniFiles.set_target_window(new_target_window)
			MiniFiles.go_in({ close_on_file = close_on_file })
		end
	end

	local desc = "Open in " .. direction .. " split"
	if close_on_file then
		desc = desc .. " and close"
	end
	vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

--- Deletes all listed buffers in a given direction from the current one silently.
--- @param direction 'left' | 'right'
H.delete_buffers_in_direction = function(direction)
	local listed_buffers = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].buflisted then
			table.insert(listed_buffers, bufnr)
		end
	end

	local current_bufnr = vim.api.nvim_get_current_buf()
	local current_buf_idx
	for i, bufnr in ipairs(listed_buffers) do
		if bufnr == current_bufnr then
			current_buf_idx = i
			break
		end
	end

	if not current_buf_idx then
		return
	end

	if direction == "right" then
		if current_buf_idx == #listed_buffers then
			return
		end
		for i = #listed_buffers, current_buf_idx + 1, -1 do
			pcall(require("mini.bufremove").delete, listed_buffers[i], false)
		end
	elseif direction == "left" then
		if current_buf_idx == 1 then
			return
		end
		for i = current_buf_idx - 1, 1, -1 do
			pcall(require("mini.bufremove").delete, listed_buffers[i], false)
		end
	end
end

--- Get relative time string from timestamp
--- @param timestamp number Unix timestamp
H.get_relative_time = function(timestamp)
	local current_time = os.time()
	local diff = os.difftime(current_time, timestamp)
	local minutes = math.floor(diff / 60)
	local hours = math.floor(minutes / 60)
	local days = math.floor(hours / 24)

	if minutes < 1 then
		return "just now"
	elseif minutes < 60 then
		return string.format("%d mins ago", minutes)
	elseif hours < 24 then
		return string.format("%d hours ago", hours)
	elseif days <= 3 then
		return string.format("%d days ago", days)
	else
		return os.date("%m/%d/%Y", timestamp)
	end
end

--- @param state boolean
--- @param fs_entry table
H.toggle_dotfiles = function(state, fs_entry)
	if state then
		return true
	end
	return not vim.startswith(fs_entry.name, ".")
end

return H
