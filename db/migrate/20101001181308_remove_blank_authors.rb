class RemoveBlankAuthors < ActiveRecord::Migration
  def self.up
    Author.destroy_all(:name => "", :affiliation => "")
  end

  def self.down
  end
end
