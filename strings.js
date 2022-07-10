export const htmlDocType = "<!doctype html>";
export const htmlTagEn = "<html lang=en>";
export const htmlCharset = "<meta charset=\"utf-8\">";

export function htmlBeginEn() {
    return htmlDocType + htmlTagEn + htmlCharset;
}