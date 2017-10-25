def welcome_message # => greets user at the start of the program
  puts "Welcome to RecipeHound, the CLI app that sniffs out the perfect recipe for you!"
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
    create_new_user_account
  elsif user_welcome_input == 2
    existing_account_login
  else
    puts "That is not a valid option. Please enter '1' to create a new account or enter '2' to sign in to an existing account."
    welcome_option
  end
end


def create_new_user_account # => takes user inputs and creates a new User instance with those a
  # puts "Awesome! Let's create a new account for you!"
  puts "What would you like your username to be?"
  user_username = gets.chomp
  taken_username = User.find_by(username: user_username)
  if taken_username == nil
    puts "Got it. Choose a password. Make sure you save it in a safe place!"
    user_password = gets.chomp
    puts "What's your first name?"
    user_first_name = gets.chomp
    puts "You're all set up, #{user_first_name}! Your username is #{user_username}."
    user_username = User.create(first_name: user_first_name, username: user_username, password: user_password)
  else
    puts "Sorry, that username is already taken."
    create_new_user_account
  end
end

def existing_account_login
  puts "Please enter your username."
  user_username = gets.chomp
  existing_user = User.find_by(username: user_username)
  if existing_user == nil
    puts "No user found with that username. Please try again."
  else
    puts "Hello #{existing_user.first_name}. Welcome back!"
    existing_user
  end
end

def find_recipe_by_ingredient
  puts "What ingredient would you like to use?"
  user_ingredient = gets.chomp
  ingredient_given = Ingredient.find_by(title: user_ingredient)
  if ingredient_given == nil
    puts "No recipes with that ingredient could be found. Try making it plural?"
    find_recipe_by_ingredient
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
