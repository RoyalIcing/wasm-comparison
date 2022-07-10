const mem = @import("std").mem;
const ComptimeStringMap = @import("std").ComptimeStringMap;
const EnumArray = @import("std").EnumArray;

const Switch = struct {
    pub const State = enum(u8) {
        off,
        on,
    };

    pub const Event = enum {
        flick,

        pub fn apply(self: Event, state: State) State {
            switch (self) {
                .flick => {
                    return switch (state) {
                        State.off => State.on,
                        State.on => State.off,
                    };
                }
            }
        }
    };

    fn flick(self: Switch) Switch {
        var copy = self;
        copy.state = switch (self.state) {
            State.off => State.on,
            State.on => State.off,
        };
        return copy;
    }

    const EventHandlers = ComptimeStringMap(fn (Switch) Switch, .{.{ @tagName(Event.flick), Switch.flick }});

    const Events = ComptimeStringMap(Event, .{.{ @tagName(Event.flick), .flick }});
    const EventHandlers2 = EnumArray(Event, fn (Switch) Switch).init(.{ .flick = Switch.flick });

    state: State,

    pub fn next(self: Switch, event: [:0]const u8) Switch {
        if (Events.get(event)) |e| {
            var copy = self;
            copy.state = e.apply(self.state);
            return copy;
        }
        // if (EventHandlers.get(event)) |h| {
        //     return h(self);
        // }
        // if (Events.get(event)) |v| {
        //     return EventHandlers2.get(v)(self);
        // }

        return self;
    }
};

export var current = Switch{ .state = Switch.State.off };

export fn flick() void {
    current = current.next("flick");
}

export fn toString() [*:0]const u8 {
    return @tagName(current.state);
}
