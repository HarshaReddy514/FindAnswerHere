package com.harsha;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.DatatypeConverter;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.gson.Gson;

@Controller
public class ControllerFile {
	@RequestMapping("/")
	public String home()
	{
		return "index";
	}
	@RequestMapping(value="/signUp",method=RequestMethod.POST)
	public void storeUserDetails(HttpServletRequest request,HttpServletResponse response) throws IOException
	{
		BufferedReader bufferedReader=new BufferedReader(new InputStreamReader(request.getInputStream()));
		String inputGiven;
		String userData="";
		while((inputGiven=bufferedReader.readLine())!=null)
		{
			userData+=inputGiven;
		}
		bufferedReader.close();
		System.out.println(userData);
		JSONParser jsonParser= new JSONParser();
		JSONObject jsonObject=null;
		try {
			jsonObject=(JSONObject)jsonParser.parse(userData);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String userName=(String) jsonObject.get("userName");
		String email=(String) jsonObject.get("email");
		String password=(String) jsonObject.get("password");
		System.out.println("UserName: "+userName+" email: "+email+" Password: "+password);
		
		byte[] passwordInBytes = password.getBytes("UTF-8");
		String encryptedPassword = DatatypeConverter.printBase64Binary(passwordInBytes);
		
		UserDetails userDetails=new UserDetails();
		userDetails.setDate(new Date().getTime());
		userDetails.setUserName(userName);
		userDetails.setEmail(email);
		userDetails.setPassword(encryptedPassword);
		AuthorizationHelper authorization=new AuthorizationHelper();
		boolean canStore=false;
		canStore=authorization.checkUserExists(email);
		PersistenceManager pm=PMF.get().getPersistenceManager();
		try{
			if(canStore==true)
			{
				pm.makePersistent(userDetails);
				Map<String, String> map=retrieveUserData(email);
				response.getWriter().write(new Gson().toJson(map));
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally {
			pm.close();
		}
	}
	
	@RequestMapping(value="/login",method=RequestMethod.POST)
	public void login(HttpServletRequest request,HttpServletResponse response) throws IOException, JSONException
	{
		BufferedReader bufferedReader=new BufferedReader(new InputStreamReader(request.getInputStream()));
		String inputGiven;
		String userData="";
		while((inputGiven=bufferedReader.readLine())!=null)
		{
			userData+=inputGiven;
		}
		bufferedReader.close();
		System.out.println(userData);
		JSONParser jsonParser= new JSONParser();
		JSONObject jsonObject=null;
		try {
			jsonObject=(JSONObject)jsonParser.parse(userData);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String email=(String) jsonObject.get("email");
		String password=(String) jsonObject.get("password");
		boolean isExisting=new AuthorizationHelper().checkUserAuthorization(email,password);
		if(isExisting==true)
		{
			Map<String, String> map=retrieveUserData(email);
			response.getWriter().write(new Gson().toJson(map));
		}
	}
	@SuppressWarnings("unchecked")
	private Map<String, String> retrieveUserData(String email) {
		// TODO Auto-generated method stub
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query q = pm.newQuery("select from " + UserDetails.class.getName() + " where email == emailParam "
				+ "parameters String emailParam " + "order by date desc");
		try {
			List<UserDetails> results = null;
			Map<String,String> map=new HashMap<String,String>();
			results = (List<UserDetails>) q.execute(email);
			if (!results.isEmpty() && !(results == null)) {
				for (UserDetails data : results) {
					map.put("UserName", data.getUserName());
					map.put("email", data.getEmail());
				}
			}
			return map;
		} finally {
			pm.close();
			q.closeAll();
		}	
	}
	@RequestMapping(value="/dashboard",method=RequestMethod.POST)
	public ModelAndView dashBoard(HttpServletRequest request,HttpServletResponse response)
	{
		String email=request.getParameter("email");
		String userName=request.getParameter("userName");
		System.out.println(email);
		HttpSession session=request.getSession();
		session.setAttribute("email", email);
		session.setAttribute("userName", userName);
		return new ModelAndView("dashboard");
	}
}
