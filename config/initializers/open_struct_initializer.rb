class OpenStructSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(argument)
    argument.kind_of?(OpenStruct)
  end

  def serialize(open_struct)
    super(
      {
        'json_str' => open_struct.to_h.to_json
      }
    )
  end

  def deserialize(hash)
    OpenStruct.new(JSON.parse(hash['json_str']))
  end
end

Rails.application.config.active_job.custom_serializers << OpenStructSerializer
