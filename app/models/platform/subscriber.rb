module Platform
  class Subscriber < ActiveRecord::Base
    validates :email, presence: true, uniqueness: {message: "is already subscribed to the mailing list"}, email: true, reduce: true
  end
end
