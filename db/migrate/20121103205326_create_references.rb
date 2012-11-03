class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.integer :issue_id
      t.string :link_title
      t.string :link_url
      t.text :description

      t.timestamps
    end
  end
end
