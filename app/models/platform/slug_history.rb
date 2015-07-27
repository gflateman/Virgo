module Platform
  class SlugHistory < ActiveRecord::Base
    belongs_to :record, polymorphic: true
  end
end
