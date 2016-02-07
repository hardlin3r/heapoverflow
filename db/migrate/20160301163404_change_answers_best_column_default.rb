class ChangeAnswersBestColumnDefault < ActiveRecord::Migration
  def change
    change_column_default :answers, :best, true
  end
end
