$(function(){
    sjjy();
    function sjjy(){
        alert("1");
        bindRq();
        //initTree([{'contentid':'ywcbContent','treeid':'ywcbTree','inputid':'ywcb','selected':['<%=fydm%>'],'expand':true,'hide':false,
        //	'valueid':'ywcbValue','onClick':ywcbClick,'url':contextPath+'/webapp/spxt/sjzl/sjzl_tree.jsp?'+"FYDM="+fydm}]);

        //initTree([{'contentid':'gzContent','treeid':'gz_tree','inputid':'gz_text','expand':true,'hide':true,
        //	'valueid':'gz','url':contextPath+'/webapp/spxt/sjzl/sjzl_gz_tree.jsp'}]);

        var wds = new Array();


        wds.push({
            'contentid':'ywcbContent',
            'treeid':'ywcbTree',
            'inputid':'ywcb',
            'selected':['<%=fydm%>'],
            'expand':true,
            'hide':false,
            'valueid':'ywcbValue',
            'onClick':ywcbClick,
            'url':contextPath+'/webapp/spxt/sjzl/sjzl_tree.jsp?'+"FYDM="+fydm
        });

        wds.push({
            'contentid':'gz_content',
            'treeid':'gz_tree',
            'inputid':'gz_text',
            'expand':true,
            'hide':true,
            'valueid':'gz',
            'url':contextPath+'/webapp/spxt/sjzl/sjzl_gz_tree.jsp'
        });

        initTree(wds);

        sizeChange(true);
        loadTable(1,true);
    }
});