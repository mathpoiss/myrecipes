require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

	def setup
		@recipe = Recipe.new(name: "vegetable", description: "great vegetable recipe")
	end

	test "recipe should be valid" do
		assert @recipe.valid?
	end

	test "name should be present" do
		@recipe.name = " "
		assert_not @recipe.valid?
	end

	test "description should be present" do
		@recipe.description = " "
		assert_not @recipe.valid?
	end

	test "description should not have more then 5 caracters" do
		@recipe.description = "a" * 3
		assert_not @recipe.valid?
	end

	test "description should have less then 500 caracters" do
		@recipe.description = "a" * 501
		assert_not @recipe.valid?
	end

	test "email should accept correct format" do
		
	end	
end