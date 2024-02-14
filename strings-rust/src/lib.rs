mod utils;

use wasm_bindgen::prelude::*;

// When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
// allocator.
#[cfg(feature = "wee_alloc")]
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

static HTML_DOC_TYPE: &'static str = "<!doctype html>";
static HTML_TAG_EN: &'static str = "<html lang=en>";
static HTML_CHARSET: &'static str = "<meta charset=\"utf-8\">";

#[wasm_bindgen]
extern {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet() {
    alert("Hello, strings-rust!");
}

#[wasm_bindgen]
pub fn htmlDocType() -> String {
    return HTML_DOC_TYPE.to_string();
}

#[wasm_bindgen]
pub fn htmlTagEn() -> String {
    return HTML_TAG_EN.to_string();
}

#[wasm_bindgen]
pub fn htmlCharset() -> String {
    return HTML_CHARSET.to_string();
}
