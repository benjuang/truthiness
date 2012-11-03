class User < ActiveRecord::Base
  attr_accessible :facebook_session_key, :facebook_uid, :persistence_token
end
