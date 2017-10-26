require 'pry'


def welcome_message # => greets user at the start of the program
  puts "Welcome to \e[34m\e[1mRecipeHound\e[0m, the CLI app that sniffs out the perfect recipe for you!"
end


def create_new_account_or_login_prompt  # => asks user to sign in or create a new account
  puts "Would you like to create a new account or sign in to an existing account?"
  puts "Enter '1' to create a new account. Enter '2' to sign in to an existing account."
  welcome_option
end


def welcome_option  # => validation for user input on create_new_account_or_login_prompt. Will output user object
  user_welcome_input = gets.chomp.to_i
  if user_welcome_input == 1
    puts "Awesome! Let's create a new account for you!"
    user = create_new_user_account
  elsif user_welcome_input == 2
    user = existing_account_login
  else
    puts "Ruh roh! That is not a valid option. Please enter '1' to create a new account or enter '2' to sign in to an existing account."
    welcome_option
  end
  user
end


def create_new_user_account # => takes user inputs and creates a new User instance
  puts "What would you like your username to be?"
  user_username_input = gets.chomp
  user = User.find_by(username: user_username_input)
  if user == nil
    puts "I like that. What's your first name?"
    user_first_name = gets.chomp
    puts "Got it. Choose a password. Make sure you save it in a safe place!"
    user_password = gets.chomp
    puts "You're all set up, #{user_first_name}! Your username is #{user_username_input}."
    user = User.create(first_name: user_first_name, username: user_username_input, password: user_password)
  else
    puts "Sorry, that username is already taken."
    create_new_user_account
  end
  user
end


def existing_account_login
  puts "Please enter your username."
  user_username = gets.chomp
  user = User.find_by(username: user_username)
  if user == nil
    puts "Ruh roh! No user found with that username. Please try again."
  else
    puts "Hello #{user.first_name}. Welcome back!"
  end
user
end


def find_recipe_by_ingredient(user)
  puts "What ingredient would you like to use?"
  user_ingredient = gets.chomp
  ingredient_given = Ingredient.find_by(title: user_ingredient)
  if ingredient_given == nil
    puts "Ruh roh! No recipes with that ingredient could be found. Try making it plural?"
    find_recipe_by_ingredient(user)
  else
    relationships = RecipeIngredient.where(ingredient_id: ingredient_given.id)
    recipe_ids = relationships.collect {|row| row.recipe_id}
    recipes = recipe_ids.collect do |id|
      Recipe.find(id)
    end
    puts "Here are some available recipes with that ingredient:"
    recipes.each do |recipe|
      puts "#{recipe.title}"
    end
  end
end


def save_recipe(user)
  puts "Would you like to save a recipe from this list? (y/n)"
  should_recipe_be_saved = gets.chomp
    if should_recipe_be_saved != "n" && should_recipe_be_saved != "y"
      puts "Get it together, #{user.first_name}. That's not a valid input."
      save_recipe(user)
    elsif should_recipe_be_saved == "n"
      false
    else should_recipe_be_saved == "y"
      puts "Okay. Enter the name of the recipe you'd like to save."
      saved_recipe_input = gets.chomp
      saved_recipe = Recipe.find_by(title: saved_recipe_input)
      new_user_recipe = UserRecipe.create(recipe: saved_recipe, user: user)
      puts "Great! #{saved_recipe_input} has been saved to your list."
    end
end

def menu
  # -search for recipe by ingredient
  # -search for recipe by another ingredient
  # -look at user's cookbook
  # -Ask for random recipe "I don't know what to eat"
  # -shopping list (list of all ingredients for entire cookbook)
  #   -shopping list for specific recipe in cookbook
  # -BONUS search for more than one ingredient
puts "\e[34m\e[1m\e[4mMain Menu\e[0m"
puts "\e[32mWhat would you like me to fetch?\e[0m"
puts "search for recipe by ingredient"
puts "view cookbook"
puts "I don't know what to eat..." #ask for random recipe
puts "make shopping list"
user_input = gets.chomp
if user_input == "search for recipe by ingredient"
  #write method here
elsif user_input == "view cookbook"
  #write method here
elsif user_input == "I don't know what to eat" || user_input == "I don't know what to eat..."
  #write method here
elsif user_input == "make shopping_list"
  #write method here
else
  puts "\e[31mRuh roh! That's not a menu item! Please choose a menu item.\e[0m"
  menu
end

end

menu



def shopping_list(user)
  puts "Shopping List"

end
