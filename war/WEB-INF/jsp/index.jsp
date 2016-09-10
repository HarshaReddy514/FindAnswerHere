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
			var signUpForm=	"<table>"+
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
							"</table>";
			$(".formContainer").html(signUpForm);
		}
		function loginForm(){
			var loginForm= "<table>"+
			"<tr>"+
			"<td><input type='text' name='emailId' class='emailId' placeholder='Email'><span id='emailSpanLogin'></span></td>"+
			"</tr>"+
			"<tr>"+
			"<td><input type='password' name='password' class='password' placeholder='Password'><span id='passwordSpanLogin'></span></td>"+
			"</tr>"+
			"<tr>"+
			"<td><span id='loginErrorSpan'></span></td>"+
			"</tr>"+
			"<tr>"+
			"<td><button class='login' onclick='login()'>Login</button></td>"+
			"</tr>"+
			"</table>";
			$(".formContainer").html(loginForm);
		}
		function signUpClicked(){
			var emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
			var pwdRegex=/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
			var userName=$(".userName").val();
			var email=$(".emailId").val();
			var password=$(".password").val();
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
					var data={"userName":userName,"email":email,"password":password}
					$.ajax({
						url:"/signUp",
						type:"post",
						contentType:"application/json; charset=utf-8",
						dataType:"json",
						data:JSON.stringify(data),
						success: function(responseFromServer){
							if(responseFromServer.email!=email)
							{
								$("#errorSpan").html("User Already Exists.");
							}
							else
							{
								var form = document.createElement("form");
	    						form.setAttribute("method", "post");
	    						form.setAttribute("action", "/dashboard");
						        var hiddenField1 = document.createElement("input");
					            hiddenField1.setAttribute("type", "hidden");
						        hiddenField1.setAttribute("name", "email");
								hiddenField1.setAttribute("value", responseFromServer.email);
								var hiddenField2 = document.createElement("input");
								hiddenField2.setAttribute("type", "hidden");
						        hiddenField2.setAttribute("name", "userName");
								hiddenField2.setAttribute("value", responseFromServer.UserName);
								form.appendChild(hiddenField1);
								form.appendChild(hiddenField2);
							    document.body.appendChild(form);
							    form.submit();
								$("#errorSpan").html("");
							}
						}
					});
				}
			}
		}
		function login(){
			var emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
			var pwdRegex=/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
			var email=$(".emailId").val();
			var password=$(".password").val();
			if(email==null || email=="" || !emailRegex.test(email))
			{
				$("#emailSpanLogin").html("Enter Valid EmailId.");
				$("#passwordSpanLogin").html("");
			}
			else if(password==null || password=="")
			{
				$("#emailSpanLogin").html("");
				$("#loginErrorSpan").html("Enter passowrd.");
			}
			else
			{
				var data={"email":email,"password":password};
				$.ajax({
					url:"/login",
					type:"post",
					contentType:"application/json; charset=utf-8",
					datatype:"json",
					data:JSON.stringify(data),
					success:function(responseFromServer){
						var parsedResponse=JSON.parse(responseFromServer);
						if(parsedResponse.email==email)
						{
							var form = document.createElement("form");
    						form.setAttribute("method", "post");
    						form.setAttribute("action", "/dashboard");
					        var hiddenField1 = document.createElement("input");
				            hiddenField1.setAttribute("type", "hidden");
					        hiddenField1.setAttribute("name", "email");
							hiddenField1.setAttribute("value", parsedResponse.email);
							var hiddenField2 = document.createElement("input");
							hiddenField2.setAttribute("type", "hidden");
					        hiddenField2.setAttribute("name", "userName");
							hiddenField2.setAttribute("value", parsedResponse.UserName);
							form.appendChild(hiddenField1);
							form.appendChild(hiddenField2);
						    document.body.appendChild(form);
						    form.submit();
							$("#loginErrorSpan").html("");
						}
						else
						{
							$("#emailSpanLogin").html("");
							$("#loginErrorSpan").html("Password is wrong. (Or) User Doesn't Exists. Please SignUp");
						}
					}
				});
			}
		}
</script>
</head>
<body>
	<div class="homeContainer">
		<button id="login" onclick="loginForm()">Login</button>
		<button id="signup" onclick="signUp()">SignUp</button>
	</div>
	<div class="formContainer">
	</div>
</body>
</html>