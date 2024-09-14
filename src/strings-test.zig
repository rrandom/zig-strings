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

test "split - basic functionality" {
    const str = "apple,banana,cherry";
    var iter = strings.split(str, ",");

    try expectEqualStrings("apple", iter.first());
    try expectEqualStrings("banana", iter.next().?);
    try expectEqualStrings("cherry", iter.next().?);
    try expectEqual(@as(?[]const u8, null), iter.next());
}

test "split - empty string" {
    const str = "";
    var iter = strings.split(str, ",");

    try expectEqualStrings("", iter.first());
    try expectEqual(@as(?[]const u8, null), iter.next());
}

test "split - no delimiter" {
    const str = "hello";
    var iter = strings.split(str, ",");

    try expectEqualStrings("hello", iter.first());
    try expectEqual(@as(?[]const u8, null), iter.next());
}

test "split - multiple consecutive delimiters" {
    const str = "a,,b,,,c";
    var iter = strings.split(str, ",");

    try expectEqualStrings("a", iter.first());
    try expectEqualStrings("", iter.next().?);
    try expectEqualStrings("b", iter.next().?);
    try expectEqualStrings("", iter.next().?);
    try expectEqualStrings("", iter.next().?);
    try expectEqualStrings("c", iter.next().?);
    try expectEqual(@as(?[]const u8, null), iter.next());
}

test "split - reset functionality" {
    const str = "1:2:3";
    var iter = strings.split(str, ":");

    try expectEqualStrings("1", iter.first());
    try expectEqualStrings("2", iter.next().?);
    iter.reset();
    try expectEqualStrings("1", iter.next().?);
    try expectEqualStrings("2", iter.next().?);
    try expectEqualStrings("3", iter.next().?);
    try expectEqual(@as(?[]const u8, null), iter.next());
}

test "split - rest functionality" {
    const str = "a:b:c:d";
    var iter = strings.split(str, ":");

    try expectEqualStrings("a", iter.first());
    try expectEqualStrings("b", iter.next().?);
    try expectEqualStrings("c:d", iter.rest());
    try expectEqualStrings("c", iter.next().?);
    try expectEqualStrings("d", iter.rest());
}
