require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post("/sessions", body: { "email":email, "password":password })
    @auth_token = response["auth_token"]
    raise "Invalid Email or Password" if @auth_token.nil?
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
    @current_user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page_number = 0)
    if page_number > 0
      response = self.class.get("/message_threads?page=#{page_number}", headers: { "authorization" => @auth_token })
      @message_threads = JSON.parse(response.body)
    else
      response = self.class.get("/message_threads", headers: { "authorization" => @auth_token })
      @message_page = JSON.parse(response.body)
    end
  end

  def create_message(sender, recipient_id, token = nil, subject, message)
    response = self.class.post("/messages", headers: { "authorization" => @auth_token }, body: {
      "sender":sender,
      "recipient_id":recipient_id,
      "token":token,
      "subject": subject,
      "stripped-text": message
    })
    puts "Your message has been sent!" if response.success?
  end
end
