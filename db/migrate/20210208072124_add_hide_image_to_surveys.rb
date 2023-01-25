class AddHideImageToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :hide_image, :boolean, null: false, default: false
  end
end
