class AddCounterMaxAndRatingIconToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :counter_max, :integer
    add_column :surveys, :rating_icon, :string
  end
end
