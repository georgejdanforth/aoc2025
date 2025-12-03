const std = @import("std");
const Allocator = std.mem.Allocator;

const common = @import("./common.zig");

pub fn run(gpa: Allocator) !void {
    const input = try common.readFile("inputs/day1", gpa);

    var line_buf: [16]u8 = undefined;
    var buf_index: usize = 0;

    var position: i32 = 50;
    var num_zeros: i32 = 0;

    for (input, 0..) |char, i| {
        if (char == '\n' or i == input.len - 1) {
            const sign: i32 = switch (line_buf[0]) {
                'L' => -1,
                'R' => 1,
                else => unreachable,
            };
            const raw_val = try std.fmt.parseInt(i32, line_buf[1..buf_index], 10);
            const val = @mod(raw_val, 100) * sign;

            position += val;
            position = @mod(@mod(position, 100) + 100, 100);
            if (position == 0) num_zeros += 1;

            std.debug.print("{s} :: {d} :: {d}\n", .{line_buf[0..buf_index], val, position});

            buf_index = 0;
        } else {
            line_buf[buf_index] = char;
            buf_index += 1;
        }
    }

    std.debug.print("Num zeros: {d}\n", .{num_zeros});
}
