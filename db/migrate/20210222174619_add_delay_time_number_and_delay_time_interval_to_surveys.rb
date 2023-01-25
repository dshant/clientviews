class AddDelayTimeNumberAndDelayTimeIntervalToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :delay_time_number, :integer
    add_column :surveys, :delay_time_interval, :string
  end
end
