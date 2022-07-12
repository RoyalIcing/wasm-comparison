export function startSwitch() {
    let count = 0;
    let state = "off";

    return {
        get value() {
            return Object.freeze({ count, state });
        },
        next(event) {
            if (event === "flick") {
                count++;
                if (state === "off") {
                    state = "on";
                } else {
                    state = "off";
                }
            }
            return { value: this.value, done: false };
        },
    };
}