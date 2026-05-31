class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :condition, null: false
      t.string :status, null: false, default: "available"
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end