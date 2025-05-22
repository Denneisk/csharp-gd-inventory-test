local lua_test = {
	extends = Node2D,
}

local GRID_WIDTH = 10
local GRID_HEIGHT = 10
local ITEM_SIZE = 2

local inventory = {}

local function get_index(x, y)
	return (y - 1) * GRID_WIDTH + x
end

local function is_space_available(x, y)
	for dy = 0, ITEM_SIZE - 1 do
		for dx = 0, ITEM_SIZE - 1 do
			if inventory[get_index(x + dx, y + dy)] ~= 0 then
				return false
			end
		end
	end
	return true
end

local function find_next_available_space()
	for y = 1, GRID_HEIGHT - ITEM_SIZE + 1 do
		for x = 1, GRID_WIDTH - ITEM_SIZE + 1 do
			if is_space_available(x, y) then
				return x, y
			end
		end
	end
end

local function print_grid()
	print("Lua Grid:")
	for y = 1, GRID_HEIGHT do
		local row = {}
		for x = 1, GRID_WIDTH do
			row[#row + 1] = inventory[get_index(x, y)] == 0 and "□ " or "■ "
		end
		print(table.concat(row))
	end
	print("")
end

local function place_item(item, x, y)
	for dy = 0, ITEM_SIZE - 1 do
		for dx = 0, ITEM_SIZE - 1 do
			inventory[get_index(x + dx, y + dy)] = item
		end
	end
end

local function sort_inventory()
	local items = {}
	local met_items = {}
	
	-- Find all items
	for y = 1, GRID_HEIGHT do
		for x = 1, GRID_WIDTH do
			local item = inventory[get_index(x, y)]
			if item ~= 0 and met_items[item] == nil then
				items[#items + 1] = item
				met_items[item] = true
			end
		end
	end

	-- Clear the inventory
	inventory = {}
	for i = 1, GRID_WIDTH * GRID_HEIGHT do
		inventory[i] = 0
	end
	
	-- Place items back in order
	table.sort(items)
	for i = 1, #items do
		local x, y = find_next_available_space()
		if x then
			place_item(items[i], x, y)
		end
	end
end

local function initialize_worst_case_inventory()
	inventory = {}
	for i = 1, GRID_WIDTH * GRID_HEIGHT do
		inventory[i] = 1  -- 1 represents an occupied cell
	end
	
	-- Create a 2x2 empty space near the end
	local empty_x = GRID_WIDTH - ITEM_SIZE
	local empty_y = GRID_HEIGHT - ITEM_SIZE
	for dy = 1, ITEM_SIZE do
		for dx = 1, ITEM_SIZE do
			inventory[get_index(empty_x + dx, empty_y + dy)] = 0
		end
	end
end
lua_test.initialize_worst_case_inventory = initialize_worst_case_inventory

function lua_test:benchmark_find_space(iterations)
	local start_time = Time:get_ticks_usec()
	
	for i = 1, iterations do
		find_next_available_space()
	end
	
	local end_time = Time:get_ticks_usec()
	local elapsed_time = (end_time - start_time) / 1000000.0  -- Convert to seconds
	print(string.format("Lua: Find space benchmark (%d iterations) took %.6f seconds", iterations, elapsed_time))
	return elapsed_time
end

local function initialize_inventory_for_sorting()
	inventory = {}
	for i = 1, GRID_WIDTH * GRID_HEIGHT do
		inventory[i] = 0
	end
	
	local items = {1, 2, 3, 4, 5}
	local positions = {{3, 3}, {6, 2}, {2, 6}, {8, 7}, {5, 9}}
	
	for i = 1, #items do
		place_item(items[i], positions[i][1], positions[i][2])
	end
end
lua_test.initialize_inventory_for_sorting = initialize_inventory_for_sorting

function lua_test:benchmark_sort_inventory(iterations)
	local start_time = Time:get_ticks_usec()
	
	for i = 1, iterations do
		sort_inventory()
	end
	
	local end_time = Time:get_ticks_usec()
	local elapsed_time = (end_time - start_time) / 1000000.0  -- Convert to seconds
	print(string.format("Lua: Sort inventory benchmark (%d iterations) took %.6f seconds", iterations, elapsed_time))
	return elapsed_time
end

function lua_test:print_inventory_for_sorting()
	print("Lua Inventory Before Sorting:")
	print_grid()
	sort_inventory()
	print("Lua Inventory After Sorting:")
	print_grid()
end

function lua_test:_ready()
	initialize_worst_case_inventory()
	print_grid()
end

return lua_test
