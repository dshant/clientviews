class CreateVideoAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :video_assets, id: :uuid do |t|
      t.references :response, null: false, foreign_key: true, type: :uuid
      t.string :provider
      t.string :provider_id
      t.string :provider_asset_id
      t.string :status

      t.timestamps
    end
  end
end
