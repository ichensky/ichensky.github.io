var n=function(h) { return parseInt(h,0x00000023) };
var s=n("1t");
var ss=n("1t")/1.28;	

// Hello, $username <<, what are you looking for? 

var max=0;
function textlist() {
	max=textlist.arguments.length;
	for (i=0;i<max;i++)this[i]=textlist.arguments[i];
}

var b="sh-2.1# blog ";
tl=new textlist
(
	b+"-url ",
	"https://ichensky.github.io ",
	b+"-username ",
	"ichensky ",
	b+"-name ",
	"Ivan Chensky ",
	b+"-interest ",
	"Web, scripts, C#, DDD, linux ",
	b+"-moto ",
	"The geeks shall inherit the properties and methods of object earth "
);

var text_x=0; pos=0;
var l=tl[0].length;

(function tt() {
	document.f.ft.value=tl[text_x].substring(0,pos)+"_";

	if(pos++==l) {
		pos=0;
		setTimeout(tt,s << 5);
		text_x++;
		if(text_x==max) text_x=0;
		l=tl[text_x].length;
	} else setTimeout(tt,ss);
})()

var t=" ichensky.github.io © Ivan Chensky | ";
(function pageTitle() {
	t=t.substring(1, t.length)+t.substring(0, 1);
	document.title=t;
	setTimeout(pageTitle,s<<1);
})()
