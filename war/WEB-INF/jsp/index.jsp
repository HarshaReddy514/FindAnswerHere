<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>FindAnswerHere</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
<script type="text/javascript">
		function signUp(){
			var signUpForm="<div class='homeContainer'>"+
							"<table>"+
							"<tr>"+
							"<td><input type='text' name='username' class='userName' placeholder='UserName'><span id='userNameSpan'></span></td>"+
							"</tr>"+
							"<tr>"+
							"<td><input type='text' name='emailId' class='emailId' placeholder='Email'><span id='emailSpan'></span></td>"+
							"</tr>"+
							"<tr>"+
							"<td><input type='password' name='password' class='password' placeholder='Password'><span id='passwordSpan'></span></td>"+
							"</tr>"+
							"<tr>"+
							"<td><button class='signup' onclick='signUpClicked()'>SignUP</button></td>"+
							"</tr>"+
							"<tr>"+
							"<td><span id='errorSpan'></span></td>"+
							"</tr>"
							"</table>"+
							"</div>";
			$("#signup").hide();
			$("body").html(signUpForm);
		}
		function signUpClicked(){
			var emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
			var pwdRegex=/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
			var userName=$(".userName").val();
			var email=$(".emailId").val();
			var password=$(".password").val();
			console.log("UserName: "+userName+" Email: "+email+" Password: "+password);
			if(userName==null || userName=="")
			{
				$("#userNameSpan").html("UserName should not be null.");
				$("#emailSpan").html("");
				$("#passwordSpan").html("");
			}
			else if(email==null || email=="")
			{
				$("#userNameSpan").html("")
				$("#emailSpan").html("Email should not be null.");
				$("#passwordSpan").html("");
			}
			else if(password==null || password=="")
			{
				$("#userNameSpan").html("");
				$("#emailSpan").html("");
				$("#passwordSpan").html("Password should not be null.");
			}
			else{
				if(!emailRegex.test(email))
				{
					$("#userNameSpan").html("");
					$("#passwordSpan").html("");
					$("#emailSpan").html("Email specified is not valid..");
				}
				else if(!pwdRegex.test(password))
				{
					$("#userNameSpan").html("");
					$("#emailSpan").html("");
					$("#passwordSpan").html("Password should be alphanumeric.");
				}
				else
				{
					$("#userNameSpan").html("");
					$("#emailSpan").html("");
					$("#passwordSpan").html("");
					$.ajax({
						url:"/signUp",
						type:"post",
						datatype:'text',
						data:{userName,email,password},
						success: function(responseFromServer){
							console.log(responseFromServer);
							console.log(responseFromServer==="false");
							console.log(responseFromServer===email);
							if(responseFromServer==email)
							{
								window.location.href = "/dashboard";
								$("#errorSpan").html("");
							}
							else
							{
								$("#errorSpan").html("User Already Exists.");
							}
						}
					});
				}
			}
		}
		function login(){
			var emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
			var pwdRegex=/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
			var email=$("#emailId").val();
			var password=$("#password").val();
			if(email==null || email=="" || !emailRegex.test(email))
			{
				$("#emailSpanLogin").html("Enter Valid EmailId.");
				$("#passwordSpanLogin").html("");
			}
			else
			{
				$.ajax({
					url:"/login",
					type:"post",
					datatype:"text",
					data:{email,password},
					success:function(responseFromServer){
						if(responseFromServer==="true")
						{
							window.location.href="/dashboard";
							$("#loginErrorSpan").html("");
						}
						else
						{
							$("#emailSpanLogin").html("");
							$("#passwordSpanLogin").html("Password is wrong. OR User Doesn't Exists. Please SignUp");
						}
					}
				});
			}
		}
</script>
</head>
<body>
	<div class="homeContainer">
		<table>
			<tr>
				<td><input type="text" name="emailId" id="emailId" placeholder="Email"><span id="emailSpanLogin"></span></td>
			</tr>
			<tr>
				<td><input type="password" name="password" id="password" placeholder="Password"><span id="passwordSpanLogin"></span></td>
			</tr>
			<tr>
				<td><button id="login" onclick="login()">Login</button></td>
			</tr>
			<tr>
				<td><span id="loginErrorSpan"></span></td>
			</tr>
			<tr>
				<td><button id="signup" onclick="signUp()">SignUp</button></td>
			</tr>
		</table>
	</div>
</body>
</html>