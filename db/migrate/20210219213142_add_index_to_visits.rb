class AddIndexToVisits < ActiveRecord::Migration[6.1]
  def change
    add_index :visits, [:survey_id, :visit_token, :path]
  end
end
