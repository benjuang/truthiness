class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :issue_id
      t.string :title
      t.text :content
      t.text :citations

      t.timestamps
    end
  end
end
