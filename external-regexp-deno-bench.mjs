const decodeUTF8 = new TextDecoder();
const encodeUTF8 = new TextEncoder();

const { instance } = await WebAssembly.instantiate(await Deno.readFile("external-regexp-zig.wasm"), {
  env: {
    matchAsciiCount: (input, pattern) => {
      input = getStringAt(input);
      pattern = getStringAt(pattern);
      const re = new RegExp(pattern, "g");
      const result = re.exec(input);
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
}

Deno.bench("wasm: hello", () => {
  parse("hello")
});

Deno.bench("wasm: 123", () => {
  parse("123")
});

Deno.bench("wasm: 1234567890", () => {
  parse("1234567890")
});

function matchAsciiCount(input, pattern) {
  const re = new RegExp(pattern, "g");
  const result = re.exec(input);
  return re.lastIndex;
}

Deno.bench("js: hello", () => {
  matchAsciiCount("hello", "\\d{1,2}")
});

Deno.bench("js: 123", () => {
  matchAsciiCount("123", "\\d{1,2}")
});

Deno.bench("js: 1234567890", () => {
  matchAsciiCount("1234567890", "\\d{1,2}")
  matchAsciiCount("34567890", "\\d{1,2}")
  matchAsciiCount("567890", "\\d{1,2}")
  matchAsciiCount("7890", "\\d{1,2}")
  matchAsciiCount("90", "\\d{1,2}")
  matchAsciiCount("", "\\d{1,2}")
});
