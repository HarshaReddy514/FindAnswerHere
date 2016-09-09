package com.harsha;

import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable
public class UserDetails {

	@Persistent
	private String userName;
	
	@PrimaryKey
	@Persistent
	private String email;
	@Persistent
	private String password;
	public long getDate() {
		return date;
	}

	public void setDate(long date) {
		this.date = date;
	}

	@Persistent
	private long date;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}