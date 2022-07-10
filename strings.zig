// const std = @import("std");

const HTML_DOC_TYPE = "<!doctype html>";
const HTML_TAG_EN = "<html lang=en>";
const HTML_CHARSET = "<meta charset=\"utf-8\">";

export fn htmlDocType() [*:0]const u8 {
    return HTML_DOC_TYPE;
}

export fn htmlTagEn() [*:0]const u8 {
    return HTML_TAG_EN;
}

export fn htmlCharset() [*:0]const u8 {
    return HTML_CHARSET;
}

// const HTML_BEGIN_EN = HTML_DOC_TYPE ++ HTML_TAG_EN ++ HTML_CHARSET;

export fn htmlBeginEn() [*:0]const u8 {
    return HTML_DOC_TYPE ++ HTML_TAG_EN ++ HTML_CHARSET;
}
