class Post < ActiveRecord::Base
    has_permalink :name, :update => true
end
