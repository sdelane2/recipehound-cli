require_relative '../config/environment'
require_relative '../lib/api_communicator'
require_relative '../lib/cli'
require 'asciiart'

#ascii = AsciiArt.new("https://s7d2.scene7.com/is/image/PetSmart/PB1201_STORY_CARO-Authority-HealthyOutside-DOG-20160818?$PB1201$")
#print ascii.to_ascii_art

 welcome_message
 thisUser = create_new_account_or_login_prompt
 find_recipe_by_ingredient(thisUser)
 save_recipe(thisUser)
