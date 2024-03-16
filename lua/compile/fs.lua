local M = {}

M.cache_folder = vim.fn.stdpath("cache") .. "/compile"
M.folder_permission = 489 -- 751

local function create_dir(path)
	vim.fn.mkdir(path, "p", M.folder_permission)
end

---@param start_text table
---@param string table
---@param end_text table
function M:save_compile_output(start_text, string, end_text)
	create_dir(M.cache_folder)
	local fd = io.open(M.cache_folder .. "/compile.cache", "w")

	if fd == nil then
		error("Could not create cache file")
	end

	local output = {}

	vim.list_extend(output, start_text)
	vim.list_extend(output, string)
	vim.list_extend(output, end_text)

	for _, v in ipairs(output) do
		fd:write(v, "\n")
	end

	fd:close()
end

return M
