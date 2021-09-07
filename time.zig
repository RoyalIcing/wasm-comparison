const std = @import("std");

export fn now() i128 {
    return std.time.timestamp();
}
