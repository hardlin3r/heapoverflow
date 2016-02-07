class ChangeDefaultBestAnswer < ActiveRecord::Migration
  def change
    change_column_default :answers, :best, false
  end
end
