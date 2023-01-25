require 'active_storage/direct_uploads_controller'

class ActiveStorage::DirectUploadsController
  protect_from_forgery with: :null_session

  def create
    blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args.merge(service_name: verified_service_name))
    render json: direct_upload_json(blob)
  end

  def verified_service_name
    service, attachment_name = DUC.decrypt_and_verify(params[:blob][:direct_upload_token]).split('.')
    return service if params[:blob][:attachment_name] == attachment_name
  end
end

creds = ::Aws::Credentials.new(
  'AKIA5MXXOS6ILUF7V3NV',
  'SPwP5+18e9Uu2ZCtDLKPohzC0b/py05PFQ11lelh'
)
REGION = 'us-east-1'.freeze

S3 = Aws::S3::Client.new(credentials: creds, region: REGION)

key = SecureRandom.random_bytes(32)
DUC = ActiveSupport::MessageEncryptor.new(key)
