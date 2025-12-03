const std = @import("std");

const day1 = @import("./day1.zig");

const input = @embedFile("./inputs/day1");

const Error = error {
    MissingDay,
    InvalidDay,
};

pub fn main() !void {
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
        1 => day1.run(),
        else => {
            std.debug.print("Invalid day: {d}\n", .{day});
            return Error.InvalidDay;
        }
    }
}
