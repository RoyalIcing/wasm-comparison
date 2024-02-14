# WebAssembly Comparison

How do different languages decide to represent things in WebAssembly?

This project uses a Makefile to define tasks to compile each `.wasm` file. To compile a particular `.wasm` file, run passing the file name to `make` like so:

```sh
make math-zig.wasm
make math-go.wasm
make math-rust.wasm
```

## Links

- https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format
- https://blog.scottlogic.com/2019/05/17/webassembly-compiler.html
- https://rustwasm.github.io/wasm-bindgen/contributing/design/exporting-rust.html
- https://hacks.mozilla.org/2017/07/memory-in-webassembly-and-why-its-safer-than-you-think/
- https://hacks.mozilla.org/2017/07/webassembly-table-imports-what-are-they/
- https://github.com/xtuc/webassemblyjs/blob/master/packages/helper-wasm-bytecode/src/index.js
- https://crates.io/crates/wasm-encoder | https://docs.rs/wasm-encoder/latest/wasm_encoder/
- https://github.com/xtuc/webassemblyjs/blob/master/packages/wasm-gen/src/encoder/index.js
- https://hexdocs.pm/wasm/Wasm.html
- https://github.com/WebAssembly/binaryen
- https://blog.suborbital.dev/get-started-with-webassembly-using-typescript-part-1
- https://blog.suborbital.dev/foundations-wasm-in-golang-is-fantastic
- https://github.com/saghul/wasi-lab
- https://github.com/wasienv/wasienv
- https://github.com/mbasso/awesome-wasm
- https://github.com/appcypher/awesome-wasm-langs
- https://github.com/fastly/Viceroy
- https://github.com/jedisct1/zigly
- https://wasmbyexample.dev/examples/exports/exports.assemblyscript.en-us.html

### Zig

- https://www.huy.rocks/everyday/01-04-2022-zig-strings-in-5-minutes
