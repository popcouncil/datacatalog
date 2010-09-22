class Filters < OpenStruct
  def initialize(table)
    super(table || {})
  end
end
