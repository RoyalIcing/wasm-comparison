import * as JS from "./strings.js";

const { instance } = await WebAssembly.instantiate(await Deno.readFile("strings-zig.wasm"))

Deno.bench("wasm, new TextDecoder", () => {
  const htmlBeginEn = instance.exports.htmlBeginEn;
  
  const memory = new Uint8Array(instance.exports.memory.buffer);
  const ptr = htmlBeginEn();
  const endPtr = memory.indexOf(0, ptr);
  
  const utf8decoder = new TextDecoder();
  const string = utf8decoder.decode(memory.subarray(ptr, endPtr));
});

const utf8decoder = new TextDecoder();
Deno.bench("wasm, reuse TextDecoder", () => {
  const htmlBeginEn = instance.exports.htmlBeginEn;
  
  const memory = new Uint8Array(instance.exports.memory.buffer);
  const ptr = htmlBeginEn();
  const endPtr = memory.indexOf(0, ptr);
  
  const string = utf8decoder.decode(memory.subarray(ptr, endPtr));
});

Deno.bench("wasm, then join strings in JavaScript", () => {
  const htmlBeginEn = instance.exports.htmlBeginEn;
  
  const memory = new Uint8Array(instance.exports.memory.buffer);
  const ptr = htmlBeginEn();
  const endPtr = memory.indexOf(0, ptr);
  
  const string1 = utf8decoder.decode(memory.subarray(ptr, endPtr));
  const string2 = utf8decoder.decode(memory.subarray(ptr, endPtr));
  const string3 = utf8decoder.decode(memory.subarray(ptr, endPtr));
  [string1, string2, string3].join("\n");
});

Deno.bench("javascript module", () => {
  const string = JS.htmlBeginEn();
});

Deno.bench("javascript module, then join strings in JavaScript", () => {
  const string1 = JS.htmlBeginEn();
  const string2 = JS.htmlBeginEn();
  const string3 = JS.htmlBeginEn();
  [string1, string2, string3].join("\n");
});
