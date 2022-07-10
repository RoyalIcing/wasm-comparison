const mem = @import("std").mem;
const ComptimeStringMap = @import("std").ComptimeStringMap;
const testing = @import("std").testing;

const Switch = struct {
    pub const State = enum(u8) {
        off,
        on,
    };

    pub const Event = enum {
        flick,

        pub fn transition(self: Event, state: State) State {
            switch (self) {
                .flick => {
                    return switch (state) {
                        State.off => State.on,
                        State.on => State.off,
                    };
                },
            }
        }
    };

    const Events = ComptimeStringMap(Event, .{.{ @tagName(Event.flick), .flick }});

    state: State,

    pub fn next(self: Switch, eventName: [:0]const u8) Switch {
        if (Events.get(eventName)) |event| {
            var copy = self;
            copy.state = event.transition(self.state);
            return copy;
        }

        return self;
    }
};

export var current = Switch{ .state = .off };

export fn flick() void {
    current = current.next("flick");
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
    return @tagName(current.state);
}

test "toString()" {
    try testing.expectEqualSlices(u8, mem.span(toString()), "off");
    next("flick");
    try testing.expectEqualSlices(u8, mem.span(toString()), "on");
}
