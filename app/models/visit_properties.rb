class VisitProperties

  def initialize(user_agent, remote_ip, visit_params)
    @user_agent = user_agent
    @remote_ip = remote_ip
    @visit_params = visit_params
  end

  def generate
    visit_properties.merge(request_properties)
  end

  private

  attr_reader :user_agent, :remote_ip, :visit_params

  def visit_properties
    {
      visit_token: visit_params[:visit_token],
      visitor_token: visit_params[:visitor_token],
      survey_id: visit_params[:survey_id],
      referring_domain: visit_params[:referrer],
      full_location: visit_params[:landing_page],
      path: visit_params[:path],
    }
  end

  def request_properties
    client = DeviceDetector.new(user_agent)
    device_type =
      case client.device_type
      when "smartphone"
        "Mobile"
      when "tv"
        "TV"
      else
        client.device_type.try(:titleize)
      end

    {
      browser: client.name,
      os: client.os_name,
      device_type: device_type,
      ip: mask_ip(remote_ip),
      user_agent: ensure_utf8(user_agent)
    }

  end

  def mask_ip(ip)
    addr = IPAddr.new(ip)
    if addr.ipv4?
      # set last octet to 0
      addr.mask(24).to_s
    else
      # set last 80 bits to zeros
      addr.mask(48).to_s
    end
  end

  def ensure_utf8(str)
    str.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "") if str
  end
end
