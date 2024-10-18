using Godot;
using System.Diagnostics;
using System.Text;
using System.Linq;
using System.Collections.Generic;
using System;

public partial class CsTest : Node2D
{
    private const int GridWidth = 10;
    private const int GridHeight = 10;
    private const int ItemSize = 2;

    private int[] inventory;

    public override void _Ready()
    {
        InitializeWorstCaseInventory();
        PrintGrid();
    }

    private void InitializeWorstCaseInventory()
    {
        inventory = new int[GridWidth * GridHeight];
        for (int i = 0; i < inventory.Length; i++)
        {
            inventory[i] = 1; // 1 represents an occupied cell
        }

        // Create a 2x2 empty space near the end
        int emptyX = GridWidth - ItemSize;
        int emptyY = GridHeight - ItemSize;
        for (int dy = 0; dy < ItemSize; dy++)
        {
            for (int dx = 0; dx < ItemSize; dx++)
            {
                inventory[GetIndex(emptyX + dx, emptyY + dy)] = 0;
            }
        }
    }

    public double BenchmarkFindSpace(int iterations)
    {
        var stopwatch = new Stopwatch();
        stopwatch.Start();

        for (int i = 0; i < iterations; i++)
        {
            FindNextAvailableSpace();
        }

        stopwatch.Stop();
        double elapsedTime = stopwatch.Elapsed.TotalSeconds;
        GD.Print($"C#: Find space benchmark ({iterations} iterations) took {elapsedTime:F6} seconds");
        return elapsedTime;
    }

    private Vector2I FindNextAvailableSpace()
    {
        for (int y = 0; y <= GridHeight - ItemSize; y++)
        {
            for (int x = 0; x <= GridWidth - ItemSize; x++)
            {
                if (IsSpaceAvailable(x, y))
                {
                    return new Vector2I(x, y);
                }
            }
        }
        return new Vector2I(-1, -1); // No space available
    }

    private bool IsSpaceAvailable(int x, int y)
    {
        for (int dy = 0; dy < ItemSize; dy++)
        {
            for (int dx = 0; dx < ItemSize; dx++)
            {
                if (inventory[GetIndex(x + dx, y + dy)] != 0)
                {
                    return false;
                }
            }
        }
        return true;
    }

    private int GetIndex(int x, int y)
    {
        return y * GridWidth + x;
    }

    private void PrintGrid()
    {
        GD.Print("C# Grid:");
        StringBuilder sb = new StringBuilder();
        for (int y = 0; y < GridHeight; y++)
        {
            for (int x = 0; x < GridWidth; x++)
            {
                sb.Append(inventory[GetIndex(x, y)] == 0 ? "□ " : "■ ");
            }
            GD.Print(sb.ToString());
            sb.Clear();
        }
        GD.Print("");
    }

    public void InitializeInventoryForSorting()
    {
        inventory = new int[GridWidth * GridHeight];
        int[] items = { 1, 2, 3, 4, 5 };
        int[][] positions = {
            new int[] { 2, 2 }, new int[] { 5, 1 },
            new int[] { 1, 5 }, new int[] { 7, 6 },
            new int[] { 4, 8 }
        };

        for (int i = 0; i < items.Length; i++)
        {
            PlaceItem(items[i], positions[i][0], positions[i][1]);
        }
    }

    private void PlaceItem(int item, int x, int y)
    {
        for (int dy = 0; dy < ItemSize; dy++)
        {
            for (int dx = 0; dx < ItemSize; dx++)
            {
                inventory[GetIndex(x + dx, y + dy)] = item;
            }
        }
    }

    public double BenchmarkSortInventory(int iterations)
    {
        var stopwatch = new Stopwatch();
        stopwatch.Start();

        for (int i = 0; i < iterations; i++)
        {
            SortInventory();
        }

        stopwatch.Stop();
        double elapsedTime = stopwatch.Elapsed.TotalSeconds;
        GD.Print($"C#: Sort inventory benchmark ({iterations} iterations) took {elapsedTime:F6} seconds");
        return elapsedTime;
    }

    private void SortInventory()
    {
        var items = new List<(int item, int x, int y)>();

        // Find all items
        for (int y = 0; y < GridHeight; y++)
        {
            for (int x = 0; x < GridWidth; x++)
            {
                int item = inventory[GetIndex(x, y)];
                if (item != 0 && !items.Exists(i => i.item == item))
                {
                    items.Add((item, x, y));
                }
            }
        }

        // Clear the inventory
        Array.Clear(inventory, 0, inventory.Length);

        // Place items back in order
        foreach (var (item, _, _) in items.OrderBy(i => i.item))
        {
            Vector2I position = FindNextAvailableSpace();
            if (position.X != -1 && position.Y != -1)
            {
                PlaceItem(item, position.X, position.Y);
            }
        }
    }

    public void PrintInventoryForSorting()
    {
        GD.Print("C# Inventory Before Sorting:");
        PrintGrid();
        SortInventory();
        GD.Print("C# Inventory After Sorting:");
        PrintGrid();
    }
}
