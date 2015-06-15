class AddBestToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :best_answer, :boolean, null: false, default: false
  end
end
