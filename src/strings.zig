const std = @import("std");

pub const string = []const u8;
pub const stringZ = [:0]const u8;
pub const CodePoint = i32;

pub fn indexOfCharUsize(slice: string, char: u8) ?usize {
    if (slice.len == 0)
        return null;

    return std.mem.indexOfScalar(u8, slice, char);
}

pub fn indexOfChar(slice: string, char: u8) ?u32 {
    return @as(u32, @truncate(indexOfCharUsize(slice, char) orelse return null));
}

pub inline fn containsChar(self: string, char: u8) bool {
    return indexOfChar(self, char) != null;
}

pub inline fn contains(self: string, str: string) bool {
    return containsT(u8, self, str);
}

pub inline fn containsT(comptime T: type, self: []const T, str: []const T) bool {
    return indexOfT(T, self, str) != null;
}

pub inline fn indexOf(self: string, str: string) ?usize {
    return std.mem.indexOf(u8, self, str);
}

pub fn indexOfT(comptime T: type, haystack: []const T, needle: []const T) ?usize {
    if (T == u8) return indexOf(haystack, needle);
    return std.mem.indexOf(T, haystack, needle);
}

fn assert(condition: bool) void {
    if (!condition) {
        unreachable;
    }
}

pub fn split(self: string, delimiter: string) SplitIterator {
    return SplitIterator{
        .buffer = self,
        .index = 0,
        .delimiter = delimiter,
    };
}

pub const SplitIterator = struct {
    buffer: []const u8,
    index: ?usize,
    delimiter: []const u8,

    const Self = @This();

    /// Returns a slice of the first field. This never fails.
    /// Call this only to get the first field and then use `next` to get all subsequent fields.
    pub fn first(self: *Self) []const u8 {
        assert(self.index.? == 0);
        return self.next().?;
    }

    /// Returns a slice of the next field, or null if splitting is complete.
    pub fn next(self: *Self) ?[]const u8 {
        const start = self.index orelse return null;
        const end = if (indexOf(self.buffer[start..], self.delimiter)) |delim_start| blk: {
            const del = delim_start + start;
            self.index = del + self.delimiter.len;
            break :blk delim_start + start;
        } else blk: {
            self.index = null;
            break :blk self.buffer.len;
        };

        return self.buffer[start..end];
    }

    /// Returns a slice of the remaining bytes. Does not affect iterator state.
    pub fn rest(self: Self) []const u8 {
        const end = self.buffer.len;
        const start = self.index orelse end;
        return self.buffer[start..end];
    }

    /// Resets the iterator to the initial slice.
    pub fn reset(self: *Self) void {
        self.index = 0;
    }
};
