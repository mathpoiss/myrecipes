require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
  	@chef = Chef.create!(chefname: "mathpoiss", email: "mathpoiss@example.com",
							password: "password", password_confirmation: "password")
  end

  test "reject an invalid edit" do
  		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: " ", email: "mathpoiss@exemple.com" }}
		assert_template 'chefs/edit'
		assert_select 'h2.alert-heading'
	end

	test "accept valid sign up" do
		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: "mathpoiss1", email: "mathpoiss1@exemple.com" }}
		assert_redirected_to @chef
		assert_not flash.empty?
		@chef.reload
		assert_match "mathpoiss1", @chef.chefname
		assert_match "mathpoiss1@exemple.com", @chef.email	
	end
end
