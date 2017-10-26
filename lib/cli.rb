require 'pry'
require 'tty-prompt'
require 'asciiart'


## ===== WELCOME METHODS ===== ##

def welcome_image # => displays welcome ascii image
  ascii = AsciiArt.new("https://s7d2.scene7.com/is/image/PetSmart/PB1201_STORY_CARO-Authority-HealthyOutside-DOG-20160818?$PB1201$")
  print ascii.to_ascii_art
end


def welcome_message # => greets user at the start of the program
  puts "\n\e[95mWelcome to \e[97m\e[1mRecipeHound\e[0m\e[95m, the CLI app that sniffs out the perfect recipe for you!\e[0m"
end


def create_new_account_or_login_prompt  # => asks user to sign in or create a new account
  login = TTY::Prompt.new
  login_options = ["\e[95mCreate a new account\e[0m", "\e[95mSign in with an existing account\e[0m"]
  login_selection = login.select("\n\e[95mWould you like to create a new account or sign in to an existing account?\e[0m", login_options)
  if login_selection == "\e[95mCreate a new account\e[0m"
    user = create_new_user_account
  else login_selection == "\e[95mSign in with an existing account\e[0m"
    user = existing_account_login
  end
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


def existing_account_login  # => finds existing user
  puts "\n\e[95mPlease enter your username.\e[0m"
  user_username = gets.chomp
  user = User.find_by(username: user_username)
  if user == nil
    puts "\n\e[91mRuh roh! No user found with that username. Please try again.\e[0m"
    existing_account_login
  else
    puts "\e[95mHello #{user.first_name}. Welcome back!\e[0m"
  end
user
end


## ===== MENU ===== ##


def prompt_menu(user)
  menu = TTY::Prompt.new
  menu_options = ["\e[95mSearch for a recipe by ingredient\e[0m", "\e[95mFetch my recipes\e[0m", "\e[95mI don't know what to eat\e[0m", "\e[95mMake a shopping list one saved recipes\e[0m", "\e[95mMake a shopping list for all saved recipes\e[0m"]
  user_selection = menu.select("\n\e[95mWhat would you like to do?\e[0m", menu_options)
  user_selection
  if user_selection == "\e[95mSearch for a recipe by ingredient\e[0m"
    find_recipe_by_ingredient(user)
  elsif user_selection == "\e[95mFetch my recipes\e[0m"
    fetch_user_recipes(user)
  elsif user_selection == "\e[95mI don't know what to eat\e[0m"
    random_recipe(user)
  elsif user_selection == "\e[95mMake a shopping list one saved recipes\e[0m"
    shopping_list_one_recipe(user)
  else user_selection == "\e[95mMake a shopping list for all saved recipes\e[0m"
    shopping_list_all_recipes(user)
  end
end


def find_recipe_by_ingredient(user)
  puts "\n\e[95mWhat ingredient would you like to use?\e[0m"
  user_ingredient = gets.chomp
  ingredient_given = Ingredient.find_by(title: user_ingredient) # => find the ingredient inputed
  if ingredient_given == nil # => if ingredient not found in db
    puts "\n\e[91mRuh roh! No recipes with that ingredient could be found. Try making it plural?\e[0m"
    find_recipe_by_ingredient(user)
  else # => if ingredient found in db
    relationships = RecipeIngredient.where(ingredient_id: ingredient_given.id) # => finds all relationships that contain that ingredient
    recipe_ids = relationships.collect {|row| row.recipe_id} # => collects all recipe_ids
    recipes = recipe_ids.collect {|id| Recipe.find(id) } # => collects all recipe objects
    puts "\n\e[95mHere are some available recipes with that ingredient:\e[0m"
    recipes_result = recipes.each {|recipe| puts "#{recipe.title}" } # => displays title of each recipe
  end
  save_recipe(user)
end


def save_recipe(user)
  save_recipe_prompt = TTY::Prompt.new
  should_i_save_recipe = save_recipe_prompt.select("\e[95mWould you like to save a recipe from this list?\e[0m", %w(Yes No))
    if should_i_save_recipe == "No"
      puts "Okay, it won't be saved."
    else should_i_save_recipe == "Yes"
      puts "\n\e[95mOkay. Enter the name of the recipe you'd like to save.\e[0m"
      saved_recipe_input = gets.chomp
      saved_recipe = Recipe.find_by(title: saved_recipe_input)
      new_user_recipe = UserRecipe.create(recipe: saved_recipe, user: user)
      puts "\n\e[95mGreat! #{saved_recipe_input} has been saved to your list.\e[0m"
    end
end

def fetch_user_recipes(user)
  if user.recipes == []
    puts "\e[91mStop trying to make fetch happen. It's not going to happen. Try saving some recipes first."
  else
    user.recipes.each {|recipe| puts recipe.title}
  end
end


def random_recipe(user)
  puts "\n\e[95mWhy not try this recipe, #{user.first_name}?\e[0m"
  rand_recipe = Recipe.all.sample.title
  puts rand_recipe
  save_prompt = TTY::Prompt.new
  should_i_save = save_prompt.select("\e[95mWould you like to save it for later?\e[0m", %w(Yes No))
    if should_i_save == "No"
      puts "Okay, it won't be saved."
    else should_i_save == "Yes"
      saved_recipe = Recipe.find_by(title: rand_recipe)
      new_user_recipe = UserRecipe.create(recipe: saved_recipe, user: user)
      puts "\n\e[95mGreat! #{rand_recipe} has been saved to your list.\e[0m"
    end
end


def shopping_list_all_recipes(user) # => returns all ingredients for entire cookbook
  relationships = UserRecipe.where(user_id: user.id) # => returns array of all relationships
  if relationships == []
    puts "Your shopping list is empty. Save recipes before building a shopping list."
    prompt_menu(user)
  else
    puts "\n\e[96mShopping List\e[0m"
    puts "-------------------------"
    recipe_ids = relationships.collect do |row| # => returns array of all recipe ids
      row.recipe_id
    end
    all_recipes = recipe_ids.collect do |x| # => returns array of all recipe objects
      Recipe.find(x)
    end
    all_ingredients = all_recipes.collect do |recipe| # => returns array of all ingredient objects
      recipe.ingredients
    end.flatten.uniq
    shopping_list = all_ingredients.each do |ingredient|
      puts "#{ingredient.title}"
    end
  end
end

def shopping_list_one_recipe(user)
  relationships = UserRecipe.where(user_id: user.id) # => returns array of all relationships
  if relationships == []
    puts "Your shopping list is empty. Save recipes before building a shopping list."
    prompt_menu(user)
  else
    recipe_ids = relationships.collect {|row| row.recipe_id } # => returns array of all recipe ids
    all_recipes = recipe_ids.collect {|id| Recipe.find(id) } # => returns array of all recipe objects
    recipe_titles = all_recipes.collect { |recipe| recipe.title} # => print out all saved recipe titles
    recipe_list = TTY::Prompt.new
    recipe_titles
    puts "\n\e[96mShopping List\e[0m"
    puts "-------------------------"
    user_selection = recipe_list.select("\n\e[95mWhich saved recipe would you like to use?\e[0m", recipe_titles)
    ingredients_list = Recipe.find_by(title: user_selection).ingredients.each {|ingredient| puts ingredient.title}
  end
  ingredients_list
end
