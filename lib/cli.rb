require 'pry'
require 'tty-prompt'


def welcome_message # => greets user at the start of the program
  puts "\e[95mWelcome to \e[97m\e[1mRecipeHound\e[0m, the CLI app that sniffs out the perfect recipe for you!\e[0m"
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
    puts "\n\e[91mRuh roh! That is not a valid option. Please enter '1' to create a new account or enter '2' to sign in to an existing account.\e[0m"
    welcome_option
  end
  user
end


def create_new_user_account # => takes user inputs and creates a new User instance
  puts "\n\e[95mWhat would you like your username to be?\e[0m"
  user_username_input = gets.chomp
  user = User.find_by(username: user_username_input)
  if user == nil
    puts "\n\e[95mI like that. What's your first name?\e[0m"
    user_first_name = gets.chomp
    puts "\n\e[95mGot it. Choose a password. Make sure you save it in a safe place!\e[0m"
    user_password = gets.chomp
    puts "\n\e[95mYou're all set up, #{user_first_name}! Your username is #{user_username_input}.\e[0m"
    user = User.create(first_name: user_first_name, username: user_username_input, password: user_password)
  else
    puts "\n\e[91mSorry, that username is already taken.\e[0m"
    create_new_user_account
  end
  user
end


def existing_account_login
  puts "\n\e[95mPlease enter your username.\e[0m"
  user_username = gets.chomp
  user = User.find_by(username: user_username)
  if user == nil
    puts "\n\e[91mRuh roh! No user found with that username. Please try again.\e[0m"
    existing_account_login
  else
    puts "\n\e[95mHello #{user.first_name}. Welcome back!\e[0m"
  end
user
end


def find_recipe_by_ingredient(user)
  puts "\n\e[95mWhat ingredient would you like to use?\e[0m"
  user_ingredient = gets.chomp
  ingredient_given = Ingredient.find_by(title: user_ingredient) #find the ingredient inputed
  if ingredient_given == nil #if ingredient not found in db
    puts "\n\e[91mRuh roh! No recipes with that ingredient could be found. Try making it plural?\e[0m"
    find_recipe_by_ingredient(user)
  else #if ingredient found in db
    relationships = RecipeIngredient.where(ingredient_id: ingredient_given.id) #finds all relationships that contain that ingredient
    recipe_ids = relationships.collect {|row| row.recipe_id} #collects all recipe_ids
    recipes = recipe_ids.collect do |id| #collects all recipe objects
      Recipe.find(id)
    end
    puts "\n\e[95mHere are some available recipes with that ingredient:\e[0m"
    recipes.each do |recipe| #displays title of each recipe
      puts "#{recipe.title}"
    end
  end
end


def save_recipe(user)
  puts "\n\e[95mWould you like to save a recipe from this list? (y/n)\e[0m"
  should_recipe_be_saved = gets.chomp
    if should_recipe_be_saved != "n" && should_recipe_be_saved != "y"
      puts "\n\e[91mGet it together, #{user.first_name}. That's not a valid input.\e[0m"
      save_recipe(user)
    elsif should_recipe_be_saved == "n"
      false
    else should_recipe_be_saved == "y"
      puts "\n\e[95mOkay. Enter the name of the recipe you'd like to save.\e[0m"
      saved_recipe_input = gets.chomp
      saved_recipe = Recipe.find_by(title: saved_recipe_input)
      new_user_recipe = UserRecipe.create(recipe: saved_recipe, user: user)
      puts "\n\e[95mGreat! #{saved_recipe_input} has been saved to your list.\e[0m"
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
  puts "\e[91mRuh roh! That's not a menu item! Please choose a menu item.\e[0m"
  menu
end

end

#menu

# => below is an attempt to create the menu with a menu gem
def prompt_menu(user)
  menu = TTY::Prompt.new
  menu_options = ["\e[95mSearch for a recipe by ingredient\e[0m", "\e[95mFetch my recipes\e[0m", "\e[95mI don't know what to eat\e[0m", "\e[95mMake a shopping list\e[0m"]
  user_selection = menu.enum_select("\e[95mWhat would you like me to do?\e[0m", menu_options)
    if user_selection == "Search for a recipe by ingredient"
      find_recipe_by_ingredient(user)
    elsif user_selection == "Fetch my recipes"

    elsif user_selection == "I don't know what to eat"

    else user_selection == "Make a shopping list"
      shopping_list(user)
    end
end


def random_recipe(user)
  puts "\e[95mWhy not try this recipe?\e[0m"
  rand_recipe = Recipe.all.name.sample
  puts rand_recipe
  save_random_recipe(user)
end

def save_random_recipe(user)  # => helper method for random_recipe(user)
  puts "\n\e[95mWould you like to save it for later? (y/n)\e[0m"
  should_recipe_be_saved = gets.chomp
    if should_recipe_be_saved != "n" && should_recipe_be_saved != "y"
      puts "\n\e[91mGet it together, #{user.first_name}. That's not a valid input.\e[0m"
      save_random_recipe(user)
    elsif should_recipe_be_saved == "n"
      false
    else should_recipe_be_saved == "y"
      saved_recipe = Recipe.find_by(title: rand_recipe)
      new_user_recipe = UserRecipe.create(recipe: saved_recipe, user: user)
      puts "\n\e[95mGreat! #{rand_recipe} has been saved to your list.\e[0m"
    end
end


def shopping_list(user) #returns all ingredients for entire cookbook
  puts "\e[95mShopping List\e[0m"
  relationships = UserRecipe.where(user_id: user.id) #returns array of all relationships
  if relationships == []
    puts "Your shopping list is empty. Save recipes before building a shopping list."
    prompt_menu(user)
  else
    recipe_ids = relationships.collect do |row| #returns array of all recipe ids
      row.recipe_id
    end
    all_recipes = recipe_ids.collect do |x| #returns array of all recipe objects
      Recipe.find(x)
    end
    all_ingredients = all_recipes.collect do |recipe| #returns array of all ingredient objects
      recipe.ingredients
    end.flatten.uniq
    shopping_list = all_ingredients.each do |ingredient|
      puts "#{ingredient.title}"
    end
  end
end
