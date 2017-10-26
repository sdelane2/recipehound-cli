require 'pry'


def welcome_message # => greets user at the start of the program
  puts "Welcome to \e[34m\e[1mRecipeHound\e[0m, the CLI app that sniffs out the perfect recipe for you!"
end


def create_new_account_or_login_prompt  # => asks user to sign in or create a new account
  puts "\e[95mWould you like to create a new account or sign in to an existing account?]"
  puts "Enter '1' to create a new account. Enter '2' to sign in to an existing account.\e[0m"
  welcome_option
end


def welcome_option  # => validation for user input on create_new_account_or_login_prompt. Will output user object
  user_welcome_input = gets.chomp.to_i
  if user_welcome_input == 1
    puts "\e[95mAwesome! Let's create a new account for you!\e[0m"
    user = create_new_user_account
  elsif user_welcome_input == 2
    user = existing_account_login
  else
    puts "\n\e[95mRuh roh! That is not a valid option. Please enter '1' to create a new account or enter '2' to sign in to an existing account.\e[0m"
    welcome_option
  end
  user
end


def create_new_user_account # => takes user inputs and creates a new User instance
  puts "\nWhat would you like your username to be?"
  user_username_input = gets.chomp
  user = User.find_by(username: user_username_input)
  if user == nil
    puts "\nI like that. What's your first name?"
    user_first_name = gets.chomp
    puts "\nGot it. Choose a password. Make sure you save it in a safe place!"
    user_password = gets.chomp
    puts "\nYou're all set up, #{user_first_name}! Your username is #{user_username_input}."
    user = User.create(first_name: user_first_name, username: user_username_input, password: user_password)
  else
    puts "\nSorry, that username is already taken."
    create_new_user_account
  end
  user
end


def existing_account_login
  puts "\nPlease enter your username."
  user_username = gets.chomp
  user = User.find_by(username: user_username)
  if user == nil
    puts "\nRuh roh! No user found with that username. Please try again."
  else
    puts "\nHello #{user.first_name}. Welcome back!"
  end
user
end


def find_recipe_by_ingredient(user)
  puts "\nWhat ingredient would you like to use?"
  user_ingredient = gets.chomp
  ingredient_given = Ingredient.find_by(title: user_ingredient)
  if ingredient_given == nil
    puts "\nRuh roh! No recipes with that ingredient could be found. Try making it plural?"
    find_recipe_by_ingredient(user)
  else
    relationships = RecipeIngredient.where(ingredient_id: ingredient_given.id)
    recipe_ids = relationships.collect {|row| row.recipe_id}
    recipes = recipe_ids.collect do |id|
      Recipe.find(id)
    end
    puts "\nHere are some available recipes with that ingredient:"
    recipes.each do |recipe|
      puts "#{recipe.title}"
    end
  end
end


def save_recipe(user)
  puts "\nWould you like to save a recipe from this list? (y/n) \e[95mLight magenta"
  should_recipe_be_saved = gets.chomp
    if should_recipe_be_saved != "n" && should_recipe_be_saved != "y"
      puts "\nGet it together, #{user.first_name}. That's not a valid input."
      save_recipe(user)
    elsif should_recipe_be_saved == "n"
      false
    else should_recipe_be_saved == "y"
      puts "\nOkay. Enter the name of the recipe you'd like to save."
      saved_recipe_input = gets.chomp
      saved_recipe = Recipe.find_by(title: saved_recipe_input)
      new_user_recipe = UserRecipe.create(recipe: saved_recipe, user: user)
      puts "\nGreat! #{saved_recipe_input} has been saved to your list."
    end
end



def shopping_list(user)
  puts "Shopping List"

end
