require_relative "../config/environment.rb"

Ingredient.delete_all
RecipeIngredient.delete_all
Recipe.delete_all
User.delete_all
UserRecipe.delete_all

array_of_hashes = get_all_recipes

array_of_hashes.each do |hash|
  Recipe.find_or_create_by(hash)
end
