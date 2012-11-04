class ChangeIssueIdToArticleIdOnReferences < ActiveRecord::Migration
  def up
    rename_column :references, :issue_id, :article_id
  end

  def down
    rename_column :references, :article_id, :issue_id
  end
end
