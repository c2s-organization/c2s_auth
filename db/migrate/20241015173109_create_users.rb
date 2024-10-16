class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end

    remove_index :users, :email if index_exists?(:users, :email)
    add_index :users, 'LOWER(email)', unique: true
  end
end
