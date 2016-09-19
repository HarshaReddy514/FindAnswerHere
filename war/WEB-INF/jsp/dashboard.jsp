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
$(document).ready(function(){
	var allUsers=new Object();
	$.ajax({
		url:"/fetchAllQuestionsAndAnsers",
		type:"post",
		dataType:"json",
		success:function(response){
			console.log(response);
			questionsList=response.questionsList;
			var questionsDiv = '';
			if(questionsList!=null && questionsList.length>0)
			{
				for(var i=0;i<questionsList.length;i++)
				{
					var questions=questionsList[i].question;
					var answers=questionsList[i].answers;	
					var istDate = (new Date(Number(questions.dateAndTime))).toUTCString();
				    var date = new Date(istDate);
					var newIstDate = date.toString();
					newIstDate=newIstDate.split(' ').slice(0,5).join(' ');
					questionsDiv+="<div class='listOfQuestionsContainer' id="+questions.questionId+">";
					for(var k=0;k<allUsers.length;k++)
					{
						console.log(allUsers[k].email===questions.email);
						if(allUsers[k].email===questions.email)
						{
							questionsDiv+="Posted by: "+allUsers[k].userName+"<br/>";
						}
					}
					questionsDiv+="On: "+newIstDate+"<br/>";
					questionsDiv+=questions.question;
					questionsDiv+="<div class='answerDisplayContainer'>";
					if(answers!=null && answers.length>0)
					{
						for(var j=0;j<answers.length;j++)
						{
							var istDate1 = (new Date(Number(answers[j].dateAndTime))).toUTCString();
						    var date1 = new Date(istDate1);
							var newIstDate1 = date.toString();
							newIstDate1=newIstDate1.split(' ').slice(0,5).join(' ');
							questionsDiv+="<div class='answer'>";
							for(var k=0;k<allUsers.length;k++)
							{
								console.log(allUsers[k].email===answers[j].email);
								if(allUsers[k].email===answers[j].email)
								{
									questionsDiv+="Answered by: "+allUsers[k].userName+"<br/>";
								}
							}
							questionsDiv+="On: "+newIstDate1+"<br/>";
							questionsDiv+=answers[j].answer;
							questionsDiv+="</div>";
							
						}
					}
					questionsDiv+="</div>";
					questionsDiv+="<span><button type='button' class='answerBtn'>Answer Now</button></span>";
					questionsDiv+="<div class='answerContainer' id="+questions.questionId+" style='display:none;'><textarea class='answerClass' name='answer' rows='5' cols='200' placeholder='Hey!!! You know the answer... Plz write your answer and save it.'></textarea><button id='cancelAnswer' class='cancelBtn'>Cancel</button><button id='saveAnswer' >Save</button></div>";
					questionsDiv+="</div>"
				}
				$("#questionsAnswers").html(questionsDiv);
			}
		}
	});
	
	$.ajax({
		url:"/getAllUserDetails",
		type:"post",
		dataType:"json",
		success:function(response){
			console.log(response);
			allUsers=response.allUsers;
			console.log("AllUsers: "+allUsers);
		}
	});
	
	$(document).on('click','#editProfile',function(){
		var userName = $("#userName").text().substring(9);
		var email = $("#email").text();
		var data={"email":email};
		$.ajax({
			url:"/getUserDetailsToUpdate",
			type:"post",
			dataType:"json",
			contentType:"application/json",
			data:JSON.stringify(data),
			success:function(userData)
			{
				passwordInDB=userData.password;
				userNameInDB=userData.userName;
				if(userData.SuccessMsg=="success")
				{
					$("#emailToUpdate").val(userData.email);
					$("#userNameToUpdate").val(userData.userName);
					$("#passwordToUpdate").val(userData.password);
					$("#userNameToUpdateSpan").html("");
					$("#passwordToUpdateSpan").html("");
					$("#myModal").modal();
				}
				else
				{
					$("#messageToUser").html("Cannot Update Profile.");
					$("#messageToUser").show();
					$("#messageToUser").fadeIn();
					setTimeout(function() {
						  $("#messageToUser").fadeOut();
					}, 1500);
				}
			}
		});
	});		
	$(document).on('click','#save',function(){
		var userName=$("#userNameToUpdate").val();
		var email=$("#emailToUpdate").val();
		var password=$("#passwordToUpdate").val();
		var pwdRegex=/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
		if(userName==null || userName=="")
		{
			$("#passwordToUpdateSpan").html("");
			$("#userNameToUpdateSpan").html("UserName should not be empty.");
		}
		else if(password=="" || password==null)
		{
			$("#userNameToUpdateSpan").html("");
			$("#passwordToUpdateSpan").html("Password should not be empty.");
		}		
		else if(userName===userNameInDB && password===passwordInDB)
		{
			$("#passwordToUpdateSpan").html("");
			$("#userNameToUpdateSpan").html("");
			$("#footerSpan").html("No modifications in user profile.");
			$("#footerSpan").show();
			$("#footerSpan").fadeIn();
			setTimeout(function() {
				  $("#footerSpan").fadeOut();
			}, 1500);
		}
		else if(pwdRegex.test(password))
		{
			data={"userName":userName,"email":email,"password":password};
			$.ajax({
				url:"/editProfile",
				type:"post",
				contentType:"application/json; charset=utf-8",
				dataType:"json",
				data:JSON.stringify(data),
				success:function(response){
					console.log(response);
					if(response.SuccessMsg=="trueForUserName")
					{		
						$("#userNameToUpdateSpan").html("");
						$("#userNameToUpdate").val("");
						$("#passwordToUpdate").val("");
						$("#myModal").modal("hide");
						$("#userName").html("Welcome: "+response.userName);
						$("#messageToUser").html("Username Updated.");
						$("#messageToUser").show();
						$("#messageToUser").fadeIn();
						setTimeout(function() {
							  $("#messageToUser").fadeOut();
						}, 1500);
					}
					else if(response.SuccessMsg=="trueForPassword")
					{		
						$("#userNameToUpdateSpan").html("");
						$("#userNameToUpdate").val("");
						$("#passwordToUpdate").val("");
						$("#myModal").modal("hide");
						$("#messageToUser").html("Password Updated.");
						$("#messageToUser").show();
						$("#messageToUser").fadeIn();
						setTimeout(function() {
							  $("#messageToUser").fadeOut();
						}, 1500);
					}
					else
					{
						$("#userNameToUpdateSpan").html("");
						$("#userNameToUpdate").val("");
						$("#passwordToUpdate").val("");
						$("#myModal").modal("hide");
						$("#userName").html("Welcome: "+response.userName);
						$("#messageToUser").html("Username and Password are Updated.");
						$("#messageToUser").show();
						$("#messageToUser").fadeIn();
						setTimeout(function() {
							  $("#messageToUser").fadeOut();
						}, 1500);
					}
				}					
			});
		}
		else
		{
			$("#userNameToUpdateSpan").html("");
			$("#passwordToUpdateSpan").html("Password should be alphanumeric and atleast 6 characters.");
		}
	});
	$(document).on('click','#askQuestion',function(){
		$("#question_container").html("<textarea id='questionId' name='question' rows='5' cols='200' placeholder='What is your question?'></textarea><button id='cancelQuestion' class='cancelBtn'>Cancel</button><button id='postQuestion'>Post</button>");
		$("#question_container").show();
		$("#askQuestion").hide();
	});
	$(document).on('click','#postQuestion',function(){
		var question=$("#questionId").val();
		var email=$("#email").text();
		var userName=$("#userName").text().substring(9);
		console.log(question);
		console.log(email);
		if(question==null || question=="")
		{
			$("#messageToUser").html("Cannot post empty question.");
			$("#messageToUser").show();
			$("#messageToUser").fadeIn();
			setTimeout(function() {
				  $("#messageToUser").fadeOut();
			}, 1500);
		}
		else
		{
			var data={"email":email,"question":question};
			$.ajax({
				url:"/postQuestion",
				type:"post",
				dataType:"json",
				contentType:"application/json",
				data:JSON.stringify(data),
				success:function(responseOfPostedQuestion){
					console.log("responseOfPostedQuestion :: "+responseOfPostedQuestion);
					if(responseOfPostedQuestion.SuccessMsg=="success")
					{
						console.log("Date is: "+responseOfPostedQuestion.date);
						var istDate = (new Date(Number(responseOfPostedQuestion.date))).toUTCString();
						console.log("ISTDate: "+ istDate);
					    var date = new Date(istDate);
					    console.log("Date: "+date);
						var newIstDate = date.toString();
						newIstDate=newIstDate.split(' ').slice(0,5).join(' ');
						questionId=responseOfPostedQuestion.questionId;
						var questionHtml="<div class='listOfQuestionsContainer' id="+responseOfPostedQuestion.questionId+">Posted By: "+responseOfPostedQuestion.userName+"<br/>On: "+newIstDate+"<br/>"+responseOfPostedQuestion.question+""+
						"<div class='answerDisplayContainer'></div>"+
						"<span><button type='button' class='answerBtn'>Answer Now</button></span>"+
						"<div class='answerContainer' id="+responseOfPostedQuestion.questionId+" style='display:none;'><textarea class='answerClass' name='answer' rows='5' cols='200' placeholder='Hey!!! You know the answer... Plz write your answer and save it.'></textarea><button id='cancelAnswer' class='cancelBtn'>Cancel</button><button id='saveAnswer' >Save</button></div>"+
						"</div>";
						$("#question_container").hide();
						$(".questionDisplayContainer").append(questionHtml);
						$("#askQuestion").show();
						$("#messageToUser").html("Posted question Successfully.");
						$("#messageToUser").show();
						$("#messageToUser").fadeIn();
						setTimeout(function() {
							  $("#messageToUser").fadeOut();
						}, 1500);
					}
				}
			});
		}
	});
	$(document).on('click','.answerBtn',function(){
		if($(this).parent().siblings(".answerContainer").css('display')=='none')
		{
			$(".answerContainer").hide();
			$(this).parent().siblings('.answerContainer').find('textarea').val('');
			$(this).parent().siblings('.answerContainer').show();
		}
		else
		{
			$(this).parent().siblings('.answerContainer').hide();
		}
	});	
	$(document).on('click','#saveAnswer',function(){
		var answer=$(this).parent().find("textarea").val();
		var userName=$("#userName").text().substring(9);
		var email=$("#email").text();
		var questionId=$(this).parent().attr("id");
		thisElement=$(this);
		console.log(answer);
		if(answer==null || answer=="")
		{
			$("#messageToUser").html("Cannot post empty answer.");
			$("#messageToUser").show();
			$("#messageToUser").fadeIn();
			setTimeout(function() {
				  $("#messageToUser").fadeOut();
			}, 1500);
		}
		else
		{
			var data={"email":email,"answer":answer,"questionId":questionId};
			
			$.ajax({
				url:"/answer",
				type:"post",
				dataType:"json",
				contentType:"application/json",
				data:JSON.stringify(data),
				success:function(responseOfPostedAnswer){
					console.log(responseOfPostedAnswer);
					thisElement.parent().hide();
					if(responseOfPostedAnswer.SuccessMsg=="success")
					{
						var istDate = (new Date(Number(responseOfPostedAnswer.date))).toUTCString();
						console.log("ISTDate: "+ istDate);
					    var date = new Date(istDate);
					    console.log("Date: "+date);
						var newIstDate = date.toString();
						newIstDate=newIstDate.split(' ').slice(0,5).join(' ');
						var answerHtml="<div class='answer'> Answered by: "+responseOfPostedAnswer.userName+"<br/>On: "+newIstDate+"<br/>"+responseOfPostedAnswer.answer+"</div>";
						thisElement.parent().prev().prev().append(answerHtml);
						thisElement.parent().find("textarea").val("");
						$("#messageToUser").html("Posted Answer Successfully.");
						$("#messageToUser").show();
						$("#messageToUser").fadeIn();
						setTimeout(function() {
							  $("#messageToUser").fadeOut();
						}, 1500);
					}
				}
			});
		}
	});
	$(document).on('click','.cancelBtn',function(){
		$("#question_container").hide();
		$("#askQuestion").show();
		if($(this).parent().hasClass("answerContainer"))
		{
			$(this).parent().hide();
		}
	});
});
</script>
</head>
<body style="background-color: #C2E3C7">
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
							<td><button id="save">Save</button></td>
						</tr>
					</table>
				</div>
				<div class="modal-footer">
					<span id="footerSpan"></span>
				</div>
			</div>
		</div>
	</div>
	<span id="messageToUser"></span>
	<p id="userName" style="margin: 10px;">Welcome: ${userName}</p>
	<p id="email" style="margin: 10px;">${email }</p>
	<button id="logout" onclick="location.href='/logout'">Logout</button>
	<button id="editProfile" >Edit Profile</button>
	<button id="askQuestion" >Ask Question</button>
	<div id="question_container">
	</div>
	<div class='questionDisplayContainer' id="questionsAnswers">
	</div>
</body>
</html>