class Issue < ActiveRecord::Base
  attr_accessible :description, :name, :picture, :banner_image, :heading, :summary, :splash_image
  has_many :articles
end
