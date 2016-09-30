package com.harsha;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable
public class QuestionsJdo {

	@PrimaryKey
	@Persistent(valueStrategy=IdGeneratorStrategy.UUIDHEX)
	private String questionId;
	
	@Persistent
	private String email;

	public void setDateAndTime(Long dateAndTime) {
		this.dateAndTime = dateAndTime;
	}

	@Persistent
	private String question;
	
	@Persistent 
	private Long dateAndTime;

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

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public long getDateAndTime() {
		return dateAndTime;
	}

	public void setDateAndTime(long dateAndTime) {
		this.dateAndTime = dateAndTime;
	}	
}
