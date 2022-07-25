const decodeUTF8 = new TextDecoder();
const encodeUTF8 = new TextEncoder();

const { instance } = await WebAssembly.instantiate(await Deno.readFile("external-regexp-zig.wasm"), {
  env: {
    matchAsciiCount: (input, pattern) => {
      input = getStringAt(input);
      pattern = getStringAt(pattern);
      const re = new RegExp(pattern, "g");
      const result = re.exec(input);
      console.log("matchCount:", JSON.stringify([input, pattern]), re.lastIndex);
      return re.lastIndex;
    },
  },
});

const memory = new Uint8Array(instance.exports.memory.buffer);
function getStringAt(ptr) {
  // Search for null-terminating byte.
  const endPtr = memory.indexOf(0, ptr);
  // Get subsection of memory between start and end, and decode it as UTF-8.
  return decodeUTF8.decode(memory.subarray(ptr, endPtr));
}

function parse(input) {
  encodeUTF8.encodeInto(`${input}\0`, memory);
  const result = instance.exports.parse(memory);
  console.log(JSON.stringify(input), result === 1);
}

parse("hello")
parse("123")
parse("4f")
parse("45f")
parse("456f")
parse("0")
parse("1000")
parse("1234567890")
