hello: hello.zig
	zig build-exe hello.zig

hello-zig.wasm: hello.zig
	zig build-lib hello.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name hello-zig
	@ls -l $@

math-zig.wasm: math.zig
	zig build-lib math.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name math-zig
	@ls -l $@

math-go.wasm: math.go
	tinygo build -o math-go.wasm -target wasm -gc=none ./math.go
	@ls -l $@

time-zig.wasm: time.zig
	zig build-lib time.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name time-zig
	@ls -l $@

time-go.wasm: time.go
	tinygo build -o time-go.wasm -target wasm -gc=none ./time.go
	@ls -l $@

wasm: math-zig.wasm math-go.wasm

deno:
	@deno run --allow-read math-deno.mjs

node:
	@node math-node.mjs

format:
	@zig fmt *.zig

test:
	zig test math.zig

db:
	zig build db

clean:
	rm -rf zig-cache
