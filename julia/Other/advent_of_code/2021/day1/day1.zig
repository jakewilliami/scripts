const std = @import("std");
const fs = std.fs;
const io = std.io;
const ArrayList = std.ArrayList;
// const testing_allocator = std.testing.allocator;
const parseInt = std.fmt.parseInt;

pub fn main() !void {
    // Parse input
    var file = try fs.cwd().openFile("data1.txt", .{});
    defer file.close();
    var buf_reader = io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    var arena_state = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena_state.deinit();
    const allocator = arena_state.allocator();
    var data = ArrayList(isize).init(allocator);
    defer data.deinit();
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try data.append((try parseInt(isize, line, 10)));
    }
    // std.debug.print("{}", .{data});

    // Part 1
    const part1_solution = part1(data);
    std.debug.print("Part 1: {}\n", .{part1_solution});

    // Part 2
    const part2_solution = part2(data);
    std.debug.print("Part 2: {}\n", .{part2_solution});
}

fn part1(data: ArrayList(isize)) isize {
    var cnt: isize = 0;
    {
        var i: usize = 1;
        while (i < data.items.len) : (i += 1) {
            if (data.items[i - 1] < data.items[i]) {
                cnt += 1;
            }
        }
    }
    return cnt;
}

fn part2(data: ArrayList(isize)) isize {
    var cnt: isize = 0;
    {
        var i: usize = 3;
        while (i < data.items.len) : (i += 1) {
            const a: isize = data.items[i - 1] + data.items[i - 2] + data.items[i - 3];
            const b: isize = data.items[i] + data.items[i - 1] + data.items[i - 2];
            if (a < b) {
                cnt += 1;
            }
        }
    }
    return cnt;
}
