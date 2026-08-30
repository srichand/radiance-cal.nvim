local plugin = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(plugin)
vim.cmd("filetype plugin on")
vim.cmd("syntax on")
vim.cmd("edit " .. vim.fn.fnameescape(plugin .. "/tests/fixture.cal"))

local failures = {}

local function group_at(line, text)
	local source = vim.fn.getline(line)
	local column = source:find(text, 1, true)
	if not column then
		table.insert(failures, string.format("line %d does not contain %q", line, text))
		return ""
	end
	return vim.fn.synIDattr(vim.fn.synID(line, column, true), "name")
end

local function resolved_group_at(line, text)
	local source = vim.fn.getline(line)
	local column = source:find(text, 1, true)
	if not column then
		return ""
	end
	local syntax_id = vim.fn.synID(line, column, true)
	return vim.fn.synIDattr(vim.fn.synIDtrans(syntax_id), "name")
end

local function expect_filetype(expected)
	if vim.bo.filetype ~= expected then
		table.insert(failures, string.format("filetype: expected %q, got %q", expected, vim.bo.filetype))
	end
end

local function expect_group(line, text, expected)
	local actual = group_at(line, text)
	if actual ~= expected then
		table.insert(
			failures,
			string.format("line %d at %q: expected %s, got %s", line, text, expected, actual)
		)
	end
end

expect_filetype("radiancecal")
expect_group(1, "{", "radianceCalComment")
expect_group(2, "nested", "radianceCalComment")
expect_group(2, "still outer", "radianceCalComment")
expect_group(5, "FTINY", "radianceCalConstant")
expect_group(5, "1e-7", "radianceCalNumber")
expect_group(6, ".5", "radianceCalNumber")
expect_group(7, "1.", "radianceCalNumber")
expect_group(8, "fact", "radianceCalFunctionDefinition")
expect_group(8, "if", "radianceCalBuiltinFunction")
expect_group(9, "d1", "radianceCalFunctionDefinition")
expect_group(10, "local`context.value", "radianceCalDefinition")
expect_group(10, "sqrt", "radianceCalBuiltinFunction")
expect_group(10, "PI", "radianceCalConstant")
expect_group(11, "`strict_local", "radianceCalDefinition")
expect_group(11, "noise3", "radianceCalBuiltinFunction")
expect_group(11, "Dx", "radianceCalBuiltinVariable")
expect_group(11, "NyP", "radianceCalBuiltinVariable")
expect_group(12, "$1", "radianceCalChannel")
expect_group(12, "in", "radianceCalBuiltinFunction")
expect_group(12, "4E+2", "radianceCalNumber")
expect_group(13, "ro", "radianceCalBuiltinVariable")
expect_group(13, "ri", "radianceCalBuiltinFunction")

if resolved_group_at(10, "sqrt") ~= "Function" then
	table.insert(failures, "built-in functions do not resolve to the Function highlight group")
end

if #failures > 0 then
	error(table.concat(failures, "\n"))
end

print("radiance-cal.nvim syntax tests passed")
