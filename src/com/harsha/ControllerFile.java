package com.harsha;

import java.io.IOException;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

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
		String userName=request.getParameter("userName");
		String email=request.getParameter("email");
		String password=request.getParameter("password");
		System.out.println("UserName: "+userName+" email: "+email+" Password: "+password);
		
		byte[] passwordInBytes = password.getBytes("UTF-8");
		String encryptedPassword = DatatypeConverter.printBase64Binary(passwordInBytes);
		
		UserDetails userDetails=new UserDetails();
		userDetails.setDate(System.currentTimeMillis());
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
				response.getWriter().write(email);
			}
			else
			{
				response.getWriter().write("false");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally {
			pm.close();
		}
	}
	@RequestMapping(value="/login",method=RequestMethod.POST)
	public void login(HttpServletRequest request,HttpServletResponse response) throws IOException
	{
		String email=request.getParameter("email");
		String password=request.getParameter("password");
		boolean isExisting=new AuthorizationHelper().checkUserAuthorization(email,password);
		if(isExisting==true)
		{
			response.getWriter().write("true");
		}
		else
		{
			response.getWriter().write("false");
		}
	}
	@RequestMapping("/dashboard")
	public ModelAndView dashBoard()
	{
		return new ModelAndView("dashboard");
	}
}
