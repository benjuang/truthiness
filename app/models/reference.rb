class Reference < ActiveRecord::Base
  attr_accessible :description, :article_id, :link_title, :link_url
  belongs_to :article
end
