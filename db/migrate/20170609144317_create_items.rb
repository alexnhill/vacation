class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.text :body
      t.string :address
      t.string :image
      t.datetime :date
      t.string :lookup
      t.string :category, null: false
      t.references :user, foreign_key: true #, null: false
      #took out until we have users in the database that we can check
      t.references :trip, foreign_key: true, null: false

      t.timestamps
    end
  end
end
