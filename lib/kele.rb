 require 'httparty'
 require 'json'
 require './lib/roadmap'
 
 class Kele
   include HTTParty
   include Roadmap
   
   def initialize(email, password)
     response = self.class.post("https://www.bloc.io/api/v1/sessions", 
     	body: { "email": email, "password": password })
     @auth_token = response["auth_token"]
     raise "Invalid email/password combination." if @auth_token.nil?
   end

   def get_me
   	 url = "https://www.bloc.io/api/v1/users/me"
     response = self.class.get(url, headers: { "authorization" => @auth_token })
     @user_info = JSON.parse(response.body)
   end

   def get_mentor_availability(mentor_id)
     response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
     @mentor_availability = JSON.parse(response.body)
   end

   def get_messages(page)
     response = self.class.get("https://www.bloc.io/api/v1/message_threads?page=#{page}", headers: { "authorization" => @auth_token })
     @messages = JSON.parse(response.body)
   end

   def create_message(recipient_id, subject, message)
     response = self.class.post("https://www.bloc.io/api/v1/messages",
     body: {
       'sender': sender_email,
       'recipient_id': recipient_id,
       'subject': subject,
       'stripped-text': message
     },
     header: { "authorization" => @auth_token })
     puts response
   end
 
   def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
     response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions",
     body: {
       'checkpoint_id': checkpoint_id,
       'assignment_branch': assignment_branch,
       'assignment_commit_link': assignment_commit_link,
       'comment': comment,
       'enrollment_id': enrollment_id
       },
     headers: { "authorization" => @auth_token})
   end
     
 end