const mem = @import("std").mem;
const ComptimeStringMap = @import("std").ComptimeStringMap;
const testing = @import("std").testing;

extern fn waitMs(i32) void;

const Switch = struct {
    pub const State = enum(u8) {
        red,
        green,
        yellow,
    };

    pub const Event = enum {
        tick,

        pub fn transition(self: Event, state: State) State {
            switch (self) {
                .tick => {
                    return switch (state) {
                        State.red => State.green,
                        State.green => State.yellow,
                        State.yellow => State.red,
                    };
                },
            }
        }
    };

    const Events = ComptimeStringMap(Event, .{.{ @tagName(Event.tick), .tick }});

    state: State,
    change: u64 = 0,

    pub fn transition(self: Switch, event: Event) Switch {
        var copy = self;
        copy.state = event.transition(self.state);
        copy.change += 1;
        return copy;
    }

    pub fn next(self: Switch, eventName: [:0]const u8) Switch {
        if (Events.get(eventName)) |event| {
            return self.transition(event);
        }

        return self;
    }
};

var current = Switch{ .state = .red };

export fn getChange() u64 {
    return current.change;
}

test "getChange()" {
    try testing.expectEqual(@as(u64, 0), getChange());
    tick();
    try testing.expectEqual(@as(u64, 1), getChange());
    tick();
    try testing.expectEqual(@as(u64, 2), getChange());
}

export fn main() void {
    waitMs(3000);
}

export fn tick() void {
    current = current.transition(.tick);
}

test "tick()" {
    try testing.expect(current.state == .red);
    tick();
    try testing.expect(current.state == .green);
    tick();
    try testing.expect(current.state == .yellow);
    tick();
    try testing.expect(current.state == .red);
}

export fn toString() [*:0]const u8 {
    return @tagName(current.state);
}

test "toString()" {
    try testing.expectEqualSlices(u8, mem.span(toString()), "red");
    tick();
    try testing.expectEqualSlices(u8, mem.span(toString()), "green");
    tick();
    try testing.expectEqualSlices(u8, mem.span(toString()), "yellow");
}
