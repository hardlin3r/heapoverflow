class AddIndexesToComment < ActiveRecord::Migration
  def change
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
