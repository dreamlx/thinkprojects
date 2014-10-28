// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function CheckAll(chk)
{

    var a = document.getElementsByTagName('input');
    var n = a.length;
    for (var i=0; i<n; i++){
        if((a[i].type == "checkbox") && ( a[i].name.search(chk) != -1 )){
            a[i].checked = true;
        }
    }
}

function UnCheckAll(chk)
{
    var a = document.getElementsByTagName('input');
    var n = a.length;
    for (var i=0; i<n; i++){
        if((a[i].type == "checkbox") && ( a[i].name.search(chk) != -1 )){
            a[i].checked=false;
        }
    }
}

function UnCheck(chk){
    var a = document.getElementsByTagName('input');
    var n = a.length;
    for (var i=0; i<n; i++){
        if((a[i].type == "checkbox") && ( a[i].name.search(chk) != -1 )){
            if(a[i].checked == true){
                a[i].checked=false
            }else{
                a[i].checked = true
            };
        }
    }
}

function DoAll(chk,state)
{
    if (state){
        CheckAll(chk)
    }else{
        UnCheckAll(chk)
    };
}