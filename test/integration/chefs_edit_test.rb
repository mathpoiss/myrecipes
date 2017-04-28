require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
  	@chef = Chef.create!(chefname: "mathpoiss", email: "mathpoiss@example.com",
							password: "password", password_confirmation: "password")
	@chef2 = Chef.create!(chefname: "john", email: "john@example.com",
							password: "password", password_confirmation: "password")
	@admin_user = Chef.create!(chefname: "john1", email: "john1@example.com",
							password: "password", password_confirmation: "password", admin: true)
  end

  test "reject an invalid edit" do
  		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: " ", email: "mathpoiss@exemple.com" }}
		assert_template 'chefs/edit'
		assert_select 'h2.alert-heading'
	end

	test "accept valid edit" do
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

	test "accept edit attempt by admin user" do
		sign_in_as(@admin_user, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: "mathpoiss3", email: "mathpoiss3@exemple.com" }}
		assert_redirected_to @chef
		assert_not flash.empty?
		@chef.reload
		assert_match "mathpoiss3", @chef.chefname
		assert_match "mathpoiss3@exemple.com", @chef.email
	end

	test "redirect edit attempt by another non-admin user" do
		sign_in_as(@chef2, "password")
		updated_name = "joe"
		updated_email = "joe@exemple.com"
		patch chef_path(@chef), params: { chef: { chefname: "updated_name", email: "updated_email" }}
		assert_redirected_to chefs_path
		assert_not flash.empty?
		@chef.reload
		assert_match "mathpoiss", @chef.chefname
		assert_match "mathpoiss@exemple.com", @chef.email
	end
end
