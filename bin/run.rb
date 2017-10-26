require_relative '../config/environment'
require_relative '../lib/api_communicator'
require_relative '../lib/cli'
# require 'asciiart'
require 'tty-prompt'


# => USE THIS ONE
# ascii = AsciiArt.new("http://c1.staticflickr.com/5/4468/37882203826_01aeb6ea0c_b.jpg")
# print ascii.to_ascii_art


 welcome_message

 user = create_new_account_or_login_prompt

 # => insert menu options
 find_recipe_by_ingredient(user)

 save_recipe(user)
 prompt_menu(user)
