const std = @import("std");
const testing = std.testing;

const strings = @import("strings.zig");

test "basic add functionality" {
    try testing.expect(strings.add(3, 7) == 10);
}
