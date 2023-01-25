class FixColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :surveys, :body, :content
  end
end
