const memory = new WebAssembly.Memory({
  initial: 65536,
  maximum: 65536,
})

WebAssembly.instantiate(await Deno.readFile("strings-zig.wasm"), {
  env: {
    print: (result) => {
      console.log(`The result is ${result}`);
    },
  },
}).then((result) => {
  console.log(result.instance.exports);
  const htmlBeginEn = result.instance.exports.htmlBeginEn;

  const memory = new Uint8Array(result.instance.exports.memory.buffer);
  const ptr = htmlBeginEn();
  const endPtr = memory.indexOf(0, ptr);

  const utf8decoder = new TextDecoder();
  console.log(
    utf8decoder.decode(memory.subarray(ptr, endPtr)).length,
    JSON.stringify(utf8decoder.decode(memory.subarray(ptr, endPtr)))
  );
});
