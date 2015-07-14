module Common::SlugHistory
  extend ActiveSupport::Concern

  included do
    has_many :slug_histories, as: :record

    after_save :generate_slug_history_item

    def self.find_by_historic_slug(slug_val)
      slugs = ::SlugHistory.where(record_type: self.to_s, slug: slug_val)
      slugs.order(created_at: :asc).last.try(:record)
    end

    def self.find_by_id_or_historic_slug!(id_val)
      record = self.find_by(slug: id_val)

      record = self.find_by(id: id_val) if record.nil?

      record = self.find_by_historic_slug(id_val) if record.nil?

      raise ActiveRecord::RecordNotFound if record.nil?

      record
    end

    private

    def generate_slug_history_item
      if slug_changed? && !slug_was.blank?
        slug_histories.create!(record: self, slug: slug_was)
      end
    end
  end
end
