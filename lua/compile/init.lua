local has_plenary, _ = pcall(require, "plenary")

if not has_plenary then
	error("This plugin requires nvim-lua/plenary")
	return
end

local M = {}

local Job = require("plenary.job")
local utils = require("compile.utils")
local fs = require("compile.fs")

M.command_exe = ""
M.command_args = {}
M.bufnr = 9

local raw_input = ""
local start_text = {}
local end_text = {}

local function on_std(_, data)
	vim.schedule(function()
		utils:write_line(M.bufnr, data)
	end)
end

local function print_start_boilerplate()
	local tbl = {
		"Compilation start at " .. utils:get_time(),
		"",
		raw_input,
		"",
	}
	start_text = tbl

	for _, value in ipairs(tbl) do
		utils:write_line(M.bufnr, value)
	end
end

local function print_end_boilerplate()
	local tbl = {
		"",
		"Compilation finished at " .. utils:get_time(),
	}
	end_text = tbl

	for _, value in ipairs(tbl) do
		utils:write_line(M.bufnr, value)
	end
end

local function run_compile_command()
	if M.command_exe == "" then
		print("No compile command set")
		return
	end

	utils:reset_buf(M.bufnr)
	vim.schedule(print_start_boilerplate)

	local job = Job:new({
		command = M.command_exe,
		cwd = M.command_cwd,
		args = M.command_args,
		on_stdout = on_std,
		on_stderr = on_std,
		on_exit = function(j)
			vim.schedule(function()
				print_end_boilerplate()
				print(vim.inspect(start_text))
				fs:save_compile_output(start_text, j:result(), end_text)
			end)
		end,
	})

	job:start()
end

function M:compile()
	raw_input = vim.fn.input("Compile command: ", raw_input)
	M.command_exe, M.command_args = utils:split_command(raw_input)
	M.command_cwd = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
	run_compile_command()
end

return M
