class PageModulePost < ActiveRecord::Base
  belongs_to :page_module, touch: true
  belongs_to :post

  scope :by_position, ->{ order(position: :asc) }
end
