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
	var systemTimeZone=""+new Date();
	systemTimeZone=systemTimeZone.split(' ')[5];
	systemTimeZone=systemTimeZone.substring(0,6)+":"+systemTimeZone.substring(6);
	
	$.ajax({
		url:"/getAllUserDetails",
		type:"post",
		dataType:"json",
		success:function(response){
			console.log(response);
			allUsers=response.allUsers;
			getAllTimeZones();
		}
	});
	function getAllTimeZones(){
		$.ajax({
			url:"/getAllTimeZones",
			type:"post",
			dataType:"json",
			success:function(response){
				for(var k=0;k<allUsers.length;k++)
				{
					console.log("entered loop");
					if(allUsers[k].email===$("#email").text())
					{
						if((allUsers[k].timeZone)!="")
						{
							var timeZoneToDisplay=allUsers[k].timeZone.substring(allUsers[k].timeZone.indexOf(' (')+1);
							timeZoneToUpdate=allUsers[k].timeZone.split(' ')[0].replace('(','').replace(')','');
							console.log("timeZoneToUpdate1 :"+timeZoneToUpdate);
							$("#timeStandard").html(timeZoneToDisplay);
							timeZoneInTextField=allUsers[k].timeZone;
							$('#myModal1').find('#timeZoneToBeUpdated').val(timeZoneInTextField);
							fetchAllQuestionAndAnswers(timeZoneToUpdate);
						}
						else
						{
							fetchAllQuestionAndAnswers(systemTimeZone);
							$("#timeStandard").html("No time zone choosen.");
							$('#myModal1').find('#timeZoneToBeUpdated').val("Choose a time zone.");
						}
					}
				}
				if(response.success)
				{
					timeZoneList=response.TIMEZONE;
					if(timeZoneList!=null && timeZoneList.length>0)
					{
						for(var i=0;i<timeZoneList.length;i++)
						{
							var timeZone=timeZoneList[i].timezone;
							var timeZoneToDisplayInValue=timeZone.substring(0,timeZone.indexOf(' '));
							var timeZoneId=timeZone.substring(timeZone.indexOf(') ')+2,timeZone.indexOf(' ('));
							timeZoneId=timeZoneId.replace('/','-');
							var listOfTimeZonesHtml="<li id="+timeZoneId+"><p>"+timeZone+"</p></li>";
							$('.timezonesList ul').append(listOfTimeZonesHtml);
							
						}
					}
				}
			}
		});
	}
	function fetchAllQuestionAndAnswers(timeZoneToUpdate){
		console.log("Entered Function");
		console.log("SystemTimeZOne: "+systemTimeZone);
		$.ajax({
			url:"/fetchAllQuestionsAndAnsers",
			type:"post",
			dataType:"json",
			success:function(response){
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
						var month=newIstDate.split(' ')[1];
						var dateToDisplay=newIstDate.split(' ')[2];
						var year=newIstDate.split(' ')[3];
						/* var time=newIstDate.split(' ')[4]; */
						var hours=newIstDate.split(' ')[4].substring(0,2);						
						var minutesAndSeconds=newIstDate.split(' ')[4].substring(3);
						/* var seconds=newIstDate.split(' ')[4].substring(6); */
						var period="";
						if(hours<12)
						{
							period="AM";
						}
						else if(hours>12)
						{
							hours = hours-12;
							period="PM";
						}
						else if(hours==0)
						{
							hours=12;
							period="AM";
						}
						else if(hours==12)
						{
							period="PM";
						}
						
						if(hours<10 && hours.toString().charAt(0)!=0)
						{
							hours="0"+hours;
						}
						
						var dateAndTimeToDisplay=dateToDisplay+"-"+month+"-"+year+" "+hours+":"+minutesAndSeconds+" "+period;
						console.log("Date : "+newIstDate);
						questionsDiv+="<div class='listOfQuestionsContainer' id="+questions.questionId+">";
						for(var k=0;k<allUsers.length;k++)
						{
							if(allUsers[k].email===questions.email)
							{
								questionsDiv+="Posted by: "+allUsers[k].userName+"<br/>";
							}
						}
						if(systemTimeZone!=timeZoneToUpdate)
						{
							questionsDiv+="On: "+getTimeAndDateForChoosenTimeZone(timeZoneToUpdate,questions.dateAndTime)+"<br/>";
						}
						else
						{
							questionsDiv+="On: "+dateAndTimeToDisplay+"<br/>";
						}
						questionsDiv+=questions.question;
						questionsDiv+="<div class='answerDisplayContainer'>";
						if(answers!=null && answers.length>0)
						{
							for(var j=0;j<answers.length;j++)
							{
								var istDate1 = (new Date(Number(answers[j].dateAndTime))).toUTCString();
							    var date1 = new Date(istDate1);
								var newIstDate1 = date1.toString();
								newIstDate1=newIstDate1.split(' ').slice(0,5).join(' ');
								var month1=newIstDate1.split(' ')[1];
								var dateToDisplay1=newIstDate1.split(' ')[2];
								var year1=newIstDate1.split(' ')[3];
								/* var time=newIstDate.split(' ')[4]; */
								var hours1=newIstDate1.split(' ')[4].substring(0,2);						
								var minutesAndSeconds1=newIstDate1.split(' ')[4].substring(3);
								/* var seconds=newIstDate.split(' ')[4].substring(6); */
								var period1="";
								if(hours1<12)
								{
									period1="AM";
								}
								else if(hours1>12)
								{
									hours1 = hours1-12;
									period1="PM";
								}
								else if(hours1==0)
								{
									hours1=12;
									period1="AM";
								}
								else if(hours1==12)
								{
									period1="PM";
								}
								if(hours1<10 && hours1.toString().charAt(0)!=0)
								{
									hours1="0"+hours1;
								}
								var dateAndTimeToDisplay1=dateToDisplay1+"-"+month1+"-"+year1+" "+hours1+":"+minutesAndSeconds1+" "+period1;
								questionsDiv+="<div class='answer'>";
								for(var k=0;k<allUsers.length;k++)
								{
									if(allUsers[k].email===answers[j].email)
									{
										questionsDiv+="Answered by: "+allUsers[k].userName+"<br/>";
									}
								}
								if(systemTimeZone!=timeZoneToUpdate)
								{
									questionsDiv+="On: "+getTimeAndDateForChoosenTimeZone(timeZoneToUpdate,answers[j].dateAndTime)+"<br/>";
								}
								else
								{
									questionsDiv+="On: "+dateAndTimeToDisplay1+"<br/>";
								}
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
	}
	
	function getTimeAndDateForChoosenTimeZone(timeZoneToUpdate,dateAndTimeInMillis)
	{
		
		timeZoneToUpdate=timeZoneToUpdate.substring(3);
		timeZoneOffsetSeperator=timeZoneToUpdate.charAt(0);
		timeZoneToUpdate=timeZoneToUpdate.substring(1);
		var numberOfHours=Number(timeZoneToUpdate.split( ':' )[0]);
		var numberOfMinutes=Number(timeZoneToUpdate.split( ':' )[1]);
		console.log("TimeZoneToUpdate: "+timeZoneToUpdate);
		console.log("timeZoneOffsetSeperator: "+timeZoneOffsetSeperator);
		console.log("numberOfHours: "+numberOfHours);
		console.log("numberOfMinutes: "+numberOfMinutes);
		
		numberOfMinutes+=(numberOfHours*60);
		var millisOfUpdatingTimeZone=numberOfMinutes*60000;
		if(timeZoneOffsetSeperator==='-')
		{
			millisOfUpdatingTimeZone*=-1;
		}
		
		var today = new Date();
		var presentTimeZoneOffset = Number( today.getTimezoneOffset() * 60000 );
		var totalMillis = ( Number(dateAndTimeInMillis) + presentTimeZoneOffset );
		var totalMillis1= totalMillis+millisOfUpdatingTimeZone;
		console.log("totalMillis1: "+totalMillis1);
		var timeAndDateOfNewTimeZone=(new Date(totalMillis1));
		var hours=timeAndDateOfNewTimeZone.getHours();
		var minutes=timeAndDateOfNewTimeZone.getMinutes();
		var seconds=timeAndDateOfNewTimeZone.getSeconds();
		var date=timeAndDateOfNewTimeZone.getDate();
		var period="";
		if(hours==0)
		{
			hours=12;
			period="AM";
		}
		else if(hours<12)
		{
			period="AM";
		}
		else if(hours>12)
		{
			hours = hours-12;
			period="PM";
		}
		else if(hours==0)
		{
			hours=12;
			period="AM";
		}
		else if(hours==12)
		{
			period="PM";
		}
		
		if(hours<10 && hours.toString().charAt(0)!=0)
		{
			hours="0"+hours;
		}
		if(minutes<10)
		{
			minutes="0"+minutes;
		}
		if(seconds<10)
		{
			seconds="0"+seconds;
		}
		if(date<10)
		{
			date="0"+date;
		}
		
		var month = new Array();
		month[0] = "Jan";
		month[1] = "Feb";
		month[2] = "Mar";
		month[3] = "Apr";
		month[4] = "May";
		month[5] = "Jun";
		month[6] = "Jul";
		month[7] = "Aug";
		month[8] = "Sep";
		month[9] = "Oct";
		month[10] = "Nov";
		month[11] = "Dec";
		
		var dateAndTime=""+date+"-"+month[timeAndDateOfNewTimeZone.getMonth()]+"-"+timeAndDateOfNewTimeZone.getFullYear()+" "+hours+":"+minutes+":"+seconds+" "+period;
		console.log("Date and Time : "+dateAndTime);
		return dateAndTime;
	}
	
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
		var userName=$("#userNameToUpdate").val().trim();
		var email=$("#emailToUpdate").val().trim();
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
			$(".footerSpan").html("No modifications in user profile.");
			$(".footerSpan").show();
			$(".footerSpan").fadeIn();
			setTimeout(function() {
				  $(".footerSpan").fadeOut();
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
		var question=$("#questionId").val().trim();
		var email=$("#email").text();
		var userName=$("#userName").text().substring(9);
		var timeZoneToUpdateNew=$('#timeZoneToBeUpdated').val();
		timeZoneToUpdateNew=timeZoneToUpdateNew.split(' ')[0].replace('(','').replace(')','');
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
						var month=newIstDate.split(' ')[1];
						var dateToDisplay=newIstDate.split(' ')[2];
						var year=newIstDate.split(' ')[3];
						var hours=newIstDate.split(' ')[4].substring(0,2);						
						var minutesAndSeconds=newIstDate.split(' ')[4].substring(3);
						var period="";
						if(hours<12)
						{
							period="AM";
						}
						else if(hours>12)
						{
							hours = hours-12;
							period="PM";
						}
						else if(hours==0)
						{
							hours=12;
							period="AM";
						}
						else if(hours==12)
						{
							period="PM";
						}
						
						if(hours<10 && hours.toString().charAt(0)!=0)
						{
							hours="0"+hours;
						}
						var dateAndTimeToDisplay=dateToDisplay+"-"+month+"-"+year+" "+hours+":"+minutesAndSeconds+" "+period;
						questionId=responseOfPostedQuestion.questionId;
						var questionHtml="";
						questionHtml+="<div class='listOfQuestionsContainer' id="+responseOfPostedQuestion.questionId+">Posted By: "+responseOfPostedQuestion.userName+"<br/>";
						if(systemTimeZone!=timeZoneToUpdateNew)
						{
							
							questionHtml+="On: "+getTimeAndDateForChoosenTimeZone(timeZoneToUpdateNew,responseOfPostedQuestion.date)+"<br/>";
						}
						else
						{
							questionHtml+="On: "+dateAndTimeToDisplay+"<br/>";
						}
						questionHtml+=responseOfPostedQuestion.question;
						questionHtml+="<div class='answerDisplayContainer'></div>";
						questionHtml+="<span><button type='button' class='answerBtn'>Answer Now</button></span>";
						questionHtml+="<div class='answerContainer' id="+responseOfPostedQuestion.questionId+" style='display:none;'><textarea class='answerClass' name='answer' rows='5' cols='200' placeholder='Hey!!! You know the answer... Plz write your answer and save it.'></textarea><button id='cancelAnswer' class='cancelBtn'>Cancel</button><button id='saveAnswer' >Save</button></div>";
						questionHtml+="</div>";
						$("#question_container").hide();
						$(".questionDisplayContainer").prepend(questionHtml);
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
		var answer=$(this).parent().find("textarea").val().trim();
		var userName=$("#userName").text().substring(9);
		var email=$("#email").text();
		var timeZoneToUpdateNew=$('#timeZoneToBeUpdated').val();
		timeZoneToUpdateNew=timeZoneToUpdateNew.split(' ')[0].replace('(','').replace(')','');
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
						var month1=newIstDate.split(' ')[1];
						var dateToDisplay1=newIstDate.split(' ')[2];
						var year1=newIstDate.split(' ')[3];
						var hours1=newIstDate.split(' ')[4].substring(0,2);						
						var minutesAndSeconds1=newIstDate.split(' ')[4].substring(3);
						var period1="";
						if(hours1<12)
						{
							period1="AM";
						}
						else if(hours1>12)
						{
							hours1 = hours1-12;
							period1="PM";
						}
						else if(hours1==0)
						{
							hours1=12;
							period1="AM";
						}
						else if(hours1==12)
						{
							period1="PM";
						}
						if(hours1<10 && hours1.toString().charAt(0)!=0)
						{
							hours1="0"+hours1;
						}
						var dateAndTimeToDisplay1=dateToDisplay1+"-"+month1+"-"+year1+" "+hours1+":"+minutesAndSeconds1+" "+period1;
						var answerHtml="";
						answerHtml+="<div class='answer'> Answered by: "+responseOfPostedAnswer.userName+"<br/>";
						if(systemTimeZone!=timeZoneToUpdateNew)
						{
							answerHtml+="On: "+getTimeAndDateForChoosenTimeZone(timeZoneToUpdateNew,responseOfPostedAnswer.date)+"<br/>";
						}
						else
						{
							answerHtml+="On: "+dateAndTimeToDisplay1+"<br/>";
						}
						answerHtml+=responseOfPostedAnswer.answer;
						answerHtml+="</div>";
						thisElement.parent().prev().siblings('.answerDisplayContainer').append(answerHtml);
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
	$(document).on('click','#updateTimeZone',function(){
		$('#timeZoneToBeUpdated').val(timeZoneInTextField);
		$('#myModal1').modal();
	});
	
	$(document).on('click','#updateTimeZoneId',function(){
		timeZoneToUpdate=$('#timeZoneToBeUpdated').val();
		console.log("timeZoneToUpdate: "+timeZoneToUpdate);
		var email=$("#email").text().trim(" ");
		console.log(email);
		var data1={"email":email,"timeZone":timeZoneToUpdate};
		if(timeZoneToUpdate!=null && timeZoneToUpdate!="" && timeZoneToUpdate!="Choose a time zone.")
		{
			$.ajax({
				url:"/updateTimeZone",
				type:"post",
				contentType:"application/json",
				dataType:"json",
				data:JSON.stringify(data1),
				success:function(response){
					console.log(response);
					if(response.Success)
					{
						var timeZone=response.timeZone.split(' ')[0].replace(')','').replace('(','');
						var timeZoneToDisplay=response.timeZone.substring(response.timeZone.indexOf(' (')+1);
						timeZoneInTextField=timeZoneToUpdate;
						fetchAllQuestionAndAnswers(timeZone);
						$('#myModal1').modal("hide");
						$('.timezonesList').hide();
						$("#timeStandard").html(timeZoneToDisplay);
					}
				}
			}); 
		}
		else
		{
			$(".footerSpan").html("Cannot update empty timezone.");
			$(".footerSpan").show();
			$(".footerSpan").fadeIn();
			setTimeout(function() {
				  $(".footerSpan").fadeOut();
			}, 1500);
		}
	});
	
	$(document).on('click','#displayTimeZoneList',function(){
		var timeZoneToUpdateNew=$('#timeZoneToBeUpdated').val();
		var timeZoneId=timeZoneToUpdateNew.split(' ')[1];
		timeZoneId=timeZoneId.replace('/','-');
		$('.timezonesList').toggle();
	    $('.timezonesList').animate({
	    	scrollTop : $('#'+timeZoneId).offset().top - $('.timezonesList').offset().top + $('.timezonesList').scrollTop()  
	    });
		$('#'+timeZoneId).css("color","black");
	});
	
	$(document).on('click','.timezonesList ul li',function(){
		var timeZoneToDisplay=$(this).find('p').text().trim(' ');
		console.log(timeZoneToDisplay);
		$('#timeZoneToBeUpdated').val(timeZoneToDisplay);
	});
	
	$(document).on('click','.close',function(){
		$('.timezonesList').hide();
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
					<span class="footerSpan"></span>
				</div>
			</div>
		</div>
	</div>
	<div id="myModal1" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Update TimeZone</h4>
				</div>
				<div class="modal-body">
					<div id="timezonesListParent">
						<button id="displayTimeZoneList">Display TimeZones</button>
						<input type="text" name="timezone" id="timeZoneToBeUpdated" readonly/>
					</div>
					<div class='timezonesList' style="display:none">
						<ul>
						</ul>
					</div>
				</div>
				<div class="modal-footer">
					<button id="updateTimeZoneId">Update TimeZone</button>
					<span class="footerSpan"></span>
				</div>
			</div>
		</div>
	</div>
	<span id="messageToUser"></span>
	<p id="userName" style="margin: 10px;">Welcome: ${userName}</p>
	<p id="email" style="margin: 10px;">${email }</p>
	<p id="timeStandard"></p>
	<div id="buttonsDiv">
		<button id="logout" onclick="location.href='/logout'">Logout</button>
		<button id=updateTimeZone>Update TimeZone</button>
		<button id="editProfile" >Edit Profile</button>
		<button id="askQuestion" >Ask Question</button>
	</div>
	<div id="question_container">
	</div>
	<div class='questionDisplayContainer' id="questionsAnswers">
	</div>
</body>
</html>