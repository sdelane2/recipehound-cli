# RecipeHound #

RecipeHound is a CLI app that allows users to:
  - create and login to an account with a username and password.
  - The user is greeted with a menu of options after logging in, where they can:
    - search for recipes based on specific ingredients.
    - ask RecipeHound to give them a random recipe from the database.
    - save recipes to their account, and then create shopping lists of ingredients from their saved list of recipes.
    - shopping lists can be from a single recipe, or from all of the recipes saved by that User.



## GETTING STARTED ##

Fork and Clone this repo to get started.

All of the gems you need to install are in the the Gemfile. However, RMagick needs to be installed prior to running `bundle install` in your terminal.

Installing RMagick
  - First, make sure you have HomeBrew installed
  - Type this command into your terminal:
    `brew install imagemagick@6 && brew link imagemagick@6 --force`
      - This command installs ImageMagick, which is required for RMagick
  - Then, install the gem RMagick with this command:
    `gem install rmagick`
  - Finally, run `bundle install` in your terminal to install the rest of the gems
  - RMagick website for help:
    https://rmagick.github.io/

Command to run the program:
  `ruby bin/run.rb`


## AUTHORS ##

Winter LaMon - https://github.com/winterlamon
Yassi Mortensen - https://github.com/yassimortensen


## LICENSE ##

RecipeHound is released under the MIT License.

## ACKNOWLEDGEMENTS ##
