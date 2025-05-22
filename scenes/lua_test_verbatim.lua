-- Verbatim conversion GDScript->Lua. Minimal Lua idioms/tricks used
local lua_test = {
	extends = Node2D,
}

-- Emulates `Array.has`. This may not be identical in function
function table.has(tab, value)
	for _, v in pairs(tab) do
		if v == value then
			return true
		end
	end
	return false
end

local GRID_WIDTH = 10
local GRID_HEIGHT = 10
local ITEM_SIZE = 2

local inventory = {}

function lua_test:_ready()
	self:_initialize_worst_case_inventory()
	self:print_grid()
end

function lua_test:_initialize_worst_case_inventory()
	inventory = {}
	for i = 1, GRID_WIDTH * GRID_HEIGHT do
		table.insert(inventory, 1)  -- 1 represents an occupied cell
	end
	
	-- Create a 2x2 empty space near the end
	local empty_x = GRID_WIDTH - ITEM_SIZE
	local empty_y = GRID_HEIGHT - ITEM_SIZE
	for dy = 1, ITEM_SIZE do
		for dx =1, ITEM_SIZE do
			inventory[self:_get_index(empty_x + dx, empty_y + dy)] = 0
		end
	end
end

function lua_test:benchmark_find_space(iterations)
	local start_time = Time:get_ticks_usec()
	
	for i = 1, iterations do
		self:_find_next_available_space()
	end
	
	local end_time = Time:get_ticks_usec()
	local elapsed_time = (end_time - start_time) / 1000000.0  -- Convert to seconds
	print(string.format("Lua: Find space benchmark (%d iterations) took %.6f seconds", iterations, elapsed_time))
	return elapsed_time
end

function lua_test:_find_next_available_space()
	for y = 1, GRID_HEIGHT - ITEM_SIZE + 1 do
		for x = 1, GRID_WIDTH - ITEM_SIZE + 1 do
			if self:_is_space_available(x, y) then
				return Vector2(x, y)
			end
		end
	end
	return Vector2(-1, -1)  -- No space available
end

function lua_test:_is_space_available(x, y)
	for dy = 0, ITEM_SIZE - 1 do
		for dx = 0, ITEM_SIZE - 1 do
			if inventory[self:_get_index(x + dx, y + dy)] ~= 0 then
				return false
			end
		end
	end
	return true
end

function lua_test:_get_index(x, y)
	return (y - 1) * GRID_WIDTH + x
end

function lua_test:print_grid()
	print("Lua Grid:")
	for y = 1, GRID_HEIGHT do
		local row = ""
		for x = 1, GRID_WIDTH do
			row = row .. (inventory[self:_get_index(x, y)] == 0 and "□ " or "■ ")
		end
		print(row)
	end
	print("")
end

function lua_test:initialize_inventory_for_sorting()
	inventory = {}
	for i = 1, GRID_WIDTH * GRID_HEIGHT do
		table.insert(inventory, 0)
	end
	
	local items = {1, 2, 3, 4, 5}
	local positions = {{3, 3}, {6, 2}, {2, 6}, {8, 7}, {5, 9}}
	
	for i = 1, #items do
		self:_place_item(items[i], positions[i][1], positions[i][2])
	end
end

function lua_test:_place_item(item, x, y)
	for dy = 0, ITEM_SIZE - 1 do
		for dx = 0, ITEM_SIZE - 1 do
			inventory[self:_get_index(x + dx, y + dy)] = item
		end
	end
end

function lua_test:benchmark_sort_inventory(iterations)
	local start_time = Time:get_ticks_usec()
	
	for i = 1, iterations do
		self:_sort_inventory()
	end
	
	local end_time = Time:get_ticks_usec()
	local elapsed_time = (end_time - start_time) / 1000000.0  -- Convert to seconds
	print(string.format("Lua: Sort inventory benchmark (%d iterations) took %.6f seconds", iterations, elapsed_time))
	return elapsed_time
end

function lua_test:_sort_inventory()
	local items = {}
	
	-- Find all items
	for y = 1, GRID_HEIGHT do
		for x = 1, GRID_WIDTH do
			local item = inventory[self:_get_index(x, y)]
			if item ~= 0 and not table.has(items, item) then
				table.insert(items, item)
			end
		end
	end
	
	-- Clear the inventory
	inventory = {}
	for i = 1, GRID_WIDTH * GRID_HEIGHT do
		table.insert(inventory, 0)
	end
	
	-- Place items back in order
	table.sort(inventory)
	for _, item in pairs(items) do
		local item_pos = self:_find_next_available_space()
		if item_pos.x ~= -1 and item_pos.y ~= -1 then
			self:_place_item(item, item_pos.x, item_pos.y)
		end
	end
end

function lua_test:print_inventory_for_sorting()
	print("Lua Inventory Before Sorting:")
	self:print_grid()
	self:_sort_inventory()
	print("Lua Inventory After Sorting:")
	self:print_grid()
end

return lua_test
