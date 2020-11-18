require "test_helper"

describe UsersController do
  describe "login" do
    it "can log in an existing user" do
      user = perform_login(users(:dee))

      must_respond_with :redirect
    end

    it "can log in a new user" do
      new_user = User.new(username: "Kayla-Bayla", provider: "github", avatar: "Some string", email: "kayla@kaylabayla.org")
      expect {
      logged_in_user = perform_login(new_user)
      }.must_change "User.count", 1

      must_respond_with :redirect
    end
  end


end
