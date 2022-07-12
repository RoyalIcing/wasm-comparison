const mem = @import("std").mem;
const testing = @import("std").testing;

const Switch = struct {
    state: u8,
    change: u64 = 0,

    pub fn flick(self: Switch) Switch {
        var copy = self;
        if (copy.state == 0) {
            copy.state = 1;
        } else {
            copy.state = 0;
        }
        copy.change += 1;
        return copy;
    }

    pub fn next(self: Switch, eventName: [:0]const u8) Switch {
        if (mem.eql(u8, "flick", eventName)) {
            return self.flick();
        }

        return self;
    }
};

var current = Switch{ .state = 0 };

export fn getChange() u64 {
    return current.change;
}

test "getChange()" {
    try testing.expectEqual(@as(u64, 0), getChange());
    flick();
    try testing.expectEqual(@as(u64, 1), getChange());
    flick();
    try testing.expectEqual(@as(u64, 2), getChange());
}

export fn flick() void {
    current = current.flick();
}

test "flick()" {
    try testing.expect(current.state == .off);
    flick();
    try testing.expect(current.state == .on);
    flick();
    try testing.expect(current.state == .off);
}

export fn next(eventName: [*:0]const u8) void {
    current = current.next(mem.span(eventName));
}

test "next()" {
    try testing.expect(current.state == .off);
    next("blah");
    try testing.expect(current.state == .off);
    next("flick");
    try testing.expect(current.state == .on);
    next("flick");
    try testing.expect(current.state == .off);
}

export fn toString() [*:0]const u8 {
    if (current.state == 0) {
        return "off";
    } else {
        return "on";
    }
}

test "toString()" {
    try testing.expectEqualSlices(u8, mem.span(toString()), "off");
    flick();
    try testing.expectEqualSlices(u8, mem.span(toString()), "on");
}
