extends Node2D

const GRID_WIDTH = 10
const GRID_HEIGHT = 10
const ITEM_SIZE = 2

var inventory: Array = []

func _ready():
    _initialize_worst_case_inventory()
    print_grid()

func _initialize_worst_case_inventory():
    inventory = []
    for i in range(GRID_WIDTH * GRID_HEIGHT):
        inventory.append(1)  # 1 represents an occupied cell
    
    # Create a 2x2 empty space near the end
    var empty_x = GRID_WIDTH - ITEM_SIZE
    var empty_y = GRID_HEIGHT - ITEM_SIZE
    for dy in range(ITEM_SIZE):
        for dx in range(ITEM_SIZE):
            inventory[_get_index(empty_x + dx, empty_y + dy)] = 0

func benchmark_find_space(iterations: int) -> float:
    var start_time = Time.get_ticks_usec()
    
    for i in range(iterations):
        _find_next_available_space()
    
    var end_time = Time.get_ticks_usec()
    var elapsed_time = (end_time - start_time) / 1000000.0  # Convert to seconds
    print("GDScript: Find space benchmark (%d iterations) took %.6f seconds" % [iterations, elapsed_time])
    return elapsed_time

func _find_next_available_space() -> Vector2:
    for y in range(GRID_HEIGHT - ITEM_SIZE + 1):
        for x in range(GRID_WIDTH - ITEM_SIZE + 1):
            if _is_space_available(x, y):
                return Vector2(x, y)
    return Vector2(-1, -1)  # No space available

func _is_space_available(x: int, y: int) -> bool:
    for dy in range(ITEM_SIZE):
        for dx in range(ITEM_SIZE):
            if inventory[_get_index(x + dx, y + dy)] != 0:
                return false
    return true

func _get_index(x: int, y: int) -> int:
    return y * GRID_WIDTH + x

func print_grid():
    print("GDScript Grid:")
    for y in range(GRID_HEIGHT):
        var row = ""
        for x in range(GRID_WIDTH):
            row += "□ " if inventory[_get_index(x, y)] == 0 else "■ "
        print(row)
    print("")

func initialize_inventory_for_sorting():
    inventory = []
    for i in range(GRID_WIDTH * GRID_HEIGHT):
        inventory.append(0)
    
    var items = [1, 2, 3, 4, 5]
    var positions = [[2, 2], [5, 1], [1, 5], [7, 6], [4, 8]]
    
    for i in range(items.size()):
        _place_item(items[i], positions[i][0], positions[i][1])

func _place_item(item: int, x: int, y: int):
    for dy in range(ITEM_SIZE):
        for dx in range(ITEM_SIZE):
            inventory[_get_index(x + dx, y + dy)] = item

func benchmark_sort_inventory(iterations: int) -> float:
    var start_time = Time.get_ticks_usec()
    
    for i in range(iterations):
        _sort_inventory()
    
    var end_time = Time.get_ticks_usec()
    var elapsed_time = (end_time - start_time) / 1000000.0  # Convert to seconds
    print("GDScript: Sort inventory benchmark (%d iterations) took %.6f seconds" % [iterations, elapsed_time])
    return elapsed_time

func _sort_inventory():
    var items = []
    
    # Find all items
    for y in range(GRID_HEIGHT):
        for x in range(GRID_WIDTH):
            var item = inventory[_get_index(x, y)]
            if item != 0 and not items.has(item):
                items.append(item)
    
    # Clear the inventory
    inventory = []
    for i in range(GRID_WIDTH * GRID_HEIGHT):
        inventory.append(0)
    
    # Place items back in order
    items.sort()
    for item in items:
        var item_pos = _find_next_available_space()
        if item_pos.x != -1 and item_pos.y != -1:
            _place_item(item, item_pos.x, item_pos.y)

func print_inventory_for_sorting():
    print("GDScript Inventory Before Sorting:")
    print_grid()
    _sort_inventory()
    print("GDScript Inventory After Sorting:")
    print_grid()
