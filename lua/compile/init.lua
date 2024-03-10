local has_plenary, _ = pcall(require, "plenary")

if not has_plenary then
	error("This plugin requires nvim-lua/plenary")
	return
end

local M = {}

local job = require("plenary.job")
local utils = require("compile.util")

M.command_exe = ""
M.command_args = {}
M.bufnr = 6

function M:run_compile_command()
	if M.command_exe == "" then
		print("No compile command set")
		return
	end

	vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, false, { "" })

	local idx = 0

	job:new({
		command = M.command_exe,
		cwd = M.command_cwd,
		args = M.command_args,
		on_stdout = function(_, data)
			vim.schedule(function()
				vim.api.nvim_buf_set_lines(M.bufnr, idx, idx, false, { data })
			end)
			idx = idx + 1
		end,
	}):sync()
end

function M:ask_for_input()
	local foo = M.command_exe .. " " .. vim.fn.join(M.command_args, " ")
	local input = vim.fn.input("Compile command:", foo)
	M.command_exe, M.command_args = utils:split_command(input)
	M.command_cwd = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
	M.run_compile_command()
end

vim.keymap.set("n", "<leader>co", M.ask_for_input)

return M
