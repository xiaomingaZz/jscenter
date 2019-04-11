//JavaScript Document
(function($){
	$.fn.extend({
		scroll:function(options,moveComplete){
			//滚动速度,值越大速度越慢,每行的高度
			var defaults = {speed:40,rowHeight:24};
			var opts = $.extend({}, defaults, options),intId = [];
			function marquee(obj, step){
				obj.find("ul").animate({marginTop:"-=1"},0,function(){
					var s = Math.abs(parseInt($(this).css("margin-top")));
					if(s >= step){
						$(this).find("li").slice(0, 1).appendTo($(this));
						$(this).css("margin-top", 0);
						if(obj.find("ul li:first").attr("id")=='1'){
							moveComplete();
						}
					}
				});
			}
			this.each(function(i){
				var sh = opts["rowHeight"],speed = opts["speed"],_this = $(this);
				intId[i] = setInterval(function(){
					if(_this.find("ul").height()<=_this.height()){
						clearInterval(intId[i]);
					}else{
						marquee(_this, sh);
					}
				}, speed);
				_this.hover(function(){
					clearInterval(intId[i]);
				},function(){
					intId[i] = setInterval(function(){
						if(_this.find("ul").height()<=_this.height()){
							clearInterval(intId[i]);
						}else{
							marquee(_this, sh);
						}
					}, speed);
				});
			});
		}
	});
})(jQuery);