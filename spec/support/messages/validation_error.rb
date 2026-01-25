class ValidationError < StandardError
  attr_accessor :errors

  def initialize(msg = "Validation failed")
    super(msg)
    @errors = Hash.new { |hash, key| hash[key] = [] }
  end

  def add(key:, value:)
    @errors[key] << value
  end

  def message
    if @errors.empty?
      super
    else
      "#{super}: " + @errors.map { |k, v| "#{k}=[#{v.join(', ')}]" }.join(", ")
    end
  end
end
