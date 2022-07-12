import { file } from 'bun';

const decodeUTF8 = new TextDecoder();
const encodeUTF8 = new TextEncoder();

console.time('instantiate wasm');
const { instance } = await WebAssembly.instantiate(await file("state-machine-zig.wasm").arrayBuffer(), {
    env: {
        print: (result) => {
            console.log(`The result is ${result}`);
        },
    },
});
console.timeEnd('instantiate wasm');

console.time('execute wasm');
const memory = new Uint8Array(instance.exports.memory.buffer);

function getStringAt(ptr) {
    const endPtr = memory.indexOf(0, ptr);
    return decodeUTF8.decode(memory.subarray(ptr, endPtr));
}

console.log(instance.exports.getChange());
console.log(getStringAt(instance.exports.toString()));

instance.exports.flick();
console.log(instance.exports.getChange());
console.log(getStringAt(instance.exports.toString()));

encodeUTF8.encodeInto("flickk", memory);
// encodeUTF8.encodeInto("flick\u{00}", memory);
encodeUTF8.encodeInto("flick\0", memory);
instance.exports.next(memory);
console.log(instance.exports.getChange());
console.log(getStringAt(instance.exports.toString()));

console.timeEnd('execute wasm');
