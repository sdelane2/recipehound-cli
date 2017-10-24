class CreateRecipes < ActiveRecord::Migration[4.2]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :ingredients
      t.string :href
    end
  end
end
