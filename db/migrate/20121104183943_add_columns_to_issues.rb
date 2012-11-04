class AddColumnsToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :banner_image, :string
    add_column :issues, :heading, :string
    add_column :issues, :summary, :text
    add_column :issues, :splash_image, :string
  end
end
