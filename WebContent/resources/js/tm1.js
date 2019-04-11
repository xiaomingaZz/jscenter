$(function(){
    sjjy();

});
function sjjy(){
    loadTable(1,true);
}
function jyJk(){
    console.log("11");
    $('#table').html('');
    $('#mainContent').attr("src","http://localhost:8080/webapp/rarrz/main.jsp");
    $('#mainContent').contentWindow.location.reload(true);
}