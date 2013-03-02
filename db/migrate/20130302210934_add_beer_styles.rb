class AddBeerStyles < ActiveRecord::Migration
  def up
    create_table :beer_styles do |t|
      t.integer :user_id
      t.string  :name, null: false, limit: 255
      t.text    :description, null: false
      t.timestamps
    end

    change_table :beer_styles do |t|
      t.index :user_id
    end

    change_table :beers do |t|
      t.integer :beer_style_id
    end
  end

  def down
    drop_table :beer_styles

    change_table :beers do |t|
      t.remove :beer_style_id
    end
  end
end
