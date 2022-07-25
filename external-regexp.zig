const testing = @import("std").testing;

extern fn matchAsciiCount([*:0]const u8, [*:0]const u8) u32;

export fn parse(input: [*:0]const u8) bool {
    var cursor = input;
    while (true) {
        if (cursor[0] == 0) {
            return true;
        }
        const first = matchAsciiCount(cursor, "\\d{1,2}");
        if (first == 0) {
            return false;
        }

        cursor += first;
    }
    return true;
}
