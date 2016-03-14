class AddCompoundIndexToVotes < ActiveRecord::Migration
  def change
    add_index :votes, [:votable_type, :votable_id], unique: true
  end
end
