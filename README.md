# Godot GDScript vs C# Performance Benchmark

This project demonstrates a performance comparison between GDScript and C# in Godot, using a grid-based inventory system as a benchmark. These are common operations in games that use grid-based inventory systems.

## Project Description

The benchmark simulates two common operations in a grid-based inventory system:

1. Finding an available space for a 2x2 item in a 10x10 grid inventory.
2. Sorting the inventory by moving all items to the top-left corner in order.

Both GDScript and C# implementations perform the same tasks:

### Benchmark 1: Find Available Space
- Initialize the inventory grid with all cells occupied except for a 2x2 space near the end (worst-case scenario).
- Find the next available 2x2 space.

### Benchmark 2: Sort Inventory
- Initialize the inventory with five 2x2 items placed randomly (Identical for GDScript and C#).
- Sort the inventory by moving all items to the top-left corner in order.

The benchmarks measure the time taken to perform these operations for different numbers of iterations (1, 10, and 100).

## Benchmark Results

Here are the results from running the benchmark on my system:

## Worst Case Scenario Item Pickup Search

```
GDScript Grid:
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ □ □ 
■ ■ ■ ■ ■ ■ ■ ■ □ □ 
```

```
C# Grid:
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ □ □ 
■ ■ ■ ■ ■ ■ ■ ■ □ □ 
```


Running Find Space benchmark with 1 iterations:
GDScript: Find space benchmark (1 iterations) took 0.000057 seconds
C#: Find space benchmark (1 iterations) took 0.000092 seconds
Benchmark complete!
GDScript time: 0.000057 seconds
C# time: 0.000092 seconds
C# is 0.62 times faster than GDScript

Running Find Space benchmark with 10 iterations:
GDScript: Find space benchmark (10 iterations) took 0.000537 seconds
C#: Find space benchmark (10 iterations) took 0.000004 seconds
Benchmark complete!
GDScript time: 0.000537 seconds
C# time: 0.000004 seconds
C# is 134.25 times faster than GDScript

Running Find Space benchmark with 100 iterations:
GDScript: Find space benchmark (100 iterations) took 0.004859 seconds
C#: Find space benchmark (100 iterations) took 0.000035 seconds
Benchmark complete!
GDScript time: 0.004859 seconds
C# time: 0.000035 seconds
C# is 140.03 times faster than GDScript

## Sort Inventory

Running Sort Inventory Benchmark:

Running Sort Inventory benchmark with 1 iterations:
GDScript Inventory Before Sorting:

```
GDScript Grid:
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ ■ ■ □ □ □ 
□ □ ■ ■ □ ■ ■ □ □ □ 
□ □ ■ ■ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ ■ ■ □ □ □ □ □ □ □ 
□ ■ ■ □ □ □ □ ■ ■ □ 
□ □ □ □ □ □ □ ■ ■ □ 
□ □ □ □ ■ ■ □ □ □ □ 
□ □ □ □ ■ ■ □ □ □ □ 
```

GDScript Inventory After Sorting:

```
GDScript Grid:
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
```

C# Inventory Before Sorting:
C# Grid:
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ ■ ■ □ □ □ 
□ □ ■ ■ □ ■ ■ □ □ □ 
□ □ ■ ■ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ ■ ■ □ □ □ □ □ □ □ 
□ ■ ■ □ □ □ □ ■ ■ □ 
□ □ □ □ □ □ □ ■ ■ □ 
□ □ □ □ ■ ■ □ □ □ □ 
□ □ □ □ ■ ■ □ □ □ □ 
```

C# Inventory After Sorting:
C# Grid:
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
□ □ □ □ □ □ □ □ □ □ 
```

GDScript: Sort inventory benchmark (1 iterations) took 0.000075 seconds
C#: Sort inventory benchmark (1 iterations) took 0.000014 seconds
Benchmark complete!
GDScript time: 0.000075 seconds
C# time: 0.000014 seconds
C# is 5.40 times faster than GDScript

Running Sort Inventory benchmark with 10 iterations:
GDScript: Sort inventory benchmark (10 iterations) took 0.000698 seconds
C#: Sort inventory benchmark (10 iterations) took 0.000044 seconds
Benchmark complete!
GDScript time: 0.000698 seconds
C# time: 0.000044 seconds
C# is 15.76 times faster than GDScript

Running Sort Inventory benchmark with 100 iterations:
GDScript: Sort inventory benchmark (100 iterations) took 0.006762 seconds
C#: Sort inventory benchmark (100 iterations) took 0.000341 seconds
Benchmark complete!
GDScript time: 0.006762 seconds
C# time: 0.000341 seconds
C# is 19.84 times faster than GDScript

## Conclusion

Based on the benchmark results, we can draw the following conclusions:

1. Find Available Space Benchmark:
   - For a single iteration, GDScript and C# perform similarly, with GDScript being slightly faster.
   - As the number of iterations increases, C# significantly outperforms GDScript, being up to 140 times faster for 100 iterations.

2. Sort Inventory Benchmark:
   - C# consistently outperforms GDScript across all iteration counts.
   - The performance gap widens as the number of iterations increases, with C# being about 5 times faster for a single iteration and nearly 20 times faster for 100 iterations.

Overall, while GDScript performs adequately for simple operations or low iteration counts, C# demonstrates superior performance for computationally intensive tasks and higher iteration counts. This suggests that for performance-critical parts of a game, especially those involving complex calculations or frequent updates, using C# can provide significant performance benefits.

Since most inventory related operations only have 1 iteration, GDScript is perfectly suitable. No one will notice the performance difference.
