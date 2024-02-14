const std = @import("std");

export fn f32tostring(a: f32, buf: [*]u8) void {
    // var buf: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(buf[0..100]);
    var string = std.ArrayList(u8).init(fba.allocator());
    // try std.json.stringify(x, .{}, string.writer());

    std.fmt.formatFloatDecimal(a, .{}, string.writer()) catch unreachable;
}

export fn is_valid_file_name(input: [*:0]const u8) bool {
    var i: usize = 0;
    while (true) {
        const char = input[i];
        if (char == 0) {
            return true;
        }
        if (char == '/') {
            return false;
        }
        i += 1;
    }
    return true;
}
