<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>FindAnswerHere</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
	function editProfile() {
		var userName = $("#userName").text().substring(9);
		var email = $("#email").text();
		$("#emailToUpdate").val(email);
		$("#userNameToUpdate").val(userName);
		$("#myModal").modal();
	}
	function updateUserProfile()
	{
		var userName=$("#userNameToUpdate").val();
		var email=$("#emailToUpdate").val();
		var password=$("#passwordToUpdate").val();
		var pwdRegex=/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
		if(password=="" || password==null)
		{
			if(userName==null || userName=="")
			{
				$("#userNameToUpdateSpan").html("UserName should not be null.");
			}			
			else
			{
				data={"userName":userName,"email":email,"password":password};
				$.ajax({
					url:"/editProfile",
					type:"post",
					contentType:"application/json; charset=utf-8",
					dataType:"json",
					data:JSON.stringify(data),
					success:function(response){
						if(response!=null)
						{
							$("#userNameToUpdateSpan").html("");
							$("#userNameToUpdate").val("");
							$("#passwordToUpdate").val("");
							$("#myModal").modal("hide");
							$("#messageToUser").html("User Profile has been updated.");
							$("#messageToUser").show();
							setTimeout(function() {
								  $("#messageToUser").fadeIn();
							});
							setTimeout(function() {
								  $("#messageToUser").fadeOut();
							}, 3000);
						}
						else
						{
							console.log("Response is empty.");
						}
					}					
				});
			}
		}
		else
		{
			if(pwdRegex.test(password))
			{
				data={"userName":userName,"email":email,"password":password};
				$.ajax({
					url:"/editProfile",
					type:"post",
					contentType:"application/json; charset=utf-8",
					dataType:"json",
					data:JSON.stringify(data),
					success:function(response){
						if(response!=null)
						{
							$("#userNameToUpdateSpan").html("");
							$("#passwordToUpdateSpan").html("");
							$("#userNameToUpdate").val("");
							$("#passwordToUpdate").val("");
							$("#myModal").modal("hide");
							$("#messageToUser").html("User Profile has been updated.");
							$("#messageToUser").show();
							setTimeout(function() {
								  $("#messageToUser").fadeIn();
							});
							setTimeout(function() {
								  $("#messageToUser").fadeOut();
							}, 3000);
						}
						else
						{
							console.log("Response is empty.");
						}
					}					
				});
			}
			else
			{
				$("#passwordToUpdateSpan").html("Password should be alphanumeric.");
			}
		}
	}
	function askQuestion()
	{
		$("#question_container").html("<textarea id='questionId' name='question' rows='5' cols='200' placeholder='What is your question?'></textarea><button id='postQuestion' onclick='postQuestion()'>Post</button>");
		$("#question_container").show();
		$("#askQuestion").hide();
	}
	function postQuestion()
	{
		$("#question_container").hide();
		$("#askQuestion").show();
	}
</script>
</head>
<body>
	<%
		String email = session.getAttribute("email").toString();
		String userName = session.getAttribute("userName").toString();
		if(email==null)
		{
			response.sendRedirect("/");
		}
	%>
	<!-- Modal -->
	<div id="myModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Update Profile</h4>
				</div>
				<div class="modal-body">
					<table>
						<tr>
							<td><input type="text" id="emailToUpdate"
								readonly="readonly" placeholder="email" /><span></span></td>
						</tr>
						<tr>
							<td><input type="text" id="userNameToUpdate"
								placeholder="username" /><span id="userNameToUpdateSpan"></span></td>
						</tr>
						<tr>
							<td><input type="password" id="passwordToUpdate"
								placeholder="password" /><span id="passwordToUpdateSpan"></span></td>
						</tr>
						<tr>
							<td><button id="save" onclick="updateUserProfile()">Save</button></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<span id="messageToUser"></span>
	<p id="userName" style="margin: 10px;">Welcome: <%=userName%></p>
	<p id="email" style="margin: 10px;"><%=email%></p>
	<button id="logout" onclick="location.href='/logout'">Logout</button>
	<button id="editProfile" onclick="editProfile()">Edit Profile</button>
	<button id="askQuestion" onclick="askQuestion()">Ask Question</button>
	<div id="question_container">
	</div>
</body>
</html>