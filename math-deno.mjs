WebAssembly.instantiate(await Deno.readFile("math-zig.wasm"), {
  env: {
    print: (result) => {
      console.log(`The result is ${result}`);
    },
  },
}).then((result) => {
  console.log(result.instance.exports);
  const add = result.instance.exports.add;

  add(1, 2);
  add(5, 7);
});

WebAssembly.instantiate(await Deno.readFile("math-go.wasm"), {
  env: {
    "main.Print": (result) => {
      console.log(`The result is ${result}`);
    },
  },
}).then((result) => {
  console.log(result.instance.exports);
  // const add = result.instance.exports.add;

  // add(1, 2);
  // add(5, 7);
});
