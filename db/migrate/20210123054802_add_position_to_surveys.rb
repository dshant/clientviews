class AddPositionToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :position, :string
  end
end
