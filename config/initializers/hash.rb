class Hash
  def all_blank?
    values.empty? || !values.map(&:blank?).include?(false)
  end
end
