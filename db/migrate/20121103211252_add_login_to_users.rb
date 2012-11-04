class AddLoginToUsers < ActiveRecord::Migration
  def change
      add_column :users, :name, :string
      add_column :users, :email, :string
      add_column :users, :password, :string
      add_column :users, :permissions, :integer
  end
end
