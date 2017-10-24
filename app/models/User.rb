class User < ActiveRecord::Base
  has_many :userrecipes
  has_many :recipes, through: :userrecipes

  def initialize(first_name, username, password)
    @first_name = first_name
    @username = username
    @password = password
  end


end
