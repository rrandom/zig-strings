const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const expectEqualStrings = std.testing.expectEqualStrings;
const strings = @import("strings.zig");

test "indexOfCharUsize" {
    const str = "hello world";
    try expectEqual(@as(?usize, 4), strings.indexOfCharUsize(str, 'o'));
    try expectEqual(@as(?usize, null), strings.indexOfCharUsize(str, 'x'));
    try expectEqual(@as(?usize, null), strings.indexOfCharUsize("", 'a'));
}

test "indexOfChar" {
    const str = "hello world";
    try expectEqual(@as(?u32, 4), strings.indexOfChar(str, 'o'));
    try expectEqual(@as(?u32, null), strings.indexOfChar(str, 'x'));
    try expectEqual(@as(?u32, null), strings.indexOfChar("", 'a'));
}

test "containsChar" {
    const str = "hello world";
    try expect(strings.containsChar(str, 'o'));
    try expect(!strings.containsChar(str, 'x'));
    try expect(!strings.containsChar("", 'a'));
}

test "contains" {
    const str = "hello world";
    try expect(strings.contains(str, "world"));
    try expect(!strings.contains(str, "zig"));
    try expect(!strings.contains("", "a"));
}

test "containsT" {
    const str = [_]u32{ 1, 2, 3, 4, 5 };
    const substr = [_]u32{ 3, 4 };
    try expect(strings.containsT(u32, &str, &substr));
    try expect(!strings.containsT(u32, &str, &[_]u32{ 6, 7 }));
}

test "indexOf" {
    const str = "hello world";
    try expectEqual(@as(?usize, 6), strings.indexOf(str, "world"));
    try expectEqual(@as(?usize, null), strings.indexOf(str, "zig"));
    try expectEqual(@as(?usize, null), strings.indexOf("", "a"));
}

test "indexOfT" {
    const str = [_]u32{ 1, 2, 3, 4, 5 };
    const substr = [_]u32{ 3, 4 };
    try expectEqual(@as(?usize, 2), strings.indexOfT(u32, &str, &substr));
    try expectEqual(@as(?usize, null), strings.indexOfT(u32, &str, &[_]u32{ 6, 7 }));
}
