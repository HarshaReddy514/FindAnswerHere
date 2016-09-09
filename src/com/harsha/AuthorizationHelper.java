package com.harsha;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.xml.bind.DatatypeConverter;


public class AuthorizationHelper {

	public boolean checkUserExists(String email) {
		// TODO Auto-generated method stub
		List<String> userData = data(email);
		System.out.println(userData);
		if (!userData.contains(email)) {
			return true;
		} else {
			return false;
		}
	}

	@SuppressWarnings("unchecked")
	private List<String> data(String email) {
		// TODO Auto-generated method stub
		List<String> userData;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query q = pm.newQuery("select from " + UserDetails.class.getName() + " where email == emailParam "
				+ "parameters String emailParam " + "order by date desc");
		try {
			List<UserDetails> results = null;
			userData = new ArrayList<String>();
			results = (List<UserDetails>) q.execute(email);
			if (!results.isEmpty() && !(results == null)) {
				for (UserDetails data : results) {
					userData.add(data.getUserName());
					userData.add(data.getEmail());
					byte[] decoded = DatatypeConverter.parseBase64Binary(data.getPassword());
					try {
						userData.add(new String(decoded, "UTF-8"));
					} catch (UnsupportedEncodingException e) {
						e.printStackTrace();
					}
				}
			}
		} finally {
			pm.close();
			q.closeAll();
		}
		return userData;
	}

	public boolean checkUserAuthorization(String email,String password) {
		
		// TODO Auto-generated method stub
		List<String> userData = data(email);
		System.out.println(userData);
		if (userData.contains(email) && userData.contains(password)) {
			return true;
		} else {
			return false;
		}
	}	
}
