<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="/common/context.jsp"%>
<html>
	<head>
		<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>我的评论</title>
		<%@include file="/common/resinculde.jsp"%>
		<%@include file="/common/checklogin.jsp"%>
		<link href="${cssPath}/admin.css" rel="stylesheet" type="text/css" />
		<link href="${jsPath}/jquery-easyui/themes/icon.css" rel="stylesheet" type="text/css" />
		<script src="${jsPath}/jquery-easyui/jquery.easyui.min.js" type="text/javascript"></script>
		<script src="${jsPath}/jquery-easyui/local/easyui-lang-zh_CN.js" type="text/javascript"></script>
		<script src="${jsPath}/tools/json2.js" type="text/javascript"></script>
		<link rel="stylesheet" type="text/css" href="${jsPath}/jquery-easyui/themes/${cookie.easyuiTheme.value==null?'metro-blue':cookie.easyuiTheme.value}/easyui.css"  
	 id="swicth-style" />
	</head>
	<body>
		<div style="height: 100%; width: 100%;">
			<div id="tb" style="height: auto">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteComment()">刪除</a> 
			</div>
			<table id="commentDataGrid"></table>
		</div>
	</body>
	<script type="text/javascript">
		//删除选择的评论
		function deleteComment() {
			var checkedRows = $('#commentDataGrid').datagrid('getChecked');//获取选择的行
			if (checkedRows.length > 0) {
				$.messager.confirm('确认', '确定删除？', function(r) {
					if (r) {
						var deleteIds = [];//获取待删除的类别id
						for (var i = 0; i < checkedRows.length; i++) {
							deleteIds.push(checkedRows[i].id);//获取类别id
						}
		
						//调用删除。数组转字符串，以“,”分割
						var param = {
							"commentIds" : deleteIds.join(",")
						};
						$.ajax({
							type : 'GET',
							contentType : 'application/json',
							url : '${ctxPath}/comment/deleteComment.do',
							dataType : 'json',
							data : param,
							success : function(data) {
								if (data && data.success == "true") {
									$.messager.alert("成功", "评论删除成功！", "info");
								} else {
									$.messager.alert("失败", data.content);
								}
								$('#commentDataGrid').datagrid('reload');//重新刷新
							},
							error : function() {
								$.messager.alert("错误", "删除评论发生网络异常！", "error");
							}
						})
					}
				});
		
			} else {
				$.messager.alert('提醒', '请选择需要删除的评论！', 'warning');
			}
		}
		
		//分页
		function pagerFilter(data) {
			if (typeof data.length == 'number' && typeof data.splice == 'function') { // is array
				data = {
					total : data.length,
					rows : data
				}
			}
			var dg = $(this);
			var opts = dg.datagrid('options');
			var pager = dg.datagrid('getPager');
			pager.pagination({
				onSelectPage : function(pageNum, pageSize) {
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh', {
						pageNumber : pageNum,
						pageSize : pageSize
					});
					dg.datagrid('loadData', data);
				}
			});
			if (!data.originalRows) {
				data.originalRows = (data.rows);
			}
			var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
			var end = start + parseInt(opts.pageSize);
			data.rows = (data.originalRows.slice(start, end));
			return data;
		}
		
		$(document).ready(function() {
			$('#commentDataGrid').datagrid({
				url : '${ctxPath}/comment/getCommentListByUser.do',
				toolbar : '#tb',
				rownumbers : true,
				pagination : true,
				fitColumns : true,
				fit : true,
				pageSize : 10,
				loadFilter : pagerFilter,
				columns : [ [ 
					{
						checkbox : true,
					},
					{
						field : 'articleTitle',
						title : '评论博客',
						width : 300,
						align : 'center',
						editor : 'text',
						formatter : function(value, row, index) {
							return "<a href='${ctxPath}/MainIndex/getDetailById.do?id="
								+ row.articleId
								+ "' target='_blank'>"
								+ value
								+ "</a>";
						}
					}, 
					{
						field : 'comContent',
						title : '内容',
						width : 300,
						align : 'center'
					} ] ]
			});
		});
	</script>
</html>