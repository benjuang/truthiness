class AddColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :summary, :text
  end
end
