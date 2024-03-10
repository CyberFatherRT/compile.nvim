local M = {}

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

return M
