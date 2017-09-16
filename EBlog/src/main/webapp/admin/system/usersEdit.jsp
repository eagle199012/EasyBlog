<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/common/context.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>系统用户管理</title>
	<%@include file="/common/resinculde.jsp"%>
	<%@include file="/common/checklogin.jsp"%>
	<link href="${cssPath}/admin.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="${jsPath}/jquery-easyui/themes/${cookie.easyuiTheme.value==null?'metro-blue':cookie.easyuiTheme.value}/easyui.css"  
 id="swicth-style" />
	<link href="${jsPath}/jquery-easyui/themes/icon.css" rel="stylesheet" type="text/css" />
	<script src="${jsPath}/jquery-easyui/jquery.easyui.min.js" type="text/javascript"></script>
	<script src="${jsPath}/jquery-easyui/local/easyui-lang-zh_CN.js" type="text/javascript"></script>
	<title>用户编辑</title>
</head>
<body>
	<div id="tb" style="height: auto">
		<a href="${ctxPath}/admin/system/users.jsp" class="easyui-linkbutton" data-options="iconCls:'icon-blur',plain:true">列表</a> <a <c:choose><c:when test="${empty userDTO}">style="display: none;"</c:when>
		   </c:choose> href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-remove',plain:true" onclick="deleteUser()">刪除</a> <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="save()">保存</a> <a href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-undo',plain:true" onclick="clearForm()">重置</a>
	</div>
	<input type="hidden" id="currentUserId" />
	<form id="userForm" enctype="multipart/form-data">
		<input id="userId" type="hidden" name="id" value="${userDTO.id}" />
		<table cellpadding="5">
			<tr>
				<td>用户名:</td>
				<td><input id="userCode" <c:choose><c:when test="${not empty userDTO}">disabled="disabled" </c:when></c:choose> class="easyui-validatebox tb" type="text" name="userCode" data-options="required:true,validateOnCreate:false,validateOnBlur:true" value="${userDTO.userCode}"></input></td>
			</tr>
			<tr>
				<td>密码:</td>
				<td><input id="userPassword" class="easyui-validatebox tb" type="password" name="userPassword" data-options="required:true,validateOnCreate:false,validateOnBlur:true" value="${userDTO.userPassword}"></input></td>
			</tr>
			<tr>
				<td>确认密码:</td>
				<td><input id="userPasswordConfirm" class="easyui-validatebox tb" type="password" data-options="required:true,validateOnCreate:false,validateOnBlur:true" validType="equals['#userPassword']" value="${userDTO.userPassword}"></input></td>
			</tr>
			<tr>
				<td>姓名:</td>
				<td><input id="userName" class="easyui-validatebox" type="text" name="userName" data-options="required:true,validateOnCreate:false,validateOnBlur:true" value="${userDTO.userName}"></input></td>
			</tr>
			<tr>
				<td>邮箱:</td>
				<td><input id="email" class="easyui-validatebox tb" type="text" name="email" data-options="required:true,validType:'email',validateOnCreate:false,validateOnBlur:true" value="${userDTO.email}"></input></td>
			</tr>
		</table>
	</form>
</body>
<script type="text/javascript">
	//检测是否已经登录
	function checkLogin() {
		<c:choose>
		<c:when test="${empty Current_User}">
		location.href = "${ctxPath}/admin/login.jsp";
		</c:when>
		</c:choose>
	}

	$.extend($.fn.validatebox.defaults.rules, {
		equals : {
			validator : function(value, param) {
				return value == $(param[0]).val();
			},
			message : '两次密码不一致！'
		}
	});

	//保存前，各个内容是否为空校验
	function validInput() {
		var vuserCode = $("#userCode").val();
		var vuserPassword = $("#userPassword").val();
		var vuserPasswordConfirm = $("#userPasswordConfirm").val();
		var vuserName = $("#userName").val();
		var vemail = $("#email").val();

		if (vuserCode == "") {
			$.messager.alert('提醒', '请输入登录名！');
			return false;
		}
		if (vuserPassword == "") {
			$.messager.alert('提醒', '请输入密码！');
			return false;
		}
		if (vuserPasswordConfirm == "") {
			$.messager.alert('提醒', '请确认密码！');
			return false;
		}
		if (vuserPasswordConfirm != vuserPassword) {
			$.messager.alert('提醒', '两次密码不相同，请确认！');
			return false;
		}
		if (vuserName == "") {
			$.messager.alert('提醒', '请输入用户名！');
			return false;
		}
		if (vemail == "") {
			$.messager.alert('提醒', '请输入邮箱！');
			return false;
		}

		return true;
	}

	//重置
	function clearForm() {
		$('#userForm').form('clear');
	}

	//保存
	function save() {
		//id为0、1的账号为系统预置账号，不能修改
		var userId = $("#userId").val();
		if (userId == "0" || userId == "1") {
			$.messager.alert('提醒', '不能修改系统预置用户！');
			return;
		} else if (userId == $("#currentUserId").val()) {
			$.messager.alert('提醒', '不能修改当前登录用户！');
			return;
		}
		
		var passInput = validInput();
		if (passInput) {
			var params = new FormData($("#userForm")[0]);//使用FormData接收数据
			var strUrl = "";
			if ($("#userId").val() != null && $("#userId").val() != "") {
				strUrl = getContextPath() + '/User/updateUser.do';
			} else {
				strUrl = getContextPath() + '/User/registerUser.do';
			}

			$.ajax({
				type : 'POST',
				url : strUrl,
				data : params,
				dataType : 'json',
				processData : false,//使用FormData这个必须加上
				contentType : false,//使用FormData这个必须加上
				success : function(data) {
					if (data && data.success == "true") {
						$.messager.alert("成功", data.content, "info");
					} else {
						$.messager.alert("失败", data.content, "info");
					}
				},
				error : function() {
					$.messager.alert("错误", "管理用户发生网络异常！", "error");
				}
			});
		}
	}

	//删除选择的用户
	function deleteUser() {
		var userId = $("#userId").val();//获取待删除的用户id
		if (userId != null && userId != "") {
			$.messager.confirm('确认', '确定删除？', function(r) {
				if (r) {
					//id为0、1的账号为系统预置账号，不能删除
					if (userId == "0" || userId == "1") {
						$.messager.alert('提醒', '不能删除系统预置账号！');
						return;
					} else if (userId == $("#currentUserId").val()) {
						$.messager.alert('提醒', '不能删除当前登录用户账号！');
						return;
					}

					//调用删除
					var param = {
						"userId" : userId
					};
					$.ajax({
						type : 'GET',
						contentType : 'application/json',
						url : '${ctxPath}/User/deleteUser.do',
						dataType : 'json',
						data : param,
						success : function(data) {
							if (data && data.success == "true") {
								$.messager.alert("成功", "用户删除成功！", "info");
							} else {
								$.messager.alert("失败", "用户删除失败！");
							}
							
							location.href = "${ctxPath}/admin/system/users.jsp";
						},
						error : function() {
							$.messager.alert("错误", "删除用户发生网络异常！", "error");
						}
					})
				}
			});

		} else {
			$.messager.alert('提醒', '请选择需要删除的用户！', 'warning');
		}
	}

	$(document).ready(function() {
		checkLogin();
		$("#currentUserId").val("${Current_User.id}");//获取当前登录用户id
	});
</script>
</html>