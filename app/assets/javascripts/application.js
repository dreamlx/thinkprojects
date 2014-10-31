// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap-sprockets
//= require jquery_nested_form
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