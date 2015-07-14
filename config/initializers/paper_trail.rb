require 'paper_trail/frameworks/active_record/models/paper_trail/version'

module PaperTrail
  class Version < ActiveRecord::Base
    scope :by_date, ->{ order(created_at: :desc) }

    def version_user
      @version_user ||= User.find_by(id: whodunnit)
    end

    def pretty_changes
      _pretty_changes = []

      changeset.each do |attribute, changes|
        if attribute != "updated_at" || attribute != "created_at" || attribute == "id"
          buffer = ""
          buffer += attribute
          buffer += " changed from "
          buffer += changes[0].present? ? "\"#{changes[0]}\"" : "(blank)"
          buffer += " to "
          buffer += changes[1].present? ? "\"#{changes[1]}\"" : "(blank)"
          _pretty_changes << buffer
        end
      end

      _pretty_changes.join(", ")
    end
  end
end
