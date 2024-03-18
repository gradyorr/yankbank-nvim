-- data.lua
local M = {}

-- reformat yanks table for popup
function M.get_display_lines(yanks, sep)
    local display_lines = {}
    local line_yank_map = {}
    local yank_num = 0

    -- calculate the maximum width needed for the yank numbers
    local max_digits = #tostring(#yanks)

    for i, yank in ipairs(yanks) do
        yank_num = yank_num + 1

        -- remove trailing newlines
        yank = yank:gsub("\n$", "")
        local yank_lines = vim.split(yank, "\n", { plain= true })
        local leading_space, leading_space_length

        -- determine the number of leading whitespaces on the first line
        if #yank_lines > 0 then
            leading_space = yank_lines[1]:match("^(%s*)")
            leading_space_length = #leading_space
        end

        for j, line in ipairs(yank_lines) do
            if j == 1 then
                -- Format the line number with uniform spacing
                local lineNumber = string.format("%" .. max_digits .. "d: ", yank_num)
                line = line:sub(leading_space_length + 1)
                table.insert(display_lines, lineNumber .. line)
            else
                -- Remove the same amount of leading whitespace as on the first line
                line = line:sub(leading_space_length + 1)
                -- Use spaces equal to the line number's reserved space to align subsequent lines
                table.insert(display_lines, string.rep(" ", max_digits + 2) .. line)
            end
            table.insert(line_yank_map, i)
        end

        if i < #yanks then
            -- Add a visual separator between yanks, aligned with the yank content
            if sep ~= "" then
                table.insert(display_lines, string.rep(" ", max_digits + 2) .. sep)
            end
            table.insert(line_yank_map, false)
        end
    end

    return display_lines, line_yank_map
end

return M
