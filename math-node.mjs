import fs from 'fs';

const source = fs.readFileSync("./math-zig.wasm");
const typedArray = new Uint8Array(source);

WebAssembly.instantiate(typedArray, {
  env: {
    print: (result) => { console.log(`The result is ${result}`); }
  }}).then(result => {
  const add = result.instance.exports.add;
  
  add(1, 2);
  add(5, 7);
});
