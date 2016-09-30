package com.harsha;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable
public class AnswersJdo {
	
	@PrimaryKey
	@Persistent(valueStrategy=IdGeneratorStrategy.UUIDHEX)
	private String answerId;
	
	@Persistent
	private String questionId;
	
	@Persistent
	private String email;
	
	@Persistent
	private String answer;
	
	@Persistent
	private long dateAndTime;

	public String getAnswerId() {
		return answerId;
	}

	public void setAnswerId(String answerId) {
		this.answerId = answerId;
	}

	public String getQuestionId() {
		return questionId;
	}

	public void setQuestionId(String questionId) {
		this.questionId = questionId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public long getDateAndTime() {
		return dateAndTime;
	}

	public void setDateAndTime(long dateAndTime) {
		this.dateAndTime = dateAndTime;
	}
}
