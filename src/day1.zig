const std = @import("std");
const Allocator = std.mem.Allocator;

const common = @import("./common.zig");

pub fn run(gpa: Allocator) !void {
    const input = try common.readFile("inputs/day1", gpa);

    var line_buf: [16]u8 = undefined;
    var buf_index: usize = 0;

    var dial: Dial = .{};
    for (input, 0..) |char, i| {
        if (char == '\n' or i == input.len - 1) {
            // Add the last character if we're at the end
            if (i == input.len - 1 and char != '\n') {
                line_buf[buf_index] = char;
                buf_index += 1;
            }

            const dir: Direction = switch (line_buf[0]) {
                'L' => Direction.Left,
                'R' => Direction.Right,
                else => unreachable,
            };
            const amount = try std.fmt.parseInt(usize, line_buf[1..buf_index], 10);
            dial.turn(dir, amount);
            buf_index = 0;
        } else {
            line_buf[buf_index] = char;
            buf_index += 1;
        }
    }

    std.debug.print("Num zeros  (part 1): {d}\n", .{dial.num_zeros});
    std.debug.print("Num passes (part 2): {d}\n", .{dial.num_passes});
}

const Direction = enum { Left, Right };

const Dial = struct {
    // Current position of the dial
    position: i32 = 50,
    // Number of times the dial has landed on zero
    num_zeros: i32 = 0,
    // Number of times the dial has passed zero
    num_passes: i32 = 0,

    pub fn turn(self: *Dial, dir: Direction, amount: usize) void {
        const sign: i32 = switch(dir) {
            Direction.Left => -1,
            Direction.Right => 1,
        };
        for (0..amount) |_| {
            self.position = @mod(@mod(self.position + 1 * sign, 100) + 100, 100);
            if (self.position == 0) {
                self.num_passes += 1;
            }
        }
        if (self.position == 0) {
            self.num_zeros += 1;
        }
    }
};
