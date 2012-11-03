class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :facebook_session_key
      t.string :facebook_uid
      t.string :persistence_token

      t.timestamps
    end
  end
end
