class AddCommentsAndVotes < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
      t.belongs_to :commentable, :polymorphic => true
      t.text :body
      t.boolean :reports_problem
      t.belongs_to :user
      t.belongs_to :parent
      t.integer :lft, :rgt
      t.timestamps
    end

    create_table :votes, :force => true do |t|
      t.boolean :vote, :default => true
      t.belongs_to :voteable, :polymorphic => true
      t.belongs_to :user
      t.timestamps
    end
    
    add_index :comments, :user_id
    add_index :comments, :commentable_id
    add_index :votes,    :user_id
  end
  
  def self.down
    drop_table :votes
    drop_table :comments
  end
end
