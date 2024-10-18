extends Node2D

@onready var gd_test = $GDTest
@onready var cs_test = $CSTest

func _ready():
	run_find_space_benchmark(1)
	run_find_space_benchmark(10)
	run_find_space_benchmark(100)
	
	print("\nRunning Sort Inventory Benchmark:")
	run_sort_inventory_benchmark(1)
	run_sort_inventory_benchmark(10)
	run_sort_inventory_benchmark(100)

func run_find_space_benchmark(iterations: int):
	print("\nRunning Find Space benchmark with %d iterations:" % iterations)
	
	var gd_time = gd_test.benchmark_find_space(iterations)
	var cs_time = cs_test.BenchmarkFindSpace(iterations)
	
	print("Benchmark complete!")
	print("GDScript time: %.6f seconds" % gd_time)
	print("C# time: %.6f seconds" % cs_time)
	print("C# is %.2f times faster than GDScript" % (gd_time / cs_time))

func run_sort_inventory_benchmark(iterations: int):
	print("\nRunning Sort Inventory benchmark with %d iterations:" % iterations)
	
	gd_test.initialize_inventory_for_sorting()
	cs_test.InitializeInventoryForSorting()
	
	if iterations == 1:
		gd_test.print_inventory_for_sorting()
		cs_test.PrintInventoryForSorting()
	
	var gd_time = gd_test.benchmark_sort_inventory(iterations)
	var cs_time = cs_test.BenchmarkSortInventory(iterations)
	
	print("Benchmark complete!")
	print("GDScript time: %.6f seconds" % gd_time)
	print("C# time: %.6f seconds" % cs_time)
	print("C# is %.2f times faster than GDScript" % (gd_time / cs_time))
