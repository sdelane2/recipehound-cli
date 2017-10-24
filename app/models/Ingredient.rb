class Ingredient < ActiveRecord::Base
  has_many :recipeingredients
  has_many :recipes, through: :recipeingredients
end
