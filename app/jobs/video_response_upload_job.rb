class VideoResponseUploadJob < ApplicationJob
  queue_as :default

  def perform(response)
    return if response.video_asset.present?

    assets_api = MuxRuby::AssetsApi.new
    create_asset_request = MuxRuby::CreateAssetRequest.new
    create_asset_request.playback_policy = [MuxRuby::PlaybackPolicy::PUBLIC]

    create_asset_request.input = Aws::S3::Presigner.new(client: S3).presigned_url(:get_object, bucket: 'userveys-temp-videos', key: response.video_feedback_data.blob.key)

    create_response = assets_api.create_asset(create_asset_request)

    VideoAsset.create(response: response, status: 'started', provider_id: create_response.data.id, provider_asset_id: create_response.data.id)
  end
end
