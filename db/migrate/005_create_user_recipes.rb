
class CreateUserRecipes < ActiveRecord::Migration[4.2]
  def change
    create_table :user_ingredients do |t|
      t.integer :user_id
      t.integer :ingredient_id
    end
  end
end
