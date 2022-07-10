import * as JS from "./strings.js";

const { instance } = await WebAssembly.instantiate(await Deno.readFile("strings-zig.wasm"))

Deno.bench("wasm", () => {
  const htmlBeginEn = instance.exports.htmlBeginEn;
  
  const memory = new Uint8Array(instance.exports.memory.buffer);
  const ptr = htmlBeginEn();
  const endPtr = memory.indexOf(0, ptr);
  
  const utf8decoder = new TextDecoder();
  const string = utf8decoder.decode(memory.subarray(ptr, endPtr));
});

const utf8decoder = new TextDecoder();
Deno.bench("wasm 2", () => {
  const htmlBeginEn = instance.exports.htmlBeginEn;
  
  const memory = new Uint8Array(instance.exports.memory.buffer);
  const ptr = htmlBeginEn();
  const endPtr = memory.indexOf(0, ptr);
  
  const string = utf8decoder.decode(memory.subarray(ptr, endPtr));
});

Deno.bench("javascript module", () => {
  const string = JS.htmlBeginEn();
});
