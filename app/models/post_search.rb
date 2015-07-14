class PostSearch < FormModel
  attr_accessor :term

  validates :term, presence: true
end
