export GOROOT = $(shell go env GOROOT)

ls_zig:
	ls -l *.zig *-zig.wasm

hello: hello.zig
	zig build-exe hello.zig

hello-zig.wasm: hello.zig
	zig build-lib hello.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name hello-zig
	@ls -l $@

hello-as.wasm: hello.ts
	npx -y -p assemblyscript asc hello.ts -b hello-as.wasm --optimize
	@ls -l $@

constants-zig.wasm: constants.zig
	zig build-lib constants.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name constants-zig
	@ls -l $@

strings-zig.wasm: strings.zig
	zig build-lib strings.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name strings-zig
	@ls -l $@
	@shasum -a 256 $@

state-machine-zig.wasm: state-machine.zig
	rm -rf zig-cache/
	zig build-lib state-machine.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name state-machine-zig
	@ls -l $@
	@shasum -a 256 $@

light-machine-zig.wasm: light-machine.zig
	rm -rf zig-cache/
	zig build-lib light-machine.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name light-machine-zig
	@ls -l $@
	@shasum -a 256 $@

math-zig.wasm: math.zig
	zig build-lib math.zig -target wasm32-freestanding -dynamic -O ReleaseSmall --name math-zig
	@ls -l $@

math-go.wasm: math.go
	tinygo build -o math-go.wasm -target wasm -gc=none ./math.go
	@ls -l $@

math-rust.wasm: math.rs
	arch -x86_64 npx -y wasm-pack build --target web ./math-rust
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

deno_strings:
	deno run --allow-read strings-deno.mjs
	deno bench --unstable --allow-read strings-deno-bench.mjs

deno_state_machine:
	deno run --allow-read state-machine-deno.mjs
	#deno bench --unstable --allow-read strings-deno-bench.mjs

test_state_machine_zig: state-machine.zig
	#rm -rf zig-cache/
	zig test state-machine.zig

deno_light_machine:
	deno run --allow-read light-machine-deno.mjs

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
