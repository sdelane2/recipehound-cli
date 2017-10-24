class User < ActiveRecord::Base
#  has_many :recipes

  def initialize(first_name, username, password)
    @first_name = first_name
    @username = username
    @password = password
  end


end
