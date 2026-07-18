local chezmoi_dir = vim.fn.expand("~/.local/share/chezmoi/")

vim.filetype.add({
	pattern = {
		[vim.pesc(chezmoi_dir) .. ".*"] = function(path, buf)
			if vim.startswith(path, chezmoi_dir .. "fugitive:/") then
				local fixed_path = path:gsub("^" .. vim.pesc(chezmoi_dir .. "fugitive:/"), "fugitive:///")
					:gsub(vim.pesc("/.git/"), "/.git//")
				local ok, parsed = pcall(vim.fn.FugitiveReal, fixed_path)
				if ok and parsed ~= "" then
					path = parsed
				end
			end

			local base_path = path:gsub("%.tmpl$", "")
			local contents = vim.api.nvim_buf_get_lines(buf, 0, 100, false)
			local filetype, _, fallback = vim.filetype.match({
				filename = base_path,
				contents = contents,
			})

			if filetype ~= nil and not fallback then
				return filetype
			end

			if vim.fn.executable("chezmoi") ~= 1 then
				return filetype
			end

			local obj = vim.system({ "chezmoi", "target-path", path }, { text = true }):wait()
			if obj.code ~= 0 then
				return filetype
			end

			local filetype2, _, fallback2 = vim.filetype.match({
				filename = vim.trim(obj.stdout),
				contents = contents,
			})

			if filetype2 ~= nil and not fallback2 then
				return filetype2
			end

			return filetype
		end,
	},
})
