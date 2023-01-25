class Api::V1::DirectUploadsController < ActiveStorage::DirectUploadsController
  # Should only allow null_session in API context, so request is JSON format
  protect_from_forgery with: :null_session

end
