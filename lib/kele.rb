require 'httparty'
require 'json'

class Kele
  include HTTParty

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
end
