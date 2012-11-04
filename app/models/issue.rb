class Issue < ActiveRecord::Base
  attr_accessible :description, :name, :picture
  has_many :articles
end
