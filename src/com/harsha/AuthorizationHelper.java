package com.harsha;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.xml.bind.DatatypeConverter;


public class AuthorizationHelper {

	public boolean checkUserExists(String email) {
		// TODO Auto-generated method stub
		Map<String, String> userData = data(email);
		System.out.println("UserData :"+userData);
		if (userData.isEmpty()){
			return true;
		} else {
			return false;
		}
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> data(String email) {
		// TODO Auto-generated method stub
		Map<String, String> userData;
		UserDetails userDetails=new UserDetails();
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query q = pm.newQuery("select from " + UserDetails.class.getName() + " where email == emailParam "
				+ "parameters String emailParam " + "order by date desc");
		try {
			List<UserDetails> results = null;
			userData = new HashMap<String,String>();
			results = (List<UserDetails>) q.execute(email);
			if (!results.isEmpty() && !(results == null)) {
				for (UserDetails data : results) {
					userData.put("userName",data.getUserName());
					userData.put("email",data.getEmail());
					byte[] decoded = DatatypeConverter.parseBase64Binary(data.getPassword());
					try {
						userData.put("password",new String(decoded, "UTF-8"));
					} catch (UnsupportedEncodingException e) {
						e.printStackTrace();
					}
					System.out.println("Timezone"+data.getTimeZone());
					if(data.getTimeZone()==null)
					{
						userDetails=(UserDetails)results.get(0);
						userDetails.setTimeZone("");
					}
				}
			}
		} finally {
			pm.close();
			q.closeAll();
		}
		return userData;
	}

	public Map<String, String> checkUserAuthorization(String email,String password) {
		
		// TODO Auto-generated method stub
		Map<String, String> userData = data(email);
		System.out.println("UserData: "+userData);
		Map<String, String> map = new HashMap<String,String>();
		if (userData.get("email").equals(email) && userData.get("password").equals(password)) {
			map.put("SucessMsg", "success");
			map.put("UserName",userData.get("userName"));
			map.put("Email", userData.get("email"));
			return map;
		} else {
			map.put("SuccessMsg", "failed");
			return map;
		}
	}

	public List<Object> fetchQuestions() {
		// TODO Auto-generated method stub
		PersistenceManager pm = PMF.get().getPersistenceManager();
		@SuppressWarnings("unchecked")
		List<QuestionsJdo> questions=(List<QuestionsJdo>) pm.newQuery("select from "+ QuestionsJdo.class.getName()+" order by dateAndTime desc").execute();
		List<Object> list = new ArrayList<Object>();
		for(int i=0;i<questions.size();i++)
		{
			System.out.println("QuestionId of question"+i+"is "+questions.get(i).getQuestionId());
			List<Object> answers=fetchAnswers(questions.get(i).getQuestionId());
			Map<String, Object> map=new HashMap<String,Object>();
			System.out.println("answers: "+answers);
				map.put("answers", answers);
				map.put("question", questions.get(i));
				list.add(map);
		}
		return list;
	}

	public Map<String, String> fetchSingleQuestionDetails(long date) {
		// TODO Auto-generated method stub
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Map<String, String> singleQuestionMap=new HashMap<String, String>();
		@SuppressWarnings("unchecked")
		List<QuestionsJdo> singleQuestion=(List<QuestionsJdo>) pm.newQuery("select from "+ QuestionsJdo.class.getName()+" where dateAndTime == dateAndTimeParam "+ "parameters String emailParam").execute(date);
		for(QuestionsJdo questionsJdo : singleQuestion)
		{
			System.out.println("questionId: "+ questionsJdo.getQuestionId());
			singleQuestionMap.put("questionId", questionsJdo.getQuestionId());
		}
		return singleQuestionMap;
	}

	public List<Object> fetchAnswers(String questionId) {
		// TODO Auto-generated method stub
		System.out.println("answers");
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<Object> answerList=new ArrayList<Object>();
		@SuppressWarnings("unchecked")
		List<AnswersJdo> answers=(List<AnswersJdo>) pm.newQuery("select from "+ AnswersJdo.class.getName()+" where questionId == questionIdParam "+ "parameters String questionIdParam "+"order by dateAndTime asc").execute(questionId);
		for(AnswersJdo answersJdo:answers)
		{
			answerList.add(answersJdo);
		}
		return answerList;
	}

	public List<Object> getAllUsers() {
		// TODO Auto-generated method stub
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<Object> usersList=new ArrayList<Object>();
		@SuppressWarnings("unchecked")
		List<UserDetails> users=(List<UserDetails>) pm.newQuery("select from "+UserDetails.class.getName()).execute();
		for(UserDetails user:users)
		{
			usersList.add(user);
		}
		return usersList;
	}
}
