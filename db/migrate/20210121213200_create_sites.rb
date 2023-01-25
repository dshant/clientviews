class CreateSites < ActiveRecord::Migration[6.1]
  def change
    create_table :sites, id: :uuid do |t|
      t.string :domain
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
