const std = @import("std");
const Allocator = std.mem.Allocator;

const common = @import("./common.zig");

pub fn run(gpa: Allocator) !void {
    const input = try common.readFile("inputs/day2", gpa);

    var invalid_sum_1: usize = 0;
    var invalid_sum_2: usize = 0;
    var iter = common.commaIterator(input);
    while (iter.next()) |range_str| {
        var low, const high = try parseRange(gpa, common.strip(range_str));
        while (low.val <= high.val) {
            if (!low.isValidPart1()) invalid_sum_1 += low.val;
            if (!low.isValidPart2()) invalid_sum_2 += low.val;
            try low.incr();
        }
    }

    std.debug.print("Invalid sum (part 1): {d}\n", .{invalid_sum_1});
    std.debug.print("Invalid sum (part 2): {d}\n", .{invalid_sum_2});
}

fn parseRange(gpa: Allocator, range: []u8) !struct { Id, Id } {
    var hyphenIdx: usize = 0;
    while (hyphenIdx < range.len) {
        if (range[hyphenIdx] == '-') break;
        hyphenIdx += 1;
    }
    if (hyphenIdx == range.len) unreachable;

    const low = try std.fmt.parseInt(usize, range[0..hyphenIdx], 10);
    const high = try std.fmt.parseInt(usize, range[hyphenIdx+1..], 10);

    const low_id = try Id.init(gpa, low);
    const high_id = try Id.init(gpa, high);

    return .{low_id, high_id};
}

const Id = struct {
    val: usize,
    buf: []u8,
    str: []u8 = undefined,

    pub fn init(gpa: Allocator, val: usize) !Id {
        var id: Id = .{
            .val = val,
            .buf = try gpa.alloc(u8, 256),
        };
        try id.updateStr();
        return id;
    }

    pub fn deinit(self: *Id, gpa: Allocator) void {
        gpa.free(self.str);
    }

    fn updateStr(self: *Id) !void {
        self.str = try std.fmt.bufPrint(self.buf, "{d}", .{self.val});
    }

    pub fn incr(self: *Id) !void {
        self.val += 1;
        try self.updateStr();
    }

    pub fn isValidPart1(self: *Id) bool {
        if (@mod(self.str.len, 2) != 0) {
            return true;
        }
        const half_len: usize = self.str.len / 2;
        for (0..half_len) |i| {
            if (self.str[i] != self.str[half_len + i]) return true;
        }
        return false;
    }

    /// In part 2, an ID is valid if it is composed of any repeated sequence
    /// of digits that's repeated at least twice.
    pub fn isValidPart2(self: *Id) bool {
        if (self.str.len == 1) return true;
        var upper_bound: usize = undefined;
        if (self.str.len == 2) {
            upper_bound = 3;
        } else {
            upper_bound = @divTrunc(self.str.len, 2) + 1;
        }
        for (1..upper_bound) |seq_len| {
            if (@mod(self.str.len, seq_len) != 0) continue;
            const num_seqs = @divTrunc(self.str.len, seq_len);
            if (num_seqs < 2) continue;
            var all_match = true;
            for (0..seq_len) |i| {
                for (1..num_seqs) |j| {
                    if (self.str[i + j * seq_len] != self.str[i]) {
                        all_match = false;
                        break;
                    }
                }
                if (!all_match) break;
            }
            if (all_match) {
                return false;
            }
        }
        return true;
    }
};

