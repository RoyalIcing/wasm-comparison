export function startTrafficLights({ waitMs }) {
    let count = 0;
    let state = "Red";

    return {
        get value() {
            return Object.freeze({ count, state });
        },
        main() {
            waitMs(3000);
        },
        next(event) {
            if (event === "tick") {
                count++;
                if (state === "Red") {
                    state = "Green";
                } else if (state === "Green") {
                    state = "Yellow";
                } else if (state === "Yellow") {
                    state = "Red";
                }
            }
            return { value: this.value, done: false };
        },
    };
}