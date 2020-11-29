require "test_helper"

describe UsersController do
  describe "login" do
    it "can log in an existing user" do
      user = perform_login(users(:dee))

      must_respond_with :redirect
    end

    it "can log in a new user" do
      new_user = User.new(uid: "111111",username: "Kayla-Bayla", provider: "github", avatar: "Some string", email: "kayla@kaylabayla.org")
      expect {
      logged_in_user = perform_login(new_user)
      }.must_change "User.count", 1

      must_respond_with :redirect
    end
  end

  describe "logout" do
    it "can logout an existing user" do
      #Arrange
      perform_login

      expect(session[:user_id]).wont_be_nil

      delete logout_path, params: {}

      expect(session[:user_id]).must_be_nil
      must_respond_with :redirect
    end

    it "flashes alert for guests trying to logout"
  end


end
