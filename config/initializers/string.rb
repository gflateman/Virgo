class String
  def to_bool
    !!(self =~ /^(true|t|yes|y|1)$/i)
  end
end
