const testing = @import("std").testing;

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

test "is_valid_file_name()" {
    try testing.expect(is_valid_file_name("abc") == true);
    try testing.expect(is_valid_file_name("a/bc") == false);
}