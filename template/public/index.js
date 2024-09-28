const username = "ichensky";
const n = function (v) { return (parseInt(v, 0x00000016) >> 12) };
const s = n(username);

// Hello, $username <<. 

let max=0;
function textlist() {
	max=textlist.arguments.length;

    for (i = 0; i < max; i++) {
        this[i] = textlist.arguments[i];
    }
}

const b = "sh-2.1# blog ";
const tl = new textlist
    (
        b + "-url ", "https://ichensky.github.io ",
        b + "-username ", username + " ",
        b + "-name ", "Ivan Chensky ",
        b + "-interest ", "Web, scripts, C#, DDD, linux ",
        b + "-moto ", "The geeks shall inherit the properties and methods of object earth "
    );

let text_x = 0;
let pos = 0;
let l = tl[0].length;

(function tt() {
    document.f.ft.value = tl[text_x].substring(0, pos) + "_";

    if (pos++ == l) {
        pos = 0;
        setTimeout(tt, s << 5);
        text_x++;

        if (text_x == max) {
            text_x = 0;
        }

        l = tl[text_x].length;
    } else {
        setTimeout(tt, s);
    }
})()

let t = " ichensky.github.io © Ivan Chensky | ";
(function pageTitle() {
    t = t.substring(1, t.length) + t.substring(0, 1);
    document.title = t;
    setTimeout(pageTitle, s << 2);
})()