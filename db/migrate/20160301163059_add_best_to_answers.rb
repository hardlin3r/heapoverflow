class AddBestToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :best, :boolean
  end
end
