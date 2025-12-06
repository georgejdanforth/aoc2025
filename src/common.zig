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

pub const StringIterator = struct {
    data: []u8,
    delimiter: u8,
    offset: usize = 0,

    pub fn init(data: []u8, delimiter: u8) StringIterator {
        return .{
            .data = data,
            .delimiter = delimiter
        };
    }

    pub fn next(self: *StringIterator) ?[]u8 {
        if (self.offset >= self.data.len) {
            return null;
        }
        const start = self.offset;
        var end = self.offset;
        while (end < self.data.len and self.data[end] != self.delimiter) {
            end += 1;
        }
        if (end > self.data.len) {
            self.offset = self.data.len;
            return null;
        }
        const line = self.data[start..end];
        self.offset = end + 1;
        return line;
    }
};

pub fn lineIterator(data: []u8) StringIterator {
    return StringIterator.init(data, '\n');
}

pub fn commaIterator(data: []u8) StringIterator {
    return StringIterator.init(data, ',');
}

pub fn isWhitespace(chr: u8) bool {
    return chr == ' ' or chr == '\r' or chr == '\t' or  chr == '\n';
}

pub fn strip(str: []u8) []u8 {
    var new_str = str;
    while (new_str.len > 0 and isWhitespace(new_str[0])) {
        new_str = new_str[1..];
    }
    while (new_str.len > 0 and isWhitespace(new_str[new_str.len - 1])) {
        new_str = new_str[0..new_str.len - 1];
    }
    return new_str;
}
