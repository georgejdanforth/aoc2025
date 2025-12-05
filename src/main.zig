const std = @import("std");

const day1 = @import("./day1.zig");
const day2 = @import("./day2.zig");

const input = @embedFile("./inputs/day1");

const Error = error {
    MissingDay,
    InvalidDay,
};

pub fn main() !void {
    var general_purpose_allocator: std.heap.GeneralPurposeAllocator(.{}) = .init;
    const gpa = general_purpose_allocator.allocator();

    var args_iter = std.process.args();
    if (!args_iter.skip()) unreachable;

    const day_buf = args_iter.next();
    if (day_buf == null) {
        std.debug.print("Missing day\n", .{});
        return Error.MissingDay;
    }
    const day = std.fmt.parseInt(u32, day_buf.?, 10) catch |err| {
        std.debug.print("Invalid day: {s}", .{day_buf.?});
        return err;
    };

    switch (day) {
        1 => try day1.run(gpa),
        2 => try day2.run(gpa),
        else => {
            std.debug.print("Invalid day: {d}\n", .{day});
            return Error.InvalidDay;
        }
    }
}
