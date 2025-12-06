const std = @import("std");
const Allocator = std.mem.Allocator;

const common = @import("./common.zig");

pub fn run(gpa: Allocator) !void {
    const input = try common.readFile("inputs/day3", gpa);
    var iter = common.lineIterator(input);
    var total_joltage_1: usize = 0;
    var total_joltage_2: usize = 0;
    while (iter.next()) |bank| {
        total_joltage_1 += getMaxJoltagePart1(common.strip(bank));
        total_joltage_2 += getMaxJoltagePart2(common.strip(bank));
    }
    std.debug.print("Total joltage (part 1): {d}\n", .{total_joltage_1});
    std.debug.print("Total joltage (part 2): {d}\n", .{total_joltage_2});
}

fn getMaxJoltagePart1(bank: []u8) usize {
    const tens_idx = getMaxIndex(bank, 0, bank.len - 1);
    const ones_idx = getMaxIndex(bank, tens_idx + 1, bank.len);
    std.debug.assert(tens_idx != ones_idx);
    const tens_place: usize = @intCast(bank[tens_idx] - 48);
    const ones_place: usize = @intCast(bank[ones_idx] - 48);
    const max_joltage = tens_place * 10 + ones_place;
    return max_joltage;
}

fn getMaxJoltagePart2(bank: []u8) usize {
    var digits: [12]u8 = undefined;
    var start: usize = 0;
    for (0..12) |i| {
        const idx = getMaxIndex(bank, start, bank.len - 11 + i);
        digits[i] = bank[idx];
        start = idx + 1;
    }

    var max_joltage: usize = 0;
    for (digits, 1..) |chr, i| {
        const digit: usize = @intCast(chr - 48);
        max_joltage += digit * std.math.pow(usize, 10, 12 - i);
    }
    return max_joltage;
}

fn getMaxIndex(str: []u8, start: usize, end: usize) usize {
    var max_byte: u8 = 0;
    var max_idx: usize = 0;
    for (str[start..end], start..) |chr, i| {
        if (chr > max_byte) {
            max_byte = chr;
            max_idx = i;
        }
    }
    return max_idx;
}
