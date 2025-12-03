const std = @import("std");
const Allocator = std.mem.Allocator;
const Reader = std.Io.Reader;

pub fn readFile(path: []const u8, gpa: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const buf: []u8 = undefined;
    var reader = file.reader(buf);
    const file_size = try reader.getSize();
    return try Reader.readAlloc(&reader.interface, gpa, file_size);
}
