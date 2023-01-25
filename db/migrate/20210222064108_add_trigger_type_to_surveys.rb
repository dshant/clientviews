class AddTriggerTypeToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :trigger_type, :string
  end
end
