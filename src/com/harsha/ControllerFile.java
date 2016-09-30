package com.harsha;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.DatatypeConverter;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class ControllerFile {
	@RequestMapping("/")
	public String home() {
		return "index";
	}

	@RequestMapping(value = "/signUp", method = RequestMethod.POST)
	@ResponseBody
	public String storeUserDetails(@RequestBody String userData) throws IOException {

		String userName = null;
		String email = null;
		String timeZone;
		String password;
		String hours ;
		String minutes;
		int mins=0;
		int hrs=0;
		String encryptedPassword = null;
		boolean canStore = false;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		UserDetails userDetails = new UserDetails();
		ObjectMapper objectMapper=new ObjectMapper();
		Map<String, String> map = new HashMap<String, String>();
		try {
			Map<String, Object> map1 = objectMapper.readValue(userData, new TypeReference<Map<String, Object>>() {
			});
			userName = (String) map1.get("userName");
			email = (String) map1.get("email");
			password = (String) map1.get("password");
			timeZone=(String)map1.get("timeZone");
			hours=(String) map1.get("hours");
			minutes=(String) map1.get("minutes");
			mins=Integer.parseInt(minutes);
			hrs=Integer.parseInt(hours);
			mins+=hrs*60;
			int offsetMillis=mins*60*1000;
			String[] timezones = TimeZone.getAvailableIDs(offsetMillis);
			String timeZoneDisplayName = null;
			for (String id : timezones) {
				/*TimeZone timeZoneObj = TimeZone.getTimeZone(id);
				timeZoneObj.getDisplayName();*/
				timeZoneDisplayName=(displayTimeZone(TimeZone.getTimeZone(id)));
	        }
			System.out.println("TimeZone : "+timeZoneDisplayName);
			timeZone=timeZoneDisplayName;
			System.out.println("UserName: " + userName + " email: " + email + " Password: " + password);
			System.out.println("Timezone : "+timeZone+" hours : "+hours+" minutes : "+minutes);
			byte[] passwordInBytes = password.getBytes("UTF-8");
			encryptedPassword = DatatypeConverter.printBase64Binary(passwordInBytes);
			userDetails.setDate(new Date().getTime());
			userDetails.setTimeZone(timeZone);
			userDetails.setEmail(email);
			userDetails.setUserName(userName);
			userDetails.setPassword(encryptedPassword);
			AuthorizationHelper authorization = new AuthorizationHelper();
			canStore = authorization.checkUserExists(email);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (canStore == true) {
			pm.makePersistent(userDetails);
			map.put("SuccessMsg", "success");
			map.put("email", email);
			map.put("UserName", userName);
			return objectMapper.writeValueAsString(map);
		} else {
			map.put("SuccessMsg", "failed");
			return objectMapper.writeValueAsString(map);
		}
	}

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	@ResponseBody
	public String login(@RequestBody String userData) throws IOException
	// public HashMap<String, String> login(@RequestBody String userData) throws
	// JsonProcessingException
	{
		/* System.out.println("UserData: "+userData); */
		ObjectMapper objectMapper=new ObjectMapper();
		HashMap<String, String> map = new HashMap<String, String>();
		try {
			Map<String, Object> map1 = objectMapper.readValue(userData, new TypeReference<Map<String, Object>>() {
			});
			String email = map1.get("email").toString();
			String password = map1.get("password").toString();
			map = (HashMap<String, String>) new AuthorizationHelper().checkUserAuthorization(email, password);
			// System.out.println("Map: "+map.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return objectMapper.writeValueAsString(map);
	}

	@RequestMapping(value = "/dashboard", method = RequestMethod.POST)
	public String dashBoard(HttpServletRequest request, ModelMap modelMap) {
		String email = request.getParameter("email");
		/*String userName = request.getParameter("userName");*/
		System.out.println(email);
		Map<String, String> map=new AuthorizationHelper().data(email);
		modelMap.addAttribute("email", map.get("email"));
		modelMap.addAttribute("userName", map.get("userName"));
		return "dashboard";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/editProfile", method = RequestMethod.POST)
	@ResponseBody
	public String editProfile(@RequestBody String updatedInfoOfUser)
			throws IOException {
		String email = null;
		String userName = null;
		String password = null;
		UserDetails objUserDetails = new UserDetails();
		List<UserDetails> userList = new ArrayList<UserDetails>();
		Map<String, String> map = new HashMap<String, String>();
		Map<String, String> userData=new HashMap<String, String>();
		PersistenceManager pm = PMF.get().getPersistenceManager();
		ObjectMapper objectMapper=new ObjectMapper();
		try
		{
			Map<String, Object> map1 = objectMapper.readValue(updatedInfoOfUser,
					new TypeReference<Map<String, Object>>() {
					});
			email = (String) map1.get("email");
			userName = (String) map1.get("userName");
			password = (String) map1.get("password");
			byte[] passwordInBytes = password.getBytes("UTF-8");
			String encryptedPassword = DatatypeConverter.printBase64Binary(passwordInBytes);
			String query = "select FROM " + UserDetails.class.getName() + " where email == '" + email + "'";
			userList = (List<UserDetails>) pm.newQuery(query).execute();
			if (!userList.isEmpty() && !(userList == null)) {
				for (UserDetails data : userList) {
					userData.put("userName",data.getUserName());
					userData.put("email",data.getEmail());
					byte[] decoded = DatatypeConverter.parseBase64Binary(data.getPassword());
					try {
						userData.put("password",new String(decoded, "UTF-8"));
					} catch (UnsupportedEncodingException e) {
						e.printStackTrace();
					}
				}
			}
			if(userData.get("userName").equals(userName) && !(userData.get("password").equals(password)))
			{
				objUserDetails=(UserDetails)userList.get(0);
				objUserDetails.setPassword(encryptedPassword);
				map.put("SuccessMsg","trueForPassword");
			}
			else if(!(userData.get("userName").equals(userName)) && userData.get("password").equals(password))
			{
				objUserDetails=(UserDetails)userList.get(0);
				objUserDetails.setUserName(userName);
				map.put("SuccessMsg","trueForUserName");
				map.put("userName", userName);
			}
			else
			{
				objUserDetails=(UserDetails)userList.get(0);
				objUserDetails.setUserName(userName);
				objUserDetails.setPassword(encryptedPassword);
				map.put("userName", userName);
				map.put("SuccessMsg","trueForBoth");
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			pm.close();
		}
		return objectMapper.writeValueAsString(map);
	}

	@RequestMapping(value="/postQuestion",method=RequestMethod.POST)
	@ResponseBody
	public String postQuestion(@RequestBody String questionData) throws JsonProcessingException
	{
		String question;
		String email;
		PersistenceManager pm=PMF.get().getPersistenceManager();
		ObjectMapper objectMapper=new ObjectMapper();
		Map<String, String> map = new HashMap<String, String>();
		QuestionsJdo questionsJdo=new QuestionsJdo();
		try {
			Map<String, String> map1=objectMapper.readValue(questionData, new TypeReference<Map<String, String>>() {});
			question = map1.get("question");
			email = map1.get("email");
			System.out.println("Email: "+email+" Question: "+question);
			long date=new Date().getTime();
			questionsJdo.setQuestionId(null);
			questionsJdo.setEmail(email);
			questionsJdo.setQuestion(question);
			questionsJdo.setDateAndTime(date);
			pm.makePersistent(questionsJdo);
			map=new AuthorizationHelper().data(email);
			Map<String, String> singleQuestionMap=new AuthorizationHelper().fetchSingleQuestionDetails(date);
			map.put("question", question);
			map.put("email",email);
			map.put("date",Long.toString(date));
			map.put("questionId", singleQuestionMap.get("questionId"));
			map.put("SuccessMsg", "success");
		} catch (Exception e) {
			// TODO: handle exception
		}
		finally {
			pm.close();
		}
		return objectMapper.writeValueAsString(map);
	}
	
	@RequestMapping(value="/answer",method=RequestMethod.POST)
	@ResponseBody
	public String answer(@RequestBody String answerData) throws JsonProcessingException
	{
		String answer;
		String email;
		String questionId;
		PersistenceManager pm=PMF.get().getPersistenceManager();
		ObjectMapper objectMapper=new ObjectMapper();
		Map<String, String> map = new HashMap<String, String>();
		AnswersJdo answersJdo=new AnswersJdo();
		long date=new Date().getTime();
		try {
			Map<String, String> map1=objectMapper.readValue(answerData, new TypeReference<Map<String, String>>() {});
			answer = map1.get("answer");
			email = map1.get("email");
			questionId =map1.get("questionId");
			System.out.println("Email: "+email+" Question: "+answer);
			answersJdo.setAnswerId(null);
			answersJdo.setQuestionId(questionId);
			answersJdo.setEmail(email);
			answersJdo.setAnswer(answer);
			answersJdo.setDateAndTime(date);
			pm.makePersistent(answersJdo);
			map=new AuthorizationHelper().data(email);
			map.put("answer", answer);
			map.put("email",email);
			map.put("date",Long.toString(date));
			map.put("SuccessMsg", "success");
		} catch (Exception e) {
			// TODO: handle exception
		}
		finally {
			pm.close();
		}
		return objectMapper.writeValueAsString(map);
	}
	@RequestMapping(value="/getUserDetailsToUpdate",method=RequestMethod.POST)
	@ResponseBody
	public String getUserDataToUpdate(@RequestBody String userData) throws JsonProcessingException
	{
		String email;
		ObjectMapper objectMapper=new ObjectMapper();
		Map<String, String> map=new HashMap<String,String>();
		try {
			Map<String, String> map1=objectMapper.readValue(userData, new TypeReference<Map<String, String>>() {});
			email=map1.get("email");
			map=new AuthorizationHelper().data(email);
			map.put("SuccessMsg", "success");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return objectMapper.writeValueAsString(map);
	}
	
	@RequestMapping(value="/fetchAllQuestionsAndAnsers",method=RequestMethod.POST)
	@ResponseBody
	public String fetchAllQuestionsAndAnsers() throws JsonProcessingException{
		
		List<Object> questions=new AuthorizationHelper().fetchQuestions();
		Map<String,Object> questionsList=new HashMap<String,Object>();
		questionsList.put("questionsList", questions);
		return new ObjectMapper().writeValueAsString(questionsList);
	}
	
	@RequestMapping(value="/getAllUserDetails",method=RequestMethod.POST)
	@ResponseBody
	public String  getAllUserDetails() throws JsonProcessingException
	{
		List<Object> list=new AuthorizationHelper().getAllUsers();
		Map<String, Object> map=new HashMap<String,Object>();
		map.put("allUsers", list);
		return new ObjectMapper().writeValueAsString(map);
		
	}

	@RequestMapping(value="/getAllTimeZones",method=RequestMethod.POST)
	@ResponseBody
	public String getAllTimeZones() throws JsonProcessingException
	{
		String[] ids = TimeZone.getAvailableIDs();
		List<Object> listOfTimeZones = new ArrayList<Object>();
		Map<String, Object> timeZonesMap=new HashMap<String, Object>();
		for (String id : ids) {
			/*System.out.println("TimeZone");*/
			String timezone=(displayTimeZone(TimeZone.getTimeZone(id)));
			Map<String, Object> timeZoneMap=new HashMap<String,Object>();
			timeZoneMap.put("timezone", timezone);
			listOfTimeZones.add(timeZoneMap);
		}
		timeZonesMap.put("TIMEZONE", listOfTimeZones);
		timeZonesMap.put("success", true);
		return new ObjectMapper().writeValueAsString(timeZonesMap);
	}
	
	private String displayTimeZone(TimeZone timeZone) {
		// TODO Auto-generated method stub
		long hours = TimeUnit.MILLISECONDS.toHours(timeZone.getRawOffset());
		long minutes = TimeUnit.MILLISECONDS.toMinutes(timeZone.getRawOffset())
                                  - TimeUnit.HOURS.toMinutes(hours);
		// avoid -4:-30 issue
		minutes = Math.abs(minutes);

		String result = "";
		if (hours > 0) {
			result = String.format("(GMT+%02d:%02d) %s (%s)", hours, minutes, timeZone.getID(), TimeZone.getTimeZone(timeZone.getID()).getDisplayName());
		} else {
			result = String.format("(GMT%02d:%02d) %s (%s)", hours, minutes, timeZone.getID(), TimeZone.getTimeZone(timeZone.getID()).getDisplayName());
		}

		return result;
	}
	
	@RequestMapping(value="/updateTimeZone",method=RequestMethod.POST)
	@ResponseBody
	public String updateTimeZone(@RequestBody String dataForUpdatingTimeZOne) throws IOException
	{
		String email;
		String timeZoneToUpdate;
		ObjectMapper objectMapper=new ObjectMapper();
		Map<String, Object> map=new HashMap<String,Object>();
		PersistenceManager pm=PMF.get().getPersistenceManager();
		UserDetails userDetails=new UserDetails();
		Map<String, Object> map1 = objectMapper.readValue(dataForUpdatingTimeZOne, new TypeReference<Map<String, Object>>() {});
		email=(String) map1.get("email");
		System.out.println("email:"+email);
		timeZoneToUpdate=(String) map1.get("timeZone");
		System.out.println("TimeZone "+timeZoneToUpdate);
		String query = "select FROM " + UserDetails.class.getName() + " where email == '" + email + "'";
		@SuppressWarnings("unchecked")
		List<UserDetails>userList = (List<UserDetails>) pm.newQuery(query).execute();
		if(!userList.isEmpty())
		{
			userDetails=(UserDetails)userList.get(0);
			userDetails.setTimeZone(timeZoneToUpdate);
			map.put("Success", true);
			map.put("timeZone", timeZoneToUpdate);
		}
		return objectMapper.writeValueAsString(map);
	}

	@RequestMapping("/logout")
	public String logout() {
		return "index";
	}
}