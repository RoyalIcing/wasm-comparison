const decodeUTF8 = new TextDecoder();
const encodeUTF8 = new TextEncoder();

// const memory = new WebAssembly.Memory({
//   initial: 65536,
//   maximum: 65536,
// });

WebAssembly.instantiate(await Deno.readFile("state-machine-zig.wasm"), {
  env: {
    print: (result) => {
      console.log(`The result is ${result}`);
    },
  },
}).then((result) => {
  const memory = new Uint8Array(result.instance.exports.memory.buffer);

  function getStringAt(ptr) {
    const endPtr = memory.indexOf(0, ptr);
    return decodeUTF8.decode(memory.subarray(ptr, endPtr));
  }

  console.log(getStringAt(result.instance.exports.toString()));
  
  result.instance.exports.flick();
  console.log(getStringAt(result.instance.exports.toString()));
  
  encodeUTF8.encodeInto("flickk", memory);
  // encodeUTF8.encodeInto("flick\u{00}", memory);
  encodeUTF8.encodeInto("flick\0", memory);
  result.instance.exports.next(memory);
  console.log(getStringAt(result.instance.exports.toString()));
});
