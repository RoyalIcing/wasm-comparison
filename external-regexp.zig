const testing = @import("std").testing;

extern fn matchAsciiCount([*:0]const u8, [*:0]const u8) u32;

export fn parse(input: [*:0]const u8) bool {
    var cursor = input;
    while (true) {
        // If we reached the end: the null termination byte
        if (cursor[0] == 0) {
            // Success
            return true;
        }
        const first = matchAsciiCount(cursor, "\\d{1,2}");
        // If this did not match
        if (first == 0) {
            // Failure!
            return false;
        }

        cursor += first;
    }
    return true;
}
