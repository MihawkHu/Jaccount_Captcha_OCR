function run()
{
    var img = document.getElementById("imageValidate");
    var text = ocr(img);
    var tt = document.getElementById("captcha");
    
    tt.value = text;
}

window.onload = run;
var btt = document.getElementById("imageValidate");
btt.onclick = function(){setTimeout(run, 300);}
btt.parentNode.onclick = function(){setTimeout(run, 300);}
