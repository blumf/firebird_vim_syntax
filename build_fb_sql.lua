#!/usr/bin/env lua 
-- Builds Vim keywords lists from keyword data file

-- Location of keyword data
local in_path  = arg[1] or [[firebird_sql_keywords.csv]]
local out_path = arg[2] or [[firebird_sql_keywords.vim]]

-- Mapping of keyword data to Vim types
local type_map = {
	keyword   = "sqlKeyword  ",
	key       = "sqlKeyword  ",
	op        = "sqlOperator ",
	["type"]  = "sqlType     ",
	func      = "sqlFunction ",
	const     = "sqlConst    ",
	state     = "sqlStatement",
	type_mod  = "sqlTypeMod  ",
	object    = "sqlObject   ",
	group_op  = "sqlFunction ",
}

-- Splits a string according to CSV rules
-- params:
--   s : The string to split
--   comma : (optional) The character to use for field seperation
--   quote : (optional) The character to use for quoting field text
-- returns: Table containing the split data, or nil + error message
local function split_csv(s, comma, quote)
        comma = comma or ','
        quote = quote or '"'

        local comma_inv = '^'..comma
        local quote_inv = '^'..quote
        local quote_match = quote.."("..quote.."?)"

        s = s .. comma          -- ending comma
        local t = {}            -- table to collect fields
        local fieldstart = 1

        repeat
                -- next field is quoted? (start with `"'?)
                if string.find(s, quote_inv, fieldstart) then
                        local a, c
                        local i  = fieldstart
                        repeat
                                -- find closing quote
                                a, i, c = string.find(s, quote_match, i+1)
                        until c ~= quote        -- quote not followed by quote?

                        if not i then
                                return nil, "Error : unmatched "..quote
                        end

                        local f = string.sub(s, fieldstart+1, i-1)
                        table.insert(t, (string.gsub(f, quote..quote, quote)))
                        fieldstart = string.find(s, comma, i) + 1
                else                -- unquoted; find next comma
                        local nexti = string.find(s, comma, fieldstart)
                        table.insert(t, string.sub(s, fieldstart, nexti-1))
                        fieldstart = nexti + 1
                end
        until fieldstart > string.len(s)

        return t
end

-- Parses a CSV file
-- params:
--   path : The path of the file to parse
--   comma : (optional) The character to use for field seperation
--   quote : (optional) The character to use for quoting field text
-- returns: An iterator function that returns parsed CSV rows
-- usage:
--   for row in read_csv("test.csv") do
--     print(row[1], row[2])
--   end
local function read_csv(path, comma, quote)
        local input = io.lines(path)

        return function()
                local l = input()
                if not l then return nil; end

                local row = split_csv(l, comma, quote)
                while not row do
                        l = l.."\n"..input()
                        row = split_csv(l, comma, quote)
                end

                return row
        end
end

---------------------------------------

local lib = {}

for row in read_csv(in_path) do
	if row[2] == "" then row[2] = "keyword"; end

	local tmp = lib[row[2]] or {}
	lib[row[2]] = tmp

	tmp[#tmp+1] = row[1]:lower()
end

local function write_keyword(f, name, items)
	local function write_kw_start()
		f:write("syn keyword ", name, "\t")
	end
	
	local a,i = 1,1
	while i <= #items do
		while (i <= #items) and (table.concat(items, " ", a,i):len() < 56) do
			i = i + 1
		end
		write_kw_start()
		f:write(table.concat(items, " ", a,i-1), "\n")
		a = i
	end

	f:write("\n")
end

local f = io.open(out_path, "w+")

for t, items in pairs(lib) do
	local name = type_map[t]
	if name then write_keyword(f, name, items); end
end

f:close()

