const decodeUTF8 = new TextDecoder();

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
  console.log(memory[result.instance.exports.current.value]);
  
  result.instance.exports.flick();

  console.log(getStringAt(result.instance.exports.toString()));
  console.log(memory[result.instance.exports.current.value]);
});
