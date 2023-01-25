class AddPlaybackIdToVideoAssets < ActiveRecord::Migration[6.1]
  def change
    add_column :video_assets, :playback_id, :string
  end
end
