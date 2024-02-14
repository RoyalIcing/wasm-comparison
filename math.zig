// const std = @import("std");

extern fn print(i32) void;

export fn add(a: i32, b: i32) void {
    print(a + b);
}

export fn bswap32(a: u32) u32 {
    return @byteSwap(a);
}

export fn powf(a: f32, b: f32) f32 {
    return @exp(a * @log(b));
}
