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
