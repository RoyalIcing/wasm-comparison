const mem = @import("std").mem;
const ComptimeStringMap = @import("std").ComptimeStringMap;

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

export fn toString() [*:0]const u8 {
    return @tagName(current.state);
}
