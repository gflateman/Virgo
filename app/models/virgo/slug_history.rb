module Virgo
  class SlugHistory < ActiveRecord::Base
    belongs_to :record, polymorphic: true
  end
end
