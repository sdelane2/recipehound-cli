require_relative '../config/environment'
require_relative '../lib/api_communicator'
require_relative '../lib/cli'
require 'asciiart'
require 'tty-prompt'



welcome_image
welcome_message
user = create_new_account_or_login_prompt
shopping_list_one_recipe(user)
# 100.times do
#   prompt_menu(user)
# end
