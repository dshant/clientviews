class AddExtraTextToResponses < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :extra_text, :string
  end
end
