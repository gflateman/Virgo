class DateTime
  def self.zero
    DateTime.now.utc.change(:hour => 0, :min => 0, :sec => 0, :year => 2000, :month => 1, :day => 1)
  end
end
