class Article < ActiveRecord::Base
  attr_accessible :citations, :content, :issue_id, :title
  belongs_to :issue
  has_many :references
end
