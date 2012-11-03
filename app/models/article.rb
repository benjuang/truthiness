class Article < ActiveRecord::Base
  attr_accessible :citations, :content, :issue_id, :title
end
