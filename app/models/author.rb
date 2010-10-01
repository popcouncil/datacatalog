class Author < Person
  has_one :data_record, :dependent => :nullify
end
