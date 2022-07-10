const memory = new WebAssembly.Memory({
  initial: 65536,
  maximum: 65536,
})

WebAssembly.instantiate(await Deno.readFile("state-machine-zig.wasm"), {
  env: {
    print: (result) => {
      console.log(`The result is ${result}`);
    },
  },
}).then((result) => {
  const memory = new Uint8Array(result.instance.exports.memory.buffer);

  console.log(result.instance.exports);
  console.log(result.instance.exports.current);
  console.log(result.instance.exports.current.value);
  console.log(memory[result.instance.exports.current.value]);
  
  console.log(result.instance.exports.flick());
  console.log(result.instance.exports.current.value);
  console.log(memory[result.instance.exports.current.value]);
});
