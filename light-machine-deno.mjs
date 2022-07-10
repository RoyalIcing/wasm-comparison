const decodeUTF8 = new TextDecoder();
const encodeUTF8 = new TextEncoder();

// const memory = new WebAssembly.Memory({
//   initial: 65536,
//   maximum: 65536,
// });

let instance;

function getStringAt(ptr) {
  const memory = new Uint8Array(instance.exports.memory.buffer);
  const endPtr = memory.indexOf(0, ptr);
  return decodeUTF8.decode(memory.subarray(ptr, endPtr));
}

WebAssembly.instantiate(await Deno.readFile("light-machine-zig.wasm"), {
  env: {
    waitMs: (ms) => {
      setTimeout(() => {
        instance.exports.tick();
        instance.exports.main();
        console.log(instance.exports.getChange());
        console.log(getStringAt(instance.exports.toString()));
      }, ms);
    },
  },
}).then((result) => {
  instance = result.instance;

  console.log(instance.exports.getChange());
  console.log(getStringAt(instance.exports.toString()));

  instance.exports.main();
});
