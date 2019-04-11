String.prototype.endWith = function(str) {
  if (str == null || str == "" || this.length == 0 || str.length > this.length)
    return false;
  if (this.substring(this.length - str.length) == str)
    return true;
  else
    return false;
  return true;
}



// 去掉空格
function trim(value) {
  if (value) {
    value = value.replace(/^\s*|\s*$/g, "");
    if (value == 'null')
      return "";
  }
  if (!value)
    return "";
  else
    return value;
}

// 如果输入框中有"&"符号，替换掉
function trimstr(value) {
  if (value)
    value = value.replace(/^\s*|\s*$/g, "");
  if (!value)
    return "";
  else
    return value = value.replace(/&/g, "");
}

// 对参数编码
function encodeStr(val) {
  return encodeURIComponent(encodeURIComponent(trim(val)));
}

// 打开模式窗口
function openModal(url, args, width, height) {
  var ua = navigator.userAgent.toLowerCase();
  if (!width) {
    width = window.screen.availWidth - 10;
  }

  if (!height) {
    height = window.screen.availHeight - 30;
  } else {
    if (window.ActiveXObject && ua.indexOf('msie 6.') >= 0) { // IE6
      height = height + 40;
    }
  }

  if (!args)
    args = "";

  var rtn = window.showModalDialog(url, args, 'dialogWidth=' + width + 'px;dialogHeight=' + height + 'px;resizeable=no;scroll=no;status=no;help=no;');
  return rtn;
}

// 打开普通窗口居中，自定义大小，可最大化
function openWindow(url, width, height) {
  var ua = navigator.userAgent.toLowerCase();
  if (!width) {
    width = window.screen.availWidth - 10;
  }
  if (!height) {
    height = window.screen.availHeight - 30;
  } else {
    var ua = navigator.userAgent.toLowerCase();
    if (window.ActiveXObject && ua.indexOf('msie 6.') >= 0) { // IE6
      height = height + 40;
    }
  }
  var Left_size = (screen.width) ? (screen.width - width) / 2 : 0;
  var Top_size = (screen.height) ? (screen.height - height) / 2 : 0;
  window.open(url, '_blank', 'width=' + width + 'px, height=' + height + 'px, left=' + Left_size + 'px, top=' + Top_size + 'px,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
}

function dateAdd(mydate, type, add) {
  if (type == "dd") { // 天
    mydate.setDate(mydate.getDate() + add)
  }

  if (type == "MM") { // 月
    mydate.setMonth(mydate.getMonth() + add)
  }

  if (type == "yyyy") { // 年
    mydate.setFullYear(mydate.getFullYear() + add)
  }
  return mydate;
}

// 检测val是否在str中; str的格式为"xxx1,xxx2"
function inVal(val, str) {
  if (trim(val) == "")
    return false;
  var flag = false;
  var arr = str.split(",");
  for (var i = 0; i < arr.length; i++) {
    if (val == arr[i]) {
      flag = true;
      break;
    }
  }
  return flag;
}

// 主要用来保存select 对象动态加载数据后变形的问题.
function setAutoSize(id) {
  jQuery(id).width(100);
  jQuery(id).css('width', '100%');
}

function disableByExp(exp) {
  jq(exp).each(function() {
        if (jq(this).attr('tagName') == 'SELECT' || jq(this).attr('type') == 'checkbox' || jq(this).attr('type') == 'radio') {
          jq(this).wrap('<span onmousemove= "this.setCapture(); " onmouseout= "this.releaseCapture(); "></span>');
          jq(this).focus(function() {
                this.blur();
              });
        } else {
          jq(this).attr("readOnly", "readOnly");
        }
      });
}

/**
 * 替换参数值
 * 
 * @param {}
 *          params
 * @param {}
 *          name
 * @param {}
 *          val
 * @return {}
 */
function addParam(params, name, val) {
  // 是否含jsp
  var jsp = "";
  var pos_jsp = params.indexOf(".jsp");
  if (pos_jsp > -1) {
    jsp = params.substring(0, pos_jsp + 4);
    params = params.substr(pos_jsp + 5);
  }

  // 是否以&为首
  var pre_sp = false;
  if (params.length > 0) {
    if (params.indexOf("&") != 0) {
      params = "&" + params;
    } else {
      pre_sp = true;
    }
  }

  var u = "";
  var tem = "&" + name + "=";
  var start = params.indexOf(tem);
  if (start > -1) {
    var next = params.substring(start + ("&" + name + "=").length).indexOf("&");
    u = params.substring(0, start + 1) + name + "=" + val
    if (next > -1)
      u = u + params.substring(start + ("&" + name + "=").length).substring(next);
  } else {
    u = params + "&" + name + "=" + val;
  }

  // 去掉第一个&
  if (!pre_sp) {
    u = u.substr(1);
  }

  // 合并jsp
  if (jsp) {
    u = jsp + "?" + u;
  }
  return u;
}

/**
 * 分析参数串中的参数值
 * 
 * @param {}
 *          params
 * @param {}
 *          name
 * @return {}
 */
function getParam(params, name) {
  params = params.replace("\?", "&");
  if (params.indexOf('&') != 0) {
    params = "&" + params;
  }

  var u = "";
  var tem = "&" + name + "=";
  var start = params.indexOf(tem);
  if (start > -1) {
    params = params.substring(start + 1);;
    var next = params.indexOf("&");
    if (next > -1) {
      u = params.substring(0, next);
    } else {
      u = params;
    }
  }

  var arr = u.split("=");
  if (u.length > 1) {
    return arr[1];
  } else {
    return "";
  }
}

// 打印前, 隐藏select
function hideSelect(exp) {
  jq(exp).each(function() {
        var t = "";
        if (this.selectedIndex >= 0) {
          t = this.options[this.selectedIndex].text
        }
        jq("<span/>").html(t).addClass("selectText").insertBefore(this);
        jq(this).hide();
      });
}

// 打印后,显示select
function showSelect(exp) {
  jq(exp).show()
  jq(".selectText").remove();
}

// Ext通用tips
function cellTip(value, meta, rec, rowIdx, colIdx, ds) {
  if (!value)
    return "";

  var title = '';
  meta.attr = "ext:qtitle='" + title + "'" + "ext:qtip='" + value + "'";
  var displayText = value;
  return displayText;
};

// 全角替换成半角字符
function CtoH(val) {
  var str = val
  var result = "";
  for (var i = 0; i < str.length; i++) {
    if (str.charCodeAt(i) == 12288) {
      result += String.fromCharCode(str.charCodeAt(i) - 12256);
      continue;
    }
    if (str.charCodeAt(i) > 65280 && str.charCodeAt(i) < 65375)
      result += String.fromCharCode(str.charCodeAt(i) - 65248);
    else
      result += String.fromCharCode(str.charCodeAt(i));
  }
  return result;
}

// textarea-自动文字高度
function setTextAutoHeight(Obj) {
  if (jQuery("#_hidetextarea").length <= 0) {
    jQuery("body").append("<textarea id='_hidetextarea'></textarea>");
  }

  jQuery("#_hidetextarea").css({
        "height" : 0,
        "width" : jQuery(Obj).width(),
        "border-width" : "0px",
        "overflow" : "hidden",
        "display" : "inline"
      });
  jQuery("#_hidetextarea").val(jQuery(Obj).val());
  var HideTextarea = document.getElementById("_hidetextarea");
  jQuery(Obj).css("height", Math.max(jQuery(Obj).height(), HideTextarea.scrollHeight + 2));
}

// textarea-自动文字高度
function setTextHeight(exp, iskeyup) {
  jQuery(exp).each(function() {
        setTextAutoHeight(this);
      });

  if (iskeyup) {
    jQuery(exp).bind("keyup", function() {
          setTextAutoHeight(this)
        });
  }

  jQuery("#_hidetextarea").css({
        "display" : "none"
      });

}

// 日期转string(2014-01-01)
function dateToStr(datetime) {
  var year = datetime.getFullYear();
  var month = datetime.getMonth() + 1;// js从0开始取
  var date = datetime.getDate();

  if (month < 10) {
    month = "0" + month;
  }
  if (date < 10) {
    date = "0" + date;
  }

  var time = year + "-" + month + "-" + date; // 2009-06-12
  return time;
}

// 时间字符串2014-01-01, 转换成Date
function strToDate(str) {
  if (!str)
    return null;

  var mydate = new Date();
  mydate.setFullYear(parseInt(str.split("-")[0], 10));
  mydate.setMonth(parseInt(str.split("-")[1], 10) - 1);
  mydate.setDate(parseInt(str.split("-")[2], 10));

  return mydate;
}
