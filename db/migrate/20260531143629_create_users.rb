class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.decimal :balance, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end