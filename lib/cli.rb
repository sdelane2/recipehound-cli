def welcome_message # => greets user at the start of the program
  puts "Welcome to RecipeHound, the CLI app that sniffs out the perfect recipe for you!"
end


def create_new_account_or_login_prompt  # => asks user to sign in or create a new account
  puts "Would you like to create a new account or sign in to an existing account?"
  puts "Enter '1' to create a new account. Enter '2' to sign in to an existing account."
  welcome_option
end


def welcome_option  # => validation for user input on create_new_account_or_login_prompt
  user_welcome_input = gets.chomp.to_i
  if user_welcome_input == 1
    create_new_user_account
  elsif user_welcome_input == 2
    existing_account_login
  else
      puts "That is not a valid option. Please enter '1' to create a new account or enter '2' to sign in to an existing account."
      welcome_option
  end
end


def create_new_user_account # => takes user inputs and creates a new User instance with those a
  puts "Awesome! Let's create a new account for you!"
  puts "What's your first name?"
    user_first_name = gets.chomp
  puts "Hi, #{user_first_name}. What would you like your username to be?"
    user_username = gets.chomp
  # => INSERT A FIND BY USERNAME METHOD
  puts "Got it. Choose a password. Make sure you save it in a safe place!"
    user_password = gets.chomp
  puts "Great! You're all set up, #{user_first_name}! Your username is #{user_username}."
  user_username = User.create(first_name: user_first_name, username: user_username, password: user_password)
end


def existing_account_login
  puts "Please enter your username."
    user_username = gets.chomp
  # => User.find_by(user_username)
end

# => THERE ARE 533 INGREDIENTS IN THE DATABASE. IT MAY BE EASIER FOR A USER TO
# => NAME AN INGREDIENT AND DO A FIND_BY RATHER THAN LIST ALL THE INGREDIENTS
# => AND HAVE A USER PICK ONE.
# => or....
# => THE SYSTEM COULD SEND A LIST OF 20 OR SO RANDOM INGREDIENTS FOR A USER TO
# => CHOOSE FROM.

def find_recipe_by_ingredient
  puts "What ingredient would you like to use?"
  user_ingredient = gets.chomp
  ingredient_given = Ingredient.find_by(title: user_ingredient)
  if ingredient_given == nil
    puts "No recipes with that ingredient could be found. Try making it plural?"
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


# def ingredients_list  # => displays list of ingredients for user to choose from
# end
