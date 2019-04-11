/**
 * @author 曾庆威
 * @date 2015-04-22
 */

function initEcharts(types,dist_path,callBackFunction){
	types.unshift('echarts');
	require.config({
		paths: {
			echarts: dist_path
		}
	});
	require(types,callBackFunction);
}

/**
 *加载图表数据
 * @param url：加载的路径
 * @param args:传递的参数{field:value}
 * @param isjson:是不是标准的json格式
 * @param callBack 异步回调函数 返回一个json格式数据
 */
function loadOption(url,args,isjson,callback){
	$.ajax({
		type: "POST",
		url: url+"?etc="+new Date().getTime(),
		data: args,
		success: function(msg){
			if(isjson){
				callback(eval('('+msg+')'));
			}else{
				callback(eval($.trim(msg)));
			}
		}
	});
}

function loadOption1(url,args,callback){
	$.ajax({
		type: "POST",
		url: url+"?etc="+new Date().getTime(),
		data: args,
		//dataType:"json",
		success: function(msg){
			callback(msg);
		}
	});
}

function createEchart(echart,id,url,args,callback){
	var line = echart.init(document.getElementById(id));
	line.showLoading({
		text: "图表数据正在努力加载...",
		x: "center",
		y: "center",
		textStyle: {
			fontSize:13
		},
		//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'，
		effect:"whirling"
	});
	loadOption(url,args,true,function(args){
		line.hideLoading();
		callback(line,args);
	});
}

function getOption_pie(title,legdata,serdata,radius,center,legx,legy,name,orient,emp){
	if(center==null||center==undefined){
		center=["50%","50%"];
	}
	if(radius==null||radius==undefined){
		radius="50%";
	}
	if(name==null||name==undefined){
		name="";
	}
	if(emp==undefined){
		emp=false;
	}
	return getOption(title,legdata,[],
			[{
				name:name,
				type:'pie',
				center: center,
				radius :radius,
				legendHoverLink:true,
				itemStyle : {
					normal : {
						label : {show : false},
						labelLine : {show : false}
					},
					emphasis : {
	                    label : {
	                        show : emp,
	                        position : 'center',
	                        textStyle : {
	                            fontSize : '18',
	                            fontWeight : 'bold'
	                        }
	                    }
	                }
				},				
				data:serdata
			}],[],[],{trigger:'item',formatter: "{b}:{c}({d}%)"},legx,legy,{x:0,y:0,x2:0,y2:0,borderWidth:0},orient);
}

function getOption(title,legdata,xdata,series,xAxis,yAxis,tooltip,legx,legy,grid,orient){
	var option={};
	if(grid==undefined||grid==null){
		grid = {x:45,y:40,x2:20,y2:30};
	}
	option["grid"]=grid;
	if(tooltip==undefined||tooltip==null){
		tooltip={trigger: "axis"};
	}
	option["tooltip"]=tooltip;
	var showTitle=true;
	if(title==undefined||title==null||title==''){
		showTitle=false;
		title='';
	}
	option["title"]={show:showTitle,text:title};
	if(legx==undefined||legx==null||legx==''){
		legx = "right";
	}
	if(legy==undefined||legy==null||legy==''){
		legy = "top";
	}
	if(orient ==undefined||orient==null||orient==''){
		orient = "horizontal";
	}
	option["legend"]={data:legdata,x:legx,y:legy,orient:orient};
	option["calculable"]=false;
	if(xAxis==undefined||xAxis==null){
		xAxis=[{type : 'category',boundaryGap : false,data : xdata}];
	}
	option["xAxis"]=xAxis;
	if(yAxis==undefined||yAxis==null){
		yAxis=[{type : 'value',axisLabel : {formatter: '{value}'}}];
	}
	option["yAxis"]= yAxis;
	option["series"]=series;
	return option;
}