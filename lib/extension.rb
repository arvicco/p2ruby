class String
  # returns snake_case representation of string
  def snake_case
    gsub(/([a-z])([A-Z0-9])/, '\1_\2').downcase
  end

  # returns camel_case representation of string
  def camel_case
    if self.include? '_'
      self.split('_').map { |e| e.capitalize }.join
    else
      unless self =~ (/^[A-Z]/)
        self.capitalize
      else
        self
      end
    end
  end
end
