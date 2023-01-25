class FileSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(argument)
    argument.kind_of?(Tempfile)
  end

  def serialize(tempfile)
    super(
      "path" => tempfile.path
    )
  end

  def deserialize(hash)
    File.read(hash['path'])
  end
end


Rails.application.config.active_job.custom_serializers << FileSerializer
