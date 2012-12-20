<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user == null) {
		response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
	}
%>
<script type="text/javascript">
var g_user = "<%= user.getEmail() %>";
</script>
<!-- 
	************************************************************
	********* below here is the same as jsp version. ***********
	************************************************************
-->

<link href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css" rel="stylesheet">
<style>
body {
  padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
}

textarea {
  width: 100%;
}

#subtitleHolder {
  padding-top: 10px;
}

div.status {
  display: none;
  position: fixed;
  right: 40px;
  top: 50px;
}


</style>
<title>つぶやくようにCoursera和訳 web Ver. Stats</title>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript">

function isLocal() {
   return typeof(g_test_srt) != "undefined";
}

function ajaxPost(url, param, onSuccess, postType){
   if(isLocal()) {
	   return dummyPost(url, param, onSuccess, postType);
   } else {
	   return $.post(url, param, onSuccess, postType);
   }
}

function ajaxGet(url, onSuccess){
	if(isLocal()) {
		dummyGet(url, onSuccess);
	} else {
		$.get(url, onSuccess);
	}
}

function ajaxGeneral(param) {
	if(isLocal()) {
		dummyAjax(param);
	} else {
		$.ajax(param);
	}
}

function onTextsComming(texts){
	var count = 0;
	for(var i =0; i < texts.length; i++) {
		if(texts[i].target != "")
			count++;
	}
	$('#resultDiv').html(count + "/" + texts.length);

}

function onCalcStatsStart() {
	notifyStatus("calc...", STATUS_STICK);
	var srtId = $('#srtList option:selected')[0].value;
	ajaxGet("/_je/text?cond=srtId.eq." + srtId, function (result) {
		onTextsComming(result);
		notifyStatus("done", STATUS_TIMED);
	});
}

function getSrts(){
 debugLog("get srts...");
 // var BASE = "http://subtitleliketweets.appspot.com";
 ajaxGet("/_je/srt", function (result) {
    notifyStatus("", STATUS_HIDE);
	var sel = $('#srtList');
	for(var i = 0; i <result.length; i++){
		sel.append($('<option>').attr({value: result[i]._docId}).text(result[i].srtTitle));
	}
	btnStartEnable(true);
 });
}


$(function(){
	notifyStatus("setup...", STATUS_STICK);
	getSrts();
 });

function debugLog(msg){
	if (console) {
		console.log(msg);        
	}
}

var STATUS_STICK =1;
var STATUS_TIMED =2;
var STATUS_HIDE =3;
var g_status = STATUS_HIDE;

function notifyDone() {
	if(g_status == STATUS_TIMED){
		$("div.status").fadeOut(1000);
		g_status =STATUS_HIDE
	}
}

function notifyWaitLong() {
	setTimeout(notifyDone, 1000);
}

function notifyStatus(msg, typ){
	$("div.status").html(msg);
	if(typ == STATUS_STICK) {
		g_status = STATUS_STICK;
		$("div.status").html(msg).fadeIn(1000);
		return;
	}
	if(typ == STATUS_TIMED) {
		g_status = STATUS_TIMED;
		$("div.status").html(msg).fadeIn(1000, notifyWaitLong);
		return;
	}
	if(typ == STATUS_HIDE){
		g_status = STATUS_HIDE;
		$("div.status").fadeOut(1000);
	}
}

function btnStartEnable(isEnable) {
	if(isEnable) {
			$("#btnSrtChoose").removeAttr("disabled");
	} else {
			$("#btnSrtChoose").attr("disabled", true);
	}
}

</script>
</head>

<body>
<div class="navbar navbar-inverse navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container">
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      <div class="nav-collapse collapse">
        <ul class="nav">
		  <li><a href="subtitle.jsp">Home</a></li>
          <li class="active"><a href="#">Stats</a></li>
          <li><a href="notice.html">Notice</a></li>
        </ul>
      </div><!--/.nav-collapse -->
    </div>
  </div>
</div>
<div class="status label label-info">status</div>
<div class="container">
  <div class="input-append">
    <select class="span5" id="srtList"></select>
    <input id="btnSrtChoose" class="btn" type="button" value="統計を計算" disabled onclick="onCalcStatsStart()">
  </div>
  <div id="resultDiv">
  </div>
</div>
</body>

</html>
