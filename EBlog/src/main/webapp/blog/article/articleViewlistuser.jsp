<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/context.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${dto[0].createBy}-博客世界</title>
<%@include file="/common/resinculde.jsp"%>
<link href="${cssPath}/index.css" rel="stylesheet" type="text/css" />
<style type="text/css">
#top {
	border: 1px solid #D8DFEA;
	margin: 5px;
}

#logTitle {
	font-size: 25px;
	color: #E33E06;
	width: 900px;
}

#articleInfo {
	margin-left: 20px;
	font-size: 16px;
	color: #333347;
	line-height: 20px;
}

#postInfo {
	color: #9D9095;
	font-size: 12px;
	margin-top: 5px;
}

hr {
	color: #c0c0c0;
}
</style>
</head>
<body>
	<!-- 	应该指向具体某人的博客内容，而不是所有的博客内容都共用这一个页面。或者显示每个人自己设置的页面
	TODO -->
	<div id="top">
		<table width="100%">
			<tr>
				<td><img src="${imgPath}/log.jpg"></td>
				<td><div id="logTitle">博客世界</div></td>
			</tr>
		</table>
	</div>
	<div id="articleInfo">
		<c:forEach items="${dto}" var="item">
			<a href="${ctxPath}/MainIndex/getDetailById.do?id=${item.id}" target="_blank">${item.title}</a>
			<p>${item.content}</p>
			<p id="postInfo">${item.createBy}发布于${item.createTime}&nbsp;评论(${item.comCount})</p>
			<hr>
		</c:forEach>
	</div>
	<%@include file="/common/footer.jsp"%>
</body>
</html>