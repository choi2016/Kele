 require 'httparty'
 
 class Kele
   #include httparty
 
   def initialize(email, password)
     response = self.class.post("https://www.bloc.io/api/v1/sessions", 
     	body: { "email": email, "password": password })
     @auth_token = response["auth_token"]
     raise "Invalid email/password combination." if @auth_token.nil?
   end
 end