class AddSiteToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_reference :surveys, :site, type: :uuid
  end
end
