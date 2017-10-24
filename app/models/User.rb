class User < ActiveRecord::Base
  has_many :user_recipes
  has_many :recipes, through: :user_recipes

  def initialize(first_name, username, password)
    @first_name = first_name
    @username = username
    @password = password
  end


end
