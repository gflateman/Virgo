class NilClass
  def [](val)
    nil
  end

  def to_bool
    false
  end

  def all_blank?
    true
  end
end
