local M = {}

M.line_index = 0

---@param command string
---@return string, table
function M:split_command(command)
	local tbl = {}

	for _, v in ipairs(vim.split(command, " ")) do
		if v ~= "" then
			table.insert(tbl, v)
		end
	end

	return table.remove(tbl, 1), tbl
end

---@return string
function M:get_time()
	local handle = io.popen([[date "+%a %h %d %T"]])

	if handle == nil then
		error("Can not get current date and time")
	end

	local result = handle:read("*a")
	handle:close()

	return vim.fn.trim(result)
end

---@param bufnr number
---@return nil
function M:reset_buf(bufnr)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
	M.line_index = 0
end

---@param bufnr number
---@param string string
---@return nil
function M:write_line(bufnr, string)
	vim.api.nvim_buf_set_lines(bufnr, M.line_index, M.line_index, false, { string })
	M.line_index = M.line_index + 1
end

return M
