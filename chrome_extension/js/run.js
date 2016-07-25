function run()
{
    var tt = document.getElementById("captcha");
    var img = tt.nextElementSibling;
    
    var text = ocr(img);
    tt.value = text;
}

window.onload = run;
var att = document.getElementById("captcha");
var btt = att.nextElementSibling;
btt.onclick = function(){setTimeout(run, 300);}
